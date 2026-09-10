---
name: workon
description: >-
  Manage durable activities under .dev-notes/activities/ (activity.md,
  journal.md, notes.md, activities.md, optional artifacts/). Use when the user
  manages activities, imports an activity, or issues workon keywords:
  approve-plan, start-building, pause-work, resume-work, mark-completed,
  replan-work, create-sibling, compact-journal, self-review, query-work,
  no-query-work, import-activity, follow-convention, verify-plan.
disable-model-invocation: true
---

# workon

Activity manager. Records must stay resumable months later.

## Hard constraints

- One focused activity per chat (memory only; no `.focus` file).
- Never silently edit a non-focused activity.
- New chat without a named activity: list activities and ask.
- Honor only reserved lifecycle keywords (exact spelling).
- No dates in `activity.md` / `journal.md` unless the user asks.
- `activity.md` is current execution truth (rewrite stale sections).
  Apply the rules in **Journal policy** for `journal.md`.
- `notes.md` headings (exact order): `## Requirement Definition` (**ARD** —
  activity definition; current before `approve-plan`), `## Design Decisions`,
  `## Conventions` (binding, living), `## User Notes` (user-owned; do not
  overwrite).
- No engineering until `approve-plan` then `start-building`.
- **Portable:** `activity.md` + `journal.md` + `notes.md` (ARD + Design
  Decisions + Conventions) must let a fresh agent continue with no chat
  memory, absolute host paths, tool state, or local-only assumptions.
- Agent-written activity prose: apply **Prose density**.
- Milestone tests and completion e2e: apply **Test evidence**.
- Sub-agents: apply **Background sub-agents**. Never block on a Task.
- **No micro-edits:** update at checkpoints (see Update cadence).
- Do **not** bulk-read `activities.md`; `rg '^## <slug>:'`. Update that catalog
  by appending on create / derive / import and by editing only when the
  activity **Goal** changes.

## Gating policy

Natural language is fine for discussion, create, switch, list, details.
Gated transitions need the exact keyword. On detected intent, do not silent-transition;
prompt the keyword, e.g. `If you want to replan, write \`replan-work\`.`

**Material-change (gated):**

- In flight (`Planning` / `Approved` / `Active` / `Paused` / `Blocked`):
  `replan-work` (same slug) or `create-sibling`.
- After `Complete`: stay on this slug (minor) or `create-sibling` (major).
  Do not `replan-work` a completed activity.

On a material change, prompt the matching choice; do not rewrite scope first.

## Model reminders

- Create, derive, `replan-work`: remind to use a **strong** model.
- At `approve-plan`: one-time note that planning is done; user may drop the
  strong model for execution. No execution-tier recommendation.
- Remind once per phase change.

## Storage

```text
.dev-notes/activities/
    activities.md
    <slug>/
        activity.md
        journal.md
        notes.md
        artifacts/          # optional; copies flat; verify-plan/ and bg/ reserved
```

Shapes: [`templates.md`](templates.md).

- Slug: kebab-case, top-level only. Ambiguous slug: list matches and ask.
- Siblings live side by side at top level.
- Commit `.dev-notes/activities/` (useful `artifacts/` copies too). Never
  `git add` or commit `artifacts/verify-plan/` or `artifacts/bg/`. Huge
  generated trees stay out of the repo.

## File roles

| File | Role |
|---|---|
| `activity.md` | Current execution truth. Rewrite stale sections. |
| `journal.md` | Skim log of pause / resume / `mark-completed`. Apply **Journal policy**. |
| `notes.md` | ARD, Design Decisions (append-only), Conventions (living), User Notes. |
| `activities.md` | High-level catalog; not a substitute for `activity.md`. |
| `artifacts/` | Cited-context copies (flat). `verify-plan/` and `bg/` are ephemeral. |

## Journal policy

File: `.dev-notes/activities/<slug>/journal.md` only.

