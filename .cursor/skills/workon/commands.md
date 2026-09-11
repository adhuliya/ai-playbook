# workon commands

Sequences for reserved keywords. Policy: [`SKILL.md`](SKILL.md) (**Named policy**
headings). Shapes: [`templates.md`](templates.md). Turn-stage:
[`subagent-contract.md`](subagent-contract.md).

Read the matching heading before executing that keyword. Apply named policies;
do not restate them.

## `replan-work`

In-flight major scope change only (not after `Complete`). **Material-change.**

1. Remind strong model.
2. Re-run **Planning quality bar** from the top. **Cited context** if cited.
3. Rewrite ARD, `# Scope`, and affected `activity.md` sections. Append Design
   Decisions; do not delete old ones. Update Conventions (rules + Setup)
   from observed facts and user-stated or confirmed rules (rewrite in place
   if they tighten). If **Goal** changed, patch that one **Catalog** entry via
   `rg`.
4. If status is not `Planning`, reopen to `Planning` and record the reason in
   `activity.md` (this command does not journal).
5. File review + **Execution gate** before engineering.

## `self-review`

Gated. Any status. Not during `query-work`. No status change. No journal.
**Do not** edit `activity.md`, `journal.md`, notes files, or `activities.md`
(**Notes files** Repair first, then freeze). **draft-check** is not this pipeline.

Turn-stage, paths, briefs: **Parent orchestration** in the contract.

If `self-review.md` already exists, overwrite on re-run (working files too).
Parent Reads **only** `self-review.md`. Show it. Stop. User may edit the file.
Wait for `apply-review`. **Apply timing:** never apply from `self-review`.

## `apply-review`

Gated. Focused activity; not during `query-work`. Missing
`artifacts/self-review.md` → stop.

Applies **remaining** proposals in that file (user may have edited it). Not
product code. Keyword is the nod when the report already answers resume
questions. **Apply timing.** **Journal policy.** **Complete stay-on-slug.**

1. Read `self-review.md`. Restate: outcome, remaining work, next action,
   status change if any. Ask **only** gaps the report does not settle (one
   round). If no gaps, apply in this turn.
2. A remaining proposal that is **Material-change** → apply **nothing**; ask
   `replan-work` or `create-sibling` (Complete: `create-sibling` only).
3. Apply the rest to `activity.md` and notes files as each proposal’s
   `where` says. Design Decisions stay append-only. Setup/rules via
   rewrite-in-place when that is the proposal. Never prune `user-notes.md`.
4. **Status / journal:**
   - `Paused`: restore pre-pause status from the pause recap heading; append
     resume recap; apply. Engineer this turn only if restored status is
     already `Active`.
   - `Complete`: stay-on-slug. `Complete` → `Planning`; append resume recap;
     apply. No sibling. Then **Execution gate** before engineering.
   - `Planning` / `Approved` / `Active`: apply; no status change; no journal.
     In-flight = in-scope plan refresh, not `replan-work`.
5. If already resumed (`resume-work` earlier) and still `Active` /
   `Approved` / `Planning`: apply only; no second journal recap.
6. Keep `self-review.md` and `artifacts/self-review/` (overwrite on next
   `self-review`). Do not delete until `mark-completed` cleanup.

## `query-work` / `no-query-work`

Session read-only until `no-query-work` or session end. Status unchanged.
Any mutation (activity files, product code, git, gated keywords) → say query
mode is on and ask for `no-query-work`.

## `create-sibling`

Derived `activity.md` + ARD / Design Decisions / Conventions must stand alone
(no "see parent"). `derived-from: <slug>` in `# References` is non-load-bearing
only.

Slug: `{parent-slug}-{short-suffix}` kebab-case. Propose; user may override.

1. Remind strong model.
2. Read source `activity.md`, `requirements.md`, `design-choices.md`,
   `conventions.md` once. Open its journal only if it has entries past
   `# Journal`. Do not copy `user-notes.md` (fresh `# User Notes` only).
3. **Planning quality bar** for the **new** scope (fresh intake; do not inherit fuzz).
4. Rewrite all required sections and a fresh ARD. Copy still-applicable
   decisions **and conventions** (rules + Setup) inline, not as pointers.
   User may drop or rewrite conventions on the sibling.
