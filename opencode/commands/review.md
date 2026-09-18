---
description: Review the current branch's changes (or $ARGUMENTS = a PR number/URL) with the read-only review subagent
agent: review
subtask: true
---

Review the changes on the current branch relative to its base (or `$ARGUMENTS` if it's a PR number or
URL). Follow the `review` agent's format: verdict, then major/minor/nit findings with `file:line` cites
and concrete fixes. Do not edit anything — report only.