**Write only** on `pause-work`, `resume-work`, and `mark-completed`. Append at
end. Prior entries are **read-only** except `compact-journal`.

Do **not** write on `approve-plan`, `start-building`, `self-review`, import,
create, `create-sibling`, `follow-convention`, or `verify-plan` (new sibling
starts with `# Journal` only).

**Pause / resume recap** — hard cap **~8–12 lines**, this shape (omit empty fields):

```markdown
## Pause (Active → Paused)

- why: <one line>
- done: <1–3 bullets>
- next: <single start step>
- watch: <one blocker or risk>
```

Resume headings use `Resume (<from> → <to>)`. No dates unless asked. No
milestone tables, ARD dumps, or plan copies.

**`mark-completed`:** thicker **project-work** write-up (what shipped, paths,
decisions, gaps). The heading carries the completion tick
(`## <work title> (<from> → Complete)`); no separate tick line. Not lifecycle
novels.

**`resume-work` after `Complete`:** understand the issue first (see Resume).
Journal the resume recap only if this slug reopens. Creating a sibling writes
nothing on the parent journal.

**`compact-journal`:** the only rewrite. See that command.

Until the first journal write, the file is `# Journal` only.

## Reserved keywords

| Keyword | Action |
|---|---|
| `approve-plan` | Lock planning; no engineering yet. |
| `start-building` | Begin implementation from `Approved`. |
| `pause-work` | Pause protocol (allowed in Planning). |
| `resume-work` | Unpause / unblock, or reopen `Complete` (see Resume). |
| `mark-completed` | Completion handoff + journal + cleanup confirm. |
| `replan-work` | In-flight major scope change (same slug). |
| `create-sibling` | New top-level sibling (`Planning`). |
| `self-review` | Reconcile plan vs repo; no status change. |
| `query-work` / `no-query-work` | Session read-only guard (not a status). |
| `import-activity` | Adopt files; this host starts in `Planning` (imported `Complete` stays `Complete`). |
| `compact-journal` | Rewrite journal to ~12 headings (confirm first). |
| `follow-convention` | Add or rewrite `## Conventions` from user-stated rules. |
| `verify-plan` | Optional two-critic plan review (`Planning` only). |

## Command map

| Do | How | Typical result |
|---|---|---|
| New activity | natural language | `Planning`; write the three files; append catalog |
| Cited context | list-ask (Context files) | `artifacts/` only for chosen files |
| `approve-plan` | gated | `Planning` → `Approved` |
| `start-building` | gated | conventions checkpoint; `Approved` → `Active` |
| `pause-work` | gated | → `Paused` + journal recap |
| `resume-work` | gated | unpause or Complete-reopen; journal after understand |
| `mark-completed` | gated | → `Complete` + journal + cleanup list |
| `replan-work` | gated | → `Planning` (in flight only) |
| `create-sibling` | gated | new `Planning` sibling |
| `self-review` | gated | files updated, status unchanged |
| `query-work` / `no-query-work` | gated | session flag |
| `import-activity` | gated | adopt files; `Planning` (`Complete` kept) |
| `compact-journal` | gated | journal rewritten in place |
| `follow-convention` | gated | Conventions added or rewritten |
| `verify-plan` | gated | critics → synthesis → confirm edits |

Do not alias `self-review` and `verify-plan`:
- `self-review`: any status; parent syncs records to the repo (evidence, live tree). Apply drift fixes. Material scope → stop (`replan-work` / `create-sibling`).
- `verify-plan`: `Planning` only; isolated critics attack the written plan (contradictions, missing evidence, over/under-scope, resume holes). No extra repo walk. Confirm before apply.
- Planning order: `self-review` → `verify-plan` → `approve-plan`. After `Active`: `self-review` only.

Preferred lifecycle: `Planning → Approved → Active → Complete`, with optional
`Paused` / `Blocked`. Never `Complete` → `Active`.

## `activity.md`

Title + metadata table in the first ~10 lines. Template: [`templates.md`](templates.md).

