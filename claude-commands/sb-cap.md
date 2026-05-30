---
description: Commit and push the current git branch
---

Commit all staged and unstaged changes on the current git branch with a well-written message following the repo's conventions, then push to the remote (setting upstream with `-u` if the branch isn't tracked yet).

Follow the commit-message guidance in the system prompt: run `git status`, `git diff`, and `git log` in parallel first; draft a concise message focused on *why*; never use `--no-verify` or `--amend`; do not commit files that look like secrets.
