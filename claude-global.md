# CLAUDE.md - Global Configuration

This file provides guidance to Claude Code across all projects.

## General Workflow

When working across multiple repositories, always confirm the current file structure and organization before making edits. Files may have been reorganized since last session.

## Interaction Style

Before implementing changes, briefly state your plan and wait for confirmation. Do not start editing files until the user approves the approach, especially for refactoring tasks.

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

## TypeScript

This project uses TypeScript extensively. When editing TS files, respect existing tsconfig paths, baseUrl settings, and import conventions. Always check tsconfig.json before modifying import paths.

## Code Review

When asked to review code or PRs, provide the review first and wait for user direction before making any code changes. Do not combine review and implementation unless explicitly asked.

## Data & Content Updates

For data entry tasks (JSON content updates, version history, newsletters), always confirm the target file structure and schema by reading an existing entry before adding new ones.