Status tokens (exact): `Planning` | `Approved` | `Active` | `Paused` | `Blocked` | `Complete`

Required rows: `status`, `slug`, `branch`, `ticket`, `notes`
(`ticket` may be `none`; `notes` may be empty; `branch` may be `none`).
`branch` is a hint; do not auto-create or check out branches.

Required sections (order): Goal, Scope, Background and Special Notes, Current
Design, Current Plan, Milestones, Next Steps, References.

- **Goal** summarizes ARD. On conflict, ARD wins; refresh Goal / Scope at the
  next checkpoint.
- **Scope:** one or two paragraphs after the first grill; then near-fixed.
  Major in-flight change → `replan-work` and ARD rewrite.
- **Current Design:** execution handoff (invariants, boundaries, evidence
  signals). Chosen-vs-alternatives live only in Design Decisions.
- **Milestones:** MECE outcomes. Apply **Test evidence**. On reopen, keep
  checked items; append new ones; mark removed work `superseded` — do not delete.
- **References:** one bullet per cited planning file (source path, `copied` /
  `excerpt` / `context-only`, 1–3 sentences learned).

## `activities.md`

`.dev-notes/activities/activities.md`. Create lazily (`# Activities`).
**Append** new entries at the end. Do not rewrite or reorder the whole file
unless asked. Heading: `## <slug>: Short title` plus one high-level paragraph.

On create / derive / import, do not Read the catalog:

```bash
printf '\n## %s: %s\n\n%s\n' "$slug" "$title" "$para" >> .dev-notes/activities/activities.md
```

Goal change (`replan-work` or equivalent): edit **that one** heading via `rg`.
Skip catalog updates for design/plan/status/pause/complete/`self-review`.

```bash
rg -n -A 8 '^## <slug>:' .dev-notes/activities/activities.md
rg '^## ' .dev-notes/activities/activities.md
```

## `notes.md`

Required at birth. Template: [`templates.md`](templates.md).
If missing later, create it and seed ARD from Goal / Scope, plus empty
Design Decisions, Conventions, and User Notes headings.

### Activity Requirement Definition (ARD)

Keep current as grilling reveals requirements; user challenges them before
`approve-plan`. List, not a table:

```markdown
### <title>
- kind: end-user-interface | software-interface | internal-behavior
- <description>
```

`kind` is exactly one of those three:

- `end-user-interface`: humans (UI, CLI output, docs the user reads).
- `software-interface`: contract other software must honor — in-repo
  modules/libraries (headers, package APIs, plugins), plus API / ABI / FFI /
  protocol / link. Prefer this name; `external-interface` on old notes is the
  same kind (do not rewrite solely to rename).
- `internal-behavior`: no contract outside this component.

Drop or reword when the user challenges. Material ARD change after approval
follows **Material-change**.

### Design Decisions

Append when a real choice is made. Do not delete or rewrite history. Supersede
with a new entry and `replaces: <old heading title>`. Do not rename a cited
heading. Skip micro-choices recoverable from code.

Keep each entry under ~200 words as a hard max; prefer a few short bullets
(see **Prose density**). Skip micro-choices recoverable from code.

Every entry carries a `level:` — exactly one of:

- `design-choice`: affects the user interface or a software-facing contract
  (anything an ARD `kind` of `end-user-interface` / `software-interface` would
  cover). These are the entries a future design document is built from.
- `major-implementation-detail`: internal, but gets individual mention in that
  design document (internals section). Test: a fresh maintainer would make a
  costly mistake without knowing it, or reversing it would ripple across
  multiple components.
- `implementation-detail`: internal choice; summarized (not copied) when that
  design document is written.

When unsure between adjacent levels, default to the higher one and let the
user downgrade.

### Conventions

Binding for plan and build. Living list — not a decision log. Single source
in `notes.md`; do not duplicate into `activity.md`. For this activity, these
conventions take precedence over project/repo conventions, style guides, and
Cursor rules where they conflict. Workon hard constraints, safety, and git
safety still win. Where Conventions are silent, repo rules apply.

