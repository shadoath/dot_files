# CLAUDE.md - Global Configuration

This file provides guidance to Claude Code across all projects.

I work in a tight, PR-driven Rails loop: investigate → implement → test → push → iterate on review comments. Match that rhythm. Keep responses terse — I read diffs, I don't need recaps.

## Default Session Workflow

Unless I say otherwise, every unit of work follows this sequence by default — I should not have to ask for it:

1. **Plan first.** Start in plan mode. Present the approach and wait for my confirmation before editing. (See *Interaction Style*.)
2. **Ask questions if needed.** Resolve ambiguity up front, before writing code — not after.
3. **Build.** Branch off `master` before the first edit, then implement. (See *Branch Before Editing*.)
4. **Open a PR.** Never merge directly to `master`. (See *Definition of Done*.)
5. **Run a code review.** Drive a `/review` loop on the PR.
6. **Address findings.** Loop until no **major** findings remain. (See *Definition of Done* for the major/minor distinction.)
7. **Enable auto-merge.** Let the PR merge itself when CI is green, then `gcom` back to `master`.

The sections below carry the detail and edge cases for each step; this is the canonical order. If a repo can't support part of it (no PR/CI/auto-merge), say so and propose the closest equivalent rather than silently skipping.

## Interaction Style

Before implementing changes, briefly state your plan and wait for confirmation. Do not start editing files until the user approves the approach, especially for refactoring tasks.

When you see a real choice between approaches, present numbered or lettered options (1/2/3 or A/B) and wait for me to pick. I reply with "Option 2" or "A" — make that easy.

## Pulling Ambiguity Out Early

These refine the plan/questions steps of the Default Session Workflow; that workflow still governs.

- **Batch your questions.** When requirements are unclear, gather everything that's still ambiguous and ask it as one stacked list — ordered by how much my answer would change the plan — so I can answer once and let you run. Don't dribble questions out one at a time.
- **Options before commitment.** For open-ended problems, present 2–4 approaches spanning cheapest → most ambitious and let me pick, rather than proposing one plan.
- **Blindspot pass.** If I'm clearly new to the domain, open with the unknown unknowns — what I'd need to know to direct the work well — before planning.
- **Ask for an example.** Before I describe something from scratch, ask if something close already exists (doc, design, code) to match instead.
- **Teach me to judge.** If I can't tell good output from bad, teach me the evaluation criteria before asking me to choose.

## Plans and Decision Logs

- In plans, put the decisions I might want to change at the top; routine steps last.
- On longer autonomous runs, log every judgment call my instructions didn't cover and surface the list at the end — decisions must not pass silently. (Same spirit as *Flag Manual Work*.)
- At closeout, summarize what changed well enough that I could explain it myself, and offer to quiz me on it. (A quiz is available on request, not a merge gate — the Definition of Done still governs merging.)

## Flag Manual Work — Keep Surfacing It Until Done

Any work that requires me to do something by hand — anything outside what you can do yourself — must be called out **in bold**. Examples: running an interactive login, setting an environment variable or secret, clicking through a dashboard, rotating a key, approving/merging something, restarting a service, or any step I have to perform manually.

- Call out each manual item in **bold** so it stands out.
- Keep bringing it up at the end of every relevant response until I explicitly mark it as done. Do not let it drop after mentioning it once.
- Maintain a short running checklist of outstanding manual items when there is more than one.
- These items are easy to lose track of, and when they fall through the cracks they cause issues that are hard to track down and debug — so err on the side of over-reminding.

## Branch Before Editing

When starting new work, create a branch before making the first file change — but only if currently on `master` (the default branch). Steps:

- Before the first file mutation (Edit/Write/etc.), check the current branch.
- If on `master`, create and switch to a well-named branch first: `feature/…` for new functionality, `fix/…` for bug fixes, `chore/…` for maintenance/docs/refactor.
- If already on a non-default branch (or detached HEAD), do not branch — keep working where you are.
- Read-only exploration does not trigger this — only an actual edit does.

## Git & PRs

- **Verify worktree before any git operation.** Run `git worktree list` and `git branch --show-current`. Feature branches are often checked out in a separate worktree (see `gbdm`); don't commit on the wrong one.
- **Draft PRs by default.** Use `gh pr create --draft` unless I explicitly say otherwise.
- **Never `--no-verify`, never `--amend`** unless I ask.
- **Don't wrap commit message lines.** No fixed line-length limit — write each line in full and let it run long rather than inserting hard line breaks. These messages land in production history and forced wrapping makes them annoying to read.
- **Write `gh pr create` / `gh pr edit` bodies via a temp file or HEREDOC**, not inline strings — backticks in descriptions break inline quoting.

## PR Descriptions — Keep Them Short

Keep PR descriptions SHORT.

