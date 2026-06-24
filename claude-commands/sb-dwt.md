---
description: Drop the current worktree via bin/worktree-remove
---

Drop a git worktree by calling `bin/worktree-remove <name>`, where `<name>` is the worktree directory name with the leading `web-` stripped off.

Steps:
1. Determine the name to pass:
   - If I gave an argument, use it (strip any leading `web-`).
   - Otherwise use the current worktree's directory basename (`basename "$PWD"`) and strip the leading `web-`. E.g. `web-sb-proxy-dashboards` → `sb-proxy-dashboards`.
2. Run `bin/worktree-remove <name>`.
3. This drops the associated databases and removes the worktree directory — show me the output so I can confirm it cleaned up.

Notes:
- `bin/worktree-remove` lives in the web repo; run it from inside that repo's checkout.
- Don't try to manually `git worktree remove` or drop databases yourself — `bin/worktree-remove` handles all of it.