Missing section (old notes): insert `## Conventions` immediately before
`## User Notes` (create that heading if missing). Empty section is valid.
Do this before any Conventions read or write, including `start-building`,
`follow-convention`, `resume-work`, and `verify-plan`.

Each entry:

```markdown
### <short title>
- <2–5 bullets: the rule>
```

`replaces: <old title>` only when splitting or renaming.

Write **only** what the user stated or confirmed. Do not invent conventions.

**Rewrite in place** when the user asks, or when a newly confirmed rule
contradicts or tightens that named entry (keep the title if it still fits).
No taste-only rephrase. No tighter rule than they stated. Drop: mark
`superseded` on request — do not delete.

Write without the keyword during planning grill, the `start-building`
checkpoint, and in-flight confirmed rules. The `follow-convention` keyword
is for an explicit add/rewrite command; on detected intent for that command,
prompt the keyword (do not silent-run it). No forced conventions interview
in Planning.

### User Notes

Do not overwrite or prune. Read for intake; promote load-bearing bits into ARD,
Design Decisions, or Conventions. Agent may append a short `agent:` line only
when asked.

## Portability

Handoff is `activity.md` + `journal.md` + ARD / Design Decisions /
Conventions. User Notes are extra — handoff must not depend on them.

- Inline load-bearing facts. No "as discussed".
- Repo-relative paths, commands, commit/PR/ticket IDs. No host paths in Goal /
  Scope / Plan (source path in References is OK for untracked files).
- Milestone evidence must be commands/checks a new session can run. Apply
  **Test evidence**.
- `# Next Steps` names the safest first action.
- Prefer rediscovering fine-grained progress from repo, tests, and evidence.

## Test evidence

Planning, building, `self-review`, `verify-plan`, `mark-completed`.

- **Per milestone:** focused tests for that outcome only. List cases neatly
  (happy path, edges, errors that belong here). Do not hang the whole suite
  off every milestone.
- **Last milestone** (or a dedicated final one): one or more **end-to-end**
  tests that confirm the Goal as a whole. `mark-completed` MUST NOT proceed
  without that e2e evidence unless the user explicitly drops it (reason in
  `activity.md`).
- **`software-interface` peers you cannot run live:** emulate. Smallest
  in-repo test double / throwaway fake that implements the concerned
  interface. Reuse the repo's test-double pattern if one exists. Ship it
  with the tests so a fresh agent can run e2e. Not activity `artifacts/`
  only. Not a second product.
- Evidence bullets name the runnable command and the case list (**Prose
  density**). Write tests as each milestone is implemented.

## Prose density

Agent-written: `activity.md`, ARD, Design Decisions, Conventions, Current
Plan, journal recaps. Not User Notes. Grill questions and confirm gates stay
full sentences.

- Bullets and fragments. No essays, filler, hedging, pleasantries.
- Drop articles when the line stays unambiguous. Short synonyms.
- Exact technical terms, paths, commands, status tokens, heading titles.
- No invented abbreviations (`cfg`, `impl`).
- One fact once. Pattern: `[thing] [action] [reason].`
- If dropping a word would scramble order, a constraint, or a confirm, write a
  normal sentence.
- ARD: title + `kind` + 1–3 short bullets.
- Design Decision: required fields + short bullets (~200 words hard max).
- Plan / milestones: numbered outcomes, focused test cases, and checks — not
  paragraphs.
- Conventions: 2–5 short bullets per named rule.

## Background sub-agents

Always `run_in_background: true`. Never wait on a Task. Status = output-file
metadata or header `rg` (see contract); never Read the body, never the agent.
Read [`subagent-contract.md`](subagent-contract.md) before launching any Task.

