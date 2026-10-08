---
name: workon
description: >-
  Manage durable activities under .dev-notes/activities/ (activity.md,
  journal.md, requirements.md, design-choices.md, conventions.md,
  notes-by-user.md, reviews.md, user-guide.md, activities.md, optional
  artifacts/). Use when the user manages activities, imports an activity, or
  issues workon keywords: help, approve-plan, conventions-ok, start-building,
  pause-work, resume-work, mark-completed, replan-work, create-sibling,
  import-activity, self-review, apply-review, verify-plan, follow-convention,
  sync-notes, fix-notes, compact-journal, create-guide, delete-tmp-files,
  query-work, no-query-work.
disable-model-invocation: true
---

# workon

Activity manager. Records must stay resumable months later.

Shapes and layout: [`templates.md`](templates.md). Keyword sequences:
[`commands.md`](commands.md). Sub-agents:
[`subagent-contract.md`](subagent-contract.md). Apply a **Named policy** by
heading. Do not restate it.

## Stops

- One focused activity at a time (memory only; no `.focus` file). A switch
  replaces the focus; announce it. Never silently edit a non-focused activity.
  New chat without a named activity: list and ask.
- **Keyword gate.** **Material-change:** prompt; do not rewrite scope first.
- No dates in `activity.md` / `journal.md` unless asked.
- `activity.md` is current execution truth (rewrite stale sections).
  **Journal policy.** **Notes files.**
- **Execution gate.** **Portability.** **Writing style.** **Test evidence.**
- **Background sub-agents.** **Update cadence** (no micro-edits). **Catalog**
  (`rg`, no bulk-read).
- **`query-work`:** session flag until `no-query-work` or session end. Blocks
  every mutation: files, git writes, sub-agent output files, and mutating
  keywords. Allowed: `help`, `no-query-work`, list, details, and reads. On a
  blocked request, say query mode is on and ask for `no-query-work`.
- **Pipeline in flight:** a `verify-plan`, `self-review`, or milestone
  pipeline runs from launch until the parent reads its final file
  (`synthesis.md`, `self-review.md`, `collate.md`). While it runs, activity
  files are frozen and mutating keywords are refused (name the pipeline).
  `help`, `query-work`, and `no-query-work` stay allowed. New chat: a final
  file missing or older than its working files means in flight; ask to wait
  or abandon.

## Keyword gate

Natural language is fine for discussion, create, switch, list, details.
Gated transitions need the exact reserved keyword. On detected intent, do not
silent-transition; prompt it, e.g. `If you want to replan, write \`replan-work\`.`

Exceptions: the agent MAY start the `sync-notes` flow (**Update cadence**);
`mark-completed` runs the `delete-tmp-files` flow. Both confirm each item.

## Material-change

**Material** = Goal or Scope rewrite; ARD add/drop/reword after approval that is
not an in-scope plan refresh; or independently durable new work.

**Not material:** in-scope tightening of plan, design, or conventions on the
same Goal.

On a material change, prompt the matching choice; do not rewrite scope first.

| Status | Keyword |
|---|---|
| In flight (`Planning` / `Approved` / `Active` / `Paused` / `Blocked`) | `replan-work` (same slug) or `create-sibling` |
| `Complete` | stay-on-slug (minor) or `create-sibling` (major). Never `replan-work` |

**Complete stay-on-slug** (never `Complete` → `Active`):

- `resume-work`: grill, then reopen `Complete` → `Planning` (see that command).
- `apply-review`: stay-on-slug **only**. Report is intake; no sibling; no full
  resume grill. Material remaining proposal → apply nothing; ask
  `create-sibling`. For the grill/classify fork, the user runs `resume-work`
  first.

**Complete sibling:** prompt `create-sibling`. Parent stays `Complete`. No parent
journal. Sibling `derived-from:` only; parent never points at the sibling.

## Execution gate

No product engineering until `approve-plan`, `conventions-ok`, then
`start-building`. `conventions-ok` may come before or after `approve-plan`.
It is one-time: once `conventions: ok`, it stays `ok` for the life of the
activity (edits, `replan-work`, and reopens do not reset it). Only
`import-activity` resets it, because the repo may differ. After a
Complete stay-on-slug reopen to `Planning`, `approve-plan` and
`start-building` run again.

