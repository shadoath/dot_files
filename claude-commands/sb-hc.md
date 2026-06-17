---
description: Hypothesis check — prove the root cause with a cheap probe before building a fix
---

Before implementing anything, stop and validate the current hypothesis about `$ARGUMENTS` (or the bug/root cause we're currently discussing). The goal is to *cheaply prove or disprove the theory* with evidence before any fix gets built — no implementation in this step.

Do this:
- **State the hypothesis explicitly** in one sentence: "I think X is happening because Y." Make the claim falsifiable.
- **List the assumptions it rests on**, and mark which are confirmed vs. unverified. Call out the single load-bearing assumption that, if wrong, sinks the whole theory.
- **Design the cheapest probe** that would confirm or kill it — a one-off Rails console snippet, a log/Datadog/Rollbar query, a `git log`/`grep` over the code, a tiny script, a curl against the real endpoint. Prefer reading evidence over running anything; prefer a 30-second probe over a 5-minute one.
- **Run the probe** (or, if it needs prod/credentials I have to run, hand me a ready-to-paste read-only snippet — follow the `sb-prod-query` conventions: multi-tenant `Tenant.switch_each`, read-only, no writes/enqueues).
- **Report the verdict plainly:** confirmed / disproven / inconclusive, with the evidence that decided it. If inconclusive, say what additional probe would settle it.
- **Note known dead-ends** so we don't re-walk them.

Only after the hypothesis is confirmed should we move on to implementing. If it's disproven, say so directly and propose the next most-likely hypothesis instead of patching the dead theory. Don't build the fix in this step even if the hypothesis turns out correct — just report and let me decide.