Planning: MAY background-explore, then grill and end the turn. Implementation:
parent writes code; background MAY inspect or test. Sub-agents do not grill
and do not write activity files. `verify-plan` is turn-staged; no activity-file
edits while that pipeline is in flight.

## Update cadence

Durability, not a live log.

- `activity.md`: scope/design/plan change, milestone reached, blocker, before
  pause / complete / handoff.
- ARD whenever requirements change; must be current before `approve-plan`.
- Design Decisions when an important choice is made.
- Conventions when the user states, confirms, or tightens a rule.
- `activities.md` only on **Goal** change.
- `journal.md`: apply **Journal policy**.
- Always sync before `pause-work`, `mark-completed`, or handoff.
- User Notes exempt (user-owned).

## List / details

- **List:** default `Approved` / `Active` / `Paused` / `Blocked` (exclude
  `Complete` unless asked). Table from first ~10 lines of each `activity.md`.
  Prefer `rg` on `activity.md` files; catalog search via `rg` on `activities.md`.
- **Details** (no resume): full path + first ~20 lines of `activity.md`, stop.

## Planning quality bar

Applies to create, `create-sibling`, `replan-work`.

Use [`grill-me`](../grill-me/SKILL.md): one question at a time, recommend an
answer, explore the repo instead of asking. Do not skip grilling to draft files.

**Order (mandatory):**

1. **Project-fit** against `.dev-notes/definition.md`. Do not proceed until it fits.
2. **Intake:** free-text scope (objective, in/out, constraints, done).
3. Grill remaining branches: goal, success, scope, constraints, assumptions,
   risks, interfaces, non-goals. Classify each requirement and write ARD as it
   becomes clear. Record Design Decisions as they are made. If the user states
   conventions, record them under Conventions (do not force a conventions
   interview here).
4. If they cited files, run Context files.
5. Draft Goal (ARD summary) / Design / Plan / MECE milestones / evidence /
   Next Steps / References. Each milestone lists focused test cases; the last
   names e2e (and any interface fake). Self-review before user review.

Required project-fit prompt (or equivalent):

> Before scope: how does this activity fit the larger project? State the
> problem and lay it out against the project scope in `.dev-notes/definition.md`.

Required intake prompt (or equivalent):

> In free text, define this activity's scope: objective, in-scope work,
> out-of-scope boundaries, constraints, and what "done" looks like.

If the current message already supplied both, acknowledge and continue grilling.

## Create sequence

1. Remind strong model.
2. Planning quality bar.
3. Draft + self-review `activity.md` (`# Scope` after the grill; `# Goal` from ARD).
4. Write `activity.md`, `journal.md` (`# Journal` only), `notes.md`. Append one
   `activities.md` entry (create catalog lazily).
5. File review: user can challenge ARD, Conventions, and plan before
   `approve-plan`.
6. Revision loop. Then Execution gate (`approve-plan`, `start-building`).

## Context files → `artifacts/`

When the user points at files as initial context or definition updates (create,
derive, `replan-work`, ARD changes — not every source file touched while building):

1. Use every cited file **this session**, saved or not.
2. Ask **once** with a list. For each: tracked or not, hint whole copy vs excerpt.
   Do not copy until they choose. Subset OK.
3. **Whole copy:** `artifacts/<basename>` at the artifacts **root** (create dir
   if needed). Do not place copies under `verify-plan/` or `bg/`. Name clash:
   ask. No secrets. Huge trees: excerpt or skip.
4. **Excerpt:** new `artifacts/<stem>-excerpt.md` (header: source + what was kept).
   Binary: markdown of what mattered, or whole copy if they asked for the file.
5. Every cited file gets a `# References` bullet (`copied` / `excerpt` /
   `context-only` + 1–3 sentences learned). On `replan-work`, refresh if the
   same files return.

## `replan-work`

In-flight major scope change only (not after `Complete`).

