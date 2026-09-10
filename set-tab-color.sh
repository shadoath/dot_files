#!/bin/bash
# Sets the iTerm2 tab color for the terminal the calling session is attached to.
#
# Usage:
#   set-tab-color.sh <name|#rrggbb>   set the color and pin it for this terminal
#   set-tab-color.sh reset            clear the pin, hand the tab back to the hook
#   set-tab-color.sh --clear-pin      drop the pin without touching the tab
#
# Pinning is what makes a hand-picked color stick. sync-tab-color.sh re-derives a
# color from the directory on every Stop, so without a pin a manual choice would
# be overwritten seconds later. Pins are keyed by tty under /tmp.

PIN_DIR="/tmp/claude-tab-color-$(id -u)"

# tty names get recycled, so a pin left behind by a closed terminal would hand a
# stranger's color to the next session on that number. The hook touches a pin
# every time it honors one, so an in-use pin never ages out and an abandoned one
# stops applying after half a day.
PIN_MAX_AGE_MIN=720

# The color a directory resolves to with no pin in play: a color name in the repo
# root's own name, else nothing — an unnamed directory keeps the tab uncolored.
# Reading the root rather than the path keeps the color steady as you cd around,
# and keeps a `blue/` parent from colouring every repo beneath it.
derive_color() {
  local cwd=$1 root name tok
  [ -n "$cwd" ] || return 1
  root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  [ -n "$root" ] || root="$cwd"
  root=${root%/}
  [ -n "$root" ] || root=/

  # Split on anything that isn't alphanumeric so `web-blue` matches but
  # `credentials` doesn't pick up the `red` buried inside it.
  name=$(basename "$root" | tr 'A-Z' 'a-z')
  for tok in $(printf '%s' "$name" | LC_ALL=C tr -c 'a-z0-9' ' '); do
    color_name_to_hex "$tok" && return 0
  done
  return 1
}

# Names are a readable alias for a hex value, and the only thing that colors a
# tab automatically. The first five are Claude Code's theme tokens and the head of
# iTerm's swatch row, so `red` here, a `web-red` tab and right-click → red are all
# the same color.
color_to_hex() {
  case "$1" in
    red)       echo '#dc2626' ;;
    orange)    echo '#d77757' ;;
    yellow)    echo '#ffdf39' ;;
    green)     echo '#4eba65' ;;
    blue)      echo '#4782c8' ;;
    purple)    echo '#af87ff' ;;
    gray|grey) echo '#888888' ;;
    pink)      echo '#ff0087' ;;
    teal)      echo '#48968c' ;;
    cyan)      echo '#00cccc' ;;
    brown)     echo '#ca8a04' ;;
    fuchsia)   echo '#c46686' ;;
    indigo)    echo '#93a5ff' ;;
    white)     echo '#ffffff' ;;
    black)     echo '#2b2b2b' ;;
    mint)      echo '#7fe3a0' ;;
    magenta)   echo '#c832c8' ;;
    lime)      echo '#64dc32' ;;
    coral)     echo '#ff7f50' ;;
    salmon)    echo '#fa8072' ;;
    gold)      echo '#ffd700' ;;
    navy)      echo '#000080' ;;
    maroon)    echo '#800000' ;;
    olive)     echo '#808000' ;;
    chartreuse) echo '#64a028' ;;
    rust)      echo '#b45309' ;;
    *)         echo "$1" ;;
  esac
}

# color_to_hex passes an unknown value through, so a token is a color name only
# when it resolves to something else.
color_name_to_hex() {
  local hex
  hex=$(color_to_hex "$1")
  [ "$hex" != "$1" ] || return 1
  echo "$hex"
}

color_to_rgb() {
  local hex
  hex=$(color_to_hex "$1" | tr 'A-Z' 'a-z')
  hex=${hex#\#}
  case "$hex" in
    [0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]) ;;
    *) return 1 ;;
  esac
  echo "$((16#${hex:0:2})) $((16#${hex:2:2})) $((16#${hex:4:2}))"
}

# Hooks run detached with no controlling terminal, so /dev/tty fails. Walk up the
# process tree to find the TTY of whatever launched us — writes to a slave PTY
# from another process are processed by the terminal as program output.
resolve_tty() {
  local pid=$PPID tty_name target=''
  while [ "$pid" -gt 1 ]; do
    tty_name=$(ps -o tty= -p "$pid" 2>/dev/null | tr -d ' ')
    if [ -n "$tty_name" ] && [ "$tty_name" != "??" ] && [ "$tty_name" != "-" ]; then
      target="/dev/$tty_name"
      break
    fi
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    [ -n "$pid" ] || break
  done
  [ -n "$target" ] && [ -w "$target" ] || return 1
  echo "$target"
}

pin_file() {
  echo "$PIN_DIR/$(echo "${1#/dev/}" | tr '/' '_')"
}

# Echoes the pinned color, or fails if there is none or it has aged out.
read_pin() {
  local pin=$1
  [ -s "$pin" ] || return 1
  if [ -n "$(find "$pin" -mmin +$PIN_MAX_AGE_MIN 2>/dev/null)" ]; then
    rm -f "$pin"
    return 1
  fi
  cat "$pin"
}

apply() {
  local target=$1 r=$2 g=$3 b=$4
  printf "\033]6;1;bg;red;brightness;%d\007" "$r" > "$target"
  printf "\033]6;1;bg;green;brightness;%d\007" "$g" > "$target"
  printf "\033]6;1;bg;blue;brightness;%d\007" "$b" > "$target"
}

# sync-tab-color.sh sources this file for the color table and tty helpers, so only
# run the CLI when the script is executed directly.
[ "${BASH_SOURCE[0]}" = "$0" ] || return 0

# Clearing a pin is best-effort cleanup: if the terminal is already gone there is
# nothing to resolve, and the age-out above collects the leftover.
if [ "$1" = --clear-pin ]; then
  TARGET=$(resolve_tty) || exit 0
  rm -f "$(pin_file "$TARGET")"
  exit 0
fi

TARGET=$(resolve_tty) || {
  echo "set-tab-color.sh: no writable terminal found for this process" >&2
  exit 2
}
PIN=$(pin_file "$TARGET")

case "$1" in
  reset)
    rm -f "$PIN"
    # Blanking the tab would leave it uncolored until the next hook fires, which
    # in an idle shell can be a long time.
    if COLOR=$(derive_color "$PWD") && RGB=$(color_to_rgb "$COLOR"); then
      apply "$TARGET" $RGB
    else
      printf "\033]6;1;bg;*;default\007" > "$TARGET"
    fi
    exit 0
    ;;
  '')
    echo "usage: set-tab-color.sh <name|#rrggbb> | reset" >&2
    exit 2
    ;;
esac

RGB=$(color_to_rgb "$1") || {
  echo "set-tab-color.sh: unknown color '$1'" >&2
  exit 2
}

apply "$TARGET" $RGB
mkdir -p "$PIN_DIR" && printf '%s' "$1" > "$PIN"
