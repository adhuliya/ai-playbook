# Planning stages

The `stage` row in `agent-activity.md` is `requirements` or `design`. The default
is `design`: the whole **Planning quality bar** runs in one pass. Both
stages keep the status `Planning`. `stage: requirements` is always
`kind: full`. When a record has that stage and `kind: thin`, set
`kind: full`. A user who wants to settle requirements first says so at
create, or on an existing activity through `replan-work` or `make-full`.
Set `kind: full` and `stage: requirements` (**Activity kind**). The exit
keyword is `requirements-ok`.

In `stage: requirements`:

- Run steps 1–4 of the **Planning quality bar**: project-fit, intake,
  grill, **Cited context**. Write the **Problem header**, RD, and Goal.
- Record a Design Decision when a choice is made; do not hunt for them.
  Draft Conventions only when the user raises them.
- Do not draft `spec-design.md`'s Current Design, Test Plan, or Traceability,
  Current Plan, milestones, or `spec-plan-outline.md`. Each holds
  `TBD (design stage)`.
  `spec-design.md`'s Decisions section gains a `DD<n>` citing that `DC` as
  choices are made. `# Next Steps` says `requirements-ok` follows once RD is
  complete.
- **File review** covers the Problem header, RD, and Design Decisions
  (below).
- When no grill branch is open, say RD looks complete and prompt
  `requirements-ok`. Never move to design silently.

`requirements-ok` sets `stage: design` and starts the design half. In
`stage: design`, RD and Design Decisions stay editable while the status is
`Planning`.

- `approve-plan` refuses while `stage: requirements`; prompt
  `requirements-ok`.
- To reopen requirements, the user asks in `Planning`, or runs
  `replan-work`, which sets `stage: requirements` on request. Drafted design
  stays until the user revises it.
- `create-sibling` and `import-activity` start at `stage: design`, unless
  the user asked for requirements first.

## File review

In `stage: design`, show `spec-plan-outline.md` first, then the other
drafted files. In `stage: requirements`, show the Problem header, RD, and
Design Decisions. The user
challenges RD, Conventions, Setup, and the plan before `approve-plan` and
`conventions-ok`. Feedback goes per **Reviews** (where points go);
`start-review` is not required. File review is done when the user has seen
the files and every feedback round is recorded. Stay `Planning`.
Prompt `requirements-ok` in the requirements stage, `approve-plan` on a
full design, or `start-building` on thin.