## Paused vs Blocked

Both record `prior: <status>` in the `activity.md` `notes` row.
`resume-work` restores that status and clears the entry.

- `Paused`: intentional stop via `pause-work`.
- `Blocked`: cannot continue. The agent MAY set it at a checkpoint when work
  is stuck. Add a one-line blocker to `notes`; details in `activity.md`
  `# Next Steps`. No journal write on entering `Blocked`.

## Reminders

- Create, `create-sibling`, `replan-work`: remind to use a **strong** model.
- At `approve-plan`: one-time note that planning is done; user may drop the
  strong model. No execution-tier recommendation.
- Remind once per phase change.

**Optional-remind** (once, do not require): `verify-plan` at `approve-plan` if
this session has not run it; `apply-review` when `self-review.md` exists
unapplied (`approve-plan`, `start-building`, `pause-work`, `resume-work`);
`create-guide` at `mark-completed` if `user-guide.md` is missing or stale.

## Journal policy

File: `.dev-notes/activities/<slug>/journal.md` only. Shapes: `templates.md`.

**Write only** on `pause-work`, `mark-completed`, and on `resume-work` /
`apply-review` when status actually changes (from `Paused`, `Blocked`, or
`Complete`). Append at end. Prior entries are **read-only** except
`compact-journal` (the only rewrite). No other command writes the journal. A
new activity or sibling starts with `# Journal` only.

Pause / resume recap: cap **~10 lines**; omit empty fields. Headings:
`## Pause (<from> → Paused)` / `## Resume (<from> → <to>)`. No dates unless
asked. No milestone tables, ARD dumps, or plan copies.

**`mark-completed`:** thicker **project-work** write-up (what shipped, paths,
decisions, gaps). Heading carries the tick (`## <work title> (<from> → Complete)`);
no separate tick line. Not a lifecycle novel.

## Layout

Tree and artifact names: `templates.md`. Slugs are kebab-case and top-level
only; siblings sit side by side. Ambiguous slug: list matches and ask.

Commit `.dev-notes/activities/`, including useful `artifacts/` copies and
reserved `verify-plan/`, `self-review/`, `bg/` records. Agent does not
`git add` / commit unless asked. Huge generated trees stay out of the repo.

Status tokens (exact): `Planning` | `Approved` | `Active` | `Paused` | `Blocked` | `Complete`

Preferred lifecycle: `Planning → Approved → Active → Complete`, with optional
`Paused` / `Blocked`. Never `Complete` → `Active`.

## `activity.md`

Title + metadata table in the first ~10 lines. Template: `templates.md`.

Required rows: `status`, `conventions`, `slug`, `branch`, `ticket`, `notes`
(`ticket` may be `none`; `notes` may be empty; `branch` may be `none`).
`branch` is a hint; do not auto-create or check out branches.
`conventions` is `pending` or `ok` (**Execution gate**).

Required sections (order): Goal, Scope, Background and Special Notes, Current
Design, Current Plan, Milestones, Next Steps, References.

- **Goal** summarizes ARD. On conflict, ARD wins; refresh Goal / Scope at the
  next checkpoint.
- **Scope:** one or two paragraphs after the first grill; then near-fixed.
  Major in-flight change → **Material-change**.
- **Current Design:** execution handoff (invariants, boundaries, evidence
  signals). Chosen-vs-alternatives live only in Design Decisions.
- **Milestones:** MECE outcomes. Apply **Test evidence**. On reopen, keep
  checked items; append new ones; mark removed work `superseded` — do not
  delete (except `fix-notes`). Review milestones: **Reviews**.
- **References:** one `REF<n>` bullet per cited planning file (**Cited
  context**).

## IDs

Activity entries carry stable IDs. Cross-references use the ID, not the title.

