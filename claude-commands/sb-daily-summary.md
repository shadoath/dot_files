---
description: Summarize merged PRs and closed Linear issues from the last 24 hours into a Slack blurb, link list, and outstanding manual follow-ups.
allowed-tools: Bash, Read
---

# Daily summary

Summarize my merged PRs and closed Linear issues from the last 24 hours.

Output exactly three parts:

1. A 3-sentence Slack blurb in plain language, no code.
2. A bulleted link list of PRs and Linear tickets.
3. Any manual follow-ups still outstanding.

Notes:

- Find merged PRs via `gh search prs --author=@me --merged --sort=updated` (or `gh pr list` per repo), scoped to the last 24 hours.
- Find closed Linear issues via the Linear MCP tools if available; otherwise say Linear data was unavailable rather than guessing.
- Headless equivalent for shell/cron use:
  `claude -p "Summarize my merged PRs and closed Linear issues from the last 24 hours. Output: (1) a 3-sentence Slack blurb in plain language, no code, (2) a bulleted link list of PRs and Linear tickets, (3) any manual follow-ups still outstanding." --allowedTools "Bash,Read"`
