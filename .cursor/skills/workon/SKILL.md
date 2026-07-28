---
name: workon
description: >-
  Manage durable, portable engineering activities under .dev-notes/activities/
  using self-contained activity.md + journal.md lifecycle workflows
  (create/derive/list/resume/replan/import and reserved lifecycle commands). Use
  when the user manages activities, imports an activity from another
  system/session, or issues workon lifecycle keywords.
disable-model-invocation: true
---

# workon

Activity manager for software engineering work.
Documentation is part of the deliverable: keep records resumable months later.

## Hard constraints

- One focused activity per chat (memory only; no `.focus` file).
- Never silently edit a non-focused activity.
- New chat without a named activity: list activities and ask.
- Honor only reserved lifecycle commands (exact keywords).
- No dates in `activity.md` / `journal.md` unless user explicitly asks.
- `activity.md` is current truth (rewrite stale sections); `journal.md` is append-only.
- No engineering until plan is approved and user starts execution.
- **Portable by default**: `activity.md` + `journal.md` must let another system
  or agent session assess and continue the task with no host-specific context
  (no chat memory, absolute host paths, tool state, or local-only assumptions).
- **No micro-edits**: update files at meaningful checkpoints, not on every minor
  operation (see Update cadence).

## Model reminders

- Planning/replanning (create, derive, `replan-work`): remind to use a **strong**
  model.
- At `approve-plan`, give a one-time note that planning is complete, so the user
  may switch off the strong model for execution. No execution-tier recommendation.
- Remind once per phase change; one-line confirmation is enough if already appropriate.

## Gating policy

- Users interact freely in natural language for discussion and exploration.
- Gated transitions require their exact reserved keyword. When the agent detects
  intent for a gated action, it must not perform it silently; instead prompt the
  user with the exact command to run, e.g.:
  > If you want to replan the activity, write the command `replan-work` to start.
  Apply the same pattern for other gated commands.

## Storage and identity

```text
.dev-notes/activities/<slug>/
    activity.md          # current truth (rewritable)
    journal.md           # append-only history
    artifacts/           # optional activity artifacts
    activities/<child>/  # optional child (max depth 2)
```

- Slug: kebab-case, top-level at `.dev-notes/activities/<slug>/`.
- Child ref: `parent-slug/child-slug` maps to
  `.../<parent-slug>/activities/<child-slug>/`.
- Filesystem hierarchy only (no parent/children metadata rows).
- Max depth 2 (top-level → child only).
- `artifacts/` stores activity-specific durable files; avoid dumping huge
  generated trees better kept elsewhere.
- Keep durable activity context in repo; commit
  `.dev-notes/activities/` (including useful `artifacts/`).
- Ambiguous slug: list matches and ask; never guess.

## Reserved lifecycle commands

Honor only these exact keywords (ordinary words like "pause"/"done" do not
trigger them):

| Keyword | Action |
|---|---|
| `approve-plan` | Mark plan as approved and lock planning output (no engineering yet). |
| `start-building` | Begin implementation from an approved plan. |
| `pause-work` | Pause protocol (allowed in Planning too). |
| `resume-work` | Resume protocol. |
| `complete-work` | Completion protocol. |
| `replan-work` | Re-open scope: re-run project-fit + scope grill on a major change. |
| `query-work` | Enter read-only query mode (no changes) until `no-query-work`. |
| `no-query-work` | Exit query mode; changes allowed again. |
| `imported-activity` | Adopt an `activity.md` + `journal.md` brought from another system/session and orient. |

Natural language initiates create/switch/list/details (create still runs its
gated flow). Gated transitions (derive, replan, execution) require their reserved
keywords per the Gating policy.

**Execution gate** (referenced elsewhere): `approve-plan`, then `start-building`;
no engineering before it.

**Material-change choice set** (gated): `create-sibling`, `create-child` (derive
keywords), or `replan-work` (reserved lifecycle command). On a material change,
prompt the user to write one of these to proceed.

## State model and activity lifecycle

Single source of truth for an activity's whole life: its states and the birth
sequence that creates it.

Preferred lifecycle:

`Planning → Approved → Active → Complete`

with optional `Paused` / `Blocked`.

`Complete` does not go directly to `Active`; reopen to `Planning`
first when new work is needed.

### Create sequence (a new activity's birth)

(applies to `Planning`; see Planning quality bar for the grill detail)