| ID | Entry | Home |
|---|---|---|
| `R<n>` | requirement | `requirements.md` `## R<n>: <title>` |
| `DC<nn>` | design decision (two digits) | `design-choices.md` `## DC<nn>: <title>` |
| `CONV<n>` | convention rule (Setup H2 has no ID) | `conventions.md` `## CONV<n>: <title>` |
| `REF<n>` | reference | `activity.md` `# References` bullet |
| `UR<n>`, `UR<n>.<m>` | user review cycle, point | `reviews.md` |
| `SR<n>`, `SR<n>.<m>` | `apply-review` / `verify-plan` apply cycle, point | `reviews.md` |

- Assign the next free number. Do not reuse a retired (superseded or removed)
  ID, except via `fix-notes` renumbering.
- `replaces:` names the old ID.
- IDs stay out of shipped work and `user-guide.md` (**Engineering while
  focused**).

## Reviews

`<slug>/reviews.md`, H1 `# Reviews`. Create lazily. Agent-written record.
Shape: `templates.md`. Not part of the handoff.

- **User review:** each round of user feedback on activity files or built
  work is one `UR<n>` cycle. Each point is `UR<n>.<m>` with its outcome.
  Open the cycle with a **state** note: status, milestone, and what changed
  since `UR<n-1>` (IDs added or changed, work built). One or two short
  paragraphs; deltas only. Earlier cycles hold the rest.
- **Self-review:** each `apply-review` or `verify-plan` apply step is one
  `SR<n>` cycle. Each proposal is `SR<n>.<m>` with its outcome.
- Outcome: `applied → <IDs>` | `rejected: <why>` | `open`.
- **Review milestone:** if a cycle needs product work (code, tests, docs),
  append milestone `Apply UR<n>` (or `SR<n>`) to `activity.md`. Its MECE
  steps cite the points. Notes-only edits need no milestone.
- **Renumber log:** `fix-notes` appends `## Renumber <k>` with the
  old → new ID map. Journal entries before it use the old numbers.

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
edit **that one** heading via `rg`. Skip catalog updates for any other change.

```bash
rg -n -A 8 '^## <slug>:' .dev-notes/activities/activities.md
rg '^## ' .dev-notes/activities/activities.md
```

**List:** default all statuses except `Complete` (show `Complete` only when
asked). Table from first ~10 lines of each `activity.md` (`rg`). Shape:
`templates.md`.

**Details** (no resume): full path + first ~20 lines of `activity.md`, stop.

## Notes files

`requirements.md`, `design-choices.md`, `conventions.md`, `notes-by-user.md`.
Required at birth. Templates: `templates.md`.

**Repair** (before the first activity-file read or write in a session):

- Legacy `notes.md`: map each old `##` to the file whose H1 matches
  (Requirement Definition, Design Decisions, Conventions); the rest goes to
  `notes-by-user.md`. Promote `###` to `##`. Add an empty
  `## Setup, build, test and install notes` if missing. Delete `notes.md`.
- Legacy `user-notes.md`: rename to `notes-by-user.md` (`git mv` if tracked);
  change H1 `# User Notes` to `# Notes by User`. Keep the body.
- Entries or References bullets without **IDs**: number them in file order;
  rewrite title-based `replaces:` to IDs.
- Missing `conventions` row: `ok` if status is `Active`, `Paused`, `Blocked`,
  or `Complete`; else `pending`.
- Missing file: create with its H1 (and Setup H2 on `conventions.md`). Empty
  body is valid.

Agent **best-effort drafts** all except `notes-by-user.md` (repo + this
activity; user reviews and corrects). Bullets wherever possible. What
sub-agents may read or receive: contract **Shared bans** and **Pass
`conventions.md`**.

### `requirements.md` (ARD)

H1: `# Requirement Definition`. Entries: `## R<n>: <title>`. Parent-only. Keep
current as grilling reveals requirements; user challenges them before
`approve-plan`. `kind` is exactly one of:

- `end-user-interface`: humans (UI, CLI output, docs the user reads).
- `software-interface`: contract other software must honor (in-repo
  modules/libraries, API / ABI / FFI / protocol / link). Prefer this name;
  old `external-interface` is the same kind (do not rewrite solely to rename).
- `internal-behavior`: no contract outside this component.

Drop or reword when the user challenges. Material ARD change after approval:
apply **Material-change**.

### `design-choices.md`

