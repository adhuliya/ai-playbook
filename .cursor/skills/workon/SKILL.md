---
name: workon
description: >-
  Manage durable, portable engineering activities under .dev-notes/activities/
  using self-contained activity.md + journal.md lifecycle workflows
  (create/derive/list/resume/replan/self-review/import and reserved lifecycle
  commands), plus notes.md (requirements, design decisions, user notes) and a
  high-level activities.md catalog. Use when the user manages activities,
  imports an activity from another system/session, or issues workon
  lifecycle keywords.
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
- `activity.md` is current execution truth (rewrite stale sections); `notes.md`
  **Software Requirement Definition** is the activity definition. `journal.md`
  records **completed project work** only — append **one** entry at
  **`complete-work`**, at the **end** of the file; prior journal entries are
  **read-only**.
- `notes.md` has three fixed sections (exact headings). **Software Requirement
  Definition** is the activity definition — keep it current for user review
  before `approve-plan`. **Software Design Decisions** records chosen design
  plus compelling alternatives. **User Notes** is the user's free-form area;
  do not overwrite it.
- No engineering until plan is approved and user starts execution.
- **Portable by default**: `activity.md` + `journal.md` + `notes.md` (SRD and
  Software Design Decisions) must let another system or agent session assess
  and continue the task with no host-specific context (no chat memory,
  absolute host paths, tool state, or local-only assumptions).
- **No micro-edits**: update files at meaningful checkpoints, not on every minor
  operation (see Update cadence).
- Do **not** bulk-read `.dev-notes/activities/activities.md`; slice with `rg`
  (`^## <slug>:`). The file can grow large.
- `activities.md` stays high-level: update only when the activity **Goal**
  changes, not for minor design/plan/status edits.

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
.dev-notes/activities/
    activities.md        # high-level catalog (heading + short para per activity)
    <slug>/
        activity.md          # current execution truth (rewritable)
        journal.md           # completed project-work log (`complete-work` only)
        notes.md             # SRD + design decisions + user notes
        knowledge/           # optional activity knowledge tree (see below)
        activities/<child>/  # optional child (max depth 2)
```

**`knowledge/`:** optional activity tree — layout and navigation per the
[`knowledge`](../knowledge/SKILL.md) skill. Create lazily when first needed.
Durable activity knowledge and files: commit under `knowledge/`; avoid huge
generated trees better kept outside the repo.
- Slug: kebab-case, top-level at `.dev-notes/activities/<slug>/`.
- Child ref: `parent-slug/child-slug` maps to
  `.../<parent-slug>/activities/<child-slug>/`.
- Filesystem hierarchy only (no parent/children metadata rows).
- Max depth 2 (top-level → child only).
- Keep durable activity context in repo; commit `.dev-notes/activities/`
  (including useful `knowledge/`).
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
| `self-review` | Review plan + notes + verified progress; grill as needed and update `activity.md`. |
| `query-work` | Enter read-only query mode (no changes) until `no-query-work`. |
| `no-query-work` | Exit query mode; changes allowed again. |
| `imported-activity` | Adopt `activity.md` + `journal.md` (+ `notes.md` if present) from another system/session and orient. |

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
3. Discovery/grill until scope and evidence are clear. Actively maintain
   `notes.md` **Software Requirement Definition** as requirements emerge;
   invite the user to challenge each one.
4. Draft + self-review `activity.md`, including the human-readable `# Scope`
   paragraph(s), with `# Goal` summarizing the SRD.
5. Write `activity.md` + `journal.md` scaffold (`# Journal` only; no entries yet)
   + `notes.md` (three sections). Append one `activities.md` entry (create the
   catalog lazily if missing).
6. File review gate: user reviews and can challenge the SRD (and plan) before
   `approve-plan`.
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

- **Goal** is a short summary of `notes.md` **Software Requirement Definition**
  (SRD). SRD is the activity definition; on conflict, SRD wins and `# Goal` /
  `# Scope` refresh at the next checkpoint.
