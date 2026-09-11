---
name: workon
description: >-
  Manage durable activities under .dev-notes/activities/ (activity.md,
  journal.md, requirements.md, design-choices.md, conventions.md,
  user-notes.md, activities.md, optional artifacts/). Use when the user
  manages activities, imports an activity, or issues workon keywords:
  approve-plan, start-building, pause-work, resume-work, mark-completed,
  replan-work, create-sibling, compact-journal, self-review, apply-review,
  query-work, no-query-work, import-activity, follow-convention, verify-plan.
disable-model-invocation: true
---

# workon

Activity manager. Records must stay resumable months later.

Shapes: [`templates.md`](templates.md). Keyword sequences: [`commands.md`](commands.md).
Sub-agents: [`subagent-contract.md`](subagent-contract.md).
Apply a **Named policy** by heading. Do not restate it.

## Stops

- One focused activity per chat (memory only; no `.focus` file). Never silently
  edit a non-focused activity. New chat without a named activity: list and ask.
- **Keyword gate.** **Material-change:** prompt; do not rewrite scope first.
- No dates in `activity.md` / `journal.md` unless asked.
- `activity.md` is current execution truth (rewrite stale sections).
  **Journal policy.** **Notes files** (never overwrite `user-notes.md`).
- **Execution gate.** **Portability.** **Prose density.** **Test evidence.**
- **Background sub-agents.** Chat parent never waits on a Task.
- **Update cadence** (no micro-edits). **Catalog** (`rg`, no bulk-read).
- `query-work`: session flag; blocks **any** mutation (files, git, keywords)
  until `no-query-work` or session end.

## Keyword gate

Natural language is fine for discussion, create, switch, list, details.
Gated transitions need the exact reserved keyword. On detected intent, do not
silent-transition; prompt it, e.g. `If you want to replan, write \`replan-work\`.`

## Material-change

**Material** = Goal or Scope rewrite; ARD add/drop/reword after approval that is
not an in-scope plan refresh; or independently durable new work.

**Not material:** in-scope plan, design, or convention tighten on the same Goal
(in-flight `apply-review`).

On a material change, prompt the matching choice; do not rewrite scope first.

| Status | Keyword |
|---|---|
| In flight (`Planning` / `Approved` / `Active` / `Paused` / `Blocked`) | `replan-work` (same slug) or `create-sibling` |
| `Complete` | stay-on-slug (minor) or `create-sibling` (major). Never `replan-work` |

**Complete stay-on-slug** (never `Complete` → `Active`):

- `resume-work`: grill, then reopen `Complete` → `Planning` (see that command).
- `apply-review`: stay-on-slug **only**. Report is intake; no sibling; no full
  resume grill. Material remaining proposal → apply nothing; ask
  `create-sibling`. For the grill/classify fork, they use `resume-work` first.

**Complete sibling:** prompt `create-sibling`. Parent stays `Complete`. No parent
journal. Sibling `derived-from:` only; parent never points at the sibling.

## Execution gate

No product engineering until `approve-plan` then `start-building`. After a
Complete stay-on-slug reopen to `Planning`, this gate runs again. Already
`Approved` or `Active`: `approve-plan` reports state; do not rewrite history.

## Paused vs Blocked

- `Paused`: intentional stop via `pause-work`. `resume-work` restores the
  pre-pause status (recorded in the pause recap heading).
- `Blocked`: cannot continue. The agent MAY set it at a checkpoint when work
  is stuck; record a one-line blocker **and the prior status** in the
  `activity.md` metadata `notes` row, details in `activity.md` / User Notes.
  No journal write on entering `Blocked`. `resume-work` clears it back to
  that prior status.

## Reminders

- Create, `create-sibling`, `replan-work`: remind to use a **strong** model.
- At `approve-plan`: one-time note that planning is done; user may drop the
  strong model. No execution-tier recommendation.
- Remind once per phase change.

**Optional-remind** (once, do not require): `verify-plan` at `approve-plan` if
this session has not run it; `apply-review` when `self-review.md` exists
unapplied (`approve-plan`, `start-building`, `pause-work`, `resume-work`).

## Journal policy

File: `.dev-notes/activities/<slug>/journal.md` only. Shapes: `templates.md`.

**Write only** on `pause-work`, `resume-work`, `mark-completed`, and
`apply-review` when that command **actually resumes** (`Paused` or `Complete`).
Append at end. Prior entries are **read-only** except `compact-journal`.

Do **not** write on `approve-plan`, `start-building`, `self-review`, import,
create, `create-sibling`, `follow-convention`, `verify-plan`, or `apply-review`
that does not resume (new sibling starts with `# Journal` only).