- Structure: `## Summary` (1–3 bullets, the *why*) and `## Test plan` (a checklist). No "Testing" section, no generic testing prose — the checklist is enough.
- Skip filler sections; prefer a few tight bullets over long templated write-ups.

## Definition of Done — Open PR, Review to Green, Auto-Merge

Unless I say otherwise, treat "the work is done" as a workflow, not a stopping point. When a unit of work is complete:

- Open a pull request for the branch (do not merge directly to `master`).
- Run a `/review` loop on that PR: address findings, re-run review, repeat. Keep looping until no **major** findings remain that need to be addressed.
  - "Major" = correctness bugs, security issues, broken/missing tests, or anything that would block a careful human reviewer. Minor/nitpick/stylistic findings do not need to block the loop — note them but don't keep cycling on them.
- Once the review loop is clean of major findings, enable auto-merge so the PR merges itself when CI passes and required checks are green.
- After the merge completes, if I'm still on the merged branch, run the `gcom` alias to return to `master`. This pulls the merged changes into local `master` and deletes the now-stale branch, leaving me ready for the next unit of work. (`gcom` = `git checkout master && gpo && gbDm` — only for `master`-based repos without a `develop` branch.)

This is the default so I don't have to restate it per project. If a repo lacks PR/CI/auto-merge support, or the situation clearly calls for something else, say so and propose the closest equivalent rather than silently skipping it.

## Code Review & Iteration

When asked to review code or a PR cold, provide the review first and wait for my direction before making any code changes. Do not combine review and implementation unless explicitly asked.

Iterating on my own PR is different — that loop is expected:

- **After pushing any PR, run the review loop.** Once a PR is pushed/opened: (1) run the `/code-review` slash command on it and triage + address the findings (applying judgment, not blindly), then (2) check the PR for comments left by the other review bots (codex, etc.) and address any real issues they raise too. Don't consider the PR done until both the slash review and the bot comments have been worked through.
- **Run tests and rubocop locally before pushing**, not after CI catches it. For Ruby changes: `bundle exec rspec <touched specs>` and `bundle exec rubocop <modified files>`.
- **Don't over-consolidate.** When addressing review comments, make minimal targeted edits. Don't delete per-type descriptions, `rescue` paths, or existing behavior unless I explicitly ask.
- **Codex suggestions aren't gospel.** Apply judgment — if a codex comment is wrong or already addressed, push back rather than complying.
- **Check CI history before assuming a failing test is a real regression.** Known flakes are common; `gh run list` on the same spec across recent runs.
- **When changing shared code, audit all callers.** Before committing a change to a method or schema used elsewhere, grep for every call site and confirm their assumptions still hold. (Past pain: a `build_customer` tweak broke `purchase_orders` specs because nil-membership callers weren't checked.)

## Implementation Defaults

- **Investigate before implementing.** For non-trivial bugs or ambiguous reports, trace the code path and confirm the hypothesis before writing a fix. Don't open a PR until you can name the root cause.
- **Probe before building when evidence is weak.** When a fix rests on an unconfirmed theory about the root cause — especially for production failures, integration/proxy issues, or "I think X is happening" hunches — validate it with the cheapest probe first (a console snippet, log/Datadog/Rollbar query, grep, or tiny script) before writing the fix. If the load-bearing assumption is unverified, run `/sb-hc` to prove or kill the hypothesis, then implement. (Past pain: built a full Ferrum transport and proposed an Oxylabs failover before probes showed neither was needed.)
- **Default to the simplest viable approach**, especially for one-off tasks. Backfills, rake tasks, and migration scripts should be serial unless I ask for concurrency.
- **Keep comments short, or better, let the code explain itself.** Prefer self-documenting names and structure over comments; add a comment only when the *why* isn't obvious from the code. Don't narrate the *what*.
- **Verify third-party APIs exist before building on them.** Don't invent methods or properties that "feel right" — check the SDK docs, grep the codebase for existing usage, or write a tiny probe first. (Past pain: built against a non-existent Unlayer rows API before pivoting to native page anchors.)
- **For multi-tenant Rails work, use `Tenant.switch_each`.** Any query touching tenant-scoped data needs to iterate tenants, not run once against the public schema.
- **Per-tenant loops need per-iteration `rescue`.** When iterating with `Tenant.switch_each`, wrap the body so one bad tenant doesn't kill the whole audit — log the tenant and the error, then continue. Aggregate failures at the end.
- **Read-only by default for production console snippets.** No `update`/`destroy`/`delete_all`/job enqueues without an explicit `dry_run` gate.

## General Workflow

When working across multiple repositories, always confirm the current file structure and organization before making edits. Files may have been reorganized since last session.

## Data & Content Updates

For data entry tasks (JSON content updates, version history, newsletters), always confirm the target file structure and schema by reading an existing entry before adding new ones.
