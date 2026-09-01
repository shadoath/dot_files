#!/bin/bash
# Syncs the iTerm2 tab color to the current session's context.
# Invoked as a SessionStart and Stop hook — receives JSON on stdin with
# session_id, transcript_path, cwd, etc.
#
# Precedence:
#   1. A color pinned by set-tab-color.sh wins, so a hand-picked color survives
#      the next Stop instead of being overwritten seconds later.
#   2. A `web-<color>` worktree forces that color, so the tab reliably signals
#      which worktree you're in.
#   3. Otherwise hash the repo root, so every session gets a color and a given
#      directory always looks the same. Stable per directory, not unique:
#      distinct repos can collide and share a color.

SCRIPT_DIR=$(python3 -c 'import os,sys; print(os.path.dirname(os.path.realpath(sys.argv[1])))' "$0" 2>/dev/null)
LIB="$SCRIPT_DIR/set-tab-color.sh"
[ -r "$LIB" ] || exit 0
. "$LIB"

INPUT=$(cat)

CWD=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)

if [ -z "$CWD" ]; then
  exit 0
fi

TARGET=$(resolve_tty) || exit 0

# 1. A pin outranks anything derived from the directory.
PIN=$(pin_file "$TARGET")
if [ -s "$PIN" ]; then
  RGB=$(color_to_rgb "$(cat "$PIN")") && apply "$TARGET" $RGB
  exit 0
fi

# Resolve the repo root up front so the reserved match and the hash below agree
# on one canonical path. This keeps the color steady as you cd around inside a
# worktree, and lets a worktree reached through a symlink still match its
# reserved name.
ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null)
[ -n "$ROOT" ] || ROOT="$CWD"
ROOT=${ROOT%/}
[ -n "$ROOT" ] || ROOT=/

# 2. Explicitly named worktrees win.
case "$ROOT" in
  */code/web-blue*)   COLOR=$RESERVED_BLUE   ;;
  */code/web-green*)  COLOR=$RESERVED_GREEN  ;;
  */code/web-yellow*) COLOR=$RESERVED_YELLOW ;;
  */code/web-orange*) COLOR=$RESERVED_ORANGE ;;
  */code/web-red*)    COLOR=$RESERVED_RED    ;;
esac

# 3. Hash the repo root against the shared swatch palette.
if [ -z "$COLOR" ]; then
  HASH=$(printf '%s' "$ROOT" | cksum | cut -d' ' -f1)
  PALETTE=($(hash_palette))
  [ ${#PALETTE[@]} -gt 0 ] || exit 0
  COLOR=${PALETTE[$(( HASH % ${#PALETTE[@]} ))]}
fi

RGB=$(color_to_rgb "$COLOR") || exit 0
apply "$TARGET" $RGB
