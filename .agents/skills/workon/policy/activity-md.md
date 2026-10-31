# `agent-activity.md`

Title plus metadata table through the `notes` row. Shape:
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
is `on` (default at create) or `off` (**Comments** levels). `continue`
is `ask` or `auto` (**Continue mode**). A missing row means `ask`.

Required sections, in order: Goal, Scope, Background and Special Notes,
Current Design, Current Plan, Milestones, Next Steps. References live in
`references.md`.

- **Goal** summarizes RD. On conflict, RD wins; refresh Goal and Scope at
  the next checkpoint. That refresh is not a **Material-change**.
- **Scope:** one or two paragraphs after the first grill, then near-fixed.
  A major in-flight change is a **Material-change**.
- **Current Design:** a one-line pointer to `spec-design.md` (**Design
  document**), which now holds the execution handoff, the decision
  synthesis, and the requirement-to-test-to-path trace. Rewrite the
  pointer only if it goes stale.
- **Milestones:** MECE outcomes with **Test evidence**, numbered `M1`,
  `M2`, … in order. Always write the `M` prefix, in this file and in every
  citation. Each real milestone has a `reads:` line (**IDs**): the `RD` and
  `DD` it implements, plus a `REF` when that reference is load-bearing.
  Leave `AC`, `TC`, `DC`, and `CONV` off the line. The `DD` `cites:` line
  is the link to the `DC`. The milestone's agents
  read `conventions.md` and `notes-by-user.md` in full. Use `reads: none`
  when it implements no RD. Each real milestone has a short paragraph
  under its title. The paragraph says what the milestone does, and which
  parts of the project tree it touches. Name areas, such as a directory or
  a module, not each file (unless some or all the file names are already known).
  A reader can follow it without the other activity files.
  Do not list the concrete edits there. Those edits are
  chosen when the milestone is picked up. Each milestone lists the test
  cases that complete it (**Test evidence**). A `TBD (design stage)` milestone
  has no `reads:` line and no paragraph. A `removed` milestone and a
  `superseded` milestone have no `reads:` line and no paragraph.
  A checked milestone stays in the list. When a later milestone
  replaces an aspect of it, add `Superseded by: M<k> — <aspect>`.
  On reopen, `replan-work`, or `make-full`, keep checked items,
  append new ones, and mark undone work `superseded`; do not delete.
  Milestone numbers are stable.
  A `fix-activity` prune may replace an unchecked milestone with a one-line
  `M<n>: removed: <why>` stub. It asks before it removes a checked
  milestone. Review milestones: **Reviews**.
- **Next Steps:** while `Planning`, item 1 is the exit keyword. Work
  steps follow it. On `Complete`, item 1 is `resume-work`.
- In `stage: requirements`, Current Design points at `spec-design.md`, whose
  Current Design, Test Plan, and Traceability hold `TBD (design stage)`;
  Current Plan and Milestones hold `TBD (design stage)` too.