- **Scope** is one or two human-readable paragraphs explaining the whole
  activity scope and how it fits the project. Written after initial grilling;
  then near-fixed (minor edits only). A major scope change requires
  `replan-work` (re-run project-fit and scope questions) and an SRD rewrite.
- **Current Design** is a compact execution handoff: invariants, conventions,
  boundaries, edge cases, acceptance signals. Chosen-vs-alternatives history
  lives only in `notes.md` **Software Design Decisions** — do not duplicate
  that log here.
- **Milestones** must be MECE outcomes with concrete evidence checks.
- `branch` is a hint only; do not auto-create/check out branches.
- Template: [`templates.md`](templates.md)

## `activities.md` (high-level catalog)

Path: `.dev-notes/activities/activities.md`. One heading + short paragraph per
activity folder. Not a substitute for `activity.md`. Details live in that
activity folder.

Create lazily if missing (`# Activities`, then entries). **Append** new entries
at the **end**. Do not rewrite, reorder, or rebuild the whole file unless the
user asks. If `rg` finds no heading for the focused slug, append one.

### Entry format

```markdown
## <activity-slug>: Short activity title

<paragraph>
```

A para of about 100 words or less explaining the activity. A one liner summary
is the best for brevity and searches. Details can always be discovered in that
particular activity folder.

Child slug in the heading: `parent-slug/child-slug`. Keep the paragraph
high-level enough that minor design choices do not require an update. Update
the description over time if the activity **Goal** changes.

### When to write

- **Create / derive / import:** append one entry (do not Read the file):

```bash
printf '\n## %s: %s\n\n%s\n' "$slug" "$title" "$para" >> .dev-notes/activities/activities.md
```

- **Goal change** (`replan-work` or equivalent): update **that one** entry.
- **Do not update** for design/plan/milestone/status/pause/complete/`self-review`
  unless the Goal itself changed.

### Do not bulk-read (MUST)

When working on a particular activity, avoid reading the whole index.

```bash
rg -n -A 8 '^## <slug>:' .dev-notes/activities/activities.md
rg '^## ' .dev-notes/activities/activities.md
```

Then a targeted edit of that heading + paragraph only. Resume, engineer, pause,
and complete: do not open `activities.md` unless appending or the Goal changed.

## `journal.md` contract (history)

- **When to write:** append **one** entry **only** in the `complete-work` protocol,
  after `activity.md` is synced and `status` is set to `Complete`. No journal
  updates on `approve-plan`, `start-building`, `pause-work`, `self-review`,
  `replan-work`, import, derive, or mid-session checkpoints.
- **Append-only at end:** add that entry after the last existing entry. Prior
  entries are **read-only** (no edits, inserts, or reordering).
- **Content — project work only:** what was built, changed, or learned in the
  repo (paths, behavior, decisions, tradeoffs, accepted gaps). **Not** activity
  lifecycle or status prose — no status transitions, approvals, pauses, reopen
  reasons, or “Resume Hint” (those live in `activity.md` metadata, sections,
  and `notes.md`).
- No dates unless the user explicitly asks.
- One short heading per completion (describe the work slice, not the command).
- Resume must not depend on opening source activity (derive: provenance in
  `activity.md` `# References`, not journal).

## Activity `knowledge/`

- Follow the [`knowledge`](../knowledge/SKILL.md) skill for structure and navigation.
- Complements `activity.md` (handoff truth); deep reference stays in the tree.
- Create/maintain notes via [`curate-knowledge`](../curate-knowledge/SKILL.md).

## `notes.md` contract

Required file (create at activity birth). Exact headings, this order:

1. `## Software Requirement Definition`
2. `## Software Design Decisions`
3. `## User Notes`

If missing on a later planning pass, create it and seed SRD from `# Goal` /
`# Scope` for user review. Template: [`templates.md`](templates.md).

### Software Requirement Definition

Authoritative **goal/definition** of the activity. The skill MUST keep this
list current as grilling and work reveal requirements, so the user can review
and challenge them **before** `approve-plan`.

A list (not a table). Each item:

```markdown
### <title>
- kind: end-user-interface | internal-behavior | external-interface
- <description>
```

