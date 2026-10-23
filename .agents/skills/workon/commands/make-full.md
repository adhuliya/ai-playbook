# `make-full`

Status: `Planning`, `Approved`, `Active`. `Paused` or `Blocked`: prompt
`resume-work` and stop. `Complete`: prompt `resume-work` and stop.
`kind: full`: say so and stop.

Reads: policy/activity-kind.md, policy/planning-quality-bar.md, policy/planning-stages.md, policy/execution-gate.md, policy/journal.md

1. Set `kind: full` and `status: Planning`. Append a `Make-full` event
   (**Journal policy**). Omit the arrow when the status was already
   `Planning`.
2. Deepen the records with the **Planning quality bar**. Grill only open
   branches. Do not re-ask a settled fact. Keep code already written.
   Keep checked milestones (**agent-activity.md**). Append new ones, and
   mark removed work `superseded`.
   When the user asks for requirements first, set `stage: requirements`
   and run steps 1–4 only.
3. Stop product engineering. When `stage` is `requirements`, review the
   Problem header, RD, and Design Decisions, and prompt `requirements-ok`.
   Otherwise run **File review** and prompt `approve-plan`.
