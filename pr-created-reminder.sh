#!/usr/bin/env bash
# PostToolUse (Bash) hook.
#
# Remind to run /review before enabling auto-merge — but ONLY after a `gh pr create`
# that actually created a PR.
#
# A hook's `matcher` filters by tool name only (e.g. "Bash"), not command text, so
# the check has to live here. Matching the command string alone is unreliable: the
# phrase "gh pr create" also shows up in commit messages, `echo`, `--help`, and
# failed/aborted runs. So we require TWO signals from the PostToolUse payload:
#   1. the command referenced `gh pr create`, and
#   2. the tool output contains a freshly created PR URL (.../pull/<n>).
# `gh pr create` prints that URL to stdout on success, so together these fire the
# reminder exactly when a PR was really created. Requires jq (as do the sibling hooks).
input="$(cat)"
cmd="$(jq -r '.tool_input.command // ""' <<<"$input" 2>/dev/null)"
resp="$(jq -r '.tool_response // "" | tostring' <<<"$input" 2>/dev/null)"

if printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]_])gh[[:space:]]+pr[[:space:]]+create' \
   && printf '%s' "$resp" | grep -Eq 'https://github\.com/[^/[:space:]]+/[^/[:space:]]+/pull/[0-9]+'; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"A PR was just created. Before enabling auto-merge: run /review on the PR diff, address the findings, and ONLY THEN enable auto-merge (gh pr merge --auto --squash)."}}'
fi
exit 0
