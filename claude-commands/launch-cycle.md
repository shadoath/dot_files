---
description: Launch a multi-phase cron cycle that ships a feature via auto-merging PRs. Wraps the cron-cycle skill with lessons learned from prior runs.
---

# Launch a Cron Cycle

Your job: set up a multi-phase remote-agent cycle that ships a feature plan via auto-merging PRs, each phase one cloud agent.

## What this command does

1. **Confirm scope** — collect the plan or generate one
2. **Write plan file** to `plans/<feature-slug>.md` with checkboxes per phase
3. **Seed audit log** with a Run N header in `plans/cron-audit-log.md`
4. **Schedule cron triggers** via `RemoteTrigger create`, 25 min apart, with a tight prompt per phase
5. **Set up event-driven chain** via `.github/workflows/<feature-slug>-chain.yml` (uses `CLAUDE_TRIGGER_API_TOKEN` secret)
6. **Fire the first trigger immediately** via `RemoteTrigger run` to skip the initial cron wait
7. **Commit + push plan + workflow to master** so cloud agents can read them

## Inputs to collect

Before writing anything, ask:

- **Feature name** (slug — used in branch names, plan file, workflow name)
- **Number of phases** — how many small implementation phases? Each should be < 30 min of focused work
- **Brief description per phase** — one line each, you'll expand into trigger prompts
- **Reviews to run after** — pick from: test coverage, security, accessibility, naming/readability, DRY, performance, error handling, observability, accessibility (default: test coverage + security)
- **Branch prefix** (e.g., `rebuild-X-phase-N`, `lightweight-phase-AN`) — needs to be unique across active cycles to avoid chain collisions
- **Run number** — check `plans/cron-audit-log.md` for the next available

## Hard rules from prior runs

### Setup
- **Master uses bypass push for plan + audit-log + workflow files.** This works because the user has admin rights. Cloud agents do NOT have bypass — they open audit-only PRs to update the log.
- **Cron interval: 25 minutes.** 30 was too generous; 20 is too tight for first-time-context phases. 25 is the sweet spot.
- **Start the first phase immediately** via `RemoteTrigger run <trigger_id>` after creating it. Don't wait for the first cron tick.
- **First phase has no dependency check.** Subsequent phases dependency-check via `grep -q` or `test -f` against expected files from prior phase.

### Trigger prompts
Each prompt MUST include, in order:
1. Rules header (no chained bash, master-first pull, Minitest, branch name)
2. STEP 1: Record START_TIME via `date -u "+%Y-%m-%d %H:%M UTC"`
3. STEP 2: Heal master — check open PRs for failing CI, fix with 10-min budget, else log + exit
4. STEP 3: Dependency check (skip cleanly if missing)
5. STEP 4: Read context (plan file is source of truth; list specific files to Read)
6. STEP 5: `git checkout -b <branch>`
7. STEP 6: Implement per plan section
8. STEP 7: Update plan — change `[ ]` to `[x]` + add `✅ SHIPPED (PR #N)` to heading + update status table
9. STEP 8: Tests (`bundle exec rails test`) + `bundle exec rubocop`
10. STEP 9: Commit + `gh pr create` + `gh pr merge --auto --squash` + poll merge (5 min cap, sleep 30 in separate calls)
11. STEP 10: Audit log row on master — checkout master, pull, append row, commit, push. If push rejected (branch protection), open audit-only PR with `gh pr create` + `gh pr merge --auto --squash`

### Reviews
- Reviews look for issues, don't invent them — EVERY review prompt must include: "If no actionable issues found, log a ⏭ Skipped row and exit cleanly."
- Each review = ONE concern. Don't mix DRY + tests + perf in one review.
- Review branch only created if a PR actually opens.

### Final report
- One final report at the end, fires 25 min after last review.
- Direct push to master (no PR) — writes `plans/cron-cycle-reports/YYYY-MM-DD-runN.md`.
- Self-heals any stuck PRs from the cycle before composing.

### Event-driven chain workflow
File: `.github/workflows/<feature-slug>-chain.yml`. Structure:

```yaml
name: <Feature> Cycle Chain
on:
  pull_request:
    types: [closed]
    branches: [master]
jobs:
  fire_next:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Map branch to next trigger
        id: next
        run: |
          BRANCH="${{ github.event.pull_request.head.ref }}"
          case "$BRANCH" in
            <branch-1>) echo "trigger=<trigger_id_2>" >> "$GITHUB_OUTPUT" ;;
            <branch-2>) echo "trigger=<trigger_id_3>" >> "$GITHUB_OUTPUT" ;;
            *) echo "trigger=" >> "$GITHUB_OUTPUT" ;;
          esac
      - name: Fire next trigger
        if: steps.next.outputs.trigger != ''
        run: |
          curl -fsS -X POST "https://claude.ai/api/v1/code/triggers/${{ steps.next.outputs.trigger }}/run" \
            -H "Authorization: Bearer ${{ secrets.CLAUDE_TRIGGER_API_TOKEN }}" \
            -H "Content-Type: application/json" \
            -d '{}'
```

**KNOWN ISSUE**: as of Run 6/7 the `claude.ai/api/v1/...` endpoint returns 403 with the current token. Cron is the working fallback. When you set up a new cycle, mention this to the user and offer to investigate the right endpoint URL or token format. The cycle works fine on cron alone.

## RemoteTrigger create body template

```json
{
  "name": "<Feature> - <N>: <Phase Name>",
  "cron_expression": "<MM HH DD MO *>",
  "enabled": true,
  "job_config": {
    "ccr": {
      "environment_id": "env_014zXTKpAodYBoerU1pE2hh8",
      "session_context": {
        "model": "claude-opus-4-7",
        "sources": [{"git_repository": {"url": "https://github.com/<org>/<repo>"}}],
        "allowed_tools": ["Bash", "Read", "Write", "Edit", "Glob", "Grep"]
      },
      "events": [{
        "data": {
          "uuid": "<fresh v4 lowercase>",
          "session_id": "",
          "type": "user",
          "parent_tool_use_id": null,
          "message": {"role": "user", "content": "<prompt>"}
        }
      }]
    }
  }
}
```

## Plan file template

```markdown
# <Feature> — Plan

> <One-paragraph vision.>

**Current state** (as of YYYY-MM-DD):
- <file or system>: <state>

**Target state**:
- <desired end-state bullets>

## Files touched
- `<path>` — <which phase>

## Phased Implementation

### Phase 1: <name>
**Goal:** <one sentence>
- [ ] <specific task with file paths>
- [ ] <test to add>
- Branch: `<feature-slug>-phase-1`

### Phase 2: <name> — depends on Phase 1
- [ ] <task>
- Branch: `<feature-slug>-phase-2`

...

## Reviews
- [ ] Test coverage
- [ ] Security

## Final report
- Composes `plans/cron-cycle-reports/YYYY-MM-DD-runN.md`

## Status
| Phase | Status | PR |
|-------|--------|----|
| Phase 1 | Planned | — |
| Phase 2 | Planned | — |
```

## After scheduling

Tell the user:
- Full schedule table with UTC times and phase names
- That cron is the safety net; chain workflow is event-driven (or note the known 403 issue)
- That you'll be tracking via `plans/cron-audit-log.md` Run N rows
- Where the final report will land
- Total expected cycle duration

## Tips from prior runs

- **One UUID per trigger** (`uuidgen` × N, lowercase). Don't reuse.
- **Cron in UTC** (`MM HH DD MO *`). Anthropic scheduler adds ~3-6 min lag.
- **Avoid :00 and :30 minutes** when timing is flexible — schedulers cluster on round numbers.
- **Two phases can't fire at exact same minute** if they're in the same workflow — pick distinct minutes.
- **If a phase's prompt is > 8000 chars**, reference the plan file: "Implement Phase N per plans/X.md (source of truth)." Keep the prompt focused on STEPs + dep check + tests + audit row.
- **Phase prompts can be short** when the plan file is detailed. Use the plan as DRY source.
- **Run/Cycle numbering**: increments are global across the audit log. Check the existing log before picking your Run N.
- **Branch names need to be globally unique** across active cycles, or the chain workflow's case statement misroutes.

## When NOT to use this command

- Single-PR work — just do it directly
- Plans with < 3 phases — overhead not worth it
- Plans where each phase needs human judgment mid-stream — keep interactive
- Plans that touch shared infrastructure or DB schema in unrecoverable ways
