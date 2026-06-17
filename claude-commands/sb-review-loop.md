---
description: Drive a PR's codex review to green — poll, address with judgment, reply, resolve threads, re-trigger, repeat
---

Run the full review loop on the PR for the current branch (or `$ARGUMENTS` = a PR number / URL)
until codex signs off. Codex is the `chatgpt-codex-connector[bot]` reviewer: it posts a PR review
with inline comments when it has suggestions, reacts 👀 on the PR while processing, and reacts 👍 on
the PR description when it finds nothing. **Success = a codex 👍 with no unresolved findings.**

This loop posts `@codex review` comments, replies, and resolves review threads on your behalf — that's
the whole point, so don't ask before each GitHub action. (Codex never replies back, so pushing back in
a thread won't change its mind — only a code change or a resolved thread will.)

## Loop

1. **Identify the PR.** `gh pr view [N] --json number,url,headRefOid,isDraft,reviewDecision`.
   Capture `owner`/`repo`: `gh repo view --json owner,name`.

2. **Trigger codex.** `gh pr comment <N> --body "@codex review"`. (Codex auto-reviews only the *first*
   push; every later commit needs an explicit `@codex review` to re-review.)

3. **Wait for codex** with a background watcher (don't burn context polling inline). First record the
   baseline: number of codex *reviews* and whether codex already has a 👍. The watcher exits when a new
   codex review appears **or** a codex 👍 appears (see *Helper: watcher*). Run it with `run_in_background`.

4. **Check the reviewed commit.** Read the `**Reviewed commit:** \`<sha>\`` line in the latest codex
   review and compare to the current PR HEAD (re-fetch it each loop). If they differ, codex reviewed a
   **stale commit** — do NOT act on those findings; leave a one-line note on the thread and re-trigger
   (step 2). Codex lags a push by a commit fairly often.

5. **Triage findings** — inline comments from codex on the current commit, excluding ids you've already
   handled (track them). Codex prefixes each finding with a priority badge (P1–P4).
   - **Skip P4 entirely.** Don't make code changes for P4 (nit/cosmetic) findings — reply once that it's
     out of scope for this loop and resolve the thread so it stops resurfacing. Don't push a commit for it.
   - **Don't let low-priority items drive the loop.** P3s and contrived edge-cases are usually not worth a
     code change either; default to resolve-with-a-note unless the fix is trivial and clearly right, or I've
     said otherwise. The loop exists to clear *real* (P1/P2) findings, not to chase nits to zero.
   - For the findings worth handling:
     - **Verify the claim against the actual code first** (`file:line`). Codex is wrong or already-addressed
       often enough that blind compliance is a mistake.
     - **Valid** → make the smallest targeted fix. Don't delete existing behavior, rescue paths, or
       per-case handling unless the comment is specifically about that.
     - **Invalid / already-addressed** → don't change; explain why in the reply.
     - **Ambiguous or large** → ask me before changing.

6. **Test + commit + push.** Run the affected specs and `bundle exec rubocop` on changed files *before*
   pushing. Commit with a message naming what codex raised; push. Never `--no-verify` / `--amend`;
   force-push only with `--force-with-lease`.

7. **Reply to + resolve each handled thread** (see *Helper: resolve*). For every finding:
   - Reply in-thread with a short note (what you changed, or why you pushed back):
     `gh api repos/{owner}/{repo}/pulls/<N>/comments/<comment_id>/replies -f body="..."`
   - Then resolve the thread so it stops re-surfacing and codex can converge.
   For a stale-commit re-flag of something already fixed, reply pointing at the fix commit and resolve it too.

8. **Re-trigger** `@codex review` and return to step 3 with the new baseline (review count +1).

9. **Stop when** codex 👍s and there are no unresolved findings → success. Also stop — summarize and hand
   back to me rather than looping forever — when any of these hold:
   - only P3/P4 / nit / contrived edge-case findings remain (resolve them with a note, then stop; don't
     re-trigger just to chase low-priority items to zero);
   - codex keeps re-flagging something you've deliberately rejected;
   - you've hit **~6 iterations**.
   Each re-trigger should be justified by an unresolved P1/P2 — if the last round produced no real findings,
   stop instead of spinning.

10. **Final report.** Verify and report: codex verdict; CI (`gh pr checks <N>` — all green?); `mergeable`;
    `reviewDecision` (note: a codex 👍 is a reaction, *not* a GitHub approval — a human approval is still
    required to merge); draft state; and a one-line summary of each finding + how it was resolved.

## Helper: watcher

Write to `.git/codex-watch-<N>.sh` and run with `run_in_background: true`. Args: `<N>` `<baseline_reviews>`
`<baseline_thumbs 0|1>`. It exits when codex posts a new review or reacts 👍 (or after ~20 min).

```bash
#!/usr/bin/env bash
set -uo pipefail
PR="$1"; BASE_R="${2:-0}"; BASE_T="${3:-0}"; CODEX=chatgpt-codex-connector
OWNER=$(gh repo view --json owner -q .owner.login); REPO=$(gh repo view --json name -q .name)
for i in $(seq 1 40); do            # 40 * 30s ≈ 20 min
  reviews=$(gh api "repos/$OWNER/$REPO/pulls/$PR/reviews" --paginate 2>/dev/null) || reviews="[]"
  reactions=$(gh api "repos/$OWNER/$REPO/issues/$PR/reactions" 2>/dev/null) || reactions="[]"
  out=$(printf '%s\1%s' "$reviews" "$reactions" | BR="$BASE_R" BT="$BASE_T" CX="$CODEX" python3 -c '
import sys,json,os
a=sys.stdin.read().split("\1"); cx=os.environ["CX"]
rv=json.loads(a[0] or "[]"); rc=json.loads(a[1] or "[]")
n=sum(1 for r in rv if r["user"]["login"].startswith(cx))
t=1 if any(x["user"]["login"].startswith(cx) and x["content"]=="+1" for x in rc) else 0
print("NEW_REVIEW" if n>int(os.environ["BR"]) else "THUMBS" if t>int(os.environ["BT"]) else "WAIT", n, t)')
  st=$(echo "$out" | awk "{print \$1}")
  if [ "$st" = "NEW_REVIEW" ] || [ "$st" = "THUMBS" ]; then echo "WAKE $out loop=$i"; exit 0; fi
  [ "$i" = 40 ] && echo "WAKE timeout $out loop=$i"
  sleep 30
done
```

Then inspect: latest review body (`Reviewed commit`, inline-comment ids) and
`gh api repos/{owner}/{repo}/issues/<N>/reactions` for the codex `+1`.

## Helper: resolve a review thread (GraphQL — REST cannot resolve threads)

```bash
resolve_thread() {  # args: <PR_NUMBER> <COMMENT_DATABASE_ID>
  local owner repo tid
  owner=$(gh repo view --json owner -q .owner.login); repo=$(gh repo view --json name -q .name)
  tid=$(gh api graphql -f query='
    query($o:String!,$r:String!,$n:Int!){ repository(owner:$o,name:$r){ pullRequest(number:$n){
      reviewThreads(first:100){ nodes{ id isResolved comments(first:50){ nodes{ databaseId } } } } } } }' \
    -f o="$owner" -f r="$repo" -F n="$1" | python3 -c "
import sys,json;d=json.load(sys.stdin)
th=d['data']['repository']['pullRequest']['reviewThreads']['nodes']
print(next((t['id'] for t in th if any(c['databaseId']==$2 for c in t['comments']['nodes'])),''))")
  [ -n "$tid" ] && gh api graphql -f query='
    mutation($id:ID!){ resolveReviewThread(input:{threadId:$id}){ thread{ isResolved } } }' -f id="$tid"
}
```

Reply first (the note), then `resolve_thread <N> <comment_id>`. To list unresolved codex threads, run the
query above and filter `isResolved == false` with a `chatgpt-codex-connector` comment author.
