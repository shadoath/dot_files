# CLAUDE.local.md — rinsed-org repos

Symlinked into each rinsed-org repo/worktree as `CLAUDE.local.md` by `~/dot_files/sync-claude-local.sh`. These rules apply on top of the global `~/.claude/CLAUDE.md` and refine it for Rinsed work.

## Code Review — Arby, not Codex

- **Skip Codex here.** Repos under the [rinsed-org](https://github.com/rinsed-org) GitHub org have Arby (Rinsed's own review bot) instead of Codex — don't comment `@codex review` or wait on Codex findings. `/code-review` alone satisfies the review loop and the global *Definition of Done*; let Arby's automatic review run as it normally does.

## Shell & Test Commands

- ALWAYS quote rspec/glob file arguments: `bundle exec rspec "spec/**/foo_spec.rb"` — unquoted globs have repeatedly expanded to the whole suite and timed out.
- For Ruby changes, "run tests and linters locally before pushing" means: `bundle exec rspec <touched specs>` and `bundle exec rubocop <modified files>`.

## Before Opening a PR

- For Rails repos with these tools configured (e.g. the web repo): run the N+1 detectors locally (Prosopite/Bullet) and Brakeman on changed files before pushing; CI has failed on N+1 and Brakeman warnings repeatedly.
- Verify migrations include required FK indexes (repos with a migration-check job fail otherwise).

## Multi-Tenant & Production Data

- **For multi-tenant Rails work, use `Tenant.switch_each`.** Any query touching tenant-scoped data needs to iterate tenants, not run once against the public schema.
- **Per-tenant loops need per-iteration `rescue`.** When iterating with `Tenant.switch_each`, wrap the body so one bad tenant doesn't kill the whole audit — log the tenant and the error, then continue. Aggregate failures at the end.
- **Read-only by default for production console snippets.** No `update`/`destroy`/`delete_all`/job enqueues without an explicit `dry_run` gate.

## Environment (local dev / sim)

- The dev Postgres restore needs the lock-pool setting from bin/setup; if pg_restore fails with lock errors, that's the cause.
- Tailwind watcher exits without a TTY and redis drops in the sim — restart these before assuming an app bug.
- Container registry (gcr.io) 502s are transient; retry before debugging the build. OrbStack runtime is not recognized by the default build path.
- Before any browser testing: verify redis is up, the Tailwind watcher is running, and the sim responds — report the health-check results. For any third-party iframe (Stripe, embedded artifacts), skip click/type automation and go straight to JS evaluation. Then walk the flow and log each step's outcome.

## Communication

- Slack blurbs must be 3 sentences or fewer unless asked otherwise.