H1: `# Design Decisions`. Entries: `## DC<nn>: <title>`. Parent-only.
Append-only (except `fix-notes`). Append when a real choice is made. Do not
delete or rewrite history. Supersede with a new entry and `replaces: DC<nn>`.
Skip micro-choices recoverable from code. ~200 words hard max. `level` is
exactly one of:

- `design-choice`: UI or software-facing contract (same coverage as ARD
  `end-user-interface` / `software-interface`). Feeds a future design document.
- `major-implementation-detail`: internal, but individually mentioned in that
  document. Test: costly if unknown, or reversal ripples across components.
- `implementation-detail`: internal; summarized (not copied) in that document.

Unsure between adjacent levels → higher; user may downgrade.

### `conventions.md`

H1: `# Conventions`. Target **≤ ~500 words**; rewrite in place. Commands stay
exact — if over budget, trim rules before commands.

Two H2 kinds: `## CONV<n>: <short title>` binding **rules** (living list, not a
decision log); `## Setup, build, test and install notes` (commands, cwd,
toolchain for **this** activity). Single source; do not duplicate into
`activity.md`. Do not duplicate rules into Setup. Do not put commands only in
rules, or constraints only in Setup.

For this activity, **rules** take precedence over project/repo conventions,
style guides, and Cursor rules where they conflict. Workon **Stops**, safety,
and git safety still win. Where rules are silent, repo rules apply.

**Rules:** 2–5 bullets each. `replaces: CONV<n>` only when splitting or
renaming. Seed from observed repo/activity facts. No taste-only rules. Write
without a keyword during the planning grill, `conventions-ok`, and for
in-flight confirmed rules. Rewrite in place when the user asks, or when a
newly confirmed rule contradicts or tightens an entry. No tighter than the
user stated. Drop: mark `superseded` on request — do not delete (except
`fix-notes`). Explicit user add/rewrite → `follow-convention`; on detected
intent, prompt it. No forced conventions interview in Planning.

**Setup:** always best-effort draft; user corrects. It is the env-agent
bootstrap; the env agent reads it and never writes it.

**Isolated setup:** for quick tests and activity env setup, do not install
into or change the system unless the user asks. Use path-redirect sandboxes
(e.g. `bwrap` bind mounts on Linux), local prefixes, virtual envs, or
`PATH`-style overrides. They test a package or library without disturbing the
system. Record the method in Setup.

User sign-off of rules + Setup is `conventions-ok` (**Execution gate**).

### `notes-by-user.md`

H1: `# Notes by User`. User-owned. Aim **≤ ~500 words**; if over budget, warn
once; the user trims. Read for intake; promote load-bearing bits into ARD,
Design Decisions, or Conventions. The agent never edits it, except a short
`agent:` line when asked.

## User guide

`<slug>/user-guide.md`. Written only by `create-guide`; rewrite in place on
re-run. Audience: a human user, not an agent. Explains what the activity
delivered and how to use it, test it, and explain it to others. Uses
**Writing style** prose. No **IDs**. Shape: `templates.md`.

## Portability

Handoff is `activity.md` + `journal.md` + `requirements.md` +
`design-choices.md` + `conventions.md`. `notes-by-user.md`, `reviews.md`, and
`user-guide.md` are extra — handoff must not depend on them.

- Inline load-bearing facts. No "as discussed".
- Repo-relative paths, commands, commit/PR/ticket IDs. No host paths in Goal /
  Scope / Plan (source path in References is OK for untracked files).
- Milestone evidence must be commands/checks a new session can run
  (**Test evidence**).
- `# Next Steps` names the safest first action.
- Prefer rediscovering fine-grained progress from repo, tests, and evidence.

Resume loads the handoff files — keep them lean. Delete stale prose when
rewriting `activity.md`. Do not load `activities.md` on resume. Do not load
`notes-by-user.md` unless the user points at it.

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
- Evidence bullets name the runnable command and the case list. Write tests
  as each milestone is implemented.

## Writing style

Follow ASD-STE100 about 70% of the way: readable, not mechanical. Be terse.
Spend few tokens. Applies to all agent text: replies, code comments,
`user-guide.md`, user docs the activity writes, these skill files, activity
records, and sub-agent reports. Not `notes-by-user.md`.

