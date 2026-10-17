# `activity.md`

Title plus metadata table in the first ~10 lines. Shape:
`shapes/activity.md`. Required rows: `status`, `stage`, `conventions`,
`review-comments`, `slug`, `branch`, `base-branch`, `ticket`, `notes`.
`ticket` and `branch` may be `none`; `notes` may be empty.

`stage` is `requirements` or `design` (**Planning stages**). `branch` is a
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
- **Current Design:** the execution handoff (invariants, boundaries,
  evidence signals). Chosen-vs-alternatives live only in Design Decisions.
- **Milestones:** MECE outcomes with **Test evidence**, numbered `M1`,
  `M2`, … in order. Always write the `M` prefix, in this file and in every
  citation. On reopen, keep checked items, append new ones, and mark removed
  work `superseded`; do not delete. Milestone numbers are stable: a
  `fix-activity` prune replaces a milestone body with a one-line
  `M<n>: removed: <why>` stub. Review milestones: **Reviews**.
- In `stage: requirements`, Current Design, Current Plan, and Milestones
  hold `TBD (design stage)`.
