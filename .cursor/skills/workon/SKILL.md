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

Shapes and layout: [`templates.md`](templates.md). Keyword sequences:
[`commands.md`](commands.md). Sub-agents:
[`subagent-contract.md`](subagent-contract.md). A bold name such as
**Reviews** points at the heading or bold term of that name in `SKILL.md`
(or in the contract when it says so). Apply it; do not restate it.

**Command isolation:** when running a reserved keyword, follow only its
heading in `commands.md` and the policies it names. Rules written for
another command apply only where this heading names them.

## Stops

- One focused activity at a time (memory only; no `.focus` file). A switch
  replaces the focus; announce it. Never silently edit a non-focused activity.
  New chat without a named activity: list and ask.
- **Keyword gate.** **Material-change:** prompt; do not rewrite scope first.
- No dates in `activity.md` / `journal.md` unless asked.
- `activity.md` is current execution truth (rewrite stale sections).
  **Journal policy.** **Notes files.**
- **Execution gate.** **Portability.** **Writing style.** **Test evidence.**
- **Guide the user** on every reply that runs a command or meets an
  unusual situation.
- **Background sub-agents.** **Update cadence** (no micro-edits). **Catalog**
  (`rg`, no bulk-read).
- **`query-work`:** session flag until `no-query-work` or session end. Blocks
  every mutation: files, git writes, sub-agent output files, and mutating
  keywords. Allowed: `help`, `no-query-work`, list, details, reads, and
  `resume-work` on `Planning` / `Approved` / `Active` (reload only). Skip
  **Notes files** Repair; report pending repairs instead. Review points the
  user states are not recorded; after `no-query-work`, ask whether to record
  them. On a blocked request, say query mode is on and ask for
  `no-query-work`.
- **Pipeline in flight:** a `verify-plan`, review (`start-review` or fix
  cycle), comment, drift, or milestone pipeline. It is in flight while
  `artifacts/inflight.md` exists (**Inflight scratch**). While it runs,
  activity files are frozen (except the parent's own steps of that
  pipeline, such as a milestone checkpoint), Repair is skipped, and mutating keywords are
  refused (name the pipeline). A comment pipeline also freezes the files it
  snapshots; ask the user not to edit them. Allowed: `help`, `query-work`,
  `no-query-work`, list, details, reads. Planning explores are not
  pipelines. New chat with `inflight.md` present: name the pipeline from it;
  ask to wait or abandon. Abandon deletes `inflight.md`.

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
or `none`. Take it with `snap=$(git stash create); snap=${snap:-$(git
rev-parse HEAD)}`, then pin it with `git update-ref refs/workon/<slug>
$snap` so git does not garbage-collect it. Write `$snap` to the row. The
snapshot covers uncommitted tracked agent work, so that work is not
mistaken for drift. Neither command changes the working tree or the index.
The **`synced` base** is the snapshot's first parent (the `HEAD` it was
taken on) when it has two parents, else the commit itself.

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

## Reviews

`<slug>/reviews.md`, H1 `# Reviews`. Create lazily. Agent-written record;
the user MAY edit points of an `open` cycle. Shape: `templates.md`. Not part
of the handoff.

- **Cycle:** each review round is one `RU<n>` cycle (Review Update). Two
  kinds only: **regular** (default) and **fix** (`kind: fix`). Do not label
  cycles by any other source.
- **Point:** each item is `RU<n>.<m> (agent|user)` with its outcome. The tag
  names who raised it. A cycle MAY mix both, or hold no points.
- **Open / closed:** `status: open | closed`. At most one regular and one
  fix cycle are `open` at a time. Cycles without the line (legacy) are
  `closed`.
- **Where points go** (regular cycle):

  | Source | Open regular cycle exists | None open |
  |---|---|---|
  | `start-review` | refresh it | open a new one |
  | chat feedback on activity files or built work | add `user` points; apply only via `apply-review` | new cycle, closed and applied this turn |
  | `verify-plan` apply | add `agent` points; apply only via `apply-review` | new cycle, closed and applied this turn |
  | `fix-activity` inline path | new closed cycle (user edits already in the files) | same |

