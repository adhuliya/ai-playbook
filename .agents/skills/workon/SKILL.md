---
name: workon
description: >-
  Manage durable activities under .dev-notes/activities/ (activity.md,
  journal.md, requirement-def.md, design-choices.md, conventions.md,
  notes-by-user.md, reviews.md, user-guide.md, activities.md, optional
  artifacts/). Use when the user manages activities, imports an activity, or
  issues workon keywords: help, approve-plan, conventions-ok, start-building,
  pause-work, resume-work, mark-completed, replan-work, create-sibling,
  import-activity, start-review, apply-review, verify-plan, update-convention,
  add-review-comments, remove-review-comments, fix-activity, compact-journal,
  create-guide, delete-tmp-files, query-work, no-query-work.
disable-model-invocation: true
---

# workon

Activity manager. Records must stay resumable months later.

Shapes and layout: [`templates.md`](templates.md).
Keyword steps live in the command files below.
Sub-agents: [`subagent-contract.md`](subagent-contract.md).

A bold name points at that heading or bold term.
Names in the index live in that file.
A qualified name such as **Reviews** fix first lives in the file that owns the first name.
Any other bold name lives in this file.
Apply the named text.
Do not restate it.

Do not open the index files at the start of a turn.
Open an index file when a command heading names it.
Also open it when the Reads section names it.
Also open it when the step you are running tells you to follow that name.
Load a keyword with the extract under **Commands**.

## Index

| File | Names |
|---|---|
| `notes-files.md` | Notes files, Repair, Problem header, Isolated setup |
| `review-policy.md` | Reviews, Apply timing |
| `planning.md` | Planning quality bar, Create sequence, Cited context, draft-check, File review |
| `building.md` | Test evidence, Engineering while focused |
| `subagent-contract.md` | critic pair, Pipelines, Every agent, Paths and readiness |
| `editing.md` | Editing the workon skill |

## Reads

Read `planning.md` and `notes-files.md` to create an activity.
Read `review-policy.md` before you record chat feedback on the work.
Read `building.md` before product engineering.
Read `subagent-contract.md` before you launch any sub-agent.
Read `editing.md` before you change a file in this skill directory.
Do not read `editing.md` while you run an activity.
Do not alias `start-review`, `apply-review`, `verify-plan`, and **draft-check**.

## Command isolation

Follow only the heading for the keyword you are running.
Follow the policies that heading names.
Ignore rules that belong to another command.
Every command needs one focused activity.
Exceptions are `help`, `import-activity`, `query-work`, and `no-query-work`.
**Stops** apply.
Run the **Session probe** first.
Report the status and stop when it sits outside the heading's `Status:` line.
Run the steps in order.
The word "Stop" ends the command and the turn.

## Commands

Extract one keyword from the repo root.
Do not read `commands.md`.
Replace `<keyword>` with the reserved keyword.

```bash
awk -v cmd='<keyword>' '
  /^## / && index($0, "`" cmd "`") { show = 1 }
  show && /^## / && !index($0, "`" cmd "`") { exit }
  show
' .agents/skills/workon/commands.md
```


## Stops

- One focused activity at a time (memory only; no `.focus` file). A switch
  replaces the focus; announce it. Never silently edit a non-focused activity.
  New chat without a named activity: list and ask.
- **Keyword gate.** **Material-change:** prompt; do not rewrite scope first.
- No dates in `activity.md` / `journal.md` unless asked.
- `activity.md` is current execution truth (rewrite stale sections).
  **Journal policy.**
- **Execution gate.** **Portability.** **Writing style.**
- **Guide the user** on every reply that runs a command or meets an
  unusual situation.
- **Background sub-agents.** **Update cadence** (no micro-edits). **Catalog**
  (`rg`, no bulk-read).
- **`query-work`:** session flag until `no-query-work` or session end. Blocks
  every mutation: files, git writes, sub-agent output files, and mutating
  keywords. Allowed: `help`, `no-query-work`, list, details, reads, and
  `resume-work` on `Planning` / `Approved` / `Active` (reload only). Skip
  the **Session probe**. Report pending repairs instead. Review points the
  user states are not recorded; after `no-query-work`, ask whether to record
  them. On a blocked request, say query mode is on and ask for
  `no-query-work`.