1. Remind strong model.
2. Project-fit-first, then intake prompt (see Planning quality bar).
3. Discovery/grill until scope and evidence are clear.
4. Draft + self-review `activity.md`, including the human-readable `# Scope`
   paragraph(s).
5. Write `activity.md` + `journal.md` immediately once coherent.
6. File review gate: user reviews and approves plan.
7. Revision loop until satisfied.
8. Pass the Execution gate (`approve-plan`, then `start-building`) before
   engineering.

Other transitions have their own procedures: Derive flow, Resume protocol,
`start-building`, `approve-plan`, `pause-work`, `replan-work`, `complete-work`.

## `activity.md` contract (current truth)

Keep title + metadata table in first ~10 lines:

```markdown
# <Human Title>

| Key | Value |
|---|---|
| status | Planning |
| slug | my-activity |
| branch | feature/my-activity |
| ticket | none |
| notes | |

# Goal
...
```

Status tokens (exact):
`Planning` | `Approved` | `Active` | `Paused` | `Blocked` | `Complete`

Required metadata rows:
`status`, `slug`, `branch`, `ticket`, `notes`

(`ticket` may be `none`; `notes` may be empty; `branch` may be `none`.)

Required sections (order):

1. `# Goal`
2. `# Scope`
3. `# Background and Special Notes`
4. `# Current Design`
5. `# Current Plan`
6. `# Milestones`
7. `# Next Steps`
8. `# References`

- **Scope** is one or two human-readable paragraphs explaining the whole
  activity scope and how it fits the project. Written after initial grilling;
  then near-fixed (minor edits only). A major scope change requires
  `replan-work` (re-run project-fit and scope questions).
- **Current Design** is a compact execution handoff: invariants, conventions,
  boundaries, edge cases, acceptance signals.
- **Milestones** must be MECE outcomes with concrete evidence checks.
- `branch` is a hint only; do not auto-create/check out branches.
- Template: [`templates.md`](templates.md)

## `journal.md` contract (history)

- Append-only, no dates, concise entries.
- Keep one short heading per session; skip noise.
- On derive, first entry is provenance only:

  `Derived from <slug>: <reason>.`

- Resume must not depend on opening source activity.

## Portability

`activity.md` + `journal.md` are the whole handoff. Assume the next reader is a
fresh agent on a different machine with no memory of this chat.

- Self-contained: inline the context needed to assess and continue. No reliance
  on chat history, tool state, or "as discussed".
- System-agnostic references: repo-relative paths, commands, commit/PR/ticket
  IDs, and links. No absolute host paths or machine-local assumptions.
- Verifiable progress: milestone evidence must be commands/checks a new session
  can run to confirm state itself (do not trust prose alone).
- `# Next Steps` names the safest first action a newcomer should take.
- Prefer letting a new session rediscover fine-grained progress from the repo,
  tests, and evidence rather than tracking every step in the files.

## Update cadence

Write files for durability and handoff, not as a live log.

- Update `activity.md` at meaningful checkpoints: scope/design/plan change,
  milestone reached, blocker found, or before pausing/completing.
- Append **one** concise `journal.md` entry per work session, not per action.
- Do not micro-edit on every minor step; a fresh session should be able to
  reconstruct fine-grained progress from repo state, tests, and evidence.
- Always sync before `pause-work`, `complete-work`, or handing the activity off.

## List/details output

- **List** (e.g. list activities/paused/blocked/completed/all):
  - default filter: `Approved`, `Active`, `Paused`, `Blocked`
    (exclude `Complete` unless asked)
  - recurse into `activities/` and show parent/child slugs
  - build markdown table from first ~10 lines
    (title/slug/status, plus branch/notes when present)
  - prefer `rg`; no index file

- **Details** (no resume):
  show full path + first ~20 lines of `activity.md`, then stop.

## Planning quality bar

(applies to create, derive, material replan)

- Project-fit-first rule (mandatory, highest priority): before any specific
  grill question, ask how this activity fits the larger project. The user must
  state the problem against the project scope in `.dev-notes/definition.md`.
  If unsatisfied it fits, ask for clarification until satisfied; do not proceed
  otherwise.
- Intake rule (mandatory): after project fit, ask for a free-text activity
  scope definition before other detailed grilling.