- **Fix cycle:** opened only by `fix-activity` on the fix-cycle path.
  Holds only drift findings; `scope: drift <synced>..HEAD`. Other feedback
  goes to the regular cycle. Refresh by re-running `fix-activity`, never
  `start-review`. Never reopens.
- **Fix first:** while a fix cycle is open, `apply-review` applies it, not
  the regular cycle. The regular cycle waits; the user MAY still add points.
- **Recheck:** after a fix cycle closes, recheck each `open` point of the
  regular cycle against the new state. Still valid → stays `open`. Fixed
  → `noted: resolved by RU<k>.<m>`. No longer applies → `noted: obsolete
  after RU<k>`. Changed `agent` point → rewrite it. Changed `user` point →
  ask after the close; it stays `open` until answered.
- **Edit while open:** the user adds, edits, or strikes points in
  `reviews.md`, or states them in chat. A `start-review` refresh replaces
  only `agent` points that are still `open`. It never touches `user`
  points.
- **Reopen:** the user MAY add points to the last closed regular cycle when
  no newer regular cycle exists (an open fix cycle does not block this).
  The user does it by editing that cycle in `reviews.md`, or by naming
  `RU<n>` in chat. Other chat feedback follows the table above.
  The agent sets that cycle `open` again. `apply-review` closes it and
  handles only the new `open` points.
- **Scope** (`start-review` cycles): records `scope:`. Default: milestones
  checked after the newest earlier regular cycle with a milestone `scope:`
  (none → all checked milestones), plus their joins with earlier work. The
  user MAY name milestones (`start-review 2-3`). In `Planning`: `scope:
  plan`. Refresh rewrites `scope:` and `state:`.
- **Authority:** the user approves every cycle in principle. A point MAY
  change a requirement, a design decision, a convention, or the
  implementation.
