---
description: Commit current work and open a draft PR
---

Commit any uncommitted work on the current branch, push it, and open a **draft** pull request (draft is the default — only open a non-draft PR if I explicitly say so).

Steps:
1. Run `git status`, `git diff`, and `git log <base>...HEAD` in parallel to understand all changes since the branch diverged from its base.
2. If there are uncommitted changes, commit them with a message focused on *why* (never `--no-verify`, never `--amend`).
3. Push with `-u` if the branch isn't tracked yet.
4. Open the PR with `gh pr create --draft`:
   - Title: short (<70 chars), follows repo style.
   - Body: `## Summary` (1–3 bullets, the *why*), then `## Test plan` (checklist). Keep descriptions short — do **not** add a "Testing" section or generic testing prose; the checklist is enough.
5. Print the PR URL.