`kind` is exactly one of:

- `end-user-interface` — end-user facing UI/CLI/UX
- `internal-behavior` — behavior inside this software
- `external-interface` — contract with other software (API, ABI, link,
  protocol). Example: generated-code API a compiler expects a library to
  supply at link time — compiler and library inter-depend.

Drop or reword items when the user challenges them. A material SRD change
after approval follows the material-change choice set / `replan-work`.

### Software Design Decisions

Important design choices with the **compelling alternatives** weighed before
selecting one. Later reference, and the source other skills MUST use when
writing design documents (big and little choices plus reasoning). Do not keep
a parallel decision log elsewhere.

Detailed but crisp — no bloat; skip micro-choices that a reader can rediscover
from the code.

```markdown
### <decision title>
- chosen: <what>
- why: <compelling reason>
- alternatives:
  - <alt>: <why not>
- replaces: <old decision title>
```

Record a decision when it is made (planning or execution). Do not delete or
rewrite history. If a later choice supersedes an earlier one, **append** a new
entry and set `replaces:` to the **old heading title** (do not restate the old
write-up — a reader follows that heading). Omit `replaces:` when there is
nothing to point at. Do not rename an old heading after it has been cited.

### User Notes

The user's free-form area for information useful to the activity. Do **not**
overwrite or prune it. Read it for intake; promote load-bearing bits into SRD
or Software Design Decisions instead of editing the user's text away. Agent
may append a short `agent:` line only when the user asked to capture something
here.

## Portability

`activity.md` + `journal.md` + `notes.md` (SRD and Software Design Decisions)
are the handoff. Assume the next reader is a fresh agent on a different
machine with no memory of this chat. **User Notes** is extra — the handoff
must not depend on it.

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
- Update `notes.md` **Software Requirement Definition** whenever requirements
  are added, dropped, or restated; it must be current before `approve-plan`.
- Update `notes.md` **Software Design Decisions** when an important design
  choice is made (chosen + why + compelling alternatives).
- Update `activities.md` only when the **Goal** (high-level purpose) changes;
  skip it for minor design/plan edits (see `activities.md`).
- Do **not** update `journal.md` until `complete-work` (see `journal.md` contract).
- Do not micro-edit on every minor step; a fresh session should be able to
  reconstruct fine-grained progress from repo state, tests, and evidence.
- **User Notes** is exempt from checkpoint cadence (user-owned).
- Always sync before `pause-work`, `complete-work`, or handing the activity off.

## List/details output

- **List** (e.g. list activities/paused/blocked/completed/all):
  - default filter: `Approved`, `Active`, `Paused`, `Blocked`
    (exclude `Complete` unless asked)
  - recurse into `activities/` and show parent/child slugs
  - build markdown table from first ~10 lines of each `activity.md`
    (title/slug/status, plus branch/notes when present)
  - prefer `rg` on `activity.md` files for status; for high-level search,
    `rg` on `activities.md` (do not dump or bulk-read that file)

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
  assumptions, risks, interfaces, non-goals, artifacts. Classify each
  requirement (`end-user-interface` / `internal-behavior` /
  `external-interface`) and write it into the SRD as it becomes clear.
- Use `grill-me` skill when attached or when user wants a full design grill.
- Draft explicit Goal (SRD summary) / Design / Plan / MECE milestones /
  evidence / Next Steps / References. Record important choices in Software
  Design Decisions as they are made.
- Capture execution-critical invariants and guardrails in planning.
- Define knowledge/artifact expectations up front (`knowledge/` tree vs pointers elsewhere).
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
3. Rewrite SRD for the new definition; rewrite `# Scope` and affected
   `activity.md` sections; keep completion/decision history (append new
   Software Design Decisions; do not delete old ones).
   If the **Goal** / high-level purpose changed, update that one `activities.md`
   entry via `rg` (do not bulk-read the catalog).
4. If status is not `Planning`, reopen to `Planning` and record the reason in
   `activity.md` (not `journal.md`).
5. Then file review + Execution gate before engineering.

## `self-review`