Pause / resume recap: hard cap **~8–12 lines**; omit empty fields. Headings:
`## Pause (<from> → Paused)` / `## Resume (<from> → <to>)`. No dates unless
asked. No milestone tables, ARD dumps, or plan copies.

**`mark-completed`:** thicker **project-work** write-up (what shipped, paths,
decisions, gaps). Heading carries the tick (`## <work title> (<from> → Complete)`);
no separate tick line. Not a lifecycle novel.

Until the first journal write, the file is `# Journal` only. `compact-journal`
is the only rewrite.

## Layout

```text
.dev-notes/activities/
    activities.md
    <slug>/          # kebab-case, top-level only; siblings side by side
        activity.md, journal.md, requirements.md, design-choices.md,
        conventions.md, user-notes.md
        artifacts/   # cited copies flat; reserved: verify-plan/, bg/,
                     # self-review/, self-review.md
```

Ambiguous slug: list matches and ask. Commit `.dev-notes/activities/` including
useful `artifacts/` copies and reserved review/env/bg records. Agent does not
`git add` / commit unless asked. Huge generated trees stay out of the repo.

Status tokens (exact): `Planning` | `Approved` | `Active` | `Paused` | `Blocked` | `Complete`

Preferred lifecycle: `Planning → Approved → Active → Complete`, with optional
`Paused` / `Blocked`. Never `Complete` → `Active`.

## `activity.md`

Title + metadata table in the first ~10 lines. Template: `templates.md`.

Required rows: `status`, `slug`, `branch`, `ticket`, `notes`
(`ticket` may be `none`; `notes` may be empty; `branch` may be `none`).
`branch` is a hint; do not auto-create or check out branches.

Required sections (order): Goal, Scope, Background and Special Notes, Current
Design, Current Plan, Milestones, Next Steps, References.

- **Goal** summarizes ARD. On conflict, ARD wins; refresh Goal / Scope at the
  next checkpoint.
- **Scope:** one or two paragraphs after the first grill; then near-fixed.
  Major in-flight change → **Material-change**.
- **Current Design:** execution handoff (invariants, boundaries, evidence
  signals). Chosen-vs-alternatives live only in Design Decisions.
- **Milestones:** MECE outcomes. Apply **Test evidence**. On reopen, keep
  checked items; append new ones; mark removed work `superseded` — do not delete.
- **References:** one bullet per cited planning file (source path, `copied` /
  `excerpt` / `context-only`, 1–3 sentences learned).

## Catalog

`.dev-notes/activities/activities.md`. Create lazily (`# Activities`).
**Append** new entries at the end. Do not rewrite or reorder the whole file
unless asked. Heading: `## <slug>: Short title` plus one high-level paragraph.
Not a substitute for `activity.md`.

On create / derive / import, do not Read the catalog:

```bash
printf '\n## %s: %s\n\n%s\n' "$slug" "$title" "$para" >> .dev-notes/activities/activities.md
```

Goal change (`replan-work`, `apply-review` if Goal text changes, or equivalent):
edit **that one** heading via `rg`. Skip catalog updates for
design/plan/status/pause/complete/`self-review`.

```bash
rg -n -A 8 '^## <slug>:' .dev-notes/activities/activities.md
rg '^## ' .dev-notes/activities/activities.md
```

**List:** default `Approved` / `Active` / `Paused` / `Blocked` (exclude
`Complete` unless asked). Table from first ~10 lines of each `activity.md`.
Prefer `rg` on `activity.md` files; catalog search via `rg` on `activities.md`.

**Details** (no resume): full path + first ~20 lines of `activity.md`, stop.

## Notes files

Required at birth. Templates: `templates.md`.

**Repair** (before any notes-file read or write, including `start-building`,
`follow-convention`, `resume-work`, `verify-plan`, `self-review`, `apply-review`):

- Legacy `notes.md` on first touch: split on old `##` into the four files,
  promote `###` to `##`, add empty `## Setup, build, test and install notes` if
  missing, then delete `notes.md`.
- Missing file later: create with the H1 below (and Setup H2 on
  `conventions.md`). Empty body is valid.

Repair, then freeze notes during a `verify-plan` / `self-review` pipeline. That
pipeline does not edit notes; `apply-review` / the verify-plan apply step does.

Agent **best-effort drafts** all except `user-notes.md` (repo + this activity;
user reviews and corrects). Bullets wherever possible.

