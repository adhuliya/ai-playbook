# Lifecycle commands

Keyword steps for workon.
Read only the heading you are running.
Shared rules and the session probe live in [`SKILL.md`](SKILL.md).
Shapes: [`templates.md`](templates.md).
A bold name follows the index in `SKILL.md`.

## `replan-work`

Status: `Planning`, `Approved`, `Active`, `Paused`, `Blocked`.

Read `planning.md` and `notes-files.md` before these steps.
In-flight major scope change. **Material-change.**

1. Remind strong model. If status is not `Planning`, set `Planning` now
   (stops engineering) and record the reason in `activity.md`. Clear
   `prior:` and any blocker from `notes`.
2. Re-run **Planning quality bar** from the top. **Cited context** if cited.
3. Rewrite RD, `# Scope`, and affected `activity.md` sections. Append Design
   Decisions. Update Conventions (rules + Setup) from observed facts and
   user-confirmed rules. If **Goal** changed, patch that one **Catalog** entry.
4. Append a `Replan` event: why, changed IDs, old status (**Journal
   policy**).
5. **File review**, then **Execution gate** before engineering.

## `create-sibling`

Status: any. Derived `activity.md` + RD / Design Decisions / Conventions
must stand alone (no "see parent"). Slug: `{parent-slug}-{short-suffix}`
kebab-case. Propose; user may override.

Read `planning.md` and `notes-files.md` before these steps.

1. Remind strong model.
2. Read source `activity.md`, `requirement-def.md`, `design-choices.md`,
   `conventions.md` once. Open its journal only if it has entries. Do not copy
   `notes-by-user.md` or `reviews.md`.
3. **Planning quality bar** for the **new** scope (fresh intake; do not inherit fuzz).
4. Rewrite all required sections and a fresh RD with its own **Problem
   header**. Copy still-applicable
   decisions **and conventions** (rules + Setup) inline, not as pointers.
   User may drop or rewrite conventions on the sibling. Number **IDs** fresh
   from 1.
5. Fresh `notes-by-user.md` (H1 only). Fresh `journal.md` with one
   `Created` event naming the parent slug. `status: Planning`,
   `conventions: pending`, `review-comments: on`, `synced` snapshot, new
   slug. Copy `base-branch`; the user may change it. Provenance:
   **Complete sibling** (`derived-from:` rule). Append one **Catalog**
   entry.
6. **draft-check:** derived files stand if the source were deleted.
7. In-flight parent only: mark moved RD entries and milestones
   `superseded` in the parent; status unchanged; no parent journal. If the
   parent Goal changes → **Material-change** (`replan-work`).
8. Switch focus to the sibling and announce it. **File review** + revision
   loop.

## `import-activity`

Status: n/a (new session). The user brings `activity.md` + `journal.md`, plus
notes files, `reviews.md`, `user-guide.md`, and `artifacts/` if present (or
legacy `notes.md`). No prior chat context.

Read `notes-files.md` before these steps.

1. Locate files; ask if path/slug is ambiguous. Do not assume this repo's tree.
2. Read `activity.md` fully, RD / Design Decisions / Conventions if present,
   journal only if it has entries. Treat imported `status` as not executable here.
3. Verify progress against this repo (evidence commands). Note drift.
4. Orientation: RD, Scope, design, conventions, claimed vs verified, remaining
   work, safest next action from `# Next Steps`.
5. Place under `.dev-notes/activities/<slug>/`. Repair. Reconcile drift into
   `activity.md` / RD / Conventions. Set `status` to `Planning` and
   `conventions: pending`, unless imported as `Complete` (keep both). Clear
   `prior:` and any blocker from `notes`. Set `synced: none`. Keep
   `review-comments` (Repair default if missing). Ask the user to confirm
   `base-branch` for this repo. Open review cycles stay `open`; report
   them. Append a
   **Catalog** entry if no heading. Append a `Created` event: source and
   drift found.
6. Wait for **Execution gate**. If `Complete` and new work is wanted: `resume-work`.

## `resume-work`

Status: any. **Optional-remind** `apply-review` and `fix-activity`; this
command does not close an open cycle.

### `Paused` / `Blocked`

1. Read `activity.md` and RD / Design Decisions / Conventions. Open journal
   only if it has entries.
2. Concise summary: objective, design, conventions, status, discoveries,
   remaining work, next action, branch hint. `Blocked`: restate the blocker.
3. Wait for explicit confirmation (`Blocked`: blocker resolved).
4. Restore `prior:` (**Paused vs Blocked**); append the resume recap.
5. Reminders: `Planning` → strong model; `Approved` → `conventions-ok` /
   `start-building`.

