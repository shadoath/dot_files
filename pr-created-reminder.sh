#!/usr/bin/env bash
# PostToolUse (Bash) hook.
#
# Remind to run /review before enabling auto-merge — but ONLY after `gh pr create`.
# A hook's `matcher` can only filter by tool name (e.g. "Bash"), not by the command
# text, so this script inspects the actual command and stays silent unless a PR was
# really created. (The old inline hook used a bogus `"if"` key that Claude Code ignores,
# so it fired the reminder after every Bash command — a constant false trigger.)
cmd="$(cat | jq -r '.tool_input.command // ""' 2>/dev/null)"
# Match only at a command boundary (line start, or after && || ; | ( ) so that
# commit messages / echoes that merely mention the phrase don't trigger it.
if printf '%s' "$cmd" | grep -Eq '(^|[|&;(]|&&|\|\|)[[:space:]]*gh[[:space:]]+pr[[:space:]]+create'; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"A PR was just created. Before enabling auto-merge: run /review on the PR diff, address the findings, and ONLY THEN enable auto-merge (gh pr merge --auto --squash)."}}'
fi
exit 0