5. Fresh `journal.md` (`# Journal` only). `status: Planning`, new slug.
   Provenance: `derived-from: <parent-slug>` only. **Never** add a sibling pointer
   on the parent. Append one **Catalog** entry.
6. **draft-check:** derived files stand if the source were deleted.
7. File review + revision loop.

If the source is `Complete`, it stays `Complete`. No parent journal write.

## `import-activity`

New session; user brings `activity.md` + `journal.md` (notes files if
present, or legacy `notes.md`). No prior chat context. Do not journal the
import.

1. Locate files; ask if path/slug is ambiguous. Do not assume this repo's tree.
2. Read `activity.md` fully, ARD / Design Decisions / Conventions if present,
   journal only if it has entries. Treat imported `status` as not executable here.
3. Verify progress against this repo (evidence commands). Note drift.
4. Orientation: ARD, Scope, design, conventions, claimed vs verified, remaining
   work, safest next action from `# Next Steps`.
5. Place under `.dev-notes/activities/<slug>/` if needed. Reconcile drift into
   `activity.md` / ARD / Conventions. Set `status` to `Planning` — unless the
   imported status is `Complete`, which stays `Complete`. Apply **Notes files**
   Repair. Append **Catalog** entry if no heading.
6. Wait for **Execution gate**. If import is `Complete` and they want new work,
   apply `resume-work` (`Complete`) before engineering.

## Resume (`resume-work`)

`pause-work` on `Complete` is a no-op: already completed; use `resume-work`.
**Optional-remind** `apply-review`; do not require it; this command does not
apply that report. Apply **Notes files** Repair.

### Not `Complete`

1. Read `activity.md` and ARD / Design Decisions / Conventions. Open journal
   only if it has entries. User Notes only if needed.
2. Concise summary: objective, design, conventions, status, discoveries,
   remaining work, next action, branch hint.
3. Wait for explicit confirmation before engineering.
4. Then append the resume recap (**Journal policy**).
5. Reminders: `Planning` / replan → strong model; `Approved` → ask
   `start-building`; `Blocked` → restate the blocker and confirm it is
   resolved before clearing back to the prior status (**Paused vs Blocked**).

### `Complete`

Parent stays `Complete` until the choice is clear. **Do not journal yet.**
**Complete stay-on-slug** / sibling: **Material-change**.

1. Same reads as above.
2. Free-text issue, then grill (outcome, why now, in/out, paths, risk, evidence).
3. Classify: minor stay-on-slug vs major `create-sibling`. Parent stays
   `Complete` until they choose. Do not silent-transition.
4. **Sibling:** prompt `create-sibling`. After they write it, follow that
   command. Stop (do not reopen this slug).
5. **Stay:** after they confirm this slug, reopen `Complete` → `Planning`.
   Preserve shipped design and checked milestones. `# Current Plan` /
   `# Next Steps` become: high-level **legacy verify** (re-run/spot-check old
   evidence; do not redo those milestones), then **delta steps** starting at
   the new requirement (including steps that undo earlier work). Mark undone
   milestones `superseded`. Update ARD and Design Decisions (`replaces:` if a
   choice flips). Tighten Conventions only if the user states a new or changed
   rule (Setup: best-effort refresh).
6. **Then** append the resume recap (`Complete` → `Planning`; `next:` = start
   step of the delta).
7. File review + **Execution gate**.

## `start-building`

1. Need `Approved`. If `Planning`, require `approve-plan` first.
2. **Conventions / Setup — before any engineering:**
   Apply **Notes files** Repair. Best-effort fill thin rules or empty Setup
   from the repo. Show the diff. If this message already answered it,
   acknowledge and continue; otherwise wait for a nod or edits, then proceed.
3. **Optional-remind** `apply-review`.
4. Set `status` to `Active`. Begin engineering only after this command and
   the checkpoint.

## `approve-plan`

1. Planning outputs written and reviewed; ARD current and challengeable. Empty,
   stale, or unreviewed ARD → back to file review; do not approve. Last
   milestone must name e2e (and any interface fake) per **Test evidence**;
   missing → back to file review.
2. **Optional-remind** `verify-plan` and `apply-review`. Then honor
   `approve-plan`.
