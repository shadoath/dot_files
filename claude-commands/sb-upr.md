---
description: Update the PR title and description for the current branch
---

Update the existing pull request for the current branch with a refreshed title and description that reflect *all* commits on the branch (not just the latest).

Steps:
1. Find the PR for the current branch: `gh pr view --json number,title,body,baseRefName`. If there is no PR, stop and tell the user.
2. Gather full context in parallel: `git log <base>...HEAD`, `git diff <base>...HEAD`, `git status`.
3. Draft:
   - **Title**: short (under 70 chars), no trailing punctuation, follows the repo's existing PR title style (check recent merged PRs if unsure).
   - **Body**: a `## Summary` section with 1–3 bullets covering the *why*, then a `## Test plan` checklist. Preserve any existing sections the user clearly wants kept (e.g. issue links, screenshots) — show me the diff between old and new body if you're discarding anything non-trivial.
4. Apply with `gh pr edit --title "..." --body "$(cat <<'EOF' ... EOF)"`.
5. Print the PR URL.