- **Where a change lands** (the target's own edit rule holds):

  | Target | Edit |
  |---|---|
  | `RD<n>` | Rewrite in place; add `revised-by: RU<n>.<m>`. |
  | `DC<nn>` | Append a new `DC` with `replaces: DC<nn>` and `revised-by: RU<n>.<m>`. |
  | `CONV<n>` | Rewrite in place; add `revised-by: RU<n>.<m>`. |
  | `activity.md` section or milestone | Edit in place. A regressed milestone is unchecked with `regressed: <evidence>`. |
  | Code, tests, docs | Review milestone (below). No IDs in shipped work. |

- **Material-change** still applies: a point that changes Goal or Scope, or a
  material RD change after `approve-plan`, needs the prompt.
- **State note:** open each cycle with status, milestone, and what changed
  since `RU<n-1>` (IDs added or changed, work built). One or two short
  paragraphs; deltas only. Earlier cycles hold the rest.
- Outcome: `applied → <IDs>` | `planned → milestone <k>` | `rejected:
  <why>` | `noted: <why no action>` | `open`. Name every changed ID.
  Product work is `planned` until its milestone is checked; the check is the
  proof. A cycle with no actionable points is valid: close it with each
  point `noted`, or with `- none`.
- **Review milestone:** if a cycle needs product work (code, tests, docs),
  append milestone `Apply RU<n>` to `activity.md`. Its MECE steps cite the
  points. Notes-only edits need no milestone.
- **Journal:** each cycle close (and each re-close after a reopen) appends
  one `Review` event (**Journal policy**). A status change writes the
  resume recap instead (cites `RU<n>`). Opening or refreshing writes no
  journal.
- **Renumber log:** `fix-activity` appends `## Renumber <k>` with the
  old → new ID map. Journal entries before it use the old numbers. `RU`
  IDs and milestone numbers are never renumbered.

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

`requirement-def.md`, `design-choices.md`, `conventions.md`, `notes-by-user.md`.
Required at birth. Templates: `templates.md`.

**Repair** (before the first activity-file read or write in a session):

- Legacy `notes.md`: map each old `##` to the file whose H1 matches
  (Requirement Definition, Design Decisions, Conventions); the rest goes to
  `notes-by-user.md`. Promote `###` to `##`. Add an empty
  `## Setup, build, test and install notes` if missing. Delete `notes.md`.
- Legacy `user-notes.md`: rename to `notes-by-user.md` (`git mv` if tracked);
  change H1 `# User Notes` to `# Notes by User`. Keep the body.
- Legacy `requirements.md`: rename to `requirement-def.md` (`git mv` if
  tracked). Keep the body.
- `requirement-def.md` without a **Problem header**: draft one from
  `# Scope`, `# Goal`, and `.dev-notes/definition.md`. Show it once and ask
  the user to confirm or correct it.
- Entries or References bullets without **IDs**: number them in file order;
  rewrite title-based `replaces:` to IDs.
- Legacy review and requirement IDs: rename `R<n>` → `RD<n>` (same number).
  Merge `UR<n>`, `SR<n>`, and `RRD<n>` cycles into one `RU<n>` sequence in
  file order.
  Update every reference in the scope files. Append the map as a **Renumber
  log**. Do not edit the journal.
- Missing `conventions` row: `ok` if status is `Active`, `Paused`, `Blocked`,
  or `Complete`; else `pending`.
- Missing `review-comments` row: `off` if `Complete`; else `on`. Missing
  `base-branch` row: `main`; tell the user once so they can correct it.
  Missing `synced` row: `none`.
- Legacy `artifacts/self-review.md` and `artifacts/self-review/`: old review
  records. Do not apply them. `delete-tmp-files` lists them (default
  delete).
- Missing file: create with its H1 (and Setup H2 on `conventions.md`). Empty
  body is valid.

Agent **best-effort drafts** all except `notes-by-user.md` (repo + this
activity; user reviews and corrects). Bullets wherever possible. What
sub-agents may read or receive: contract **Every agent**.

### `requirement-def.md` (RD)

**RD** (Requirement Definition) means the `RD<n>` entries in this file, one
entry or all. H1: `# Requirement Definition`. Parent-only.

**Problem header** (always present, first H2, no ID):
`## Problem: <problem title>`. The body is one short paragraph under
~100 words. It states the problem this activity solves and how it fits the
project in `.dev-notes/definition.md`. Write it from the project-fit and
intake answers. Do not list requirements here; RD entries hold them.
Keep it crisp: one problem, its impact, and the project link. Rewrite in
place when the problem understanding changes. A change to the problem
itself is **Material-change**.

Entries follow the header: `## RD<n>: <title>`. Keep them current as
grilling reveals requirements; user challenges them before `approve-plan`.
`kind` is exactly one of:

- `end-user-interface`: humans (UI, CLI output, docs the user reads).
- `software-interface`: contract other software must honor (in-repo
  modules/libraries, API / ABI / FFI / protocol / link). Prefer this name;
  old `external-interface` is the same kind (do not rewrite solely to rename).
- `internal-behavior`: no contract outside this component.

Drop or reword when the user challenges. A review point that changes an entry
adds `revised-by:` (**Reviews**; same for `DC` and `CONV`). Material RD change after approval: apply
**Material-change**.

### `design-choices.md`

H1: `# Design Decisions`. Entries: `## DC<nn>: <title>`. Parent-only.
Append-only (except `fix-activity`). Append when a real choice is made. Do not
delete or rewrite history. Supersede with a new entry and `replaces: DC<nn>`.
Skip micro-choices recoverable from code. ~200 words hard max. `level` is
exactly one of:

- `design-choice`: UI or software-facing contract (same coverage as RD
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
without a keyword while `conventions: pending` (planning grill,
`conventions-ok`), and for rules the agent observes and the user confirms.
Once `conventions: ok`, an explicit user add or rewrite needs
`update-convention`; on detected intent, prompt it. Rewrite in place when a
newly confirmed rule contradicts or tightens an entry. No tighter than the
user stated. Drop: mark `superseded` on request — do not delete (except
`fix-activity` prune). No forced conventions interview in Planning.

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
once; the user trims. Read for intake; promote load-bearing bits into RD,
Design Decisions, or Conventions. The agent never edits it, except a short
`agent:` line when asked.

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
- Milestone evidence must be commands/checks a new session can run
  (**Test evidence**).
- `# Next Steps` names the safest first action.
- Prefer rediscovering fine-grained progress from repo, tests, and evidence.

Resume loads the handoff files — keep them lean. Delete stale prose when
rewriting `activity.md`. Do not load `activities.md` on resume. Do not load
`notes-by-user.md` unless the user points at it.

## Test evidence

Planning, building, `start-review`, `verify-plan`, `mark-completed`.

Three tiers. Plan each tier during planning. Write tests as each milestone is
built.

- **Unit (per part):** each part a milestone adds or changes (function,
  component, module) gets focused tests on its own behavior. Cases: happy
  path, edges, and errors that belong to that part. Isolate the part from
  its neighbors. Do not hang the whole suite off every milestone.
- **Integration (per boundary):** test where parts meet: component
  boundaries, joins between milestones, and each `software-interface` RD.
  Name the boundary and its cases in the plan. Place the test in the
  milestone that completes the boundary.
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
- **Extend existing tests first:** before you add a test, search for tests
  with the same goal (same part, boundary, or scenario).
  - Goals match → extend that test (new case, table row, or assertion).
  - Goals differ, or the extension would blur its purpose → add a new test.
  - Do not weaken or rewrite existing assertions to fit. A changed expected
    behavior is a requirement change; record it as a review point
    (**Reviews**).
- **Layout:** follow the repo's test layout, naming, and helpers.
- Evidence bullets name the runnable command and the case list per tier.

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

Read [`subagent-contract.md`](subagent-contract.md) before launching any Task.
It owns launch mode, never-wait, depth, bans, turn-staging, and parent reads.

**Delegate by default.** Goal: keep the context of every agent small,
including the parent. Split work MECE and give each self-contained part to a
sub-agent. Work inline only for a few tool calls, or when a split would cause
overlapping writes. Handoff is files.

- **Planning:** background explores, then grill and end the turn.
- **Milestone:** parent splits the milestone into MECE jobs with disjoint
  write paths. Workers write code and tests for their job. One **collator**
  collects the job results and runs the milestone evidence. Parent reads only
  the collator report, then updates activity files. Flow: **Milestone** in
  the contract.
- **Comment commands:** `add-review-comments` and `remove-review-comments`
  always use sub-agents: comment editors plus one verifier. They change
  comments only. Flow: **Comments** in the contract.
- **Evaluate, do not just collect:** when the parent must judge results, use
  the contract's **critic pair** (one praises what stands out, one criticizes
  what it dislikes most, both with reasons), never a single agent.

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
- `reviews.md`: per **Reviews** (where points go).
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

## Apply timing

Do not alias `start-review`, `apply-review`, `verify-plan`, and
**draft-check** (**Planning quality bar**).

| Pipeline | Apply when |
|---|---|
| `verify-plan` | After the contract question gate. Never in the same turn as the first Read of `synthesis.md`. All / some / none. |
| `apply-review` | Target: the open fix cycle, else the open regular cycle. Restate its `open` points. Ask **only** gaps the points do not settle (one round), then stop; apply next turn after the answers, no new keyword. If no gaps, apply in this turn. Product work becomes a review milestone. |
| `start-review` | Never applies. Opens or refreshes the cycle only. |
| chat feedback | Open regular cycle → `user` points, applied by `apply-review`. None open → apply this turn (**Reviews** where points go). |

Planning order: `start-review` → `apply-review` (if the user wants the
points applied) → `verify-plan` → `approve-plan`. None of the middle steps
is required. After `Active`: `start-review` / `apply-review` only.

## Command map

Before a reserved keyword, Read its heading in [`commands.md`](commands.md).
Valid statuses: each heading's `Status:` line. `help all` prints these
tables.

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
| `fix-activity` | Resync activity files after user edits, source drift (edits, rebase), or major drift; grill on unclear and plan-impacting findings; then fix, prune, verify, rewrite, close ID gaps |
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

## Planning quality bar

Applies to create, `create-sibling`, `replan-work`.

Use [`grill-me`](../grill-me/SKILL.md): one question at a time, recommend an
answer, explore the repo instead of asking. Do not skip grilling to draft files.

**Order (mandatory):**

1. **Project-fit** against `.dev-notes/definition.md`. Do not proceed until it fits.
2. **Intake:** free-text scope (objective, in/out, constraints, done).
   Then write the **Problem header** in `requirement-def.md`.
3. Grill remaining branches: goal, success, scope, constraints, assumptions,
   risks, interfaces, non-goals. Classify each requirement and write RD as it
   becomes clear. Record Design Decisions as they are made. Best-effort
   Conventions (rules + Setup) from repo/activity facts; user corrects.
4. If the user cited files, run **Cited context**.
5. Draft Goal (RD summary) / Design / Plan / MECE milestones / evidence /
   Next Steps / References. Each milestone lists unit cases per part and
   integration cases for the boundaries it completes; the last names e2e (and
   any interface fake). Note existing tests to extend (**Test evidence**).
6. **draft-check:** parent re-reads the drafted files before user review. No
   critics; not the `start-review` pipeline.

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
   grill, `# Goal` from RD).
