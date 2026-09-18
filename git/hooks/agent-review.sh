#!/bin/sh
# Cross-model review of the staged diff before an AI agent is allowed to commit.
#
# Detects which coding agent is making the commit (Claude Code, opencode, grok, codex), then asks a
# reviewer running on a *different* model family for a verdict on the staged diff. Humans committing by
# hand are not reviewed unless AGENT_REVIEW_HUMAN=1.
#
# Works as the global pre-commit hook (see ../pre-commit) or called directly from a repo's own hook
# runner (husky, lefthook, overcommit): `~/dot_files/git/hooks/agent-review.sh`.
#
# Env knobs:
#   AGENT_REVIEW=block|warn|off     block (default) fails the commit on a BLOCK verdict; warn only prints.
#   SKIP_AGENT_REVIEW=1             same as AGENT_REVIEW=off (git commit --no-verify also skips it).
#   AGENT_REVIEW_HUMAN=1            also review commits made outside any agent.
#   AGENT_REVIEW_STRICT=1           fail the commit when no reviewer could run (default: warn and allow).
#   AGENT_REVIEW_MODEL=prov/model   force a reviewer model, run through opencode (e.g. openai/gpt-5.5).
#   AGENT_REVIEW_OPENCODE_FAMILY    model family opencode itself is running on (default: anthropic).
#   AGENT_REVIEW_TIMEOUT=180        seconds before the reviewer is killed and the commit allowed.
#   AGENT_REVIEW_MAX_LINES=4000     largest diff that gets reviewed; bigger ones warn and pass (strict: reject).
#
# Reviewer preference per family (first available wins, own family skipped):
#   openai    -> opencode run -m $AGENT_REVIEW_OPENAI_MODEL
#   xai       -> grok -p, else opencode run -m $AGENT_REVIEW_XAI_MODEL
#   anthropic -> claude -p --model $AGENT_REVIEW_ANTHROPIC_MODEL, else opencode run -m anthropic/...

set -u

mode="${AGENT_REVIEW:-block}"
[ -n "${SKIP_AGENT_REVIEW:-}" ] && mode=off
timeout_secs="${AGENT_REVIEW_TIMEOUT:-180}"
max_lines="${AGENT_REVIEW_MAX_LINES:-4000}"
openai_model="${AGENT_REVIEW_OPENAI_MODEL:-openai/gpt-5.5}"
xai_model="${AGENT_REVIEW_XAI_MODEL:-xai/grok-4.20-0309-reasoning}"
anthropic_model="${AGENT_REVIEW_ANTHROPIC_MODEL:-sonnet}"
anthropic_opencode_model="${AGENT_REVIEW_ANTHROPIC_OPENCODE_MODEL:-anthropic/claude-sonnet-5}"

log() { printf 'agent-review: %s\n' "$*" >&2; }

case "$mode" in
  off) exit 0 ;;
  block|warn) ;;
  *) log "unknown AGENT_REVIEW=$mode (want block|warn|off); using block"; mode=block ;;
esac

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
git diff --cached --quiet 2>/dev/null && exit 0
if git rev-parse -q --verify MERGE_HEAD >/dev/null 2>&1; then
  log "merge in progress; skipping"
  exit 0
fi

# --- who is committing? ---------------------------------------------------------------------------