**Pass:** sub-agents **never Read** `requirements.md`, `design-choices.md`, or
`user-notes.md`. Parent pastes excerpts: env/test/explore get only the slices
they need; critics and the verify-plan synthesizer get **full** current ARD +
Design Decisions. **MUST** pass `conventions.md` to env, test, critic, and
verify-plan synthesizer; to explore only if the task needs it.

### `requirements.md` (ARD)

H1: `# Requirement Definition`. Entries: `## <title>`. Parent-only. Keep current
as grilling reveals requirements; user challenges them before `approve-plan`.
Shape: `templates.md`. `kind` is exactly one of:

- `end-user-interface`: humans (UI, CLI output, docs the user reads).
- `software-interface`: contract other software must honor (in-repo
  modules/libraries, API / ABI / FFI / protocol / link). Prefer this name;
  old `external-interface` is the same kind (do not rewrite solely to rename).
- `internal-behavior`: no contract outside this component.

Drop or reword when the user challenges. Material ARD change after approval:
apply **Material-change**.

### `design-choices.md`

H1: `# Design Decisions`. Entries: `## <title>`. Parent-only. Append-only.
Append when a real choice is made. Do not delete or rewrite history. Supersede
with a new entry and `replaces: <old heading title>`. Do not rename a cited
heading. Skip micro-choices recoverable from code. ~200 words hard max
(**Prose density**). Shape: `templates.md`. `level` is exactly one of:

- `design-choice`: UI or software-facing contract (same coverage as ARD
  `end-user-interface` / `software-interface`). Feeds a future design document.
- `major-implementation-detail`: internal, but individually mentioned in that
  document. Test: costly if unknown, or reversal ripples across components.
- `implementation-detail`: internal; summarized (not copied) in that document.

Unsure between adjacent levels → higher; user may downgrade.

### `conventions.md`

H1: `# Conventions`. Target **≤ ~500 words**; rewrite in place. Commands stay
exact — if over budget, trim rules before commands. Shape: `templates.md`.

Two H2 kinds: `## <short title>` binding **rules** (living list, not a decision
log); `## Setup, build, test and install notes` (commands, cwd, toolchain for
**this** activity). Single source; do not duplicate into `activity.md`.

For this activity, **rules** take precedence over project/repo conventions,
style guides, and Cursor rules where they conflict. Workon **Stops**, safety,
and git safety still win. Where rules are silent, repo rules apply. Setup is
the env-agent bootstrap. Do not duplicate rules into Setup. Do not put commands
only in rules, or constraints only in Setup.

Each rule: 2–5 bullets. `replaces: <old title>` only when splitting or renaming.
Seed **rules** from observed repo/activity facts. No taste-only rules. User
review confirms. Rewrite in place when the user asks, or when a newly confirmed
rule contradicts or tightens that named entry (keep the title if it still fits).
No tighter than they stated. Drop: mark `superseded` on request — do not delete.

**Setup:** always best-effort draft. User corrects. Env agent **reads** this
section; it does not write this file. Write rules without the keyword during
planning grill, `start-building`, and in-flight confirmed rules.
`follow-convention` is for an explicit add/rewrite of **rules**; on detected
intent, prompt the keyword. No forced conventions interview in Planning.

### `user-notes.md`

H1: `# User Notes`. Aim **≤ ~500 words**. Never prune or overwrite user text.
If over budget, warn once; the user trims. Read for intake; promote
load-bearing bits into ARD, Design Decisions, or Conventions. Agent may append
a short `agent:` line only when asked. Never agent-fill otherwise.

## Portability

Handoff is `activity.md` + `journal.md` + `requirements.md` +
`design-choices.md` + `conventions.md`. `user-notes.md` is extra — handoff
must not depend on it.

- Inline load-bearing facts. No "as discussed".
- Repo-relative paths, commands, commit/PR/ticket IDs. No host paths in Goal /
  Scope / Plan (source path in References is OK for untracked files).
- Milestone evidence must be commands/checks a new session can run
  (**Test evidence**).
- `# Next Steps` names the safest first action.
- Prefer rediscovering fine-grained progress from repo, tests, and evidence.

Resume loads the handoff files — keep them lean. Delete stale prose when
rewriting `activity.md`. Do not load `activities.md` on resume; `rg` one heading
if the Goal changed. Do not load User Notes on resume unless pointed at.

## Test evidence

Planning, building, `self-review`, `verify-plan`, `mark-completed`.

- **Per milestone:** focused tests for that outcome only. List cases neatly
  (happy path, edges, errors that belong here). Do not hang the whole suite
  off every milestone.