1. Remind strong model.
2. Re-run Planning quality bar from the top. Context files if cited.
3. Rewrite ARD, `# Scope`, and affected `activity.md` sections. Append Design
   Decisions; do not delete old ones. Update Conventions only from user-stated
   or confirmed rules (rewrite in place if they tighten). If **Goal** changed,
   patch that one catalog entry via `rg`.
4. If status is not `Planning`, reopen to `Planning` and record the reason in
   `activity.md` (journal recap only if they also `pause-work` / `resume-work` /
   `mark-completed` — this command does not journal).
5. File review + Execution gate before engineering.

## `self-review`

Fix drift inside existing scope. Any status; no status change. Material scope
found → stop and apply **Material-change**. No journal write.

1. Read `activity.md`, ARD + Design Decisions + Conventions; User Notes if
   useful. Open `journal.md` only if it has entries past `# Journal`. Insert
   `## Conventions` before `## User Notes` if missing.
2. Verify progress with milestone evidence / repo inspection. Apply **Test
   evidence**. Do not trust prose.
3. Grill only where findings are ambiguous.
4. Refresh Design / Plan / Milestones / Next Steps; sync Goal / Scope from ARD.
   Promote load-bearing User Notes; do not prune ARD, decisions, conventions,
   or user text.

Do not alias with `verify-plan` (contrast under **Command map**).

## `query-work` / `no-query-work`

Session read-only until `no-query-work` or session end. Status unchanged.
If asked to change anything (including `follow-convention` / `verify-plan`),
say query mode is on and ask for `no-query-work`.

## `create-sibling`

Derived `activity.md` + ARD / Design Decisions / Conventions must stand alone
(no "see parent"). `derived-from: <slug>` in `# References` is non-load-bearing
only.

Slug: `{parent-slug}-{short-suffix}` kebab-case. Propose; user may override.

1. Remind strong model.
2. Read source `activity.md` and ARD / Design Decisions / Conventions once.
   Open its journal only if it has entries past `# Journal`.
3. Planning quality bar for the **new** scope (fresh intake; do not inherit fuzz).
4. Rewrite all required sections and a fresh ARD. Copy still-applicable
   decisions **and conventions** inline, not as pointers. User may drop or
   rewrite conventions on the sibling.
5. Fresh `journal.md` (`# Journal` only). `status: Planning`, new slug.
   Provenance: `derived-from: <parent-slug>` only. **Never** add a sibling pointer
   on the parent. Append one catalog entry.
6. Self-review: derived files stand if the source were deleted.
7. File review + revision loop.

If the source is `Complete`, it stays `Complete`. No parent journal write.

## `import-activity`

New session; user brings `activity.md` + `journal.md` (`notes.md` if present).
No prior chat context. Do not journal the import.

1. Locate files; ask if path/slug is ambiguous. Do not assume this repo's tree.
2. Read `activity.md` fully, ARD / Design Decisions / Conventions if present,
   journal only if it has entries. Treat imported `status` as not executable here.
3. Verify progress against this repo (evidence commands). Note drift.
4. Orientation: ARD, Scope, design, conventions, claimed vs verified, remaining
   work, safest next action from `# Next Steps`.
5. Place under `.dev-notes/activities/<slug>/` if needed. Reconcile drift into
   `activity.md` / ARD / Conventions. Set `status` to `Planning` — unless the
   imported status is `Complete`, which stays `Complete`. Seed `notes.md` if
   missing (all four headings). If `notes.md` exists without `## Conventions`,
   insert it before `## User Notes`. Append catalog entry if no heading.
6. Wait for Execution gate. If import is `Complete` and they want new work,
   apply Resume (`Complete`) before engineering.

## Resume (`resume-work`)

`pause-work` on `Complete` is a no-op: already completed; use `resume-work`.

### Not `Complete`

1. Read `activity.md` and ARD / Design Decisions / Conventions. Open journal
   only if it has entries. User Notes only if needed.
2. Concise summary: objective, design, conventions, status, discoveries,
   remaining work, next action, branch hint.