- **Pipeline in flight:** a `verify-plan`, review (`start-review` or fix
  cycle), comment, drift, or milestone pipeline. It is in flight while
  `artifacts/inflight.md` exists (**Inflight scratch**). While it runs,
  activity files are frozen (except the parent's own steps of that
  pipeline, such as a milestone checkpoint). The session probe is skipped. Mutating keywords are
  refused (name the pipeline). A comment pipeline also freezes the files it
  snapshots; ask the user not to edit them. Allowed: `help`, `query-work`,
  `no-query-work`, list, details, reads. Planning explores are not
  pipelines. New chat with `inflight.md` present: name the pipeline from it;
  ask to wait or abandon. Abandon deletes `inflight.md`.

## Session probe

Run this probe before the first activity-file read or write in a session.
Skip it under `query-work`, during a pipeline, and for `help`.
Search only `.dev-notes/activities/<slug>/`.

Create a missing notes file from its shape in `templates.md`.
An empty body is valid.
Add the Setup heading from `templates.md` when you create `conventions.md`.

Apply a missing-row default from the list below.
Tell the user once when you set `base-branch`.

- `conventions`: `ok` when status is `Active`, `Paused`, `Blocked`, or `Complete`. Otherwise `pending`.
- `review-comments`: `off` when status is `Complete`. Otherwise `on`.
- `base-branch`: `main`.
- `synced`: `none`.

Treat the activity as legacy when any condition below is true.

- A file is named `notes.md`, `user-notes.md`, or `requirements.md`.
- `artifacts/self-review.md` or `artifacts/self-review/` exists.
- `requirement-def.md` has no `## Problem:` heading.
- A `##` heading in `requirement-def.md` is neither `## Problem:` nor `## RD<n>:`.
- A `##` heading in `design-choices.md` is not `## DC<nn>:`.
- A `##` heading in `conventions.md` is neither `## CONV<n>:` nor `## Setup, build, test and install notes`.
- A `##` heading in `reviews.md` is neither `## RU<n>:` nor `## Renumber`.
- A References bullet cites a file and has no `REF<n>`.
- The text contains `UR<n>`, `SR<n>`, `RRD<n>`, or a heading `## R<n>:`.

Read `notes-files.md` and follow **Repair** only when the activity is legacy.


## Inflight scratch

`<slug>/artifacts/inflight.md`: agent-only scratch for the current unit of
work (one pipeline run: review, `verify-plan`, comments, drift, or
milestone). An open review cycle waiting for `apply-review` is not a unit.
Never shown as status to the user; `activity.md` is the user's view of
progress.

- Create it fresh when a unit starts (overwrite any old one). Write:
  pipeline, unit (`RU<n>`, milestone `<n>`, command), launched steps,
  expected final file, and short working notes.
- Before launch, set `activity.md` `# Next Steps` item 1 to `In progress:
  <pipeline> <unit>` so the user sees it.
- Delete it when the parent reads the final file (milestone: after the
  checkpoint that checks it), or when the pipeline ends early (env
  `blocked`, abandon). Then refresh `# Next Steps`.
- Sub-agents never read or write it.

## Guide the user

Assume the user may be new, or may face this situation for the first time.
Continuity with clarity comes first: the user should always know where the
activity stands and what to type next.

- **After each command or pipeline step**, end with a short guide (≤ 3
  lines): what just happened, the current state (status, open cycle,
  pipeline), and the next one or two exact keywords or replies.
- **First use of a concept** this session (cycle, fix cycle, `synced`,
  review comments, inflight pipeline): add one plain sentence that explains
  it. Do not repeat it later in the session.
- **On a refused or gated request**, say why in one sentence and give the
  exact keyword that unlocks it.
- **Exceptional situations:** map each one onto the defined set: a status,
  a command, a cycle kind, or a **Stops** rule. Name the mapping in one
  sentence ("This is source drift; `fix-activity` handles it."). Never
  invent a new flow, file, status, or keyword. If no mapping fits, stop,
  describe the situation, and offer two or three defined options with a
  recommendation.
- **Two plausible readings** of a user request: ask one short question
  with a recommended answer instead of guessing.
- Keep guides short; no essays. `help` stays the full answer for "what
  now?".

## Keyword gate

Natural language is fine for discussion, create, switch, list, details.
Gated transitions need the exact reserved keyword. On detected intent, do not
silent-transition; prompt it, e.g. `If you want to replan, write \`replan-work\`.`
"Resume <slug>" in plain words = switch plus context reload; if the status
is `Paused`, `Blocked`, or `Complete`, prompt `resume-work`.