- **Last milestone** (or a dedicated final one): one or more **end-to-end**
  tests that confirm the Goal as a whole. `mark-completed` MUST NOT proceed
  without that named, runnable e2e unless the user explicitly drops it (reason
  in `activity.md`). Run the command when the env can; a user nod does not
  replace a missing e2e name. User drop is the only waiver.
- **`software-interface` peers you cannot run live:** emulate. Smallest
  in-repo test double / throwaway fake that implements the concerned
  interface. Reuse the repo's test-double pattern if one exists. Ship it
  with the tests so a fresh agent can run e2e. Not activity `artifacts/`
  only. Not a second product.
- Evidence bullets name the runnable command and the case list (**Prose
  density**). Write tests as each milestone is implemented.

## Prose density

Agent-written: `activity.md`, ARD, Design Decisions, Conventions (rules +
Setup), Current Plan, journal recaps, `self-review.md`, critic/env/test
reports. Not User Notes. Grill questions and confirm gates stay full
sentences. Prefer bullets.

- Bullets and fragments. No essays, filler, hedging, pleasantries.
- Drop articles when the line stays unambiguous. Short synonyms.
- Exact technical terms, paths, commands, status tokens, heading titles.
- No invented abbreviations (`cfg`, `impl`).
- One fact once. Pattern: `[thing] [action] [reason].`
- If dropping a word would scramble order, a constraint, or a confirm, write a
  normal sentence.
- ARD / Design Decision / plan / convention shape: **Notes files** and
  **Test evidence** (no essays).

## Background sub-agents

Read [`subagent-contract.md`](subagent-contract.md) before launching any Task.
Chat parent: always `run_in_background: true`. Never wait on a Task (no
AwaitShell, no agent-status loops). Apply **Parent orchestration** (includes
**Parent reads**) in that contract.

Every worker splits work MECE. MAY launch **depth-1** children with a lean
brief (`run_in_background: false`; children MUST NOT spawn agents). Handoff
is files.

Sub-agents do not grill and do not write activity files (`activity.md`,
`journal.md`, notes files, `activities.md`). `verify-plan` and `self-review`
are turn-staged; Repair first, then no activity-file edits while that pipeline
is in flight. Parent MAY patch `synthesis.md` during the verify-plan question
gate.

Planning: MAY background-explore, then grill and end the turn. Implementation:
parent writes code; background MAY inspect or test.

## Update cadence

Durability, not a live log.

- `activity.md`: scope/design/plan change, milestone reached, blocker, before
  pause / complete / handoff.
- ARD whenever requirements change; must be current before `approve-plan`.
- Design Decisions when an important choice is made.
- Conventions (rules + Setup) when observed, confirmed, or tightened.
- `activities.md` only on **Goal** change.
- `journal.md`: **Journal policy**.
- Always sync before `pause-work`, `mark-completed`, or handoff.
- User Notes exempt (user-owned).

## Apply timing

Do not alias `self-review`, `apply-review`, and `verify-plan`. **draft-check**
is parent-only (read drafted files before user review). It is not the
`self-review` pipeline and launches no critics.

| Pipeline | Apply when |
|---|---|
| `verify-plan` | After **Parent orchestration** question gate. Never in the same turn as the first Read of `synthesis.md`. All / some / none. |
| `apply-review` | Restate remaining `self-review.md` proposals. Ask **only** gaps the report does not settle (one round). If no gaps, apply in this turn. Not product code. |
| `self-review` | Never applies. Report only. |

Planning order: `self-review` → `apply-review` (if they want the report applied)
→ `verify-plan` → `approve-plan`. None of the middle steps is required. After
`Active`: `self-review` / `apply-review` only.

## Command map

Before a reserved keyword, Read that heading in [`commands.md`](commands.md).

| Do | How | Typical result |
|---|---|---|
| New activity | natural language | `Planning`; write the six files; append catalog |
| Cited context | list-ask (**Cited context**) | `artifacts/` only for chosen files |
| `approve-plan` | gated | `Planning` → `Approved` |
| `start-building` | gated | conventions/setup checkpoint; `Approved` → `Active` |
| `pause-work` | gated | → `Paused` + journal recap |
| `resume-work` | gated | unpause, unblock, or Complete stay-on-slug |
| `mark-completed` | gated | → `Complete` + journal + cleanup list |
| `replan-work` | gated | → `Planning` (in flight only) |
| `create-sibling` | gated | new `Planning` sibling |
| `self-review` | gated | report only; status unchanged |
| `apply-review` | gated | apply report; resume if `Paused` / Complete stay-on-slug |
| `query-work` / `no-query-work` | gated | session flag |
| `import-activity` | gated | adopt files; `Planning` (`Complete` kept) |
| `compact-journal` | gated | journal rewritten in place |
| `follow-convention` | gated | convention rules added or rewritten |
| `verify-plan` | gated | negative+positive → synthesis → questions → confirm |