3. Wait for explicit confirmation before engineering.
4. Then append the resume recap (Journal policy).
5. Reminders: `Planning` / replan → strong model; `Approved` → ask
   `start-building`; `Blocked` → restate the blocker and confirm it is
   resolved before clearing back to the prior status.

### `Complete`

Parent stays `Complete` until the choice is clear. **Do not journal yet.**

1. Same reads as above.
2. Free-text issue, then grill (outcome, why now, in/out, paths, risk, evidence).
3. Classify: minor stay-on-slug vs major `create-sibling`. Parent stays
   `Complete` until they choose. Do not silent-transition.
4. **Sibling:** prompt `create-sibling`. After they write it, follow that
   command. Parent remains `Complete`. No parent journal tick. Sibling refers
   to parent; parent never refers to sibling. Stop (do not reopen this slug).
5. **Stay:** after they confirm this slug, reopen `Complete` → `Planning`.
   Preserve shipped design and checked milestones. `# Current Plan` /
   `# Next Steps` become: high-level **legacy verify** (re-run/spot-check old
   evidence; do not redo those milestones), then **delta steps** starting at
   the new requirement (including steps that undo earlier work). Mark undone
   milestones `superseded`. Update ARD and Design Decisions (`replaces:` if a
   choice flips). Tighten Conventions only if the user states a new or changed
   rule.
6. **Then** append the resume recap (`Complete` → `Planning`; `next:` = start
   step of the delta).
7. File review + Execution gate. Never `Complete` → `Active`.

## Engineering while focused

- Checkpoints only (Update cadence).
- Honor `## Conventions` while building (they override repo conventions;
  see **Conventions**).
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
- New definition files → Context files (ask before copy).
- Missing invariant that would mislead a fresh reader → update `activity.md`.
  New requirement or important choice → ARD / Design Decisions. New confirmed
  convention → Conventions. Material new requirements → **Material-change**.
- In-flight material change: require `replan-work` or `create-sibling` before
  state changes. Engineer only after reviewed planning + Execution gate.
- Suggest `create-sibling` when work is independently durable.
- Apply **Test evidence** while building (focused tests per milestone; e2e
  before `mark-completed`; interface fakes in the test tree).

## `start-building`

1. Need `Approved`. If `Planning`, require `approve-plan` first.
2. **Conventions checkpoint — before any engineering:**
   If `notes.md` or `## Conventions` is missing, apply that insert (create
   file / insert heading), then run the empty-vs-populated checkpoint.
   - Empty `## Conventions`: ask whether this activity has conventions to
     follow. Wait. Record confirmed rules (or leave empty if they state none).
   - Already populated: confirm those will be followed; ask if any must be
     added. Record additions / in-place tightens, then proceed.
   If this message already answered that, acknowledge and continue.
3. Set `status` to `Active`. Begin engineering only after this command and
   the checkpoint.

## `approve-plan`

1. Planning outputs written and reviewed; ARD current and challengeable. Empty,
   stale, or unreviewed ARD → back to file review; do not approve. Last
   milestone must name e2e (and any interface fake) per **Test evidence**;
   missing → back to file review.
2. If this session has not run `verify-plan`, remind once that it is available;
   then honor `approve-plan`. Do not require it.
3. Set `status` to `Approved`.
4. One-time note: planning done; user may drop the strong model.
5. Do not implement; ask for `start-building`.
6. Already `Approved` or `Active`: report state; do not rewrite history.

## `follow-convention`

Gated. Focused activity; not during `query-work`. Any status (on `Complete`,
record only — new work still needs Resume).

1. If `## Conventions` is missing, insert it first (see **Conventions**).
2. User text is the source. Translate into named convention entries (**Prose
   density**). Ambiguous wording → one confirm question before writing.
3. Add new entries, or rewrite in place per **Conventions**.
4. Show what changed. Do not start engineering from this command.

## `verify-plan`

