---
name: workon
description: >-
  Manage durable activities under .dev-notes/activities/ (activity record,
  journal, requirements, design decisions, conventions, references, reviews,
  guide for users). Use when the user manages or imports an activity, or
  issues a workon keyword: help, requirements-ok, approve-plan,
  conventions-ok, start-building, pause-work, resume-work, mark-completed,
  replan-work, create-sibling, import-activity, start-review, apply-review,
  verify-plan, update-convention, add-review-comments,
  remove-review-comments, fix-activity, compact-journal, create-guide,
  detailed-design, add-ac, delete-tmp-files, query-work, no-query-work,
  user-away, teach-off, teach-brief, teach-deep.
disable-model-invocation: true
---

# workon

workon manages activities. An activity is one unit of work with its own
folder, `.dev-notes/activities/<slug>/`. Its records must let a fresh agent
resume the work months later.

## How it works

An activity moves through `Planning → Approved → Active → Complete`, with
optional `Paused` or `Blocked` stops. The user drives each transition with a
reserved keyword such as `approve-plan`, `start-building`, or
`mark-completed`. The agent plans, builds, and keeps the records current,
but never crosses a gate on its own.

Work runs in three phases:

- **Planning.** The agent grills the user and drafts the records. The user
  reviews them. Planning may split into a requirements stage and a design
  stage (**Planning stages**).
- **Gates.** The user approves the plan and the conventions, then starts the
  build.
- **Building.** The agent runs milestones through sub-agents, collects test
  evidence, and reviews the result. Reviews, plan checks, and drift repair
  run as pipelines of background sub-agents that write files. The parent
  reads only the final file.

## Records

Each folder holds a fixed set of files. The shape of each is in `shapes/`.

- `activity.md`: the current truth (status, goal, scope, a pointer to
  design, plan, milestones `M1`, `M2`, …, next steps). Each real milestone
  has a `reads:` line. `plan-outline.md`: a short overview of that plan, in
  plain words.
- `design.md`: the lean design reference (invariants, current `DD<n>`
  statements, and a requirement-to-test-to-path trace). `detailed-design.md`
  (in `artifacts/`): a diagram-rich expansion, written only by
  `detailed-design`, readable without the IDs.
- `journal.md`: the append-only event timeline.
- `requirement-def.md`, `design-choices.md`, `conventions.md`: numbered
  entries (`RD<n>`, `DC<nn>`, `CONV<n>`). A milestone cites `RD` and `DD`
  from its `reads:` line. `DC` stays the choice history a `DD` cites.
- `references.md` (`REF<n>`), `reviews.md` (`RU<n>`), `notes-by-user.md`
  (the user's), `guide-for-users.md` (written for humans when the work
  ships).
- `artifacts/`: cited copies and sub-agent output.

## How to read this skill

`SKILL.md` is the only file the harness loads. Read the rest with the Read
tool, several files per message. Skip a file you read earlier in this
session while its text is still in context; read it again after a context
reset. Never bulk-read a folder.

1. **Once per session:** `always.md` and `writing-style.md`.
2. **Once per activity per session**, before its first file read or write:
   `policy/session-start.md`. Read `repair.md` only when it names it.
3. **Every turn:** map the user's words to a keyword (**Keyword gate**),
   then read `commands/<keyword>.md` and the files on its `Reads:` line.
   Natural language maps to `create` (new work), `list`, `build` (an
   engineering turn), or `feedback` (chat comments on the work).
   `add-review-comments` and `remove-review-comments` share
   `review-comments.md`; `query-work` and `no-query-work` share
   `query-work.md`; `teach-off`, `teach-brief`, and `teach-deep` share
   `teach-mode.md`.
4. **When a command or `always.md` names a step, read the file that step
   names, just before you reach it.** A `Reads:` line is the up-front set;
   the steps name the rest.
5. **When a bold name has no owner among the files you read,** read
   `index.md` and find it.

| Phase or action | Read after the base files |
|---|---|
| Planning: `create`, `replan-work`, `create-sibling`, `import-activity` | the command file and its `Reads:`; open each `shapes/` file when you write that record |
| Gates: `requirements-ok`, `approve-plan`, `conventions-ok`, `start-building` | the command file and its `Reads:` (a few policies) |
| Building: `build` | the command file and its `Reads:`; the launch kit and `pipelines/milestone.md` just before the first sub-agent launch |
| Review: `start-review`, `apply-review`, `verify-plan` | the command file and its `Reads:` (review policies, the launch kit, the matching `pipelines/` file) |
| Sub-agent launch | the launch kit (**Background sub-agents** in `always.md`). Sub-agents read their own `briefs/` files; the parent does not |
| Upkeep: `fix-activity`, `compact-journal`, `update-convention`, `add-ac` | the command file and its `Reads:`; `fix-activity` names its pipelines at the step that needs them |
| Output and cleanup: `create-guide`, `detailed-design` | the command file and its `Reads:` |
| Editing this skill | `editing.md`, never while you run an activity |
