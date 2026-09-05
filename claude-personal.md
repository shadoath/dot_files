# CLAUDE.local.md — personal repos

Symlinked into each non-rinsed repo as `CLAUDE.local.md` by `~/dot_files/sync-claude-local.sh`. These rules apply on top of the global `~/.claude/CLAUDE.md`.

## Code Review — Codex (shadoath / whiteboard-works)

- **Every PR in a repo whose `origin` is under `shadoath/` or `whiteboard-works/` gets a Codex review.** Codex is the non-Claude agent in the loop — the review isn't done until it has run.
- **Post `@codex review` yourself, every time.** Immediately after `gh pr create`, run `gh pr comment <N> --body "@codex review"`. Do not rely on the open-ready auto-trigger — it is not reliable and has been missed. Re-post after every push of fixes; Codex only ever reviews the commit it was asked about.
- The review loop in the global *Definition of Done* here means: `/code-review` locally, plus working Codex's comments until no major findings remain.
- Other-owner clones (prenda-school, Dwellers, etc.) follow the same Codex flow when they are repos I push PRs to; upstream clones are read-only (see *Workflow*).

## Workflow

- The full global *Definition of Done* applies to personal repos too — ready PR, review loop, auto-merge, version bump. No lighter process unless I say so.
- **Third-party/upstream clones are the exception.** If `origin` points at a repo I don't own (e.g. `rails/rails`, `curl-impersonate`), treat it as a read-only reference checkout — no PRs, no auto-merge, no pushes anywhere without asking first.
