#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"

hook_event="$(jq -r '.hook_event_name // empty' <<<"$payload")"
tool_name="$(jq -r '.tool_name // empty' <<<"$payload")"
notification_type="$(jq -r '.notification_type // empty' <<<"$payload")"
msg="$(jq -r '.message // empty' <<<"$payload")"

# Build title with tmux session:window from the pane that owns this process
cwd="$(jq -r '.cwd // empty' <<<"$payload")"
cwd_short="${cwd##*/}"
tmux_info=""
if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null 2>&1; then
  # Walk up the process tree to find the PID that lives in a tmux pane
  pid=$$
  while [[ -n "$pid" && "$pid" -ne 1 ]]; do
    pane_info="$(tmux list-panes -a -F '#{pane_pid} #{session_name} #{window_index}' 2>/dev/null \
      | awk -v p="$pid" '$1 == p {print $2, $3; exit}')"
    if [[ -n "$pane_info" ]]; then
      tmux_info="$pane_info"
      break
    fi
    pid="$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')"
  done
fi
if [[ -n "$tmux_info" ]]; then
  tmux_session="${tmux_info% *}"
  tmux_window="${tmux_info#* }"
  title="Claude [$tmux_session] #$tmux_window"
else
  title="Claude — $cwd_short"
fi

notify() {
  terminal-notifier -title "$title" -message "$1" -sound "${2:-default}" -group "claude-notify"
}

case "$hook_event" in
  PermissionRequest)
    case "$tool_name" in
      Bash)
        desc="$(jq -r '.tool_input.description // empty' <<<"$payload")"
        if [[ -n "$desc" ]]; then
          notify "Permission: $desc"
        else
          cmd="$(jq -r '.tool_input.command // empty' <<<"$payload" | head -c 80)"
          notify "Permission: Bash — $cmd"
        fi
        ;;
      Write|Edit|Read)
        file="$(jq -r '.tool_input.file_path // empty' <<<"$payload")"
        basename="${file##*/}"
        notify "Permission: $tool_name $basename"
        ;;
      ExitPlanMode)
        notify "Approve plan"
        ;;
      AskUserQuestion)
        notify "Claude has a question"
        ;;
      *)
        notify "Permission: $tool_name"
        ;;
    esac
    ;;
  Notification)
    case "$notification_type" in
      permission_prompt)
        notify "${msg:-Permission needed}"
        ;;
      idle_prompt)
        notify "Claude needs input"
        ;;
      elicitation_dialog)
        notify "Claude has a question"
        ;;
      *)
        notify "${msg:-Needs attention}"
        ;;
    esac
    ;;
  Stop)
    notify "Claude finished" "Glass"
    ;;
  *)
    notify "${msg:-Needs attention}"
    ;;
esac
