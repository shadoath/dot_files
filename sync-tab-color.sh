#!/bin/bash
# Syncs the iTerm2 tab color to the current session's context.
# Invoked as a SessionStart and Stop hook — receives JSON on stdin with
# session_id, transcript_path, cwd, etc.
#
# Precedence:
#   1. If the session runs in a `web-<color>` worktree, force that color so the
#      tab reliably signals which worktree you're in.
#   2. Otherwise fall back to the session's agentColor from the transcript.

INPUT=$(cat)

# 1. Worktree-based color wins — check cwd before consulting the transcript.
CWD=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)
case "$CWD" in
  */code/web-blue*)   COLOR=blue   ;;
  */code/web-green*)  COLOR=green  ;;
  */code/web-yellow*) COLOR=yellow ;;
esac

# 2. Fall back to the session's agent color from the transcript.
if [ -z "$COLOR" ]; then
  TRANSCRIPT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('transcript_path',''))" 2>/dev/null)

  if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
    exit 0
  fi

  COLOR=$(grep -o '"agentColor":"[^"]*"' "$TRANSCRIPT" | tail -1 | cut -d'"' -f4)

  if [ -z "$COLOR" ]; then
    exit 0
  fi
fi

# Map color names to R G B (0-255)
case "$COLOR" in
  red)        R=220 G=50  B=50  ;;
  blue)       R=50  G=100 B=220 ;;
  green)      R=50  G=180 B=80  ;;
  yellow)     R=230 G=200 B=50  ;;
  orange)     R=240 G=150 B=30  ;;
  purple)     R=150 G=60  B=200 ;;
  pink)       R=240 G=120 B=180 ;;
  cyan)       R=50  G=200 B=220 ;;
  white)      R=240 G=240 B=240 ;;
  black)      R=30  G=30  B=30  ;;
  magenta)    R=200 G=50  B=200 ;;
  lime)       R=100 G=220 B=50  ;;
  teal)       R=0   G=180 B=180 ;;
  indigo)     R=75  G=0   B=130 ;;
  coral)      R=255 G=127 B=80  ;;
  salmon)     R=250 G=128 B=114 ;;
  gold)       R=255 G=215 B=0   ;;
  navy)       R=0   G=0   B=128 ;;
  maroon)     R=128 G=0   B=0   ;;
  olive)      R=128 G=128 B=0   ;;
  *)
    # Try to parse as hex (#RRGGBB or RRGGBB)
    HEX=$(echo "$COLOR" | sed 's/^#//')
    if echo "$HEX" | grep -qE '^[0-9a-fA-F]{6}$'; then
      R=$((16#${HEX:0:2}))
      G=$((16#${HEX:2:2}))
      B=$((16#${HEX:4:2}))
    else
      exit 0
    fi
    ;;
esac

# Hooks run as a detached subprocess with no controlling terminal, so /dev/tty
# fails. Walk up the process tree to find Claude Code's TTY device and write
# the escape sequences to it directly — writes to a slave PTY device from
# another process are processed by the terminal emulator as program output.
TARGET=""
PID=$PPID
while [ "$PID" -gt 1 ]; do
  TTY_NAME=$(ps -o tty= -p "$PID" 2>/dev/null | tr -d ' ')
  if [ -n "$TTY_NAME" ] && [ "$TTY_NAME" != "??" ] && [ "$TTY_NAME" != "-" ]; then
    TARGET="/dev/$TTY_NAME"
    break
  fi
  PID=$(ps -o ppid= -p "$PID" 2>/dev/null | tr -d ' ')
  if [ -z "$PID" ]; then
    break
  fi
done

if [ -z "$TARGET" ] || [ ! -w "$TARGET" ]; then
  exit 0
fi

printf "\033]6;1;bg;red;brightness;%d\007" "$R" > "$TARGET"
printf "\033]6;1;bg;green;brightness;%d\007" "$G" > "$TARGET"
printf "\033]6;1;bg;blue;brightness;%d\007" "$B" > "$TARGET"