- Grill vague/conflicting input: goal, success, scope in/out, constraints,
  assumptions, risks, interfaces, non-goals, artifacts.
- Use `grill-me` skill when attached or when user wants a full design grill.
- Draft explicit Goal / Design / Plan / MECE milestones / evidence /
  Next Steps / References.
- Capture execution-critical invariants and guardrails in planning.
- Define artifact expectations up front (`artifacts/` vs pointers elsewhere).
- Self-review for ambiguity and missing evidence before user review.

Required first prompt (project fit, or equivalent wording):

> Before scope: how does this activity fit the larger project? State the
> problem and lay it out against the project scope in `.dev-notes/definition.md`.

Required intake prompt (after project fit, or equivalent wording):

> In free text, define this activity's scope: objective, in-scope work,
> out-of-scope boundaries, constraints, and what "done" looks like.

If the user already provided equivalent project-fit and scope text in the
current message, acknowledge it and continue with detailed grill questions.

## `replan-work`

Use when a major scope change is needed (minor scope edits do not need it).

1. Remind strong model.
2. Re-run Planning quality bar from the top: project-fit question first, then
   free-text scope, then detailed grill.
3. Rewrite `# Scope` and affected sections; keep completion/decision history.
4. If status is not `Planning`, reopen to `Planning` and journal the reason.
5. Then file review + Execution gate before engineering.

## `query-work` / `no-query-work`

Soft safeguard so nothing changes accidentally while inspecting activity state.

- `query-work`: enter read-only query mode. Answer questions about the activity;
  make no file, metadata, or code changes. Keep the current status unchanged
  (this is not a lifecycle state, just a guard).
- Mode lasts until the user issues `no-query-work` or the session ends.
- In query mode, if asked to change anything, state that query mode is on and
  ask the user to run `no-query-work` first.
- `no-query-work`: exit query mode; changes allowed again.

## Derive flow

(`create-sibling` / `create-child`)

Self-contained rule (mandatory):

Derived `activity.md` must be resumable without opening source.
No "see parent" or "continues from" dependency language.

1. Remind strong model.
2. Read source `activity.md` (plus recent journal only if needed) once as input.
3. Project-fit-first, then fresh free-text scope for the derived activity
   (see Planning quality bar).
4. Run full discovery/grill for new scope (do not inherit fuzziness).
5. Rewrite all required sections for new task; inline required context
   (no load-bearing source dependency).
6. Fresh journal with provenance line only; reset metadata
   (`status: Planning`, new slug, ticket/notes/branch).
7. Self-review: derived `activity.md` must stand alone even if source
   were deleted.
8. File review + revision loop.
9. `create-sibling` = top-level sibling.
   `create-child` = under `activities/` (respect max depth 2).
10. Under a `Complete` parent, parent may stay `Complete`;
    optional parent journal/note breadcrumb.

Optional provenance reference in `# References`:

`derived-from: <slug>` (non-load-bearing only).

## `imported-activity`

Use in a new session when the user brings an `activity.md` + `journal.md` from
another system or agent. Assume no prior chat context.

1. Locate the pair the user points to; if the slug/path is ambiguous, ask.
   Do not assume it lives under this repo's `.dev-notes/activities/`.
2. Read `activity.md` fully, then enough recent `journal.md` for context.
   Treat the files as the sole source of truth (no host-specific assumptions).
3. Independently verify progress against the repo: run milestone evidence
   commands/checks; do not trust prose alone. Note any drift between files and
   actual repo state.
4. Output an orientation summary: objective, `# Scope`, design, claimed status
   vs verified status, done vs remaining milestones, discovered gaps/drift, and
   the proposed safest next action from `# Next Steps`.
5. Set up the activity for this session: place the files under this repo's
   `.dev-notes/activities/<slug>/` if not already there, reconcile any drift
   into `activity.md`, and set `status` to `Planning` (or `Approved` if the
   user immediately approves). Append a journal entry noting the import.
6. Do not start engineering. Wait for `approve-plan`, then `start-building`
   (Execution gate); only then set `status` to `Active` and begin work.
7. If the import is `Complete` and new work is requested, apply the Complete
   decision policy (reopen to `Planning`) before the Execution gate.

## Resume protocol (`resume-work`)

1. Read this activity's `activity.md` only (do not auto-open
   parent/sibling/source), then enough recent `journal.md` for context.

