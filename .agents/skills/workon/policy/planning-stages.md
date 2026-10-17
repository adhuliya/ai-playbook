# Planning stages

The `stage` row in `activity.md` is `requirements` or `design`. The default
is `design`: the whole **Planning quality bar** runs in one pass. Both
stages keep the status `Planning`. A user who wants to settle requirements
first and design later says so, at create or any time in `Planning` ("requirements
first"). Set `stage: requirements` and tell the user the exit keyword,
`requirements-ok`.

In `stage: requirements`:

- Run steps 1–4 of the **Planning quality bar**: project-fit, intake,
  grill, **Cited context**. Write the **Problem header**, RD, and Goal.
- Record a Design Decision when a choice is made; do not hunt for them.
  Draft Conventions only when the user raises them.
- Do not draft Current Design, Current Plan, milestones, or
  `plan-outline.md`. Each holds `TBD (design stage)`. `# Next Steps` says
  `requirements-ok` follows once RD is complete.
- **File review** covers the Problem header, RD, and Design Decisions.
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
- `create-sibling` and `import-activity` start at `stage: design`.