3. Write `activity.md` (`conventions: pending`, `review-comments: on`,
   `base-branch` from the grill or `main`, `synced` snapshot),
   `journal.md` (`# Journal` plus a `Created` event),
   `requirement-def.md`, `design-choices.md`, `conventions.md` (include
   Setup H2), `notes-by-user.md` (`# Notes by User` only unless the user
   already wrote notes). Append one **Catalog** entry.
4. **File review:** show the drafted files; the user challenges RD,
   Conventions, Setup, and plan before `approve-plan` / `conventions-ok`.
   Feedback goes per **Reviews** (where points go). `start-review` is not
   required. Done when the user has seen the files and every feedback
   round is recorded.
5. Revision loop. Then **Execution gate**.

## Cited context

When the user points at files as initial context or definition updates (create,
derive, `replan-work`, RD changes — not every source file touched while building):

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
- **Coding style:** where `conventions.md` rules are silent, the repo's
  guidelines apply.
  - Match the surrounding code: naming, idiom, error handling, structure,
    and file layout.
  - Keep the diff minimal and in scope. Do not refactor or reformat code the
    milestone does not touch; suggest it separately.
  - Reuse existing helpers, utilities, and patterns before you write new
    ones.
  - Prefer the standard library and existing dependencies. A new dependency
    is a Design Decision.
