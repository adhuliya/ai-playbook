# Lifecycle

Rules for status changes and the records they touch. Commands load the
sections they need through `Reads:`. Index: [`SKILL.md`](SKILL.md).

## Session probe

`probe <slug>` runs before the first activity-file read or write in a
session. Skip it under query mode, during a pipeline, and for `help`. It
searches only `.dev-notes/activities/<slug>/` and prints the metadata table,
so the first read of `activity.md` is often unnecessary.

It creates each missing notes file with its H1 (and the Setup heading in
`conventions.md`; an empty body is valid) and fills each missing metadata
row with its default: `conventions` is `ok` when the status is
`Active`, `Paused`, `Blocked`, or `Complete` and `pending` otherwise;
`review-comments` is `off` when `Complete` and `on` otherwise;
`base-branch` is `main`; `synced` is `none`. Tell the user once when it set
`base-branch`.

It prints `legacy: yes` when any marker is present: a file named
`notes.md`, `user-notes.md`, or `requirements.md`, or
`artifacts/self-review.md` or `artifacts/self-review/`; `requirement-def.md`
without a `## Problem:` heading; a `##` heading that breaks its file's form
(`## Problem:` / `## RD<n>:`, `## DC<nn>:`, `## CONV<n>:` / the Setup
heading, `## RU<n>:` / `## Renumber`); a References bullet that cites a file
and has no `REF<n>`; the text `UR<n>`, `SR<n>`, `RRD<n>`, or a heading
`## R<n>:`. Only then load **Repair**.

## Execution gate

No product engineering until `approve-plan`, `conventions-ok`, and then
`start-building`. `conventions-ok` may come before or after `approve-plan`.
It is one-time: once `conventions: ok`, it stays `ok` for the life of the
activity through edits, `replan-work`, and reopens. Only `import-activity`
resets it, because the repo may differ. After a Complete stay-on-slug reopen
to `Planning`, `approve-plan` and `start-building` run again.

## Material-change

A change is **material** when it rewrites the Goal or Scope, when it adds,
drops, or rewords an RD entry after approval beyond an in-scope plan
refresh, or when it adds independently durable new work. In-scope
tightening of the plan, design, or conventions on the same Goal is not
material.

On a material change, prompt the matching choice; do not rewrite scope
first.

| Status | Keyword |
|---|---|
| In flight (`Planning` / `Approved` / `Active` / `Paused` / `Blocked`) | `replan-work` (same slug) or `create-sibling` |
| `Complete` | stay-on-slug (minor) or `create-sibling` (major). Never `replan-work` |

**Complete stay-on-slug** reopens `Complete` → `Planning`, never → `Active`.
Two commands do it. `resume-work` grills and classifies first.
`apply-review` is intake only: stay-on-slug, no sibling, no resume grill;
it reopens only when the cycle adds a review milestone, and a material open
point applies nothing (ask `create-sibling`). For the grill-and-classify
fork, the user runs `resume-work` first. **Complete sibling:** prompt
`create-sibling`. The parent stays `Complete` with no journal entry. Only
the sibling records `derived-from:`; the parent never points at the sibling.

## Paused vs Blocked

Both record `prior: <status>` in the `activity.md` `notes` row. Only
`resume-work` leaves either status; it restores `prior:` and clears the
entry. `apply-review` never changes these statuses.

- `Paused`: an intentional stop via `pause-work`. Not allowed from `Blocked`.
- `Blocked`: work cannot continue. The agent MAY set it at a checkpoint when
  work is stuck. Add a one-line blocker to `notes`, details in `activity.md`
  `# Next Steps`, and append a `Blocked` event (**Journal policy**).

## Reminders

Remind once per phase change.

- Create, `create-sibling`, `replan-work`: remind the user to use a
  **strong** model, the most capable reasoning model they can pick (for
  example, a top Claude Opus or GPT high-reasoning tier).
- `approve-plan`: one-time note that planning is done; the user may drop the
  strong model. Do not recommend an execution tier.

