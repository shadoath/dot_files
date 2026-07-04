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
#   2. its STDOUT contains a created PR URL (.../pull/<n>).
# `gh pr create` prints that URL to stdout on success. We deliberately ignore stderr:
# a failed run (e.g. "a pull request ... already exists: <url>") writes its URL there,
# and we don't want to claim a PR was "just created" when none was. Requires jq (as do
# the sibling hooks).
input="$(cat)"

# Cheap check first — bail before touching the (possibly huge) response payload on the
# hot path, since this hook runs after every Bash command.
cmd="$(jq -r '.tool_input.command // ""' <<<"$input" 2>/dev/null)"
printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]_])gh[[:space:]]+pr[[:space:]]+create' || exit 0

# Confirm a PR was really created: look for a fresh PR URL in stdout only.
out="$(jq -r '(.tool_response // "") | if type == "object" then (.stdout // "") else tostring end' <<<"$input" 2>/dev/null)"
if printf '%s' "$out" | grep -Eq 'https://github\.com/[^/[:space:]]+/[^/[:space:]]+/pull/[0-9]+'; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"A PR was just created. Before enabling auto-merge: run /review on the PR diff, address the findings, and ONLY THEN enable auto-merge (gh pr merge --auto --squash)."}}'
fi
exit 0