### `Planning` / `Approved` / `Active`

Reload context only: steps 1–2 above. No status change, no journal.

### `Complete`

Parent stays `Complete` until the choice is clear. **Do not journal yet.**
**Complete stay-on-slug** / sibling: **Material-change**.

1. Same reads as above.
2. Free-text issue, then grill (outcome, why now, in/out, paths, risk, evidence).
3. Classify: minor stay-on-slug vs major `create-sibling`. Do not
   silent-transition.
4. **Sibling:** prompt `create-sibling`. After the user writes it, follow that
   command. Stop (do not reopen this slug).
5. **Stay:** after the user confirms this slug, reopen `Complete` → `Planning`.
   Preserve shipped design and checked milestones. `# Current Plan` /
   `# Next Steps` become: high-level **legacy verify** (re-run/spot-check old
   evidence; do not redo those milestones), then **delta steps** starting at
   the new requirement (including steps that undo earlier work). Mark undone
   milestones `superseded`. Update RD and Design Decisions (`replaces:` if a
   choice flips). Tighten Conventions only if the user states a new or changed
   rule (Setup: best-effort refresh).
6. **Then** append the resume recap (`Complete` → `Planning`; `next:` = start
   step of the delta).
7. **File review** + **Execution gate**.

## `conventions-ok`

Status: `Planning`, `Approved`. Already `conventions: ok`: report and stop
(**Execution gate**).

Read `notes-files.md` before these steps.

1. If rules are thin or Setup is empty, and this fill was not shown in an
   earlier turn: best-effort fill them from the repo. Show the diff. Ask
   the user to review and write `conventions-ok` again. Stop. If the fill
   was already shown, go to step 2.
2. Otherwise set `conventions: ok` in `activity.md`. No journal, no status
   change.
3. If `Approved`, ask for `start-building`.

## `start-building`

Status: `Approved` (`Planning`: require `approve-plan` first).

Read `building.md` before these steps.

1. Need `conventions: ok`. If `pending`, prompt `conventions-ok`; stop.
2. **Optional-remind** `apply-review`.
3. Set `status` to `Active`. Append a `Building` event. Begin engineering.

## `approve-plan`

Status: `Planning` (`Approved` / `Active`: report state; do not rewrite history).

1. Planning outputs are written and reviewed. RD is current and challengeable.
   Send the user back to **File review** when RD is empty, stale, or unreviewed.
   Do the same when the **Problem header** is missing.
   Do the same when the last milestone has no named runnable e2e command.
   Do not approve in those cases.
   A user nod does not replace a missing e2e name.
   Only an explicit user drop waives the e2e.
   Record that reason in `activity.md`.
2. **Optional-remind** `verify-plan` and `apply-review`.
3. Set `status` to `Approved`. Append an `Approved` event (milestone count).
4. One-time note: planning done; user may drop the strong model.
5. Do not implement. Ask for `conventions-ok` if `pending`, then
   `start-building`.

## `pause-work`

Status: `Planning`, `Approved`, `Active` (`Blocked`: already stopped; say
so. `Complete`: no-op; use `resume-work`).

1. Sync `activity.md` and RD / Design Decisions / Conventions if they changed.
2. Set `status` to `Paused` with `prior:` (**Paused vs Blocked**). Resume
   context in `# Next Steps`.
3. Append pause recap (**Journal policy**). Present a short pause summary.
4. **Optional-remind** `apply-review`.

## `mark-completed`

Status: `Active`.

0. An `open` review cycle (regular or fix) → ask the user to run
   `apply-review` or to say `defer`. Stop. On `defer` (next turn): the
   agent marks each open point `noted: deferred`, sets `status: closed`,
   appends a `Review` event, then continues at step 1.
1. Milestones are complete, or the user dropped them with a reason in `activity.md`.
   The last milestone names a runnable e2e command, or the user dropped it in `activity.md`.
   A user nod does not replace a missing e2e name.
   Run that command when the environment can.
2. Rewrite `activity.md` as a maintenance handoff:
   - **Current Design:** shipped behavior, touched paths, must-not-break invariants.
   - **Milestones:** checked/dropped with evidence commands or artifact pointers.
   - **Next Steps:** minor-fix runway (small follow-ups, fastest checks, safest
     first edit targets).
3. Set `status` to `Complete`. Handoff: **Portability**.
4. Append the `Complete` journal entry (**Journal policy**).
   **Optional-remind** `create-guide` and `remove-review-comments`.
5. **Cleanup:** run the `delete-tmp-files` flow.
6. Later fixes: `resume-work` (`Complete` path), then **Execution gate**, then
   `mark-completed` again.