## Planning quality bar

Applies to create, `create-sibling`, `replan-work`.

Use [`grill-me`](../grill-me/SKILL.md): one question at a time, recommend an
answer, explore the repo instead of asking. Do not skip grilling to draft files.

**Order (mandatory):**

1. **Project-fit** against `.dev-notes/definition.md`. Do not proceed until it fits.
2. **Intake:** free-text scope (objective, in/out, constraints, done).
3. Grill remaining branches: goal, success, scope, constraints, assumptions,
   risks, interfaces, non-goals. Classify each requirement and write ARD as it
   becomes clear. Record Design Decisions as they are made. Best-effort
   Conventions (rules + Setup) from repo/activity facts; user corrects. Do
   not force a conventions interview.
4. If they cited files, run **Cited context**.
5. Draft Goal (ARD summary) / Design / Plan / MECE milestones / evidence /
   Next Steps / References. Each milestone lists focused test cases; the last
   names e2e (and any interface fake). **draft-check** before user review.

Required project-fit prompt (or equivalent):

> Before scope: how does this activity fit the larger project? State the
> problem and lay it out against the project scope in `.dev-notes/definition.md`.

Required intake prompt (or equivalent):

> In free text, define this activity's scope: objective, in-scope work,
> out-of-scope boundaries, constraints, and what "done" looks like.

If the current message already supplied both, acknowledge and continue grilling.

## Create sequence

1. Remind strong model.
2. **Planning quality bar.**
3. Draft + **draft-check** of `activity.md` (`# Scope` after the grill;
   `# Goal` from ARD).
4. Write `activity.md`, `journal.md` (`# Journal` only), `requirements.md`,
   `design-choices.md`, `conventions.md` (include Setup H2), `user-notes.md`
   (`# User Notes` only unless they already wrote notes). Append one
   **Catalog** entry (create catalog lazily).
5. File review: user can challenge ARD, Conventions, Setup, and plan before
   `approve-plan`.
6. Revision loop. Then **Execution gate**.

## Cited context

When the user points at files as initial context or definition updates (create,
derive, `replan-work`, ARD changes — not every source file touched while building):

1. Use every cited file **this session**, saved or not.
2. Ask **once** with a list. For each: tracked or not, hint whole copy vs excerpt.
   Do not copy until they choose. Subset OK.
3. **Whole copy:** `artifacts/<basename>` at the artifacts **root** (create dir
   if needed). Do not place copies under `verify-plan/`, `bg/`, or
   `self-review/`. Do not use the reserved name `self-review.md` for a
   copy. Name clash: ask. No secrets. Huge trees: excerpt or skip.
4. **Excerpt:** new `artifacts/<stem>-excerpt.md` (header: source + what was kept).
   Binary: markdown of what mattered, or whole copy if they asked for the file.
5. Every cited file gets a `# References` bullet (`copied` / `excerpt` /
   `context-only` + 1–3 sentences learned). On `replan-work`, refresh if the
   same files return.

## Engineering while focused

First: if `query-work`, stop.

- Checkpoints only (**Update cadence**).
- Honor `conventions.md` rules while building (they override repo conventions;
  **Notes files**). Use Setup commands for build/test.
- Planning vocabulary stays out of shipped work: no `DC1`/`DC2`-style labels,
  milestone IDs, or the activity slug in implementation code, comments, or
  identifiers. Such labels are meaningless outside the activity files.
- **Comments:** cover new behavior; do not narrate mechanics. When unsure a
  comment is needed, keep it.
  - New file: short module header (what this file is for).
  - New public/exported function: one-line contract/why, not a signature echo.
  - Private helper: skip if the name is the explanation; keep if a reader
    would miss a trap or invariant.
  - Bugfix: comment when the wrong code looks reasonable.
  - Test: scenario intent if the test name is not enough.
  - Match the file's comment dialect.
- New definition files → **Cited context** (ask before copy).
- Missing invariant that would mislead a fresh reader → update `activity.md`.
  New requirement or important choice → ARD / Design Decisions. New confirmed
  convention → Conventions. Material new requirements → **Material-change**.
- In-flight material change: require `replan-work` or `create-sibling` before
  state changes. Engineer only after reviewed planning + **Execution gate**.
- Suggest `create-sibling` when work is independently durable.
- Apply **Test evidence** while building.