Reconcile the plan against reality. Reviews `# Current Plan`, `# Milestones`,
and `# Next Steps` together with `notes.md` and **verified** repo progress,
then updates `activity.md` so it reflects actual state. Allowed in any status;
does not change status by itself.

Not a replan: this fixes drift within the existing scope. If review surfaces a
**material** scope change, stop and route to the material-change choice set
(`create-sibling` / `create-child` / `replan-work`) per the Gating policy.

1. Gather inputs (read-only first):
   - `activity.md` (full), `notes.md` SRD + Software Design Decisions,
     enough recent `journal.md`, and **User Notes** if useful.
   - Verify progress independently: run milestone evidence commands/checks and
     inspect repo state. Do not trust prose alone.
2. Surface findings: claimed vs verified status, done vs remaining milestones,
   drift between files and repo, stale plan/next steps, SRD vs shipped
   behavior, and any open questions in **User Notes**.
3. Grill only where it helps: if the review finds ambiguity, conflicts, or
   decisions the user must make, grill the user to resolve them (use `grill-me`
   when a fuller design grill is warranted). Skip grilling when the picture is
   already clear.
4. Update `activity.md` accordingly: refresh `# Current Design`, `# Current
   Plan`, `# Milestones` (tick/untick with evidence), and `# Next Steps`.
   Sync `# Goal` / `# Scope` from SRD if they drifted. Promote load-bearing
   **User Notes** into SRD or Software Design Decisions; do not prune SRD,
   Software Design Decisions, or the user's text.
5. Do not silently expand scope. For a material change, require the user's
   choice from the material-change choice set before rewriting scope.
   (No `journal.md` update — `self-review` does not append journal.)

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

Derived `activity.md` + `notes.md` (SRD + Software Design Decisions) must be
resumable without opening source.
No "see parent" or "continues from" dependency language.

1. Remind strong model.
2. Read source `activity.md` and its SRD / Software Design Decisions once as
   input (plus recent journal only if needed).
3. Project-fit-first, then fresh free-text scope for the derived activity
   (see Planning quality bar).
4. Run full discovery/grill for new scope (do not inherit fuzziness).
5. Rewrite all required `activity.md` sections and a fresh `notes.md` SRD for
   the new task; inline required context (no load-bearing source dependency).
   Software Design Decisions only for this activity (copy a still-applicable
   choice inline, not as a pointer).
6. Fresh `journal.md` scaffold only (`# Journal`); reset metadata
   (`status: Planning`, new slug, ticket/notes/branch). Provenance in
   `# References` (`derived-from: <slug>`), not journal. Append one
   `activities.md` entry for the new slug.
7. Self-review: derived `activity.md` + SRD must stand alone even if source
   were deleted.
8. File review + revision loop.
9. `create-sibling` = top-level sibling.
   `create-child` = under `activities/` (respect max depth 2).
10. Under a `Complete` parent, parent may stay `Complete`;
    optional breadcrumb in parent `activity.md` / **User Notes** (not journal).

Optional provenance reference in `# References`:

`derived-from: <slug>` (non-load-bearing only).

## `imported-activity`

Use in a new session when the user brings an `activity.md` + `journal.md`
(and `notes.md` if present) from another system or agent. Assume no prior
chat context.

1. Locate the files the user points to; if the slug/path is ambiguous, ask.
   Do not assume they live under this repo's `.dev-notes/activities/`.
2. Read `activity.md` fully, `notes.md` SRD + Software Design Decisions if
   present, then enough recent `journal.md` for context.
   Treat these files as the source of truth (no host-specific assumptions).
3. Independently verify progress against the repo: run milestone evidence
   commands/checks; do not trust prose alone. Note any drift between files and
   actual repo state.
4. Output an orientation summary: SRD / objective, `# Scope`, design, claimed
   status vs verified status, done vs remaining milestones, discovered
   gaps/drift, and the proposed safest next action from `# Next Steps`.
