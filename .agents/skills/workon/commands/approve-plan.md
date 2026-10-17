# `approve-plan`

Status: `Planning` (`Approved` / `Active`: report the state; do not rewrite
history).

Reads: policy/journal.md, policy/reminders.md, policy/execution-gate.md, policy/planning-stages.md, policy/plan-outline.md

1. Needs `stage: design`; if `requirements`, prompt `requirements-ok` and
   stop. The planning outputs are written and reviewed, and RD is current
   and challengeable. Send the user back to **File review** instead of
   approving when RD is empty, stale, or unreviewed; when the **Problem
   header** (a `## Problem:` heading in RD) is missing; when
   `plan-outline.md` is missing; or when the last milestone has no named
   runnable e2e command. A user nod does not replace a missing e2e name; only an explicit user drop
   waives it, and that reason goes in `activity.md`.
2. **Optional-remind** `verify-plan` and `apply-review`.
3. Set `status` to `Approved`. Append an `Approved` event (milestone count).
4. One-time note: planning is done; the user may drop the strong model.
5. Do not implement. If `conventions: pending`, ask: "Accept the
   conventions too? (`yes` / `review`)". On `yes`, run `conventions-ok`
   from step 1; on `review`, the user runs `conventions-ok` later. Then ask
   for `start-building`.
