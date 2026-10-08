# workon commands

Sequences for reserved keywords. Policy: [`SKILL.md`](SKILL.md) (**Named policy**
headings). Shapes: [`templates.md`](templates.md). Turn-stage:
[`subagent-contract.md`](subagent-contract.md).

Read the matching heading before executing that keyword. Apply named policies;
do not restate them.

**Every command:** needs a focused activity (except `help`, `import-activity`,
`query-work`, `no-query-work`). **Stops** apply (`query-work`, **Pipeline in
flight**). **Notes files** Repair runs first. Status outside the `Status:`
line → report status and stop.

## `replan-work`

Status: `Planning`, `Approved`, `Active`, `Paused`, `Blocked`.
In-flight major scope change. **Material-change.**

1. Remind strong model.
2. Re-run **Planning quality bar** from the top. **Cited context** if cited.
3. Rewrite ARD, `# Scope`, and affected `activity.md` sections. Append Design
   Decisions. Update Conventions (rules + Setup) from observed facts and
   user-confirmed rules. If **Goal** changed, patch that one **Catalog** entry.
4. If status is not `Planning`, reopen to `Planning` and record the reason in
   `activity.md`. Append a `Replan` event: why, changed IDs (**Journal
   policy**).
5. File review + **Execution gate** before engineering.

## `self-review`

Status: any. No status change. No journal. Activity files stay frozen.

Turn-stage, paths, briefs: **Pipelines** in the contract.

If `self-review.md` already exists, overwrite on re-run (working files too).
Parent Reads **only** `self-review.md`. Show it. Stop. User may edit the file.
Wait for `apply-review` (**Apply timing**).

## `apply-review`

Status: any. Missing `artifacts/self-review.md` → stop.

Applies **remaining** proposals in that file (user may have edited it). Not
product code. Keyword is the nod when the report already answers resume
questions. **Apply timing.** **Journal policy.** **Complete stay-on-slug.**

1. Read `self-review.md`. Restate: outcome, remaining work, next action,
   status change if any. Ask **only** gaps the report does not settle (one
   round). If no gaps, apply in this turn.
2. A remaining proposal that is **Material-change** → apply **nothing**; ask
   `replan-work` or `create-sibling` (`Complete`: `create-sibling` only).
3. Apply the rest to `activity.md` and agent-drafted notes files as each
   proposal's `where` says. Record the cycle as `SR<n>` in `reviews.md`; add a
   review milestone if needed (**Reviews**).
4. **Status / journal:** one entry only. With a status change, the resume
   recap replaces the `Self review` event and cites `SR<n>`.
   - `Paused` / `Blocked`: restore `prior:` (**Paused vs Blocked**); append
     resume recap. Engineer this turn only if the restored status is `Active`.
   - `Complete`: stay-on-slug. `Complete` → `Planning`; append resume recap.
     Then **Execution gate** before engineering.
   - `Planning` / `Approved` / `Active`: no status change; append the
     `Self review` event.
5. Keep `self-review.md` and `artifacts/self-review/` (overwrite on next
   `self-review`). Delete only via `delete-tmp-files`.

## `query-work` / `no-query-work`

Status: any. Session flag; behavior: **Stops**. Status unchanged.

## `create-sibling`

Status: any. Derived `activity.md` + ARD / Design Decisions / Conventions
must stand alone (no "see parent"). Slug: `{parent-slug}-{short-suffix}`
kebab-case. Propose; user may override.

1. Remind strong model.
2. Read source `activity.md`, `requirements.md`, `design-choices.md`,
   `conventions.md` once. Open its journal only if it has entries. Do not copy
   `notes-by-user.md` or `reviews.md`.
3. **Planning quality bar** for the **new** scope (fresh intake; do not inherit fuzz).
4. Rewrite all required sections and a fresh ARD. Copy still-applicable
   decisions **and conventions** (rules + Setup) inline, not as pointers.
   User may drop or rewrite conventions on the sibling. Number **IDs** fresh
   from 1.
