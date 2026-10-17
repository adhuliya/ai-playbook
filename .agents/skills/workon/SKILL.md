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
  delete-tmp-files, query-work, no-query-work, user-away.
disable-model-invocation: true
---

# workon

workon manages activities. An activity is one unit of work with its own
folder under `.dev-notes/activities/<slug>/`. Its records must let a fresh
agent resume the work months later.

## How it works

An activity moves through `Planning → Approved → Active → Complete`, with
optional `Paused` or `Blocked` stops. The user drives each transition with a
reserved keyword such as `approve-plan`, `start-building`, or
`mark-completed`. The agent plans, builds, and keeps the records current,
but never crosses a gate on its own.

Each folder holds a fixed set of files. `activity.md` is the current truth:
status, goal, scope, design, plan, milestones (`M1`, `M2`, …), next steps.
`plan-outline.md` is a short overview of that plan for quick review.
`journal.md` is the append-only event timeline. `requirement-def.md`,
`design-choices.md`, and `conventions.md` hold numbered entries (`RD<n>`,
`DC<nn>`, `CONV<n>`) that the plan cites by ID. `references.md` holds every
`REF<n>`. `notes-by-user.md` belongs to the user. `reviews.md` records
review cycles (`RU<n>`). `guide-for-users.md` is written for humans when the
work ships. `artifacts/` holds cited copies and sub-agent output. Shapes:
`shapes/`.

Work runs in three phases. In planning, the agent grills the user and drafts
the records, and the user reviews them. Planning may split into a
requirements stage and a design stage (**Planning stages**). At the gates,
the user approves the plan and the conventions, then starts the build. In
building, the agent runs milestones through sub-agents, collects test
evidence, and reviews the result. Reviews, plan checks, and drift repair run
as pipelines of background sub-agents that write files; the parent reads
only the final file.

## How to read this skill

`SKILL.md` is the only file the harness loads. Read the rest with the Read
tool, in the order below, several files per message. Skip a file you read
earlier in this session while its text is still in context; read it again
after a context reset. Never bulk-read a folder.

1. **Once per session:** `always.md` and `writing-style.md`.
2. **Once per activity per session**, before its first file read or write:
   `policy/session-start.md`. It scans for old layouts and names
   `repair.md` when it finds one. Read `repair.md` only then.
3. **Every turn:** map the user's words to a keyword (**Keyword gate**),
   then read `commands/<keyword>.md` and the files on its `Reads:` line.
   Natural language maps to `create` (new work), `list`, `build` (an
   engineering turn), or `feedback` (chat comments on the work).
4. **When a bold name has no file at hand,** find it in the Index and read
   that file.

Command files: `commands/<keyword>.md`. Exceptions: `add-review-comments`
and `remove-review-comments` share `review-comments.md`; `query-work` and
`no-query-work` share `query-work.md`.

| Phase or action | Read |
|---|---|
| Planning (`create`, `replan-work`, `create-sibling`) | the command file; its `Reads:` brings the planning, notes, and shape files. Open `shapes/` files only when you write that record |
| Gates (`requirements-ok`, `approve-plan`, `conventions-ok`, `start-building`) | the command file; it names two or three policies |
| Building (`build`) | `commands/build.md`; it names engineering, test, and milestone-pipeline files |
| Review (`start-review`, `apply-review`, `verify-plan`) | the command file plus the review policies and the matching `pipelines/` file |
| Sub-agent launch | the launch kit in `always.md` (**Background sub-agents**). Sub-agents read their own `briefs/` files; the parent does not |
| Upkeep (`fix-activity`, `compact-journal`, `update-convention`) | the command file; `fix-activity` adds its pipelines when it reaches them |
| Editing this skill | `editing.md`, never while you run an activity |

## Index

A bold name points at a heading or a bold term. Apply the named text; do
not restate it. The file that owns each name:

| File | Names |
|---|---|
| `always.md` | Commands, Stops, Keyword gate, Guide the user, Asking, Fewer prompts, Background sub-agents |
| `writing-style.md` | Writing style |
| `policy/session-start.md` | Session start |
| `policy/execution-gate.md` | Execution gate |
| `policy/material-change.md` | Material-change, Complete stay-on-slug, Complete sibling |
| `policy/paused-blocked.md` | Paused vs Blocked |
| `policy/reminders.md` | Reminders, Optional-remind, strong model |
| `policy/journal.md` | Journal policy |
| `policy/update-cadence.md` | Update cadence |
| `policy/consistency-check.md` | Consistency check |
| `policy/layout.md` | Layout |
| `policy/activity-md.md` | `activity.md`, Milestones |
| `policy/ids.md` | IDs, Citing and reading by ID |
| `policy/catalog.md` | Catalog |
| `policy/portability.md` | Portability |
| `policy/guide-for-users.md` | Guide for users |
| `policy/planning-quality-bar.md` | Planning quality bar, draft-check |
| `policy/planning-stages.md` | Planning stages |
| `policy/definition-bootstrap.md` | Definition bootstrap |
| `policy/create-sequence.md` | Create sequence, File review |
| `policy/plan-outline.md` | Plan outline |
| `policy/references.md` | References, Cited context, MCP sources, Refresh |
| `policy/notes-files.md` | Notes files |
| `policy/requirement-def.md` | RD, Problem header |
| `policy/design-choices.md` | Design Decisions |
| `policy/conventions.md` | Conventions, Rules, Setup, Isolated setup |
| `policy/notes-by-user.md` | Notes by User |
| `policy/reviews.md` | Reviews, Where points go, Fix cycle, Fix first, Recheck, Where a change lands, Review milestone, Renumber log |
| `policy/apply-timing.md` | Apply timing |
| `policy/test-evidence.md` | Test evidence |
| `policy/engineering.md` | Engineering while focused |
| `policy/comments.md` | Comments |
| `policy/launch.md` | Launch, Prompt shape, Plan packet |
| `policy/inflight.md` | Inflight pipelines |
| `policy/paths.md` | Paths and readiness |
| `policy/parent-reads.md` | Parent reads |
| `policy/critic-pair.md` | critic pair |
| `policy/planning-explores.md` | Planning explores |
| `pipelines/` | one file per pipeline: `verify-plan` (Question gate), `review`, `milestone`, `comments`, `drift`; the bold names Milestone, Review, Comments, Drift mean these |
| `commands/` | one file per keyword; Details is in `list.md`, Command map in `help.md`, User away is `user-away.md` |
| `shapes/` | the shape of every record |
| `briefs/` | one file per sub-agent role; sub-agents read them, the parent does not |
| `repair.md` | Repair |
| `editing.md` | Editing the workon skill |