2. Output concise resume summary:
   - objective
   - design
   - status
   - discoveries
   - remaining work
   - proposed next action
   - branch hint

3. If status is not `Complete`: stop and wait for explicit confirmation
   before engineering.

4. If status is `Complete`, run decision policy before any state/file change:

   - Ask for a free-text scope definition of the requested addition/fix,
     then grill specifics (outcome, why now, scope in/out, affected
     paths/interfaces, risk/rollback, acceptance evidence).

   - Classify: non-material extension/fix vs material plan change.

   - If material: prompt for and require explicit user choice from the
     material-change choice set (`create-sibling`, `create-child`, `replan-work`)
     before changing state.

   - Apply choice:
     - `create-sibling`: derive sibling in `Planning`; current stays `Complete`.
     - `create-child`: derive child in `Planning`; parent stays `Complete`.
     - `replan-work`: reopen current to `Planning` and re-run the replan
       protocol, preserving completion history.

   - If non-material in same activity: reopen `Complete → Planning`,
     journal reason, add targeted plan delta.

5. From any reopened/new planning path, require reviewed file updates,
   then pass the Execution gate before engineering.

6. Never jump `Complete → Active` directly.

Status-specific reminders:

- `Planning` or definition/replan next: remind strong model.
- `Approved`: remind user to issue `start-building`.
- `Blocked`: restate blocker and ask if cleared.
- Missing derived context: ask before opening optional `derived-from` reference.

## Engineering while focused

- Follow the Update cadence: edit at checkpoints, not on every minor step.
- If execution reveals a missing invariant/convention that would mislead a
  fresh reader, update `activity.md` before continuing.
- Replan anytime:
  - non-material: concise targeted plan delta.
  - material (including resumed `Complete` risks to original plan):
    prompt for and require user choice from the material-change choice set
    (`create-sibling` / `create-child` / `replan-work`) before state changes.
  - do engineering only after reviewed planning updates + Execution gate.
- Suggest child activity when work becomes independently durable.

## `start-building`

1. Preferred precondition: status `Approved`.
2. If status is `Planning`, require `approve-plan` first.
3. Set `status` to `Active`; append journal start entry.
4. Begin engineering only after this command.

## `approve-plan`

1. Validate planning outputs are written and reviewed.
2. Set `status` to `Approved` in `activity.md`.
3. Append short journal entry (approved and ready to build).
4. Give the one-time note that planning is complete, so the user may switch off
   the strong model for execution.
5. Do not implement yet; ask user to run `start-building`.
6. If already `Approved` or `Active`, report current state; do not rewrite history.

## `pause-work`

1. Sync `activity.md` current truth (Design / Plan / Milestones / Next Steps).
2. Set `status` to `Paused`.
3. Append concise journal entry with Resume Hint.
4. Present concise pause summary.

## `Blocked` vs `Paused`

- `Paused`: intentional stop, can continue later.
- `Blocked`: cannot continue until dependency clears; record one-line blocker
  in `notes` and details in `activity.md` / `journal.md`.

## `complete-work`

1. If open children (`Planning` / `Approved` / `Active` / `Paused` / `Blocked`)
   exist: warn, list, ask to complete/abandon children or force-complete parent;
   never force silently.

2. Abandon child = `Complete` with notes: `abandoned: <reason>`.

3. Require milestones complete or explicitly dropped with journal reason;
   verify evidence when possible (or ask user to confirm).

4. Before setting `Complete`, rewrite `activity.md` as a resumable completion
   handoff:
   - **Current Design**: shipped behavior, touched paths/interfaces,
     must-not-break invariants.
   - **Milestones**: checked/dropped with concrete evidence commands/checks
     or artifact pointers.
   - **Next Steps**: minor-fix runway (known small follow-ups, fastest
     validation commands, safest first edit targets).

5. Set `status` to `Complete`; keep maintenance context needed for future fixes.

6. Append final journal entry: outcome, key decisions, lessons, accepted gaps,
   and concrete "Resume from Complete" hint.

7. If post-completion fixes are requested, reopen via planning
   (`Complete → Planning`), capture delta plan, pass the Execution gate,
   then return to `Complete` with refreshed evidence.

## Token economy

- Keep `activity.md` and `journal.md` lean; they are loaded during resume.
- Prefer concise bullets; avoid narrative dumps; link paths/artifacts instead.
- Delete stale prose when rewriting `activity.md`.
