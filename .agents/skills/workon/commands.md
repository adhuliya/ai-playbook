# workon commands

Keyword steps. Extract one heading with the command in [`SKILL.md`](SKILL.md).
Do not read this file from top to bottom.

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
5. Do not implement. If `conventions: pending`, ask: "Accept the conventions
   too? (`yes` / `review`)". On `yes`, run `conventions-ok` from step 1.
   On `review`, the user runs `conventions-ok` later. Then ask for
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

## `start-review`

Status: any. No status change. No journal. Never applies (**Apply timing**).

Read `review-policy.md` and `subagent-contract.md` before these steps.
Works on the **regular** cycle only; never touches a fix cycle. Cycle
rules: **Reviews**. Usage: `start-review [<milestones>] [manual]`.

0. **Checks:** a fix cycle is `open` → warn that results will need the
   recheck; suggest `apply-review` first. Stop; continue next turn only
   after a yes. A named milestone that is not checked → warn and drop it
   from scope.
1. **Cycle:** if a regular cycle is `open`, refresh it (rewrite `scope:`
   and `state:`). Else append a new `RU<n>` to `reviews.md` with `status:
   open`, `scope:`, and a `state:` note. Scope: named milestones, else the
   **Reviews** default. Nothing in scope and not `Planning` → say so and
   ask whether to open the cycle for user points. Stop; open it next turn
   only after a yes.
2. **Mode:** automated unless the user asks for a manual review (`manual`,
   or plain words such as "I will review it myself"). Manual: mark `open`
   `agent` points from an earlier scope `noted: out of scope`; tell the user
   to add points in `reviews.md` or in chat. Stop.
3. **Automated:** write `inflight.md` (**Inflight scratch**), then run the
   **Review** pipeline in the contract. Re-run overwrites
   `artifacts/review/`.
4. Parent Reads `review/report.md` (or `review/env.md` when `blocked`;
   then record `- none (env blocked)` and stop). Replace the cycle's `open`
   `agent` points with the report's points (`open`). Keep every `user`
   point. Report `- none` → record `- none (agent)`. Delete `inflight.md`.
5. Show the cycle. Say the user MAY add, edit, or strike points, then run
   `apply-review`. Stop.

## `apply-review`

Status: any. No `open` cycle in `reviews.md` → say so; suggest
`start-review`, or adding points to the last closed regular cycle if no
newer regular cycle exists (**Reviews** reopen). Stop.

Read `review-policy.md` before these steps.

Applies and closes **one** cycle (the user may have edited it). Target: the
open fix cycle, else the open regular cycle (**Reviews** fix first). Keyword
is the nod when the points already answer the questions. **Apply timing.**
**Journal policy.** **Complete stay-on-slug.**

1. Read the target cycle. Restate each `open` point with its planned outcome,
   plus remaining work, next action, and status change if any. Ask **only**
   gaps the points do not settle (one round), then stop; after the answers,
   apply next turn (no new keyword). If no gaps, apply in this turn.
2. An `open` point that is **Material-change** → apply **nothing**; ask
   `replan-work` or `create-sibling` (`Complete`: `create-sibling` only).
   Stop. The cycle stays `open`; no status change, no journal.
3. Give every `open` point an outcome (**Reviews** outcome). Apply notes
   edits as each point's `where` says (**Reviews** where a change lands).
   Product work → review milestone `Apply RU<n>`; those points are
   `planned → milestone <k>`. Set `status: closed`.
4. **Status / journal:** one entry only.
   - `Complete` with a new review milestone: `Complete` → `Planning`.
     Rewrite `# Current Plan` / `# Next Steps` as `resume-work` `Complete`
     step 5 (no grill). Append the resume recap citing `RU<n>`. Then
     **Execution gate**.
   - Any other case (including `Paused` / `Blocked`, and `Complete` without
     product work): no status change; append the `Review` event.
5. **Fix cycle only:** refresh `synced` (**`activity.md`** snapshot). Run
   the **Reviews** recheck on the open regular cycle and show the result.
   Say that the next `fix-activity` runs the deferred housekeeping.
6. Keep `artifacts/review/` or `artifacts/fix/review/` (overwritten on the
   next run of that pipeline). Delete only via `delete-tmp-files`.

