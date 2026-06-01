---
description: Update or add tests/specs for recent changes
---

Update or add tests covering the most recent changes on this branch.

Steps:
1. Identify what changed: `git diff <base>...HEAD` and `git log <base>...HEAD --stat`. Default base is the merge-base with the repo's default branch.
2. For each non-trivial code change, find the corresponding spec/test file (follow the repo's conventions — e.g. `spec/` mirrors `app/` in Rails, `__tests__/` colocated in JS).
3. Update existing specs that now fail or no longer cover the behavior, and add new specs for new behavior. Include edge cases: empty/nil inputs, error paths, boundary conditions.
4. Run the affected specs and make sure they pass. If a spec is failing because of a real bug (not a test gap), surface it instead of papering over it.
5. Report: which files were updated, which were added, and the test command output summary.

If the repo uses RSpec, prefer `it` blocks with descriptive English. If Jest/Vitest, follow existing `describe`/`it` style.