Exceptions: the agent MAY run the **Consistency check** without a keyword;
`mark-completed` runs the `delete-tmp-files` flow. Both confirm each item.

## Material-change

**Material** = Goal or Scope rewrite; RD add/drop/reword after approval that is
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
- `apply-review`: stay-on-slug **only**. The cycle is intake; no sibling; no
  full resume grill. Reopen `Complete` → `Planning` only when the cycle adds
  a review milestone. Material open point → apply nothing; ask
  `create-sibling`. For the grill/classify fork, the user runs `resume-work`
  first.

**Complete sibling:** prompt `create-sibling`. Parent stays `Complete`. No parent
journal entry. Sibling `derived-from:` only; parent never points at the sibling.

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

- `Paused`: intentional stop via `pause-work`. Not allowed from `Blocked`.
- Only `resume-work` leaves `Paused` or `Blocked`. `apply-review` never
  changes these statuses.
- `Blocked`: cannot continue. The agent MAY set it at a checkpoint when work
  is stuck. Add a one-line blocker to `notes`; details in `activity.md`
  `# Next Steps`. Append a `Blocked` event (**Journal policy**).

## Reminders

- Create, `create-sibling`, `replan-work`: remind to use a **strong** model.
- At `approve-plan`: one-time note that planning is done; user may drop the
  strong model. No execution-tier recommendation.
- Remind once per phase change.

**Optional-remind** (once, do not require): `verify-plan` at `approve-plan` if
this session has not run it; `apply-review` when `reviews.md` has an `open`
cycle (`approve-plan`, `start-building`, `pause-work`, `resume-work`);
`create-guide` at `mark-completed` if `user-guide.md` is missing or stale;
`remove-review-comments` at `mark-completed` if `review-comments` is `on`;
`fix-activity` at `resume-work`, or when the agent notices drift (activity
files edited outside the agent, the `synced` base not an ancestor of
`HEAD`, or cited paths missing).

## Journal policy

File: `.dev-notes/activities/<slug>/journal.md` only. Shapes: `templates.md`.

Purpose: the append-only **event timeline**. `activity.md` holds current
state; `reviews.md` holds review detail. The journal records each event that
changes direction or status: what happened, why, and pointers (IDs, paths,
commands). A fresh agent reads it to learn how the activity got here.

**Events** (one entry each, written in the same turn):

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
`update-convention`, `conventions-ok`, `start-review` (opening or refreshing
a cycle), `add-review-comments`, `remove-review-comments`, `create-guide`,
`delete-tmp-files`, list, details, `help`.

**Entry:** `## <Event>: <short title> (<from> → <to>)`; omit the arrow when
status is unchanged. Then ≤ 3 bullets: what happened, IDs / paths / evidence
command, `next:` if not obvious. Point at IDs; do not copy RD, plans, or
review points. No dates unless asked; entry order is the timeline.

Pause / resume recap: cap **~10 lines**; omit empty fields.

**`Complete`:** the one thick entry. Project-work write-up (what shipped,
paths, decisions, gaps). Not a lifecycle novel.

Append at end. Prior entries are **read-only** except `compact-journal` (the
only rewrite).

## Layout

Tree and artifact names: `templates.md`. Slugs are kebab-case and top-level
only; siblings sit side by side. Ambiguous slug: list matches and ask.

Commit `.dev-notes/activities/`, including useful `artifacts/` copies and
reserved `verify-plan/`, `review/`, `comments/`, `fix/`, `bg/` records
(not `inflight.md`; it is scratch). Agent does not
`git add` / commit unless asked. Huge generated trees stay out of the repo.
A gitignored `.dev-notes/` is valid; the `synced` snapshot still covers it.

Status tokens (exact): `Planning` | `Approved` | `Active` | `Paused` | `Blocked` | `Complete`

Preferred lifecycle: `Planning → Approved → Active → Complete`, with optional
`Paused` / `Blocked`. Never `Complete` → `Active`.

## `activity.md`

Title + metadata table in the first ~10 lines. Template: `templates.md`.

Required rows: `status`, `conventions`, `review-comments`, `slug`, `branch`,
`base-branch`, `synced`, `ticket`, `notes` (`ticket` may be `none`; `notes` may be
empty; `branch` may be `none`).
`branch` is a hint; do not auto-create or check out branches.
`base-branch` is the parent branch the activity diffs against (default
`main`). The activity diff is `git diff $(git merge-base HEAD <base-branch>)`
plus new untracked files.
`conventions` is `pending` or `ok` (**Execution gate**).
`review-comments` is `on` (default at create) or `off` (**Engineering while
focused** comment levels).
`synced` is the drift baseline for `fix-activity`: a snapshot commit of
the working tree when the activity files were last in line with the repo,
or `none`. A **snapshot** holds `HEAD`, uncommitted tracked changes, and the
activity folder, also when `.dev-notes/` is gitignored:

```bash
d=.dev-notes/activities/<slug>; idx=$(mktemp -u)
GIT_INDEX_FILE=$idx git read-tree HEAD
GIT_INDEX_FILE=$idx git add -u
GIT_INDEX_FILE=$idx git add -f "$d"
tree=$(GIT_INDEX_FILE=$idx git write-tree); rm -f "$idx"
if [ "$tree" = "$(git rev-parse 'HEAD^{tree}')" ]; then snap=$(git rev-parse HEAD)
else snap=$(git commit-tree "$tree" -p HEAD -m "workon synced <slug>"); fi
```

Pin it with `git update-ref refs/workon/<slug> $snap` so git does not
garbage-collect it. Write `$snap` to the row. The snapshot covers
uncommitted agent work, so that work is not mistaken for drift. It does
not change the working tree or the real index. Measure drift between two
snapshots: `git diff <synced> <now>`, where `<now>` is a fresh unpinned
snapshot. A plain `git diff <synced>` misses gitignored activity files.
The **`synced` base** is the snapshot's first parent when its subject
starts with `workon synced` or it is a legacy stash (two parents). Else it
is the commit itself.

Writers of `synced` (no others): create and `create-sibling` (first
snapshot); `import-activity` (`none`); every other agent write to an
activity file (**Update cadence** checkpoints, `update-convention`,
`conventions-ok`, **Consistency check** fixes); `fix-activity` step 9;
`apply-review` closing a fix cycle. Agent writes skip the refresh while a
fix cycle is `open`, or when the `synced` base is not an ancestor of
`HEAD` (then remind `fix-activity`).

Required sections (order): Goal, Scope, Background and Special Notes, Current
Design, Current Plan, Milestones, Next Steps, References.

- **Goal** summarizes RD. On conflict, RD wins; refresh Goal / Scope at the
  next checkpoint.
- **Scope:** one or two paragraphs after the first grill; then near-fixed.
  Major in-flight change → **Material-change**.
- **Current Design:** execution handoff (invariants, boundaries, evidence
  signals). Chosen-vs-alternatives live only in Design Decisions.
- **Milestones:** MECE outcomes. Apply **Test evidence**. On reopen, keep
  checked items; append new ones; mark removed work `superseded` — do not
  delete. Milestone numbers are stable: `fix-activity` prune replaces a
  milestone body with a one-line `<n>. removed: <why>` stub. Review
  milestones: **Reviews**.
- **References:** one `REF<n>` bullet per cited planning file (**Cited
  context**).

## IDs

Activity entries carry stable IDs. Cross-references use the ID, not the title.

| ID | Entry | Home |
|---|---|---|
| `RD<n>` | Requirement Definition | `requirement-def.md` `## RD<n>: <title>` |
| `DC<nn>` | design decision (two digits) | `design-choices.md` `## DC<nn>: <title>` |
| `CONV<n>` | convention rule (Setup H2 has no ID) | `conventions.md` `## CONV<n>: <title>` |
| `REF<n>` | reference | `activity.md` `# References` bullet |
| `RU<n>`, `RU<n>.<m>` | Review Update: review cycle, point | `reviews.md` |

- Assign the next free number. Do not reuse a retired (superseded or removed)
  ID, except via `fix-activity` renumbering.
- `replaces:` names the old ID.
- IDs stay out of shipped work and `user-guide.md` (**Engineering while
  focused**).

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

## User guide

`<slug>/user-guide.md`. Written only by `create-guide`; rewrite in place on
re-run. Audience: a human user, not an agent. Explains what the activity
delivered and how to use it, test it, and explain it to others. Uses
**Writing style** prose. No **IDs**. Shape: `templates.md`.

## Portability

Handoff is `activity.md` + `journal.md` + `requirement-def.md` +
`design-choices.md` + `conventions.md`. `notes-by-user.md`, `reviews.md`, and
`user-guide.md` are extra — handoff must not depend on them.

- Inline load-bearing facts. No "as discussed".
- Repo-relative paths, commands, commit/PR/ticket IDs. No host paths in Goal /
  Scope / Plan (source path in References is OK for untracked files).