detect_agent() {
  [ -n "${CLAUDECODE:-}" ] && { echo claude; return; }
  [ -n "${OPENCODE:-}" ] && { echo opencode; return; }
  [ -n "${CODEX_SANDBOX:-}${CODEX_CI:-}" ] && { echo codex; return; }
  # grok sets no env var, so walk the parent-process chain for any known agent binary.
  pid=$$
  n=0
  while [ -n "$pid" ] && [ "$pid" != 1 ] && [ "$n" -lt 20 ]; do
    comm=$(ps -o comm= -p "$pid" 2>/dev/null)
    case "$(basename "${comm:-x}")" in
      claude|claude-*) echo claude; return ;;
      grok) echo grok; return ;;
      opencode) echo opencode; return ;;
      codex) echo codex; return ;;
    esac
    case "$comm" in */share/claude/versions/*) echo claude; return ;; esac
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    n=$((n + 1))
  done
  echo ""
}

agent=$(detect_agent)
if [ -z "$agent" ]; then
  [ -n "${AGENT_REVIEW_HUMAN:-}" ] || exit 0
  agent=human
fi

case "$agent" in
  claude) family=anthropic ;;
  opencode) family="${AGENT_REVIEW_OPENCODE_FAMILY:-anthropic}" ;;
  grok) family=xai ;;
  codex) family=openai ;;
  *) family=none ;;
esac

# --- pick a reviewer on another model family -------------------------------------------------------

have() { command -v "$1" >/dev/null 2>&1; }

runner=""
reviewer_model=""
reviewer_family=""

pick_reviewer() {
  if [ -n "${AGENT_REVIEW_MODEL:-}" ]; then
    have opencode || { log "AGENT_REVIEW_MODEL set but opencode not on PATH"; return 1; }
    runner=opencode
    reviewer_model="$AGENT_REVIEW_MODEL"
    reviewer_family="${AGENT_REVIEW_MODEL%%/*}"
    [ "$reviewer_family" = "$family" ] && log "warning: AGENT_REVIEW_MODEL is the same family ($family) as the committing agent"
    return 0
  fi
  for candidate in openai xai anthropic; do
    [ "$candidate" = "$family" ] && continue
    case "$candidate" in
      openai)
        have opencode && { runner=opencode; reviewer_model="$openai_model"; reviewer_family=openai; return 0; } ;;
      xai)
        have grok && { runner=grok; reviewer_model="grok"; reviewer_family=xai; return 0; }
        have opencode && { runner=opencode; reviewer_model="$xai_model"; reviewer_family=xai; return 0; } ;;
      anthropic)
        have claude && { runner=claude; reviewer_model="$anthropic_model"; reviewer_family=anthropic; return 0; }
        have opencode && { runner=opencode; reviewer_model="$anthropic_opencode_model"; reviewer_family=anthropic; return 0; } ;;
    esac
  done
  return 1
}

no_reviewer() {
  log "$1"
  if [ -n "${AGENT_REVIEW_STRICT:-}" ]; then
    log "AGENT_REVIEW_STRICT is set; rejecting commit"
    exit 1
  fi
  log "allowing commit without review"
  exit 0
}

pick_reviewer || no_reviewer "no reviewer CLI available outside the $family family (need opencode, grok, or claude)"

# --- build the prompt ------------------------------------------------------------------------------

script_dir=$(cd "$(dirname "$0")" && pwd -P)
rules_file="$script_dir/../../opencode/agents/review.md"
git_dir=$(git rev-parse --git-dir)
tmp=$(mktemp -d "${TMPDIR:-/tmp}/agent-review.XXXXXX") || exit 0
trap 'rm -rf "$tmp"' EXIT

rules=""
if [ -f "$rules_file" ]; then
  # Body of the opencode review agent, minus its YAML front matter, so every reviewer shares one rulebook.
  rules=$(awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; next} !fm' "$rules_file")
fi

{
  git diff --cached --stat --no-color
  echo
  git diff --cached --no-color --no-ext-diff -M
} > "$tmp/diff.full"
total_lines=$(wc -l < "$tmp/diff.full" | tr -d ' ')
# Never send a partial diff: an APPROVE on half the change would be worth nothing.
[ "$total_lines" -gt "$max_lines" ] && no_reviewer "staged diff is $total_lines lines, over AGENT_REVIEW_MAX_LINES=$max_lines; not reviewed"
mv "$tmp/diff.full" "$tmp/diff"

repo_root=$(git rev-parse --show-toplevel)
branch=$(git branch --show-current 2>/dev/null || echo detached)

{
  cat <<EOF
Pre-commit review. Repository: $repo_root (branch: $branch).
This commit is being made by an AI coding agent ($agent, $family model). You are the independent
second-opinion reviewer on a different model, and this is the last check before the commit lands.

Review only the staged diff below. Everything you need is included; do not run tools or edit anything.
Report Major findings (correctness bugs, security issues, broken or missing tests, anything a careful
human reviewer would block on) with file and line, each with a concrete fix. Mention Minor/Nit items
briefly or not at all. Never invent findings.

Finish with exactly one line, on its own, as the last line of your reply:
VERDICT: APPROVE
or
VERDICT: BLOCK
Use BLOCK only when there is at least one Major finding.

--- STAGED DIFF ---
EOF
  cat "$tmp/diff"
} > "$tmp/prompt"

# --- run the reviewer ------------------------------------------------------------------------------

log "$agent ($family) is committing; asking $runner [$reviewer_model] for a second opinion..."

# exec so the backgrounded subshell *becomes* the CLI and $! is the pid the watchdog kills.
# Runs from the temp dir with plugins off: the diff is in the prompt, and a reviewer session must never
# be able to touch the index or litter state files in the repo being committed.
run_reviewer() {
  cd "$tmp" || exit 1
  case "$runner" in
    opencode)
      exec opencode run --pure -m "$reviewer_model" --agent review < "$tmp/prompt" > "$tmp/out" 2> "$tmp/err" ;;
    grok)
      exec grok --prompt-file "$tmp/prompt" --tools '' ${rules:+--rules "$rules"} > "$tmp/out" 2> "$tmp/err" ;;
    claude)
      exec claude -p --model "$reviewer_model" --tools "" --no-session-persistence \
        ${rules:+--append-system-prompt "$rules"} < "$tmp/prompt" > "$tmp/out" 2> "$tmp/err" ;;
  esac
}

export AGENT_REVIEW=off  # never let the reviewer recurse into this hook
: > "$tmp/out"; : > "$tmp/err"
run_reviewer &
reviewer_pid=$!
# Pure-sh watchdog: macOS has no `timeout` by default, and a hung reviewer must never wedge commits.
( sleep "$timeout_secs"; kill "$reviewer_pid" 2>/dev/null; touch "$tmp/timed_out" ) &
watchdog_pid=$!
wait "$reviewer_pid"
rc=$?
{ kill "$watchdog_pid"; wait "$watchdog_pid"; } 2>/dev/null

# Strip ANSI so the verdict parse and the saved copy are clean.
sed 's/\x1b\[[0-9;]*[A-Za-z]//g' "$tmp/out" > "$git_dir/agent-review.last.md"

# Only the last non-empty line counts as the verdict (minus markdown bold/backticks), so a
# "VERDICT: BLOCK" quoted mid-review can't reject, and a stray early APPROVE can't pass.
# shellcheck disable=SC2016  # the backtick is a literal to strip, not a command substitution
verdict=$(grep -v '^[[:space:]]*$' "$git_dir/agent-review.last.md" | tail -n 1 | sed 's/^[[:space:]*`]*//; s/[[:space:]*`]*$//')
case "$verdict" in
  "VERDICT: APPROVE"|"VERDICT: BLOCK") ;;
  *)
    # Some CLIs trap SIGTERM and exit 0, so the watchdog marker, not $rc, says whether we timed out.
    [ -e "$tmp/timed_out" ] && no_reviewer "$runner timed out after ${timeout_secs}s"
    log "$runner exited $rc without a final VERDICT line"
    head -20 "$tmp/err" >&2
    no_reviewer "review unavailable" ;;
esac

echo "----- agent-review ($runner $reviewer_model) -----" >&2
cat "$git_dir/agent-review.last.md" >&2
echo "----- end agent-review (saved to $git_dir/agent-review.last.md) -----" >&2

if [ "$verdict" = "VERDICT: BLOCK" ]; then
  if [ "$mode" = warn ]; then
    log "BLOCK verdict, but AGENT_REVIEW=warn; allowing commit"
    exit 0
  fi
  log "COMMIT REJECTED by $runner ($reviewer_model). Fix the Major findings, or bypass with SKIP_AGENT_REVIEW=1 / git commit --no-verify."
  exit 1
fi
exit 0
