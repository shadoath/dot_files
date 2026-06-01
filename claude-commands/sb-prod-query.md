---
description: Write a Rails console query to verify behavior in production
---

Write a Rails console snippet I can paste into the production console to verify behavior related to `$ARGUMENTS` (or the current task, if no arg given).

Conventions:
- This is a multi-tenant Rails app. Almost any query that touches tenant-scoped data should be wrapped in `Tenant.switch_each do |tenant| ... end` so it runs across all tenants. Don't forget this.
- The snippet must be **read-only and safe** by default — no `update`, `destroy`, `delete_all`, or background-job enqueues unless I explicitly ask. If a write is needed, gate it behind a `dry_run = true` flag at the top with clear instructions.
- Print clearly labeled output (`puts "tenant=#{tenant.subdomain} count=#{...}"`) so I can scan results across tenants.
- Aggregate at the end (totals, counts by category) when looping over tenants — don't make me eyeball N tenant outputs.
- Use `.find_each` / `.in_batches` for any loop that could hit many records.

Output the snippet in a single fenced ruby block, with a one-line summary above it explaining what it checks.
