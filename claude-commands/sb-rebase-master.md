---
description: Rebase current branch on master and push
---

Rebase the current branch onto the latest master (or `main`, whichever the repo uses) and push the result.

Steps:
1. Detect the default branch: `gh repo view --json defaultBranchRef -q .defaultBranchRef.name` (fall back to `master` then `main`).
2. Make sure the working tree is clean. If there are uncommitted changes, stop and tell me — don't auto-stash without asking.
3. `git fetch origin <default>`
4. `git rebase origin/<default>`
5. If conflicts occur:
   - Resolve them carefully — investigate intent rather than just picking one side.
   - For each conflicted file, show me the conflict markers and the resolution before continuing.
   - Never `git rebase --abort` or `git checkout --` to make conflicts go away without my OK.
6. After a clean rebase, push with `git push --force-with-lease` (never plain `--force`).
7. Report: number of commits rebased, any conflicts hit, and the final HEAD sha.
