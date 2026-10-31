# `approve-plan`

Status: `Planning` (`Approved` / `Active`: report the state; do not rewrite
history).

Reads: policy/activity-kind.md, policy/journal.md, policy/reminders.md, policy/execution-gate.md, policy/planning-stages.md, policy/plan-outline.md

When `kind` is `thin`, follow **Choose** and do not run the steps below. A typed `thin` stays thin and names `start-building`. When `kind` stays `thin`, name `start-building`. When **Choose** sets `full`, follow `commands/make-full.md`. Do not ask the user to type `make-full`. Then name `requirements-ok` or `approve-plan`.

1. Needs `stage: design`; if `requirements`, prompt `requirements-ok` and
   stop. The planning outputs are written and reviewed, and RD is current
   and challengeable. Send the user back to **File review** instead of
   approving when RD is empty, stale, or unreviewed; when the **Problem
   header** (a `## Problem:` heading in RD) is missing; when
   `spec-plan-outline.md` is missing; or when the last milestone has no named
   runnable e2e command. A user nod does not replace a missing e2e name; only an explicit user drop
   waives it, and that reason goes in `agent-activity.md`.
2. **Optional-remind** `apply-review` and `add-ac` (when any RD has no
   `AC<n>`). Do not remind `agent-review`.
3. Set `status` to `Approved`. Append an `Approved` event (milestone count).
4. One-time note: planning is done; the user may drop the strong model.
5. Do not implement. If `conventions: pending`, ask: "Accept the
   conventions too? (`yes` / `review`)". On `yes`, run `conventions-ok`
   from step 1; on `review`, the user runs `conventions-ok` later. Then ask
   for `start-building`.
