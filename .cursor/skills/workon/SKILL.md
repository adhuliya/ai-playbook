---
name: workon
description: >-
  Manage durable engineering activities under .dev-notes/activities/ using
  activity.md + journal.md lifecycle workflows (create/derive/list/resume/replan
  and reserved lifecycle commands). Use when the user manages activities or
  issues workon lifecycle keywords.
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

## Model reminders

- Planning work (create, derive, material replan): remind to use a **strong** model.
- Execution on a locked plan: remind to use a **medium** model.
- Remind once per phase change; one-line confirmation is enough if already appropriate.

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
| `start-build` | Begin implementation from an approved plan. |
| `start-building` | Backward-compatible alias for `start-build`. |
| `pause-work` | Pause protocol (allowed in Planning too). |
| `resume-work` | Resume protocol. |
| `complete-work` | Completion protocol. |

Natural language handles create/switch/list/derive/replan/details.

Planning → execution gate is always `approve-plan`, then `start-build`
(or alias `start-building`).

Decision keywords for material change policy (not lifecycle commands):
`create-sibling`, `create-child`, `override-plan`.

## State model

Preferred lifecycle:

`Planning → Approved → Active → Complete`

with optional `Paused` / `Blocked`.

`Complete` does not go directly to `Active`; reopen to `Planning`
first when new work is needed.

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
2. `# Background and Special Notes`
3. `# Current Design`
4. `# Current Plan`
5. `# Milestones`
6. `# Next Steps`
7. `# References`

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

- Intake-first rule (mandatory): before any detailed grilling, ask the user
  for a free-text activity scope definition.
- Grill vague/conflicting input: goal, success, scope in/out, constraints,
  assumptions, risks, interfaces, non-goals, artifacts.
- Use `grill-me` skill when attached or when user wants a full design grill.
- Draft explicit Goal / Design / Plan / MECE milestones / evidence /
  Next Steps / References.
- Capture execution-critical invariants and guardrails in planning.
- Define artifact expectations up front (`artifacts/` vs pointers elsewhere).
- Self-review for ambiguity and missing evidence before user review.

Required intake prompt (or equivalent wording):

> In free text, define this activity's scope: objective, in-scope work,
> out-of-scope boundaries, constraints, and what "done" looks like.

If the user already provided equivalent scope text in the current message,
acknowledge it and then continue with detailed grill questions.

## Create flow

1. Remind strong model.
2. Ask for free-text scope definition using the required intake prompt
   (or equivalent).
3. Discovery/grill until scope and evidence are clear.
4. Draft + self-review `activity.md`.
5. Write `activity.md` + `journal.md` immediately once coherent.
6. File review gate: user reviews and approves plan.
7. Revision loop until satisfied.
8. Require `approve-plan`, then `start-build` (or alias `start-building`)
   before engineering.

## Derive flow

(`create-sibling` / `create-child`)

Self-contained rule (mandatory):

Derived `activity.md` must be resumable without opening source.
No "see parent" or "continues from" dependency language.

1. Remind strong model.
2. Read source `activity.md` (plus recent journal only if needed) once as input.
3. Ask for a fresh free-text scope definition for the derived activity
   before detailed grilling.
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

   - If material: require explicit user choice
     (`create-sibling`, `create-child`, `override-plan`)
     before changing state.

   - Apply choice:
     - `create-sibling`: derive sibling in `Planning`; current stays `Complete`.
     - `create-child`: derive child in `Planning`; parent stays `Complete`.
     - `override-plan`: reopen current to `Planning`, journal reason,
       rewrite plan sections while preserving completion history.

   - If non-material in same activity: reopen `Complete → Planning`,
     journal reason, add targeted plan delta.

5. From any reopened/new planning path, require reviewed file updates,
   then `approve-plan`, then `start-build` (or alias `start-building`)
   before engineering.

6. Never jump `Complete → Active` directly.

Status-specific reminders:

- `Planning` or definition/replan next: remind strong model.
- `Approved`: remind user to issue `start-build` / `start-building`.
- `Blocked`: restate blocker and ask if cleared.
- Missing derived context: ask before opening optional `derived-from` reference.

## Engineering while focused

- Keep `activity.md` current (rewrite stale sections).
- Keep metadata current; no dates unless asked.
- Append one concise journal entry per work session.
- If execution reveals missing invariant/convention detail, update
  `activity.md` first, then continue.
- Replan anytime:
  - non-material: concise targeted plan delta.
  - material (including resumed `Complete` risks to original plan):
    require user choice `create-sibling` / `create-child` / `override-plan`
    before state changes.
  - do engineering only after reviewed planning updates + `approve-plan` +
    `start-build` / `start-building`.
- Suggest child activity when work becomes independently durable.

## `start-build`

(alias: `start-building`)

1. Preferred precondition: status `Approved`.
2. If status is `Planning`, require `approve-plan` first.
3. Set `status` to `Active`; append journal start entry.
4. Remind medium model.
5. Begin engineering only after this command.

## `approve-plan`

1. Validate planning outputs are written and reviewed.
2. Set `status` to `Approved` in `activity.md`.
3. Append short journal entry (approved and ready to build).
4. Do not implement yet; ask user to run `start-build` / `start-building`.
5. If already `Approved` or `Active`, report current state; do not rewrite history.

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
   (`Complete → Planning`), capture delta plan, require `approve-plan` +
   `start-build` / `start-building`, then return to `Complete` with refreshed
   evidence.

## Token economy

- Keep `activity.md` and `journal.md` lean; they are loaded during resume.
- Prefer concise bullets; avoid narrative dumps; link paths/artifacts instead.
- Delete stale prose when rewriting `activity.md`.
