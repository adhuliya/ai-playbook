# `agent-activity.md`

Title plus metadata table in the first ~10 lines. Shape:
`shapes/activity.md`. Required rows: `status`, `kind`, `stage`, `conventions`,
`review-comments`, `slug`, `branch`, `base-branch`, `ticket`, `notes`.
`ticket` and `branch` may be `none`; `notes` may be empty.

`kind` is `thin` or `full` (**Activity kind**). A missing `kind` means
`full` until session start adds the row. `stage` is `requirements` or
`design` (**Planning stages**). `branch` is a
hint; do not auto-create or check out branches. `base-branch` is the parent
branch the activity diffs against (default `main`); the activity diff is
`git diff $(git merge-base HEAD <base-branch>)` plus new untracked files.
`conventions` is `pending` or `ok` (**Execution gate**). `review-comments`
is `on` (default at create) or `off` (**Comments** levels).

Required sections, in order: Goal, Scope, Background and Special Notes,
Current Design, Current Plan, Milestones, Next Steps. References live in
`references.md`.

- **Goal** summarizes RD. On conflict, RD wins; refresh Goal and Scope at
  the next checkpoint.
- **Scope:** one or two paragraphs after the first grill, then near-fixed.
  A major in-flight change is a **Material-change**.
- **Current Design:** a one-line pointer to `spec-design.md` (**Design
  document**), which now holds the execution handoff, the decision
  synthesis, and the requirement-to-test-to-path trace. Rewrite the
  pointer only if it goes stale.
- **Milestones:** MECE outcomes with **Test evidence**, numbered `M1`,
  `M2`, … in order. Always write the `M` prefix, in this file and in every
  citation. Each real milestone has a `reads:` line (**IDs**): the `RD` and
  `DD` it implements, plus a `CONV` or `REF` when that rule or reference is
  load-bearing for it. Leave `AC`, `TC`, and `DC` off the line. Use
  `reads: none` when it implements no RD. A `TBD (design stage)` milestone
  has no `reads:` line. On reopen, keep checked items, append new ones, and
  mark removed work `superseded`; do not delete. Milestone numbers are
  stable: a `fix-activity` prune replaces a milestone body with a one-line
  `M<n>: removed: <why>` stub. Review milestones: **Reviews**.
- In `stage: requirements`, Current Design points at `spec-design.md`, whose
  Current Design, Test Plan, and Traceability hold `TBD (design stage)`;
  Current Plan and Milestones hold `TBD (design stage)` too.