Not `self-review` (contrast under **Command map**). Optional. `Planning`
only. If status is not `Planning`: report current status and stop. Not
required for `approve-plan`. Not during `query-work`. Two isolated critics (identical brief), then a synthesizer that
resolves deadlocks. Parent Reads **only** `synthesis.md`, filters hard
constraints. Show the synthesis proposals (full-sentence confirm). Ask all /
some / none. Apply only after the user answers. Do not apply in the same turn
as the first Read of `synthesis.md`. Critic bodies stay out of the parent.
Paths, rubric, file shapes, turn-stage: apply **Parent orchestration** in
[`subagent-contract.md`](subagent-contract.md).

## `pause-work`

If `Complete`: no-op (see Resume). Otherwise:

1. Sync `activity.md` and ARD / Design Decisions / Conventions if they changed.
2. Set `status` to `Paused`. Resume context in `# Next Steps` (and `notes` if needed).
3. Append pause recap (Journal policy). Present a short pause summary.

## `Blocked` vs `Paused`

- `Paused`: intentional stop via `pause-work`. `resume-work` restores the
  pre-pause status (recorded in the pause recap heading).
- `Blocked`: cannot continue. The agent MAY set it at a checkpoint when work
  is stuck; record a one-line blocker **and the prior status** in `notes`,
  details in `activity.md` / User Notes. No journal write on entering
  `Blocked`. `resume-work` clears it back to that prior status.

## `mark-completed`

1. Milestones complete or explicitly dropped (reason in `activity.md`). Verify
   evidence when possible, or ask the user to confirm. Apply **Test evidence**:
   no `Complete` without named, runnable e2e unless the user drops it.
2. Rewrite `activity.md` as a maintenance handoff:
   - **Current Design:** shipped behavior, touched paths, must-not-break invariants.
   - **Milestones:** checked/dropped with evidence commands or artifact pointers.
   - **Next Steps:** minor-fix runway (small follow-ups, fastest checks, safest
     first edit targets).
3. Set `status` to `Complete`. Keep ARD, Design Decisions, and Conventions.
   Do not prune User Notes.
4. Append the `mark-completed` journal entry (Journal policy).
5. **Cleanup (confirm):** list **untracked / gitignored** leftovers from **this**
   activity (scratch dirs, sample outputs, dumped test artifacts,
   `artifacts/verify-plan/`, `artifacts/bg/`). For each: path + why it looks
   dangling. Uncertain items: list as **uncertain (default keep)**.
   **Never** list `activity.md` / `journal.md` / `notes.md`, `.cursor/`, shipped
   tracked source, real tests, docs, or scripts. Tracked files only if the user
   points at them. User picks a subset (including none). Delete only that subset.
   No `git rm` of tracked files unless they explicitly selected them.
6. Later fixes: `resume-work` (Complete path), then Execution gate, then
   `mark-completed` again.

## `compact-journal`

Gated rewrite of this activity's `journal.md`. Not auto-run from `mark-completed`.
If already within budget, say so and stop.

1. Default budget **~12** `##` headings. User may name another number.
2. Keep the **newest** entries **verbatim** (about half the budget: last ~6
   when targeting ~12). Prefer recent pause/resume/`mark-completed` recaps.
3. Merge **older** entries into a few summary headings a future agent can use:
   shipped outcomes (paths, behavior, decisions, accepted gaps) plus one line
   `paused N, resumed N, completed N`. Drop plan/status prose that `activity.md`
   already holds.
4. Show the proposed compacted file. Write **in place** only after the user nods.
   Git is the archive unless they ask for an `artifacts/` snapshot.

## Token economy

Apply **Prose density**. Resume loads `activity.md`, `journal.md`, ARD, Design
Decisions, and Conventions — keep them lean. Delete stale prose when rewriting
`activity.md`. Do not load `activities.md` on resume; `rg` one heading if the
Goal changed. Do not load User Notes on resume unless pointed at. Do not Read
`verify-plan` critic bodies or `artifacts/bg/` reports for status.

