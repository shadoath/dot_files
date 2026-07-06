# CLAUDE.md - Global Configuration

This file provides guidance to Claude Code across all projects.

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

## General Workflow

When working across multiple repositories, always confirm the current file structure and organization before making edits. Files may have been reorganized since last session.

## Interaction Style

Before implementing changes, briefly state your plan and wait for confirmation. Do not start editing files until the user approves the approach, especially for refactoring tasks.

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

## Definition of Done — Open PR, Review to Green, Auto-Merge

Unless I say otherwise, treat "the work is done" as a workflow, not a stopping point. When a unit of work is complete:

- Open a pull request for the branch (do not merge directly to `master`).
- Run a `/review` loop on that PR: address findings, re-run review, repeat. Keep looping until no **major** findings remain that need to be addressed.
  - "Major" = correctness bugs, security issues, broken/missing tests, or anything that would block a careful human reviewer. Minor/nitpick/stylistic findings do not need to block the loop — note them but don't keep cycling on them.
- Once the review loop is clean of major findings, enable auto-merge so the PR merges itself when CI passes and required checks are green.
- After the merge completes, if I'm still on the merged branch, run the `gcom` alias to return to `master`. This pulls the merged changes into local `master` and deletes the now-stale branch, leaving me ready for the next unit of work. (`gcom` = `git checkout master && gpo && gbDm` — only for `master`-based repos without a `develop` branch.)

This is the default so I don't have to restate it per project. If a repo lacks PR/CI/auto-merge support, or the situation clearly calls for something else, say so and propose the closest equivalent rather than silently skipping it.

## PR Descriptions — Keep Them Short

Keep PR descriptions SHORT. A brief summary of what changed and why is enough.

- Do **not** add a `## Test plan` section (or any equivalent test-plan/checklist boilerplate).
- Skip filler sections; prefer a few tight sentences or a short bullet list over long templated write-ups.

## Code Review

When asked to review code or PRs, provide the review first and wait for user direction before making any code changes. Do not combine review and implementation unless explicitly asked.

## Data & Content Updates

For data entry tasks (JSON content updates, version history, newsletters), always confirm the target file structure and schema by reading an existing entry before adding new ones.
