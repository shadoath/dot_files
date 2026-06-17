
# Working with me

I work in a tight, PR-driven Rails loop: investigate → implement → test → push → iterate on review comments. Match that rhythm. Keep responses terse — I read diffs, I don't need recaps.

When you see a real choice between approaches, present numbered or lettered options (1/2/3 or A/B) and wait for me to pick. I reply with "Option 2" or "A" — make that easy.

## Git & PRs

- **Verify worktree before any git operation.** Run `git worktree list` and `git branch --show-current`. Feature branches are often checked out in a separate worktree (see `gbdm`); don't commit on the wrong one.
- **Draft PRs by default.** Use `gh pr create --draft` unless I explicitly say otherwise.
- **PR descriptions are short.** `## Summary` (1–3 bullets, the *why*) and `## Test plan` (checklist). No "Testing" section, no generic testing prose — the checklist is enough.
- **Never `--no-verify`, never `--amend`** unless I ask. Force-pushes use `--force-with-lease`, never plain `--force`.
- **Write `gh pr create` / `gh pr edit` bodies via a temp file or HEREDOC**, not inline strings — backticks in descriptions break inline quoting.

## Code review & iteration

- **Run tests and rubocop locally before pushing**, not after CI catches it. For Ruby changes: `bundle exec rspec <touched specs>` and `bundle exec rubocop <modified files>`.
- **Don't over-consolidate.** When addressing review comments, make minimal targeted edits. Don't delete per-type descriptions, `rescue` paths, or existing behavior unless I explicitly ask.
- **Codex suggestions aren't gospel.** Apply judgment — if a codex comment is wrong or already addressed, push back rather than complying.
- **Check CI history before assuming a failing test is a real regression.** Known flakes are common; `gh run list` on the same spec across recent runs.
- **When changing shared code, audit all callers.** Before committing a change to a method or schema used elsewhere, grep for every call site and confirm their assumptions still hold. (Past pain: a `build_customer` tweak broke `purchase_orders` specs because nil-membership callers weren't checked.)

## Implementation defaults

- **Investigate before implementing.** For non-trivial bugs or ambiguous reports, trace the code path and confirm the hypothesis before writing a fix. Don't open a PR until you can name the root cause.
- **Default to the simplest viable approach**, especially for one-off tasks. Backfills, rake tasks, and migration scripts should be serial unless I ask for concurrency.
- **Verify third-party APIs exist before building on them.** Don't invent methods or properties that "feel right" — check the SDK docs, grep the codebase for existing usage, or write a tiny probe first. (Past pain: built against a non-existent Unlayer rows API before pivoting to native page anchors.)
- **For multi-tenant Rails work, use `Tenant.switch_each`.** Any query touching tenant-scoped data needs to iterate tenants, not run once against the public schema.
- **Per-tenant loops need per-iteration `rescue`.** When iterating with `Tenant.switch_each`, wrap the body so one bad tenant doesn't kill the whole audit — log the tenant and the error, then continue. Aggregate failures at the end.
- **Read-only by default for production console snippets.** No `update`/`destroy`/`delete_all`/job enqueues without an explicit `dry_run` gate.