5. Fresh `notes-by-user.md` (H1 only). Fresh `journal.md` with one
   `Created` event naming the parent slug. `status: Planning`,
   `conventions: pending`, new slug. Provenance: **Complete sibling**
   (`derived-from:` rule). Append one **Catalog** entry.
6. **draft-check:** derived files stand if the source were deleted.
7. File review + revision loop.

In-flight parent: mark moved ARD entries and milestones `superseded`; status
unchanged. If the parent Goal changes → **Material-change** (`replan-work`).

## `import-activity`

Status: n/a (new session). The user brings `activity.md` + `journal.md`, plus
notes files, `reviews.md`, `user-guide.md`, and `artifacts/` if present (or
legacy `notes.md`). No prior chat context.

1. Locate files; ask if path/slug is ambiguous. Do not assume this repo's tree.
2. Read `activity.md` fully, ARD / Design Decisions / Conventions if present,
   journal only if it has entries. Treat imported `status` as not executable here.
3. Verify progress against this repo (evidence commands). Note drift.
4. Orientation: ARD, Scope, design, conventions, claimed vs verified, remaining
   work, safest next action from `# Next Steps`.
5. Place under `.dev-notes/activities/<slug>/`. Repair. Reconcile drift into
   `activity.md` / ARD / Conventions. Set `status` to `Planning` and
   `conventions: pending`, unless imported as `Complete` (keep both). Append a
   **Catalog** entry if no heading. Append a `Created` event: source and
   drift found.
6. Wait for **Execution gate**. If `Complete` and new work is wanted: `resume-work`.

## `resume-work`

Status: any. **Optional-remind** `apply-review`; this command does not apply
that report.

### `Paused` / `Blocked`

1. Read `activity.md` and ARD / Design Decisions / Conventions. Open journal
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
   milestones `superseded`. Update ARD and Design Decisions (`replaces:` if a
   choice flips). Tighten Conventions only if the user states a new or changed
   rule (Setup: best-effort refresh).
6. **Then** append the resume recap (`Complete` → `Planning`; `next:` = start
   step of the delta).
7. File review + **Execution gate**.

## `conventions-ok`

Status: `Planning`, `Approved`. Already `conventions: ok`: report and stop
(**Execution gate**).

1. If rules are thin or Setup is empty, best-effort fill them from the repo.
   Show the diff. Ask the user to review and write `conventions-ok` again.
   Stop.
2. Otherwise set `conventions: ok` in `activity.md`. No journal, no status
   change.
3. If `Approved`, ask for `start-building`.

## `start-building`

Status: `Approved` (`Planning`: require `approve-plan` first).

1. Need `conventions: ok`. If `pending`, prompt `conventions-ok`; stop.
2. **Optional-remind** `apply-review`.
3. Set `status` to `Active`. Append a `Building` event. Begin engineering.

## `approve-plan`

Status: `Planning` (`Approved` / `Active`: report state; do not rewrite history).

1. Planning outputs written and reviewed; ARD current and challengeable. Empty,
   stale, or unreviewed ARD, or a last milestone without e2e (**Test
   evidence**) → back to file review; do not approve.
2. **Optional-remind** `verify-plan` and `apply-review`.
3. Set `status` to `Approved`. Append an `Approved` event (milestone count).
4. One-time note: planning done; user may drop the strong model.
5. Do not implement. Ask for `conventions-ok` if `pending`, then
   `start-building`.

## `update-convention`

Status: any (`Complete`: record only; new work still needs `resume-work`).

1. User text is the source for **rules**. Translate into `CONV<n>` entries.
   Ambiguous wording → one confirm question before writing. Setup command
   corrections need no keyword.
2. Add new entries, or rewrite in place (**Notes files**).
3. Show what changed. Do not start engineering from this command.

## `verify-plan`

Status: `Planning`. Optional; not required for `approve-plan`. Isolated
**negative** and **positive** critics (different briefs), then a synthesizer.