## `verify-plan`

Status: `Planning`. Optional; not required for `approve-plan`. Isolated
**negative** and **positive** critics (different briefs), then a synthesizer.

Read `review-policy.md` and `subagent-contract.md` before these steps.

Turn-stage, question gate, paths, briefs: **Pipelines** in the contract.
Write `inflight.md` (**Inflight scratch**) before launch; delete it after
the first Read of `synthesis.md`. Parent Reads **only** `synthesis.md` and
filters **Stops**. Accepted and rejected proposals become points per
**Reviews** (where points go): into the open regular cycle if one exists
(applied later by `apply-review`), else a new cycle closed this turn.
Keep assigned files and slice dirs (overwrite on re-run; wipe stale
slices). Delete only via `delete-tmp-files`.

## `add-review-comments` / `remove-review-comments`

Status: `Active`, `Paused`, `Blocked`, `Complete`. No status change, no
journal. Comment-only edits do not need the **Execution gate** or a
`Complete` reopen. Levels: **Engineering while focused** comments.

Read `building.md` and `subagent-contract.md` before these steps.

- `add-review-comments`: raise comments in the activity diff to review
  level. Then set `review-comments: on`.
- `remove-review-comments`: trim comments in the activity diff to default
  level. Then set `review-comments: off`.

1. Resolve `base-branch` (`activity.md`), else `origin/<base-branch>`.
   Neither exists → say so, suggest fixing the row, stop. Empty activity
   diff → say so; stop.
2. Write `inflight.md` (**Inflight scratch**). Run the **Comments**
   pipeline in the contract. Scope: lines the activity added or changed.
   Comments outside that scope stay as they are.
3. Parent Reads **only** `comments/verify.md`. Restore every `fail` file
   from its snapshot. Tests `fail` → restore every file. Delete
   `inflight.md`.
4. Set the row only if at least one file kept its edits. Report: files
   changed, files restored and why. Running the same command again is safe.

## `update-convention`

Status: any (`Complete`: record only; new work still needs `resume-work`).

Read `notes-files.md` before these steps.

1. User text is the source for **rules**. Translate into `CONV<n>` entries.
   Ambiguous wording → one confirm question before writing. Setup command
   corrections need no keyword.
2. Add new entries, or rewrite in place (**Notes files**).
3. Show what changed. Do not start engineering from this command.

## `fix-activity`

Status: any. User-invoked only. No status change. Never edits product code.
Usage: `fix-activity [<what to fix> | tidy]`.

Read `review-policy.md` before these steps.
Read `subagent-contract.md` before step B or E2.
Scope: `activity.md`, RD, Design Decisions, Conventions, `reviews.md`.
Never rewrites the journal (`compact-journal`); appends only `Review` and
`Renumber` events. `notes-by-user.md` is input only.

Brings the activity files back in line with reality after drift since the
last sync. Drift kinds: user edits to activity files; source changes (user
edits, rebase, merge, pulled commits); **major drift** (new repo,
restructured tree, drastic early changes).

**Terms** (this command only): **major drift** = `drift.md` says `major:
yes`. **Plan-impacting finding** = passes the step 4 test. **Unclear
finding** = two plausible readings of a user edit, a source change of
unknown intent, or a fact the repo cannot settle.