**All text:**

- One term, one meaning. Use the same term every time. Prefer
  `.dev-notes/vocabulary.md` terms.
- Simple, common verbs. Active voice. Present tense.
- Exact technical terms, paths, commands, status tokens, heading titles.
- No invented abbreviations (`cfg`, `impl`). No filler, hedging, or
  pleasantries.
- No pronoun without a clear referent.
- State a fact once, in its home section; elsewhere, refer to it. Repeat only
  when the repeat makes the text clearer.
- Do not apply the strict STE approved-word dictionary.

**Records** (activity files, journal recaps, `reviews.md`, `self-review.md`,
sub-agent reports): bullets and fragments. Drop articles if the line stays
unambiguous. Pattern: `[thing] [action] [reason].` Shapes: `templates.md`.

**Prose** (replies, code comments, `user-guide.md`, user docs, skill
instructions, grill questions, confirm gates): full sentences with articles.
One instruction per sentence, in the imperative. Instructions ≤ 20 words;
descriptions ≤ 25 words. If a record fragment would scramble order, a
constraint, or a confirm, use prose.

## Background sub-agents

Read [`subagent-contract.md`](subagent-contract.md) before launching any Task.
It owns launch mode, never-wait, depth, bans, turn-staging, and parent reads.

**Delegate by default.** Goal: keep the context of every agent small,
including the parent. Split work MECE and give each self-contained part to a
sub-agent. Work inline only for a few tool calls, or when a split would cause
overlapping writes. Handoff is files.

- **Planning:** background explores, then grill and end the turn.
- **Milestone:** parent splits the milestone into MECE jobs with disjoint
  write paths. Workers write code and tests for their job. One **collator**
  merges the job results and runs the milestone evidence. Parent reads only
  the collator report, then updates activity files. Flow: **Milestone
  pipeline** in the contract.

## Update cadence

Durability, not a live log.

- `activity.md`: scope/design/plan change, milestone reached, blocker, before
  pause / complete / handoff.
- ARD whenever requirements change; must be current before `approve-plan`.
- Design Decisions when an important choice is made.
- Conventions (rules + Setup) when observed, confirmed, or tightened.
- `activities.md`: **Catalog**. `journal.md`: **Journal policy**.
- `reviews.md` at each user feedback round and each review apply.
- Always sync before `pause-work`, `mark-completed`, or handoff.
- If user edits leave activity files inconsistent, start `sync-notes`.

## Apply timing

Do not alias `self-review`, `apply-review`, `verify-plan`, and
**draft-check** (**Planning quality bar**).

| Pipeline | Apply when |
|---|---|
| `verify-plan` | After the contract question gate. Never in the same turn as the first Read of `synthesis.md`. All / some / none. |
| `apply-review` | Restate remaining `self-review.md` proposals. Ask **only** gaps the report does not settle (one round). If no gaps, apply in this turn. Not product code. |
| `self-review` | Never applies. Report only. |

Planning order: `self-review` → `apply-review` (if the user wants the report
applied) → `verify-plan` → `approve-plan`. None of the middle steps is
required. After `Active`: `self-review` / `apply-review` only.

## Command map

Before a reserved keyword, Read its heading in [`commands.md`](commands.md).
Valid statuses: each heading's `Status:` line. `help` prints these tables.

**Start and plan**

| Command | What it does |
|---|---|
| natural language | Create, list, switch, or show details of an activity |
| `replan-work` | Reopen in-flight scope → `Planning` |
| `create-sibling` | New `Planning` activity derived from this one |
| `import-activity` | Adopt activity files from elsewhere → `Planning` (`Complete` kept) |

**Gates and lifecycle**

| Command | What it does |
|---|---|
| `approve-plan` | `Planning` → `Approved` |
| `conventions-ok` | Sign off rules + Setup (one-time) |
| `start-building` | `Approved` → `Active`; needs `conventions: ok` |
| `pause-work` | → `Paused` + journal recap |
| `resume-work` | Unpause, unblock, reopen `Complete`, or reload context |
| `mark-completed` | → `Complete` + journal + cleanup |

**Review**