5. Set up the activity for this session: place the files under this repo's
   `.dev-notes/activities/<slug>/` if not already there, reconcile any drift
   into `activity.md` / SRD, and set `status` to `Planning` (or `Approved` if
   the user immediately approves). Do not append import notes to `journal.md`.
   If `notes.md` is missing, create the three sections and seed SRD from
   `# Goal` / `# Scope`. If it exists without the three headings, add them and
   move leftover body under **User Notes**.
   If `activities.md` has no heading for the slug, append one entry.
6. Do not start engineering. Wait for `approve-plan`, then `start-building`
   (Execution gate); only then set `status` to `Active` and begin work.
7. If the import is `Complete` and new work is requested, apply the Complete
   decision policy (reopen to `Planning`) before the Execution gate.

## Resume protocol (`resume-work`)

1. Read this activity's `activity.md` and `notes.md` SRD + Software Design
   Decisions (do not auto-open parent/sibling/source or `activities.md`), then
   enough recent `journal.md` for context. **User Notes** only if needed.

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

   - If non-material in same activity: reopen `Complete → Planning`, record
     reason in `activity.md`, add targeted plan delta.

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
  fresh reader, update `activity.md` before continuing. If it reveals a
  requirement or an important design choice, update SRD / Software Design
  Decisions the same way (material new requirements → material-change choice
  set).
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
3. Set `status` to `Active`.
4. Begin engineering only after this command.

## `approve-plan`

1. Validate planning outputs are written and reviewed, including a current
   SRD the user has had a chance to challenge. If the SRD is empty, stale, or
   unreviewed, do not approve — send them back to the file review gate.
2. Set `status` to `Approved` in `activity.md`.
3. Give the one-time note that planning is complete, so the user may switch off
   the strong model for execution.
4. Do not implement yet; ask user to run `start-building`.
5. If already `Approved` or `Active`, report current state; do not rewrite history.

## `pause-work`

1. Sync `activity.md` current truth (Design / Plan / Milestones / Next Steps)
   and `notes.md` SRD / Software Design Decisions if they changed.
2. Set `status` to `Paused`.
3. Put resume context in `activity.md` `# Next Steps` (and `notes` if needed).
4. Present concise pause summary.

## `Blocked` vs `Paused`

- `Paused`: intentional stop, can continue later.
- `Blocked`: cannot continue until dependency clears; record one-line blocker
  in `notes` and details in `activity.md` / **User Notes**.

## `complete-work`

1. If open children (`Planning` / `Approved` / `Active` / `Paused` / `Blocked`)
   exist: warn, list, ask to complete/abandon children or force-complete parent;
   never force silently.

2. Abandon child = `Complete` with notes: `abandoned: <reason>`.

3. Require milestones complete or explicitly dropped with reason recorded in
   `activity.md`; verify evidence when possible (or ask user to confirm).

4. Before setting `Complete`, rewrite `activity.md` as a resumable completion
   handoff:
   - **Current Design**: shipped behavior, touched paths/interfaces,
     must-not-break invariants.
   - **Milestones**: checked/dropped with concrete evidence commands/checks
     or artifact pointers.
   - **Next Steps**: minor-fix runway (known small follow-ups, fastest
     validation commands, safest first edit targets).

5. Set `status` to `Complete`; keep maintenance context needed for future fixes.
   Keep SRD and Software Design Decisions as-is (later reference / design docs).
   Do not prune **User Notes**.

6. Append **one** journal entry at the **end** of `journal.md`: project work
   only — shipped outcomes, key technical decisions, lessons, accepted gaps
   (no status/lifecycle narration). See [`templates.md`](templates.md).

7. If post-completion fixes are requested, reopen via planning
   (`Complete → Planning`), capture delta plan, pass the Execution gate,
   then return to `Complete` with refreshed evidence.

## Token economy

- Keep `activity.md`, `journal.md`, and `notes.md` SRD / Software Design
  Decisions lean; they are loaded during resume.
- Prefer concise bullets; avoid narrative dumps; link paths/artifacts instead.
- Delete stale prose when rewriting `activity.md`.
- Do not load `activities.md` on resume; `rg` one heading if a catalog
  update is required.
- Do not load **User Notes** on resume unless the user pointed at them.