3. Set `status` to `Approved`.
4. One-time note: planning done; user may drop the strong model.
5. Do not implement; ask for `start-building`.
6. Already `Approved` or `Active`: report state; do not rewrite history.

## `follow-convention`

Gated. Focused activity; not during `query-work`. Any status (on `Complete`,
record only — new work still needs Resume).

1. Apply **Notes files** Repair.
2. User text is the source for **rules**. Translate into named convention
   entries (**Prose density**). Ambiguous wording → one confirm question
   before writing. Setup command corrections may be written into the Setup
   H2 without this keyword.
3. Add new rule entries, or rewrite in place per **Notes files**.
4. Show what changed. Do not start engineering from this command.

## `verify-plan`

Not `self-review` (**Apply timing**). Optional. `Planning` only. If status is
not `Planning`: report current status and stop. Not required for
`approve-plan`. Not during `query-work`. Isolated **negative** and **positive**
critics (different briefs), then a synthesizer.

Turn-stage, question gate, paths, briefs: **Parent orchestration** in the
contract. Parent Reads **only** `synthesis.md` (not critic bodies, not slice
dirs), filters **Stops**. Keep assigned files and slice dirs (overwrite on
re-run; wipe stale slices). Delete only at `mark-completed` cleanup after
confirm.

## `pause-work`

If `Complete`: no-op (see Resume). Otherwise:

1. Sync `activity.md` and ARD / Design Decisions / Conventions if they changed.
2. Set `status` to `Paused`. Resume context in `# Next Steps` (and `notes` if needed).
3. Append pause recap (**Journal policy**). Present a short pause summary.
4. **Optional-remind** `apply-review`.

## `mark-completed`

1. Milestones complete or explicitly dropped (reason in `activity.md`). Apply
   **Test evidence**: no `Complete` without named, runnable e2e unless the user
   drops it. Run evidence when the env can; do not treat a nod as a substitute
   for a missing e2e name.
2. Rewrite `activity.md` as a maintenance handoff:
   - **Current Design:** shipped behavior, touched paths, must-not-break invariants.
   - **Milestones:** checked/dropped with evidence commands or artifact pointers.
   - **Next Steps:** minor-fix runway (small follow-ups, fastest checks, safest
     first edit targets).
3. Set `status` to `Complete`. Keep ARD, Design Decisions, and Conventions.
   Do not prune User Notes. Durable handoff is the activity/journal/notes
   files; review/env/bg artifacts are not needed after this.
4. Append the `mark-completed` journal entry (**Journal policy**).
5. **Cleanup (confirm):** list **untracked / gitignored** leftovers from **this**
   activity (scratch dirs, sample outputs, dumped test artifacts) **and**, as
   **default-delete**, these records if present:
   - `artifacts/self-review.md`
   - `artifacts/self-review/`
   - `artifacts/verify-plan/`
   - `artifacts/bg/`
   For each: path + why it looks dangling. Uncertain other items: list as
   **uncertain (default keep)**. User picks a subset (including none). Delete
   only that subset. If default-delete paths are tracked, confirming them
   **does** allow `git rm`.
   **Never** list `activity.md` / `journal.md` / `requirements.md` /
   `design-choices.md` / `conventions.md` / `user-notes.md`, `.cursor/`,
   shipped tracked source, real tests, docs, or scripts. Other tracked files
   only if the user points at them. No `git rm` of those unless they
   explicitly selected them.
6. Later fixes: `resume-work` (Complete path), then **Execution gate**, then
   `mark-completed` again.

## `compact-journal`

Gated rewrite of this activity's `journal.md`. Not auto-run from `mark-completed`.
If already within budget, say so and stop.

1. Default budget **~12** `##` headings. User may name another number.
2. Keep the **newest** entries **verbatim** (about half the budget: last ~7
   when targeting ~12). Prefer recent pause/resume/`mark-completed` recaps.
3. Merge **older** entries into a few summary headings a future agent can use:
   shipped outcomes (paths, behavior, decisions, accepted gaps) plus one line
   `paused N, resumed N, completed N`. Drop plan/status prose that `activity.md`
   already holds.
4. Show the proposed compacted file. Write **in place** only after the user nods.
   Git is the archive unless they ask for an `artifacts/` snapshot.