| Command | What it does |
|---|---|
| `self-review` | Sub-agents check plan vs evidence; report only |
| `apply-review` | Apply the self-review report |
| `verify-plan` | Critics + synthesis of the plan; apply on confirm |

**Notes upkeep**

| Command | What it does |
|---|---|
| `follow-convention` | Add or rewrite convention rules |
| `sync-notes` | Fix inconsistencies after user edits |
| `fix-notes` | Prune, verify paths and facts, rewrite for clarity, close ID gaps |
| `compact-journal` | Shorten the journal in place |

**Output and cleanup**

| Command | What it does |
|---|---|
| `create-guide` | Write `user-guide.md` for humans |
| `delete-tmp-files` | List activity temporaries; delete on confirm |

**Session**

| Command | What it does |
|---|---|
| `help` | Show these tables; `help <command>` explains one |
| `query-work` / `no-query-work` | Read-only session on / off |

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
   Conventions (rules + Setup) from repo/activity facts; user corrects.
4. If the user cited files, run **Cited context**.
5. Draft Goal (ARD summary) / Design / Plan / MECE milestones / evidence /
   Next Steps / References. Each milestone lists focused test cases; the last
   names e2e (and any interface fake).
6. **draft-check:** parent re-reads the drafted files before user review. No
   critics; not the `self-review` pipeline.

Required project-fit prompt (or equivalent):

> Before scope: how does this activity fit the larger project? State the
> problem and lay it out against the project scope in `.dev-notes/definition.md`.

Required intake prompt (or equivalent):

> In free text, define this activity's scope: objective, in-scope work,
> out-of-scope boundaries, constraints, and what "done" looks like.

If the current message already supplied both, acknowledge and continue grilling.

## Create sequence

1. Remind strong model.
2. **Planning quality bar** (includes **draft-check**; `# Scope` after the
   grill, `# Goal` from ARD).
3. Write `activity.md` (`conventions: pending`), `journal.md` (`# Journal`
   only), `requirements.md`, `design-choices.md`, `conventions.md` (include
   Setup H2), `notes-by-user.md` (`# Notes by User` only unless the user
   already wrote notes). Append one **Catalog** entry.
4. File review: user can challenge ARD, Conventions, Setup, and plan before
   `approve-plan` / `conventions-ok`. Each feedback round is a `UR<n>` cycle
   (**Reviews**).
5. Revision loop. Then **Execution gate**.

## Cited context

When the user points at files as initial context or definition updates (create,
derive, `replan-work`, ARD changes — not every source file touched while building):

1. Use every cited file **this session**, saved or not.
2. Ask **once** with a list. For each: tracked or not, hint whole copy vs excerpt.
   Do not copy until the user chooses. Subset OK.
3. **Whole copy:** `artifacts/<basename>` at the artifacts **root** (create dir
   if needed). Never under a reserved name (`templates.md`). Name clash: ask.
   No secrets. Huge trees: excerpt or skip.
4. **Excerpt:** new `artifacts/<stem>-excerpt.md` (header: source + what was kept).
   Binary: markdown of what mattered, or whole copy if the user asked for the file.
5. Every cited file gets a `REF<n>` bullet in `# References` (`copied` /
   `excerpt` / `context-only` + 1–3 sentences learned). On `replan-work`,
   refresh if the same files return.

## Engineering while focused

Only after the **Execution gate**, outside **Stops** blocks.

- Checkpoints only (**Update cadence**).
- Honor `conventions.md` rules (precedence: **Notes files**). Use Setup
  commands for build/test.
- Planning vocabulary stays out of shipped work: no **IDs**, milestone
  numbers, or the activity slug in code, comments, or identifiers. Such
  labels mean nothing outside the activity files.
- **Comments:** add the smallest set that lets a reader understand the change.
  Explain intent, contracts, and traps; do not narrate mechanics or restate
  code. Write in **Writing style** prose.
  - Name concepts and roles, not identifiers, literal constants, or line
    positions. Names and values change during maintenance and make the
    comment stale. Name an identifier only when no concept term fits.
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
  convention → Conventions. Material change → **Material-change**.
- Suggest `create-sibling` when work is independently durable.
- Apply **Test evidence** while building.