Turn-stage, question gate, paths, briefs: **Pipelines** in the contract. Parent Reads **only** `synthesis.md` and filters **Stops**. Keep
assigned files and slice dirs (overwrite on re-run; wipe stale slices).
Delete only via `delete-tmp-files`.

## `pause-work`

Status: `Planning`, `Approved`, `Active`, `Blocked` (`Complete`: no-op; use
`resume-work`).

1. Sync `activity.md` and ARD / Design Decisions / Conventions if they changed.
2. Set `status` to `Paused` with `prior:` (**Paused vs Blocked**). Resume
   context in `# Next Steps`.
3. Append pause recap (**Journal policy**). Present a short pause summary.
4. **Optional-remind** `apply-review`.

## `mark-completed`

Status: `Active`.

1. Milestones complete or explicitly dropped (reason in `activity.md`).
   **Test evidence** e2e rule applies.
2. Rewrite `activity.md` as a maintenance handoff:
   - **Current Design:** shipped behavior, touched paths, must-not-break invariants.
   - **Milestones:** checked/dropped with evidence commands or artifact pointers.
   - **Next Steps:** minor-fix runway (small follow-ups, fastest checks, safest
     first edit targets).
3. Set `status` to `Complete`. Handoff: **Portability**.
4. Append the `Complete` journal entry (**Journal policy**).
   **Optional-remind** `create-guide`.
5. **Cleanup:** run the `delete-tmp-files` flow.
6. Later fixes: `resume-work` (`Complete` path), then **Execution gate**, then
   `mark-completed` again.

## `create-guide`

Status: `Active`, `Complete`. No status change, no journal. Shape and
audience: **User guide**.

1. Read `activity.md`, ARD, and `conventions.md` Setup. Read shipped
   user-facing docs only where the guide must stay consistent with them.
2. Write `user-guide.md` (rewrite in place). Use runnable commands from
   milestone evidence and Setup. Mark unbuilt parts as planned.
3. Show the file. Stop.

## `delete-tmp-files`

Status: any. Also run by `mark-completed`. No status change, no journal.

1. List temporaries of **this** activity. For each: path, why it looks
   temporary, default.
   - Reserved `verify-plan/`, `self-review/`, `self-review.md`, `bg/`:
     **default delete** if `Complete` or already applied (a matching `SR<n>`
     cycle exists in `reviews.md`, or the milestone is checked); else
     **default keep**.
   - Untracked / gitignored leftovers (scratch dirs, sample outputs, dumped
     test artifacts, isolated-setup envs): **default delete**.
   - Uncertain items: **default keep**.
   - **Never** list activity files (`activity.md`, `journal.md`, notes files,
     `reviews.md`, `user-guide.md`), `.cursor/`, shipped source, real tests,
     docs, or scripts. Other tracked files only if the user points at them.
2. Ask yes / no / mods. Delete only the confirmed set. Confirmed tracked
   paths allow `git rm`. No other `git rm`.
3. Show what was deleted.

## `fix-notes`

Status: any. User-invoked only. No status change. Scope: `activity.md`, ARD,
Design Decisions, Conventions, `reviews.md`. Not the journal
(`compact-journal`) and not `notes-by-user.md`.

0. **Consistency:** find the **Consistency check** issues. Add them to the
   step 4 list as `fix:` items.
1. **Prune:** find redundant entries, entries that fold into another, nits
   recoverable from code or covered elsewhere, superseded entries, and stale
   prose.
2. **Verify** facts against the repo (read-only checks; run nothing that
   changes state):
   - Repo paths in any scope file exist; moved paths resolve via `git log
     --follow` or `rg`.
   - `REF<n>` sources and `artifacts/` copies exist; copies are not missing
     or orphaned.
   - Setup and evidence commands name scripts, targets, and test files that
     exist.
   - `branch` exists locally or on a remote; `status`, `conventions`, and
     `prior:` are valid tokens.
   - Every cited ID resolves; checked milestones have evidence.