- Milestone evidence must be commands a new session can run.
- `# Next Steps` names the safest first action.
- Prefer rediscovering fine-grained progress from repo, tests, and evidence.

Resume loads the handoff files — keep them lean. Delete stale prose when
rewriting `activity.md`. Do not load `activities.md` on resume. Do not load
`notes-by-user.md` unless the user points at it.

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

**Records** (activity files, journal recaps, `reviews.md`, sub-agent
reports): bullets and fragments. Drop articles if the line stays
unambiguous. Pattern: `[thing] [action] [reason].` Shapes: `templates.md`.

**Prose** (replies, code comments, `user-guide.md`, user docs, skill
instructions, grill questions, confirm gates): full sentences with articles.
One instruction per sentence, in the imperative. Instructions ≤ 20 words;
descriptions ≤ 25 words. If a record fragment would scramble order, a
constraint, or a confirm, use prose.

## Background sub-agents

Read [`subagent-contract.md`](subagent-contract.md) before you launch any sub-agent.
The contract owns launch, depth, waits, and parent reads.
Delegate work by default.
Give each sub-agent one self-contained part.
Keep write paths disjoint.
Use files as the handoff.
Work inline for a few tool calls.
Also work inline when a split would overlap writes.
Launch planning explores, then grill, then end the turn.
Run milestone, comment, and evaluate work as the contract describes.
Judge with the **critic pair**.
Do not judge with one agent.

## Update cadence

Durability, not a live log.

- `activity.md`: scope/design/plan change, milestone reached, blocker, before
  pause / complete / handoff. A checked milestone also appends a `Milestone`
  event. Each such checkpoint (any status) refreshes `synced` (writers and
  skips: **`activity.md`**).
- RD whenever requirements change; must be current before `approve-plan`.
- Design Decisions when an important choice is made.
- Conventions (rules + Setup) when observed, confirmed, or tightened.
- `activities.md`: **Catalog**. `journal.md`: **Journal policy**.
- `reviews.md`: when points change, follow **Reviews** (where points go).
- Always sync before `pause-work`, `mark-completed`, or handoff.
- After user edits to activity files, run the **Consistency check**.

## Consistency check

Agent-run after user edits; also step 0 of `fix-activity`. No keyword, no status
change, no journal.

1. Check `activity.md`, RD, Design Decisions, Conventions, and `reviews.md`
   against each other: broken or duplicate **IDs**, Problem header vs Goal
   and Scope, Goal vs RD, Current
   Design vs DCs, plan/milestones vs RD, Setup vs rules.
2. For each issue: ID or section, the smallest edit, why. Ask yes / no / mods.
   Apply only confirmed fixes. Do not reword beyond the fix.
3. A fix that changes Goal or Scope is **Material-change**: skip it and prompt.
4. `notes-by-user.md` is input only. If it cites stale IDs or contradicts the
   files, tell the user; do not edit it.

Never prune, rewrite, or renumber here; that needs `fix-activity`.

## Command map

Run the extract under **Commands**.
Valid statuses are that heading's `Status:` line.
`help all` prints the tables below.

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
| `start-review` | Open or refresh a review cycle; automated by default, `manual` on request |
| `apply-review` | Apply and close one open cycle (fix cycle first) |
| `verify-plan` | Critics + synthesis of the plan; apply on confirm |

**Comments**

| Command | What it does |
|---|---|
| `add-review-comments` | Raise comments in the activity diff to review level; `review-comments: on` |
| `remove-review-comments` | Trim comments in the activity diff to default level; `review-comments: off` |

**Notes upkeep**

| Command | What it does |
|---|---|
| `update-convention` | Add or rewrite convention rules |
| `fix-activity [<what to fix> \| tidy]` | Fix what the user names, or resync after drift; cheap triage first; asks before each pipeline; prune, rewrite, renumber only on `tidy` |
| `compact-journal` | Shorten the journal in place |

**Output and cleanup**

| Command | What it does |
|---|---|
| `create-guide` | Write `user-guide.md` for humans |
| `delete-tmp-files` | List activity temporaries; delete on confirm |

**Session**

| Command | What it does |
|---|---|
| `help` | Next steps for the current state |
| `help intro` | The basic path: four steps from idea to done |
| `help all` / `help <command>` | Show these tables / explain one command |
| `query-work` / `no-query-work` | Read-only session on / off |
