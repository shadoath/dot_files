#!/bin/bash
# Syncs the iTerm2 tab color to the current session's context.
# Invoked as a SessionStart and Stop hook — receives JSON on stdin with
# session_id, transcript_path, cwd, etc.
#
# Precedence:
#   1. A color pinned by set-tab-color.sh wins, so a hand-picked color survives
#      the next Stop instead of being overwritten seconds later.
#   2. A color name in the repo root's name (`web-blue`, `teal-tools`) sets that
#      color, so the tab signals which worktree you're in.
#   3. Anything else gets no color at all, leaving the tab at iTerm's default.

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
PINNED=$(read_pin "$PIN")
if [ -n "$PINNED" ]; then
  if RGB=$(color_to_rgb "$PINNED"); then
    touch "$PIN"   # keep an in-use pin from ageing out
    apply "$TARGET" $RGB
    exit 0
  fi
  # A pin we can't parse would otherwise wedge the tab with no color at all.
  rm -f "$PIN"
fi

# 2/3. A color name in the repo root's name, else nothing. Shared with
# set-tab-color.sh so `reset` restores exactly what the hook would have applied.
# Clear rather than bail when nothing derives, so a color left over from an
# earlier session in this terminal doesn't stick around.
if COLOR=$(derive_color "$CWD") && RGB=$(color_to_rgb "$COLOR"); then
  apply "$TARGET" $RGB
else
  printf "\033]6;1;bg;*;default\007" > "$TARGET"
fi
