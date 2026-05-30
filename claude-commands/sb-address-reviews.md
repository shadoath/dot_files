---
description: Address PR review comments (codex + human reviewers)
---

Address outstanding review comments on the PR for the current branch. If `$ARGUMENTS` contains a PR number or "all", target that scope instead.

Steps:
1. Find the PR: `gh pr view --json number,url,reviewDecision`. For "all", use `gh pr list --author "@me" --json number,url,title`.
2. For each PR in scope, fetch comments in parallel:
   - `gh api repos/{owner}/{repo}/pulls/{n}/comments` — inline review comments (incl. codex)
   - `gh pr view {n} --comments` — top-level review comments
3. Group comments by file and decide which are valid:
   - **Valid** → make the change.
   - **Invalid / already-addressed** → note it but don't waste effort; reply on the PR explaining why.
   - **Ambiguous** → ask me before changing.
4. Make the changes, run any affected tests, commit with a message like `address review comments`, and push.
5. Reply to each addressed comment on GitHub with a short note (`gh api ... -X POST`), or leave a single summary comment if there are many.
6. Report: what was changed, what was rejected (with reason), and the PR URL.

Don't blindly do whatever codex says — codex suggestions are sometimes wrong. Apply judgment.
