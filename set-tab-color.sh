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

# iTerm's own tab-color swatches are the source of truth for the palette, so a
# color picked by right-clicking a tab and one picked here are the same color.
# Read them live on macOS; fall back to a copy for Linux boxes with no defaults.
FALLBACK_SWATCHES='#fb6b62 #f6ac47 #f0dc4f #b5d749 #5fa3f8 #c18ed9 #787878 #ff8fd0 #4dd6c9 #7fe3a0 #a0764a #d94fa8 #8b8ff5 #ffffff #2b2b2b'

# Entries are hand-edited in iTerm's Advanced settings, so normalize case and
# drop anything that isn't a hex triplet rather than feeding junk to the palette.
swatches() {
  local raw c
  raw=$(defaults read com.googlecode.iterm2 TabColorMenuOptions 2>/dev/null)
  [ -n "$raw" ] || raw=$FALLBACK_SWATCHES
  for c in $(echo "$raw" | tr ',' ' ' | tr 'A-Z' 'a-z'); do
    case "$c" in
      '#'[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]) echo "$c" ;;
    esac
  done
}

# The five colors reserved for `web-<color>` worktrees, held as the hex values
# iTerm ships in its swatch row so the reserved tabs match the menu exactly.
RESERVED_RED='#fb6b62'
RESERVED_ORANGE='#f6ac47'
RESERVED_YELLOW='#f0dc4f'
RESERVED_GREEN='#b5d749'
RESERVED_BLUE='#5fa3f8'

is_reserved() {
  case "$1" in
    "$RESERVED_RED"|"$RESERVED_ORANGE"|"$RESERVED_YELLOW"|"$RESERVED_GREEN"|"$RESERVED_BLUE") return 0 ;;
    *) return 1 ;;
  esac
}

# Swatches minus the reserved five — the pool the directory hash draws from, so a
# hashed tab never reads as a `web-<color>` worktree.
hash_palette() {
  local c
  for c in $(swatches); do
    is_reserved "$c" || echo "$c"
  done
}

# The color a directory resolves to with no pin in play: the reserved color of a
# `web-<color>` worktree, else a hash of the repo root against the shared palette.
# Hashing the root rather than the path keeps the color steady as you cd around.
derive_color() {
  local cwd=$1 root hash palette
  [ -n "$cwd" ] || return 1
  root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  [ -n "$root" ] || root="$cwd"
  root=${root%/}
  [ -n "$root" ] || root=/

  case "$root" in
    */code/web-blue*)   echo "$RESERVED_BLUE"   ; return 0 ;;
    */code/web-green*)  echo "$RESERVED_GREEN"  ; return 0 ;;
    */code/web-yellow*) echo "$RESERVED_YELLOW" ; return 0 ;;
    */code/web-orange*) echo "$RESERVED_ORANGE" ; return 0 ;;
    */code/web-red*)    echo "$RESERVED_RED"    ; return 0 ;;
  esac

  hash=$(printf '%s' "$root" | cksum | cut -d' ' -f1)
  palette=($(hash_palette))
  [ ${#palette[@]} -gt 0 ] || return 1
  echo "${palette[$(( hash % ${#palette[@]} ))]}"
}

# Names are a readable alias for a hex value. The ones iTerm ships a swatch for
# resolve to that swatch, so `red` here, a `web-red` tab and right-click → red
# are all the same color. The rest are kept from the original table for callers
# that still use them.
color_to_hex() {
  case "$1" in
    red)       echo "$RESERVED_RED"    ;;
    orange)    echo "$RESERVED_ORANGE" ;;
    yellow)    echo "$RESERVED_YELLOW" ;;
    green)     echo "$RESERVED_GREEN"  ;;
    blue)      echo "$RESERVED_BLUE"   ;;
    purple)    echo '#c18ed9' ;;
    gray|grey) echo '#787878' ;;
    pink)      echo '#ff8fd0' ;;
    teal)      echo '#4dd6c9' ;;
    mint)      echo '#7fe3a0' ;;
    brown)     echo '#a0764a' ;;
    fuchsia)   echo '#d94fa8' ;;
    indigo)    echo '#8b8ff5' ;;
    white)     echo '#ffffff' ;;
    black)     echo '#2b2b2b' ;;
    cyan)      echo '#32c8dc' ;;
    magenta)   echo '#c832c8' ;;
    lime)      echo '#64dc32' ;;
    coral)     echo '#ff7f50' ;;
    salmon)    echo '#fa8072' ;;
    gold)      echo '#ffd700' ;;
    navy)      echo '#000080' ;;
    maroon)    echo '#800000' ;;
    olive)     echo '#808000' ;;
    *)         echo "$1" ;;
  esac
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

# sync-tab-color.sh sources this file for the palette and tty helpers, so only
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
