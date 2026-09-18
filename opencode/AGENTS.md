# OpenCode Global Rules

These are the opencode entrypoint to a rules setup shared with Claude Code. The canonical personal
workflow rules live in `~/dot_files/claude-global.md` and are loaded via the `instructions` array in
`opencode.jsonc` — treat that file as authoritative; this file only adds the opencode-specific layer and
the per-repo split opencode cannot see on its own.

## Per-repo rules — CLAUDE.local.md

opencode only auto-loads `AGENTS.md` / `CLAUDE.md`; it does NOT read `CLAUDE.local.md`. But every repo
and worktree has one symlinked in by `~/dot_files/sync-claude-local.sh` with the org-specific
conventions (Codex review flow for personal repos, Arby for rinsed-org, multi-tenant/app-specific
production rules, version-bump policies).

- **At the start of any task in a repo, check for `CLAUDE.local.md` at the repo root and Read it.** Also
  re-check the repo's own `AGENTS.md`/`CLAUDE.md`. Treat those as binding on top of the globals.
- If a repo has no `CLAUDE.local.md`, flag it and suggest running `~/dot_files/sync-claude-local.sh`;
  default to the Codex flow unless the remote is under `rinsed-org/`.

## Working style

- One unit of work = investigate → implement → test → PR → review loop → auto-merge → version bump.
  Keep responses terse; I read diffs, not recaps.
- Spec first, then plan. For any non-trivial change, work out the desired end state and present the
  approach in Plan mode (Tab) and wait for my confirmation before editing.
- Batch your questions up front, ordered by how much the answer changes the plan. Present real choices
  as numbered options (1/2/3) and let me pick.
- Branch off `master` (or the repo's default) before the first edit: `feature/…`, `fix/…`,
  `chore/…`. Verify worktree (`git worktree list`) before any git operation.
- PRs: ready by default, never draft. Short `## Summary` (1–3 bullets, the *why*). No `## Test plan`
  section. Round the review loop to green: `/review` locally, then the repo's bot (Codex / Arby per
  `CLAUDE.local.md`).
- Investigate before implementing: cite `file:line` or query output, keep unverified hypotheses in a
  separate list, probe before building when evidence is weak, read the full ticket/thread before planning.
- Flag anything I must do by hand in **bold**, and keep surfacing it until done.

## Commands & agents bundled here

- Slash commands in `~/dot_files/opencode/commands/` (ported from the Claude `sb-*` suite, incl.
  `/review`). Full inventory: `sb-cap`, `sb-daily-summary`, `sb-draft-pr`, `sb-dwt`, `sb-hc`,
  `sb-next-task`, `sb-prod-query`, `sb-rebase-master`, `sb-review-loop`, `sb-say-again`, `sb-tab-color`,
  `sb-update-specs`, `sb-upr`, and `/review` (runs the `review` subagent).
- The `review` subagent in `~/dot_files/opencode/agents/` is a read-only reviewer: `edit: deny`,
  bash restricted to read-only git/gh. Use it for cold code review — review before implementation, then
  wait for my direction before changing anything.

## Context discipline

- Start a fresh session per PR/feature/bug; `/compact` when a session bloats. Keep MCP servers to what
  the task needs — every active server eats context before work starts.
- Delegate context-heavy or token-heavy work to subagents on a cheaper model when possible; skip
  delegation when briefing the subagent would cost more than doing it yourself.