# CLAUDE.md - Global Configuration

This file provides guidance to Claude Code across all projects.

I work in a tight, PR-driven Rails loop: investigate → implement → test → push → iterate on review comments. Match that rhythm. Keep responses terse — I read diffs, I don't need recaps.

## Repo conventions win

When a repo's own `CLAUDE.md`/`AGENTS.md` states a convention that conflicts with this file — branch naming, PR description structure, commit format, comment policy — follow My personal settings.

## Default Session Workflow

Unless I say otherwise, every unit of work follows this sequence by default — I should not have to ask for it:

1. **Spec first, then plan.** Before proposing an approach, nail down the desired end result — expected behavior, inputs/outputs, acceptance criteria — and work backward from it (see *Spec/Test-First Development*). Only after the result is defined, start in plan mode: present the approach and wait for my confirmation before editing. (See *Interaction Style*.)
2. **Ask questions if needed.** Resolve ambiguity up front, before writing code — not after.
3. **Build.** Branch off `master` before the first edit, then implement. (See *Branch Before Editing*.)
4. **Open a PR — ready for review, never draft.** Never merge directly to `master`. (See *Definition of Done*.)
5. **Run both reviews.** `/code-review` locally; Codex fires on its own when the PR opens ready (comment `@codex review` to re-trigger after pushing fixes).
6. **Address findings.** Loop until both reviews are clear of **major** findings. (See *Definition of Done* for the major/minor distinction.)
7. **Enable auto-merge.** Let the PR merge itself when CI is green, then `gcom` back to `master`.
8. **Bump the version.** Once the work has landed, open the version-bump PR so the shipped/deployed version isn't stale.

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

## Spec/Test-First Development

These refine step 1 of the Default Session Workflow (spec before plan); that workflow still governs. This exists to catch false assumptions about how the system actually behaves before they get baked into a fix.

- Where the codebase and task support it, write the test(s) that encode the desired behavior first — after I've approved the plan, as the first part of *Build* — confirm they fail for the right reason, then implement until they pass.
- If my request implies an assumption about current behavior ("X currently does Y"), verify it against code/tests/logs before planning around it — don't take it as given. (Reinforces *Investigate before implementing* and *Probe before building when evidence is weak* below.)
- Expect this to mean more time in planning and more questions before code gets written — that's the intent, not a detour.

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
- **Ready PRs by default — never draft.** Use plain `gh pr create` (no `--draft`) unless I explicitly ask for a draft. Draft PRs rot: I go to a repo and find weeks-old drafts that should have merged long ago, and shipped versions that never got bumped. If a branch is worth pushing, it's worth opening ready and driving to merge. Anything already sitting in draft gets flipped ready (`gh pr ready <n>`) or closed — don't leave it.
- **Never `--no-verify`, never `--amend`** unless I ask.
- **Don't wrap commit message lines.** No fixed line-length limit — write each line in full and let it run long rather than inserting hard line breaks. These messages land in production history and forced wrapping makes them annoying to read.
- **Write `gh pr create` / `gh pr edit` bodies via a temp file or HEREDOC**, not inline strings — backticks in descriptions break inline quoting.

## PR Descriptions — Keep Them Short

Keep PR descriptions SHORT and minimal.

- Structure: a `## Summary` with 1–3 bullets on the *why*. That's it.
- **Never include a `## Test plan` section** — no test plan, no test checklist, no "Testing" section, no generic testing prose. I really don't want it.
- Skip filler sections; prefer a few tight bullets over long templated write-ups.

## Definition of Done — Ready PR, Two Reviews to Green, Auto-Merge, Version Bump

Unless I say otherwise, treat "the work is done" as a workflow, not a stopping point. When a unit of work is complete:

- **Open a ready-for-review pull request** for the branch — not a draft (do not merge directly to `master`).
- **Run both review passes:**
  1. `/code-review` on the PR — triage and address the findings.
  2. Codex — it reviews automatically when a PR opens ready or a draft is marked ready, so opening ready is itself the trigger. Comment `@codex review` to re-trigger after pushing fixes. Address what it raises with judgment (see *Codex suggestions aren't gospel*).
- Loop both until no **major** findings remain from either.
  - "Major" = correctness bugs, security issues, broken/missing tests, or anything that would block a careful human reviewer. Minor/nitpick/stylistic findings do not need to block the loop — note them but don't keep cycling on them.
- Once both reviews are clean of major findings, enable auto-merge so the PR merges itself when CI passes and required checks are green.
- After the merge completes, if I'm still on the merged branch, run the `gcom` alias to return to `master`. This pulls the merged changes into local `master` and deletes the now-stale branch, leaving me ready for the next unit of work. (`gcom` = `git checkout master && gpo && gbDm` — only for `master`-based repos without a `develop` branch.)
- **Then bump the version.** Once all the work for the release has landed, open a version-bump PR through the same loop. A merged fix that never ships is the same as no fix — never leave the deployed/published version stale behind merged work.

This is the default so I don't have to restate it per project. If a repo lacks PR/CI/auto-merge support, or the situation clearly calls for something else, say so and propose the closest equivalent rather than silently skipping it.

**Never park work in a draft PR and walk away.** If something genuinely blocks merging, say so explicitly in the response and keep surfacing it (see *Flag Manual Work*) — don't let a stalled PR sit silently in a repo.

## Code Review & Iteration

When asked to review code or a PR cold, provide the review first and wait for my direction before making any code changes. Do not combine review and implementation unless explicitly asked.

Iterating on my own PR is different — that loop is expected:

- **After pushing any PR, run the review loop.** Once a PR is pushed/opened: (1) run the `/code-review` slash command on it and triage + address the findings (applying judgment, not blindly), then (2) comment `@codex review` on the PR to trigger Codex, and address any real issues it (or another review bot) raises. Don't consider the PR done until both the slash review and the bot comments have been worked through.
- **Default `/code-review` to `medium`. Never run `xhigh`, `max`, or the workflow-backed multi-agent mode unless I ask for it by name.** One `xhigh` run spawns 30–50 subagents; a six-loop session on three small perf PRs burned ~220 agents and ~15M subagent tokens. `high` is the ceiling for ordinary work, and only when the change is genuinely risky — correctness-critical logic, security, data migrations, or something that reaches production silently. Start at `medium` and escalate only if it comes back thin.
- **Quote the cost before escalating a review.** If a level implies a large fan-out, say roughly how many agents that means and let me choose, rather than escalating on my behalf. Same for re-reviewing after each fix round — prefer scoping the re-review to the changed hunks over re-running the whole thing.
- **Cap the wait for PR comments at 10 minutes.** Tests and checks are fast — keep the loop small and tight. If review comments haven't landed within 10 minutes of polling, stop waiting and tell me rather than idling longer.
- **Run tests and rubocop locally before pushing**, not after CI catches it. For Ruby changes: `bundle exec rspec <touched specs>` and `bundle exec rubocop <modified files>`.
- **Don't over-consolidate.** When addressing review comments, make minimal targeted edits. Don't delete per-type descriptions, `rescue` paths, or existing behavior unless I explicitly ask.
- **Codex suggestions aren't gospel.** Apply judgment — if a codex comment is wrong or already addressed, push back rather than complying.
- **Check CI history before assuming a failing test is a real regression.** Known flakes are common; `gh run list` on the same spec across recent runs.
- **When changing shared code, audit all callers.** Before committing a change to a method or schema used elsewhere, grep for every call site and confirm their assumptions still hold. (Past pain: a `build_customer` tweak broke `purchase_orders` specs because nil-membership callers weren't checked.)

## Implementation Defaults

- **Investigate before implementing.** For non-trivial bugs or ambiguous reports, trace the code path and confirm the hypothesis before writing a fix. Don't open a PR until you can name the root cause.
- **Read the full ticket/thread before planning.** When work originates from a Linear/Asana ticket or a Slack thread, read every comment — not just the description or first message — and take the time to open and review any linked docs, PRs, screenshots, or attachments before forming a plan. The real constraints, prior attempts, and decisions usually live in the comments and links, and a plan made without them solves the wrong problem.
- **Probe before building when evidence is weak.** When a fix rests on an unconfirmed theory about the root cause — especially for production failures, integration/proxy issues, or "I think X is happening" hunches — validate it with the cheapest probe first (a console snippet, log/Datadog/Rollbar query, grep, or tiny script) before writing the fix. If the load-bearing assumption is unverified, run `/sb-hc` to prove or kill the hypothesis, then implement. (Past pain: built a full Ferrum transport and proposed an Oxylabs failover before probes showed neither was needed.)
- **Default to the simplest viable approach**, especially for one-off tasks. Backfills, rake tasks, and migration scripts should be serial unless I ask for concurrency.
- **Keep comments short, or better, let the code explain itself.** Prefer self-documenting names and structure over comments; add a comment only when the *why* isn't obvious from the code. Don't narrate the *what*.
- **Verify third-party APIs exist before building on them.** Don't invent methods or properties that "feel right" — check the SDK docs, grep the codebase for existing usage, or write a tiny probe first. (Past pain: built against a non-existent Unlayer rows API before pivoting to native page anchors.)
- **For multi-tenant Rails work, use `Tenant.switch_each`.** Any query touching tenant-scoped data needs to iterate tenants, not run once against the public schema.
- **Per-tenant loops need per-iteration `rescue`.** When iterating with `Tenant.switch_each`, wrap the body so one bad tenant doesn't kill the whole audit — log the tenant and the error, then continue. Aggregate failures at the end.
- **Read-only by default for production console snippets.** No `update`/`destroy`/`delete_all`/job enqueues without an explicit `dry_run` gate.

## Writing Tickets

When writing tickets (Linear, Asana, GitHub issues, etc.), keep them readable by anyone — not just engineers.

- **No code snippets.** Describe behavior in plain language instead of pasting code.
- Structure every ticket with three sections:
  - **Goal** — what should be true when this is done.
  - **Why** — the motivation or problem driving the work.
  - **Proposed Solution** — the approach, described simply.
- Keep each section short and plain — a non-technical reader should be able to follow it.

## General Workflow

When working across multiple repositories, always confirm the current file structure and organization before making edits. Files may have been reorganized since last session.

## Data & Content Updates

For data entry tasks (JSON content updates, version history, newsletters), always confirm the target file structure and schema by reading an existing entry before adding new ones.


<!-- SEMBLE_START -->
## Semble Code Search

A `semble` MCP server is available with two tools:
- `mcp__semble__search` — search the codebase with a natural-language or code query.
- `mcp__semble__find_related` — find code similar to a specific file and line.

**Anytime you're searching code (i.e. reaching for Grep, Glob, or reading files to find something), prefer `mcp__semble__search` instead — it's faster and uses far fewer tokens.** After semble returns the file and line, navigate there directly and read that file. Do not grep for the same content again.

Pass `--content docs` to search documentation and prose, `--content config` for config files, or `--content all` to search code, docs, and config together.

For CLI fallback or sub-agents without MCP access, use:

```bash
semble search "authentication flow" ./my-project --max-snippet-lines 10
semble search "deployment guide" ./my-project --content docs
semble search "database host port" ./my-project --content config
semble find-related src/auth.py 42 ./my-project
semble search "save model to disk" ./my-project --top-k 10
```

The index is built on first run and cached automatically. If `semble` is not on `$PATH`, use `uvx --from "semble[mcp]==0.5.3" semble`.

### Workflow

1. Call `mcp__semble__search` with a query describing what the code does or its name. The tool returns results with 10 lines of context each (function/class signature + first body lines, enough to confirm the location).
2. Navigate directly to the top result's file and line. Read only the function or class at that location.
3. Make the edit. Do not re-search or grep for the same content.
4. Use `--content docs` for documentation, `--content config` for config files, or `--content all` for everything.
5. Optionally use `mcp__semble__find_related` with `file_path` and `line` to discover similar code elsewhere.
6. Use Grep only when you need every occurrence of a literal string across the whole repo (e.g., all callers of a renamed function).
<!-- SEMBLE_END -->