3. **Rewrite:** find text that breaks **Writing style** or reads unclear
   (vague terms, mixed terms for one concept, long sentences, unclear
   referents). Propose a clearer rewrite that keeps the meaning. If the
   meaning itself is unclear, grill the user (one question at a time,
   recommend an answer) before proposing.
4. Show one proposal list: ID or section, action (`delete` | `fold into <ID>`
   | `shorten` | `rewrite` | `fix: <new value>` | `flag: <unresolved>`), why.
   Ask yes / no / mods.
5. Apply only confirmed items. Append-only and `superseded` rules do not
   block pruning. Git is the archive. A change to Goal or Scope is
   **Material-change**: skip it and prompt.
6. Renumber each ID kind to close gaps. Update every reference in the scope
   files. Append the old → new map to `reviews.md` (**Reviews** renumber log)
   and show it. Append a one-line `Renumber` event pointing at that log.
7. If `notes-by-user.md` cites removed or renumbered IDs or broken paths, tell
   the user and show the map; do not edit it.

## `help`

Status: any; read-only; no focused activity needed.

- `help`: tell the user what to do next in the current state. Cap ~5 lines:
  one state line (slug, status, `conventions`), then 1–3 next actions from
  the table below. Check rows top-down; the first match wins. End with one
  line: `help intro` for basics, `help all` for every command.
- `help intro`: teach the basic path in ≤ 8 lines. Name only these steps:
  1. Describe the work in plain words (e.g. `workon add CSV export`).
     Answer the questions, then review the drafted files.
  2. `approve-plan` and `conventions-ok`: accept the plan and the rules.
  3. `start-building`: the agent builds and tests.
  4. `mark-completed`: close the work when the tests pass.

  Add: type `help` at any time for the next step. Teach no other commands.
- `help all`: print the **Command map** tables from `SKILL.md`. If an
  activity is focused, mark the commands its status allows (`Status:` lines
  here).
- `help <command>`: explain that command in 2–5 sentences from its heading
  here: when to use it, what it changes, and what it needs first.

| State | Next actions |
|---|---|
| Query mode on | Read and ask freely. `no-query-work` to allow edits. |
| Pipeline in flight | Wait for the named pipeline, or ask to abandon it. |
| No focused activity | Name an activity to switch to it, or describe new work to create one. |
| `Planning` | Answer open questions; review the files and give feedback. Then `approve-plan` (and `conventions-ok` if `pending`). |
| `Approved` | `conventions-ok` if `pending`; then `start-building`. |
| `Active` | Give feedback or say continue. `mark-completed` when all milestones and the e2e pass. `pause-work` to stop. |
| `Paused` | `resume-work`. |
| `Blocked` | Resolve the blocker in `notes` (quote it); then `resume-work`. |
| `Complete` | `resume-work` to fix or extend; `create-guide` if `user-guide.md` is missing. |

Add one optional line when it applies: an unapplied `self-review.md` →
`apply-review`; `Planning` with no `verify-plan` this session → `verify-plan`.

## `compact-journal`

Status: any. Not auto-run from `mark-completed`. If already within budget,
say so and stop.

1. Default budget **~12** `##` headings. User may name another number.
2. Keep the **newest** entries **verbatim** (about half the budget: last ~7
   when targeting ~12). Prefer recent `Complete`, `Replan`, and review events.
3. Merge **older** entries into a few summary headings a future agent can use:
   shipped outcomes (paths, behavior, decisions, accepted gaps); one line per
   milestone or review cycle (`Milestone 2: <outcome>`, `UR3: 4 applied, 1
   rejected`); one line `paused N, resumed N, completed N`. Drop plan/status
   prose that `activity.md` already holds.
4. Show the proposed compacted file. Write **in place** only after the user nods.
   Git is the archive unless the user asks for an `artifacts/` snapshot.