- Planning vocabulary stays out of shipped work: no **IDs**, milestone
  numbers, or the activity slug in code, comments, or identifiers. Such
  labels mean nothing outside the activity files.
- **Comments:** two levels. The `review-comments` row picks the level for
  code written now. Explain intent, contracts, and traps; do not narrate
  mechanics or restate code. Write in **Writing style** prose.
  - **Default level** (`off`; the level that ships): the smallest set that
    lets a reader understand the code.
    - New file: short module header (what this file is for).
    - New public/exported function: one-line contract/why, not a signature
      echo.
    - Private helper: one-line contract if non-trivial; skip if the name is
      the explanation.
    - Non-obvious branch or block: one line when the code cannot show the
      reason.
    - Bugfix: comment when the wrong code looks reasonable.
    - Test: scenario intent if the test name is not enough.
  - **Review level** (`on`; default while building): the default level plus
    enough for a human reviewer to follow the code without the author.
    - Non-trivial block: 1–2 lines on why it exists.
    - Function: the invariants and edge cases it handles, where it handles
      them.
    - Test case: the scenario and the expected behavior.
    - Boundary: what callers may rely on; what the code assumes of its
      neighbors.
  - Both levels: ≤ ~3 lines per comment; no essays. No change narration
    (`added`, `previously`, `now`). No **IDs**.
  - Name concepts and roles, not identifiers, literal constants, or line
    positions. Names and values change during maintenance and make the
    comment stale. Name an identifier only when no concept term fits.
  - Match the file's comment dialect.
  - Switch levels for existing code only with `add-review-comments` /
    `remove-review-comments`.
- New definition files → **Cited context** (ask before copy).
- Missing invariant that would mislead a fresh reader → update `activity.md`.
  New requirement or important choice → RD / Design Decisions. New confirmed
  convention → Conventions. Material change → **Material-change**.
- Suggest `create-sibling` when work is independently durable.
- Apply **Test evidence** while building.
