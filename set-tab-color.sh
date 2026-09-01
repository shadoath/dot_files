#!/bin/bash
# Sets the iTerm2 tab color for the terminal the calling session is attached to.
#
# Usage:
#   set-tab-color.sh <name|#rrggbb>     set the color and pin it for this terminal
#   set-tab-color.sh reset              clear the pin, hand the tab back to the hook
#   set-tab-color.sh --if-unpinned <c>  set only if nothing is pinned (used by the hook)
#   set-tab-color.sh --clear-pin        drop the pin without touching the tab
#
# Pinning is what makes a hand-picked color stick. sync-tab-color.sh re-derives a
# color from the directory on every Stop, so without a pin a manual choice would
# be overwritten seconds later. Pins are keyed by tty and live under /tmp, so they
# last for the session and are gone after a reboot.

PIN_DIR="/tmp/claude-tab-color-$(id -u)"

# iTerm's own tab-color swatches are the source of truth for the palette, so a
# color picked by right-clicking a tab and one picked here are the same color.
# Read them live on macOS; fall back to a copy for Linux boxes with no defaults.
FALLBACK_SWATCHES='#fb6b62 #f6ac47 #f0dc4f #b5d749 #5fa3f8 #c18ed9 #787878 #ff8fd0 #4dd6c9 #7fe3a0 #a0764a #d94fa8 #8b8ff5 #ffffff #2b2b2b'

swatches() {
  local s
  s=$(defaults read com.googlecode.iterm2 TabColorMenuOptions 2>/dev/null)
  [ -n "$s" ] || s=$FALLBACK_SWATCHES
  echo "$s"
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

# Resolve a color name or hex to "R G B". Names are kept for readability at call
# sites and in the worktree map; anything else is parsed as hex.
color_to_rgb() {
  local color=$1 hex
  case "$color" in
    red)        echo "220 50 50"   ; return 0 ;;
    blue)       echo "50 100 220"  ; return 0 ;;
    green)      echo "50 180 80"   ; return 0 ;;
    yellow)     echo "230 200 50"  ; return 0 ;;
    orange)     echo "240 150 30"  ; return 0 ;;
    purple)     echo "150 60 200"  ; return 0 ;;
    pink)       echo "240 120 180" ; return 0 ;;
    cyan)       echo "50 200 220"  ; return 0 ;;
    white)      echo "240 240 240" ; return 0 ;;
    black)      echo "30 30 30"    ; return 0 ;;
    magenta)    echo "200 50 200"  ; return 0 ;;
    lime)       echo "100 220 50"  ; return 0 ;;
    teal)       echo "0 180 180"   ; return 0 ;;
    indigo)     echo "75 0 130"    ; return 0 ;;
    coral)      echo "255 127 80"  ; return 0 ;;
    salmon)     echo "250 128 114" ; return 0 ;;
    gold)       echo "255 215 0"   ; return 0 ;;
    navy)       echo "0 0 128"     ; return 0 ;;
    maroon)     echo "128 0 0"     ; return 0 ;;
    olive)      echo "128 128 0"   ; return 0 ;;
  esac

  hex=$(echo "$color" | sed 's/^#//')
  if echo "$hex" | grep -qE '^[0-9a-fA-F]{6}$'; then
    echo "$((16#${hex:0:2})) $((16#${hex:2:2})) $((16#${hex:4:2}))"
    return 0
  fi
  return 1
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

apply() {
  local target=$1 r=$2 g=$3 b=$4
  printf "\033]6;1;bg;red;brightness;%d\007" "$r" > "$target"
  printf "\033]6;1;bg;green;brightness;%d\007" "$g" > "$target"
  printf "\033]6;1;bg;blue;brightness;%d\007" "$b" > "$target"
}

# sync-tab-color.sh sources this file for the palette and tty helpers, so only
# run the CLI when the script is executed directly.
[ "${BASH_SOURCE[0]}" = "$0" ] || return 0

TARGET=$(resolve_tty) || exit 0
PIN=$(pin_file "$TARGET")

case "$1" in
  --clear-pin)
    rm -f "$PIN"
    exit 0
    ;;
  reset)
    rm -f "$PIN"
    printf "\033]6;1;bg;*;default\007" > "$TARGET"
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