**Request** (classify the user's words first):
- **Targeted:** the user names an ID, section, path, or fact to fix.
- **Resync:** bare `fix-activity`, or plain words such as "out of date".
- **Tidy:** `tidy`, or plain words that ask to prune, rewrite, or renumber.
- Mixed request: run the targeted part first, then offer the rest.

**Turn order:**
- Turn 1: classify; T; then the targeted path, the tidy path, or gate 1.
- Gate 1 `scan`: B ends the turn. Next turn: read `drift.md`; D, 2;
  grill unclear findings; route. The fix-cycle route stops at gate 2.
- Then the fix-cycle path (E1–E4) or the inline path (reuse T and step 2).

T. **Triage** (parent, inline, read-only; no sub-agent): take a fresh
   **snapshot** `<now>`. Run A, C, and step 0. Summarize source drift with
   `git diff --stat <synced> <now> -- . ':!.dev-notes'`. Report in ≤ 4
   lines: baseline mode, user edits, changed source paths, consistency
   issues. Baseline `none`: skip the diffs and report that. No findings
   and no targeted request → say the files are in line. Stop.

A. **Baseline** from the `synced` row and its **`synced` base**:
   - `ok`: the base is an ancestor of `HEAD`. Drift = `git diff <synced>
     <now>`.
   - `rewritten`: the commit exists but its base is not an ancestor
     (rebase, force push). Drift = the activity's own changes then vs now:
     `git diff $(git merge-base <synced> <base-branch>) <synced>` against
     the current activity diff. Upstream commits are not drift.
   - `none`: missing row, unknown commit, or no git. Verify everything.
B. **Drift scan:** write `inflight.md` (**Inflight scratch**); run the
   **Drift** pipeline in the contract. Next turn, parent Reads only
   `fix/drift.md`; delete `inflight.md`.
C. **Notes drift** (parent): `git diff <synced> <now> --
   .dev-notes/activities/<slug>/`, limited to the scope files. An
   edit without a matching journal event, `revised-by:`, or `RU` point is a
   **user edit**. Ignore a `# Next Steps` `In progress:` line. A clear user edit is truth unless it contradicts another
   file; contradictions are findings.
D. **Source drift:** each `fail` milestone in `drift.md` is a
   plan-impacting finding. Proposed fix: uncheck it with `regressed:
   <evidence>` and add a review milestone. Moved and missing paths are step
   2 findings.

**Grill rule:** grill with [`grill-me`](../grill-me/SKILL.md) on every
unclear finding before the route, and on every plan-impacting finding
before proposing its fix. One question at a time; recommend an answer;
explore the repo first. Classify each answer: plan-impacting, clear user
edit, or a step 5 item.

**Targeted path:**
1. Propose only what the user named, in the step 5 shape. A plan-impacting
   fix adds its `# Current Plan`, `# Milestones`, and `# Next Steps` edits
   to the same proposal. Grill per the grill rule only when the request is
   unclear. Offer `review` once to run the fix-cycle path instead.
2. On yes: run steps 6, 8, and 9. On `review`: treat it as gate 1
   `scan` and run B; the next turn continues at the route.
3. List other triage findings, one line each; do not act on them. Offer
   `fix-activity` for drift or `fix-activity tidy` once.

**Tidy path:** the inline path with steps 1, 3, and 7. Report triage
drift; do not fix it. When drift exists, recommend a resync first.

**Resync path:**

G1. **Gate 1:** baseline `ok` and no changed source paths → skip the gate
    and run the inline path. Else name the drift scan: one scanner,
    evidence re-runs for checked milestones with changed paths, and a
    review that may follow. Ask `scan`, `inline` (skip the scan), or
    `stop`. Stop the turn.

**Route:** major drift, any plan-impacting finding, or baseline `none`
with at least one checked milestone → **fix-cycle path**. Else →
**inline path**. Baseline `none` with no checked milestone: inline path,
verify every fact in step 2, skip the Setup build.

G2. **Gate 2** (fix-cycle route only): list the findings and the route
    reason. Name the review: env agent, tests, critic pair, synthesizer.
    Ask `review` (run E1–E4), `inline`, or `stop`. Stop the turn.
    `inline`: run the inline path; plan-impacting findings go in the step 5
    proposal with their plan edits. `stop`: `synced` stays unchanged.

**Fix-cycle path** (all drift findings go through review):

E1. Open the fix cycle in `reviews.md` (**Reviews** fix cycle), or refresh
    the open one. Record findings from C, D, 0, and 2 as `agent` points and
    clear user edits as `user` points now, before the launch. A regular
    open cycle stays as is.
E2. Write `inflight.md`. Run the **Review** pipeline with `scope: drift`
    (paths under `fix/`). End the turn.
E3. Parent Reads `fix/review/report.md` and adds its points as `agent`
    points. Env `blocked` → Read `fix/review/env.md`, show it, and add
    `- none (env blocked)` for the report points. Delete `inflight.md`.
    Grill per the grill rule; patch the points with the answers.
E4. Show the cycle. Ask for `apply-review`. Stop. The inline path waits
    for the next `fix-activity` after the fix cycle closes.

**Inline path:** steps 0, 2, 4–6, 8, 9. Steps 1, 3, and 7 run only on
the tidy path. Otherwise, after step 9, offer `fix-activity tidy` once.

0. **Consistency:** find the **Consistency check** issues. Add them to the
   step 5 list as `fix:` items.
1. **Prune:** find redundant entries, entries that fold into another, nits
   recoverable from code or covered elsewhere, superseded entries, and stale
   prose. A pruned milestone keeps its number as a `removed` stub
   (**`activity.md`** Milestones).
2. **Verify** facts against the repo (read-only checks; run nothing that
   changes state):
   - Repo paths in any scope file exist; moved paths resolve via `git log
     --follow` or `rg`.
   - `REF<n>` sources and `artifacts/` copies exist; copies are not missing
     or orphaned.
   - Setup and evidence commands name scripts, targets, and test files that
     exist.
   - `branch` and `base-branch` exist locally or on a remote; `status`,
     `conventions`, `review-comments`, and `prior:` are valid tokens.
   - Every cited ID resolves; checked milestones have evidence.
3. **Rewrite:** find text that breaks **Writing style** or reads unclear
   (vague terms, mixed terms for one concept, long sentences, unclear
   referents). Propose a clearer rewrite that keeps the meaning. If the
   meaning itself is unclear, grill the user (one question at a time,
   recommend an answer) before proposing.
4. **Impact test:** a finding is **plan-impacting** when both hold (step D
   failures always are):
   - It changes an `RD<n>`, a `CONV<n>` rule, Setup, or another load-bearing
     assumption (a `# Current Design` invariant or a Background fact).
   - The change affects `# Current Plan`, `# Milestones`, or `# Next Steps`.

   On the inline path, a new plan-impacting finding from steps 1 or 3 goes
   to gate 2. When the user already chose `inline` there, it joins the
   step 5 proposal with its plan edits. A change to Goal or Scope is
   **Material-change**: skip it and prompt.
5. Show one proposal list: ID or section, action (`delete` | `fold into <ID>`
   | `shorten` | `rewrite` | `fix: <new value>` | `flag: <unresolved>`), why.
   Ask yes / no / mods.
6. Apply only confirmed items. Append-only and `superseded` rules do not
   block pruning. Git is the archive. A change to Goal or Scope is
   **Material-change**: skip it and prompt. Then record confirmed clear
   user edits (from C) to RD, DC, or CONV entries, and applied targeted
   requests, as `user` points of one new closed regular `RU<n>` cycle
   (`applied → <IDs>`), and append its `Review` event. No such items → no
   cycle.
7. Renumber `RD`, `DC`, `CONV`, and `REF` IDs to close gaps (never `RU`
   IDs or milestone numbers). Update every reference in the scope files.
   Append the old → new map to `reviews.md` (**Reviews** renumber log) and
   show it. Append a one-line `Renumber` event pointing at that log.
8. If `notes-by-user.md` cites removed or renumbered IDs or broken paths, tell
   the user and show the map; do not edit it.
9. Refresh `synced` (**`activity.md`** snapshot) when this run applied at
   least one item. Reported drift that was not fixed leaves the baseline;
   say so in the reply. The fix-cycle path skips this step: `synced` stays
   unchanged until `apply-review` closes the fix cycle, so a re-run before
   then still sees the drift.

## `create-guide`

Status: `Active`, `Complete`. No status change, no journal. Shape and
audience: **User guide**.

1. Read `activity.md`, RD, and `conventions.md` Setup. Read shipped
   user-facing docs only where the guide must stay consistent with them.
2. Write `user-guide.md` (rewrite in place). Use runnable commands from
   milestone evidence and Setup. Mark unbuilt parts as planned.
3. Show the file. Stop.

## `delete-tmp-files`

Status: any. Also run by `mark-completed`. No status change, no journal.

1. List temporaries of **this** activity. For each: path, why it looks
   temporary, default.
   - Reserved dirs, **default delete** when done, else **default keep**:
     `review/` and `verify-plan/` when no regular cycle is `open`; `fix/`
     when no fix cycle is `open`; `comments/` when no comment pipeline is
     in flight; `bg/milestone-<n>/` when milestone `<n>` is checked.
   - `inflight.md`: never listed; it is managed by **Inflight scratch**.
   - Snapshot ref `refs/workon/<slug>`: list only when status is `Complete`;
     **default delete**. Delete with `git update-ref -d`. Leave the `synced`
     row; after git prunes the commit, the baseline reads `none`.
   - Legacy `self-review/`, `self-review.md`: **default delete**.
   - Untracked / gitignored leftovers (scratch dirs, sample outputs, dumped
     test artifacts, isolated-setup envs): **default delete**.
   - Uncertain items: **default keep**.
   - **Never** list activity files (`activity.md`, `journal.md`, notes files,
     `reviews.md`, `user-guide.md`), `.agents/`, `.cursor/`, shipped source, real tests,
     docs, or scripts. Other tracked files only if the user points at them.
2. Ask yes / no / mods. Delete only the confirmed set. Confirmed tracked
   paths allow `git rm`. No other `git rm`.
3. Show what was deleted.

## `compact-journal`

Status: any. Not auto-run from `mark-completed`. If already within budget,
say so and stop.

1. Default budget **~12** `##` headings. User may name another number.
2. Keep the **newest** entries **verbatim** (about half the budget: last ~7
   when targeting ~12). Prefer recent `Complete`, `Replan`, and review events.
3. Merge **older** entries into a few summary headings a future agent can use:
   shipped outcomes (paths, behavior, decisions, accepted gaps); one line per
   milestone or review cycle (`Milestone 2: <outcome>`, `RU3: 4 applied, 1
   rejected`); one line `paused N, resumed N, completed N`. Drop plan/status
   prose that `activity.md` already holds.
4. Show the proposed compacted file. Write **in place** only after the user nods.
   Git is the archive unless the user asks for an `artifacts/` snapshot.

## `query-work` / `no-query-work`

Status: any. Session flag; behavior: **Stops**. Status unchanged.

## `help`

Status: any; read-only; no focused activity needed.

- `help`: tell the user what to do next in the current state. Cap ~5 lines:
  one state line (slug, status, `conventions`), then 1–3 next actions from
  the table below. Check rows top-down; the first match wins. End with one
  line: `help intro` for basics, `help all` for every command.
- `help intro`: teach the basic path in ≤ 8 lines. Name only these steps:
  1. Describe the work in plain words (e.g. `workon add CSV export`).
     Answer the questions, then review the drafted files.
  2. `approve-plan`: accept the plan. Answer `yes` to accept the rules too.
  3. `start-building`: the agent builds and tests.
  4. `mark-completed`: close the work when the tests pass.

  Add: type `help` at any time for the next step. Teach no other commands.
- `help all`: print the **Command map** tables from `SKILL.md`. If an
  activity is focused, mark the commands its status allows (`Status:` lines
  in the extracted heading). Rows with `Status: any`, `n/a`, or no heading (natural language)
  are always allowed.
- `help <command>`: explain that command in 2–5 sentences from that command's heading: when to use it, what it changes, and what it needs first.

| State | Next actions |
|---|---|
| Query mode on | Read and ask freely. `no-query-work` to allow edits. |
| Pipeline in flight | Wait for the named pipeline, or ask to abandon it. |
| Fix cycle `open` | Review its points in `reviews.md`; then `apply-review` (applies drift fixes first). |
| Regular cycle `open` | Add or edit points; then `apply-review`. |
| No focused activity | Name an activity to switch to it, or describe new work to create one. |
| `Planning` | Answer open questions; review the files and give feedback. Then `approve-plan` (it offers to accept the conventions if `pending`). |
| `Approved` | `conventions-ok` if `pending`; then `start-building`. |
| `Active` | Give feedback or say continue. `start-review` after a milestone. `mark-completed` when all milestones and the e2e pass and no review cycle is open. `pause-work` to stop. |
| `Paused` | `resume-work`. |
| `Blocked` | Resolve the blocker in `notes` (quote it); then `resume-work`. |
| `Complete` | `resume-work` to fix or extend; `create-guide` if `user-guide.md` is missing. |

Add one optional line when it applies: an `open` review cycle →
`apply-review`; `review-comments: on` at `Active` with all milestones checked
→ `remove-review-comments`; `Planning` with no `verify-plan` this session →
`verify-plan`.