**Optional-remind** (once; do not require): `verify-plan` at `approve-plan`
when this session has not run it; `apply-review` when `reviews.md` has an
`open` cycle (at `approve-plan`, `start-building`, `pause-work`,
`resume-work`); `create-guide` at `mark-completed` when `user-guide.md` is
missing or stale; `remove-review-comments` at `mark-completed` when
`review-comments` is `on`; `fix-activity` at `resume-work`, or when the
agent notices drift (activity files edited outside the agent, `base` mode
`rewritten`, or cited paths missing).

## Journal policy

`<slug>/journal.md` is the append-only event timeline. `activity.md` holds
current state and `reviews.md` holds review detail; the journal records
each event that changes direction or status: what happened, why, and
pointers (IDs, paths, commands). A fresh agent reads it to learn how the
activity got here. Shapes: `templates.md#journal.md`.

Write one entry per event, in the same turn:

| Event | Written by |
|---|---|
| `Created` | create, `create-sibling` (in the new activity), `import-activity` |
| `Approved` / `Building` | `approve-plan` / `start-building` |
| `Milestone` | checkpoint that checks a milestone |
| `Review` | every `RU<n>` cycle close, whatever the source (`apply-review`, chat feedback, `verify-plan`, `fix-activity` inline) |
| `Replan` | `replan-work` |
| `Blocked` | entering `Blocked` |
| `Pause` / `Resume` | `pause-work` / status change by `resume-work`, or `apply-review` reopening `Complete` (the recap replaces the `Review` event and cites `RU<n>`) |
| `Complete` | `mark-completed` |
| `Renumber` | `fix-activity` renumber |

No other change writes the journal: notes edits, **Consistency check**,
`update-convention`, `conventions-ok`, `start-review` (opening or
refreshing a cycle), `add-review-comments`, `remove-review-comments`,
`create-guide`, `delete-tmp-files`, list, details, `help`.

An entry is `## <Event>: <short title> (<from> → <to>)`; omit the arrow when
the status is unchanged. Then at most three bullets: what happened, IDs /
paths / evidence command, and `next:` when not obvious. Point at IDs; do
not copy RD, plans, or review points. No dates unless asked; entry order is
the timeline. A pause or resume recap stays within ~10 lines and omits
empty fields. `Complete` is the one thick entry: a project-work write-up of
what shipped, paths, decisions, and gaps, not a lifecycle novel.

Append at the end. Prior entries are read-only except through
`compact-journal`, the only rewrite.

## Update cadence

Records are for durability, not a live log.

- `activity.md`: on a scope, design, or plan change, a milestone reached, a
  blocker, and before pause, complete, or handoff. A checked milestone also
  appends a `Milestone` event. Each such checkpoint, at any status,
  refreshes `synced` with `snapshot <slug> --pin` (writers and skips:
  **`activity.md`**).
- RD whenever requirements change; it must be current before `approve-plan`.
- Design Decisions when an important choice is made.
- Conventions (rules and Setup) when observed, confirmed, or tightened.
- `activities.md`: **Catalog**. `journal.md`: **Journal policy**.
- `reviews.md`: when points change, follow **Reviews** (where points go).
- Always sync before `pause-work`, `mark-completed`, or handoff.
- After user edits to activity files, run the **Consistency check**.

## Consistency check

Agent-run after user edits, and step 0 of `fix-activity`. No keyword, no
status change, no journal.

1. Check `activity.md`, RD, Design Decisions, Conventions, and `reviews.md`
   against each other: broken or duplicate **IDs**, Problem header vs Goal
   and Scope, Goal vs RD, Current Design vs DCs, plan and milestones vs RD,
   Setup vs rules.
2. For each issue, name the ID or section, the smallest edit, and why. Ask
   yes / no / mods. Apply only confirmed fixes; do not reword beyond the
   fix.
3. A fix that changes Goal or Scope is a **Material-change**: skip it and
   prompt.
4. `notes-by-user.md` is input only. If it cites stale IDs or contradicts
   the files, tell the user; do not edit it.

Never prune, rewrite, or renumber here; that needs `fix-activity`.
