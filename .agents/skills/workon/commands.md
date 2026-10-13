# workon commands

One heading per keyword, plus `create` and `list` for natural language.
Load one heading with `load <keyword>` ([`SKILL.md`](SKILL.md)); its
`Reads:` line names the sections that come with it. Never read this file
whole.

## `create`

Status: n/a (natural language: the user describes new work).

Reads: planning.md; notes-files.md; building.md#Test evidence; Catalog; records.md#activity.md; IDs; Journal policy; Reminders; Execution gate; templates.md

Follow the **Create sequence**.

## `list`

Status: n/a; read-only.

Reads: Catalog

Run `list` (`list --all` when the user asks for `Complete`) and show the
table. For one activity, follow **Details**.

## `build`

Status: `Active` (an engineering turn with no keyword: "continue", a
milestone, a fix).

Reads: building.md; subagent-contract.md; Update cadence; Journal policy; records.md#activity.md

Follow **Engineering while focused** and **Test evidence**. Run each
milestone through the **Milestone** pipeline; checkpoint per
**Update cadence**.

## `feedback`

Status: any (the user comments in chat on activity files or built work).

Reads: review-policy.md; Journal policy

Record the feedback per **Reviews** (where points go) and **Apply timing**.

## `replan-work`

Status: `Planning`, `Approved`, `Active`, `Paused`, `Blocked`.

Reads: planning.md; notes-files.md; building.md#Test evidence; Material-change; Journal policy; Catalog; Reminders; Execution gate

This is the in-flight **Material-change**.

1. Remind strong model. If the status is not `Planning`, set `Planning` now
   (this stops engineering) and record the reason in `activity.md`. Clear
   `prior:` and any blocker from `notes`.
2. Re-run the **Planning quality bar** from the top. Run **Cited context**
   when files are cited.
3. Rewrite RD, `# Scope`, and the affected `activity.md` sections. Append
   Design Decisions. Update Conventions (rules and Setup) from observed
   facts and user-confirmed rules. If the Goal changed, patch that one
   **Catalog** entry.
4. Append a `Replan` event: why, changed IDs, old status (**Journal policy**).
5. **File review**, then the **Execution gate** before engineering.

## `create-sibling`

Status: any. The derived `activity.md`, RD, Design Decisions, and
Conventions must stand alone (no "see parent"). Propose the slug
`{parent-slug}-{short-suffix}` in kebab-case; the user may override.

Reads: planning.md; notes-files.md; building.md#Test evidence; Material-change; Catalog; IDs; Journal policy; Reminders; templates.md#journal.md

1. Remind strong model.
2. Read the source `activity.md`, `requirement-def.md`,
   `design-choices.md`, and `conventions.md` once; open its journal only if
   it has entries. Do not copy `notes-by-user.md` or `reviews.md`.
3. Run the **Planning quality bar** for the new scope as a fresh intake; do
   not inherit fuzz.
4. Rewrite all required sections and a fresh RD with its own
   **Problem header**. Copy still-applicable decisions and conventions (rules
   and Setup) inline, not as pointers; the user may drop or rewrite
   conventions on the sibling. Number **IDs** fresh from 1.
5. Create a fresh `notes-by-user.md` (H1 only) and a fresh `journal.md` with
   one `Created` event that names the parent slug. Set `status: Planning`,
   `conventions: pending`, `review-comments: on`, a `synced` snapshot, and
   the new slug. Copy `base-branch`; the user may change it. Provenance
   follows **Complete sibling** (`derived-from:`). Append one **Catalog**
   entry.
6. **draft-check:** the derived files stand if the source were deleted.
7. In-flight parent only: mark moved RD entries and milestones `superseded`
   in the parent; status unchanged; no parent journal. If the parent Goal
   changes, that is a **Material-change** (`replan-work`).
8. Switch focus to the sibling and announce it. **File review** and the
   revision loop.

## `import-activity`

Status: n/a (new session). The user brings `activity.md` and `journal.md`,
plus notes files, `reviews.md`, `user-guide.md`, and `artifacts/` if
present (or a legacy `notes.md`). There is no prior chat context.

Reads: notes-files.md; Catalog; Journal policy; Execution gate

1. Locate the files; ask when the path or slug is ambiguous. Do not assume
   this repo's tree.
2. Read `activity.md` fully, RD / Design Decisions / Conventions if present,
   and the journal only if it has entries. Treat the imported `status` as
   not executable here.
3. Verify progress against this repo with evidence commands. Note drift.
4. Orient the user: RD, Scope, design, conventions, claimed vs verified,
   remaining work, safest next action from `# Next Steps`.
5. Place the files under `.dev-notes/activities/<slug>/` and run
   **Repair**. Reconcile drift into `activity.md`, RD, and Conventions. Set
   `status` to `Planning` and `conventions: pending`, unless imported as
   `Complete` (keep both). Clear `prior:` and any blocker from `notes`. Set
   `synced: none`. Keep `review-comments` (probe default if missing). Ask
   the user to confirm `base-branch` for this repo. Open review cycles stay
   `open`; report them. Append a **Catalog** entry if no heading exists.
   Append a `Created` event: source and drift found.
6. Wait for the **Execution gate**. If `Complete` and new work is wanted:
   `resume-work`.

## `resume-work`

Status: any. **Optional-remind** `apply-review` and `fix-activity`; this
command does not close an open cycle.

Reads: Paused vs Blocked; Material-change; Journal policy; Reminders; Execution gate; templates.md#journal.md

### `Paused` / `Blocked`

1. Read `activity.md` and RD / Design Decisions / Conventions. Open the
   journal only if it has entries.
2. Summarize concisely: objective, design, conventions, status,
   discoveries, remaining work, next action, branch hint. `Blocked`: restate
   the blocker.
3. Wait for explicit confirmation (`Blocked`: that the blocker is resolved).
4. Restore `prior:` (**Paused vs Blocked**) and append the resume recap.
5. Reminders: `Planning` → strong model; `Approved` → `conventions-ok` /
   `start-building`.

### `Planning` / `Approved` / `Active`

Reload context only: steps 1–2 above. No status change, no journal.

### `Complete`

The activity stays `Complete` until the choice is clear; do not journal
yet. This is the **Complete stay-on-slug** or sibling fork
(**Material-change**).

1. Same reads as above.
2. Take the issue in free text, then grill: outcome, why now, in / out,
   paths, risk, evidence.
3. Classify: minor stay-on-slug vs major `create-sibling`. Do not
   transition silently.
4. **Sibling:** prompt `create-sibling`. After the user writes it, follow
   that command. Stop; do not reopen this slug.
5. **Stay:** after the user confirms this slug, reopen `Complete` →
   `Planning`. Preserve the shipped design and checked milestones. Rewrite
   `# Current Plan` / `# Next Steps` as a high-level **legacy verify**
   (re-run or spot-check old evidence; do not redo those milestones), then
   **delta steps** that start at the new requirement, including steps that
   undo earlier work. Mark undone milestones `superseded`. Update RD and
   Design Decisions (`replaces:` when a choice flips). Tighten Conventions
   only if the user states a new or changed rule (Setup: best-effort
   refresh).
6. Then append the resume recap (`Complete` → `Planning`; `next:` is the
   first delta step).
7. **File review** and the **Execution gate**.

## `conventions-ok`

Status: `Planning`, `Approved`. If already `conventions: ok`, report and
stop (**Execution gate**).

Reads: notes-files.md; Execution gate

1. If the rules are thin or Setup is empty, and this fill was not shown in
   an earlier turn: fill them best-effort from the repo, show the diff, and
   ask the user to review and write `conventions-ok` again. Stop. If the
   fill was already shown, go to step 2.
2. Set `conventions: ok` in `activity.md`. No journal, no status change.
3. If `Approved`, ask for `start-building`.

## `start-building`

Status: `Approved` (`Planning`: require `approve-plan` first).

Reads: building.md; Journal policy; Reminders

1. Needs `conventions: ok`. If `pending`, prompt `conventions-ok` and stop.
2. **Optional-remind** `apply-review`.
3. Set `status` to `Active`. Append a `Building` event. Begin engineering.

## `approve-plan`

Status: `Planning` (`Approved` / `Active`: report the state; do not rewrite
history).

Reads: Journal policy; Reminders; Execution gate

1. The planning outputs are written and reviewed, and RD is current and
   challengeable. Send the user back to **File review** instead of approving
   when RD is empty, stale, or unreviewed; when the **Problem header** is
   missing; or when the last milestone has no named runnable e2e command. A
   user nod does not replace a missing e2e name; only an explicit user drop
   waives it, and that reason goes in `activity.md`.
2. **Optional-remind** `verify-plan` and `apply-review`.
3. Set `status` to `Approved`. Append an `Approved` event (milestone count).
4. One-time note: planning is done; the user may drop the strong model.
5. Do not implement. If `conventions: pending`, ask: "Accept the
   conventions too? (`yes` / `review`)". On `yes`, run `conventions-ok`
   from step 1; on `review`, the user runs `conventions-ok` later. Then ask
   for `start-building`.

## `pause-work`

Status: `Planning`, `Approved`, `Active`. `Blocked` is already stopped; say
so. `Complete` is a no-op; use `resume-work`.

Reads: Paused vs Blocked; Journal policy; Reminders; Update cadence; templates.md#journal.md

1. Sync `activity.md` and RD / Design Decisions / Conventions if they
   changed.
2. Set `status` to `Paused` with `prior:` (**Paused vs Blocked**). Put the
   resume context in `# Next Steps`.
3. Append the pause recap (**Journal policy**). Present a short pause
   summary.
4. **Optional-remind** `apply-review`.

## `mark-completed`

Status: `Active`.

Reads: Journal policy; Portability; Reminders; records.md#activity.md; delete-tmp-files; templates.md#journal.md

0. An `open` review cycle (regular or fix) → ask the user to run
   `apply-review` or to say `defer`. Stop. On `defer` (next turn), mark
   each open point `noted: deferred`, set `status: closed`, append a
   `Review` event, then continue at step 1.
1. The milestones are complete, or the user dropped them with a reason in
   `activity.md`. The last milestone names a runnable e2e command, or the
   user dropped it in `activity.md`; a user nod does not replace a missing
   e2e name. Run that command when the environment can.
2. Rewrite `activity.md` as a maintenance handoff:
   - **Current Design:** shipped behavior, touched paths, must-not-break
     invariants.
   - **Milestones:** checked or dropped, with evidence commands or artifact
     pointers.
   - **Next Steps:** the minor-fix runway (small follow-ups, fastest checks,
     safest first edit targets).
3. Set `status` to `Complete`. The handoff follows **Portability**.
4. Append the `Complete` journal entry (**Journal policy**).
   **Optional-remind** `create-guide` and `remove-review-comments`.
5. **Cleanup:** run the `delete-tmp-files` flow.
6. Later fixes: `resume-work` (`Complete` path), then the **Execution gate**,
   then `mark-completed` again.

## `start-review`

Status: any. No status change, no journal. Never applies (**Apply timing**).
Usage: `start-review [<milestones>] [manual]`.

Reads: review-policy.md; subagent-contract.md; templates.md#reviews.md

This command works on the regular cycle only and never touches a fix cycle
(**Reviews**).

0. **Checks.** A fix cycle is `open` → warn that the results will need the
   recheck and suggest `apply-review` first. Stop; continue next turn only
   after a yes. A named milestone that is not checked → warn and drop it
   from scope.
1. **Cycle.** If a regular cycle is `open`, refresh it (rewrite `scope:` and
   `state:`). Else append a new `RU<n>` to `reviews.md` with `status: open`,
   `scope:`, and a `state:` note. Scope is the named milestones, else the
   **Reviews** default. Nothing in scope and not `Planning` → say so and ask
   whether to open the cycle for user points. Stop; open it next turn only
   after a yes.
2. **Mode.** Automated unless the user asks for a manual review (`manual`,
   or plain words such as "I will review it myself"). Manual: mark `open`
   `agent` points from an earlier scope `noted: out of scope`; tell the user
   to add points in `reviews.md` or in chat. Stop.
3. **Automated.** Write `inflight.md` (**Inflight pipelines**), then run the
   **Review** pipeline in the contract. A re-run overwrites
   `artifacts/review/`.
4. The parent Reads `review/report.md`, or `review/env.md` when `blocked`
   (then record `- none (env blocked)` and stop). Replace the cycle's
   `open` `agent` points with the report's points (`open`); keep every
   `user` point. A `- none` report → record `- none (agent)`. Delete
   `inflight.md`.
5. Show the cycle. Say the user MAY add, edit, or strike points, then run
   `apply-review`. Stop.

## `apply-review`

Status: any. No `open` cycle in `reviews.md` → say so; suggest
`start-review`, or adding points to the last closed regular cycle when no
newer regular cycle exists (**Reviews** reopen). Stop.

Reads: review-policy.md; Journal policy; Material-change; records.md#activity.md; Execution gate

This command applies and closes one cycle, which the user may have edited. The
target is the open fix cycle, else the open regular cycle (**Reviews** fix
first). The keyword is the nod when the points already answer the questions.
**Apply timing**, **Journal policy**, and **Complete stay-on-slug** apply.

1. Read the target cycle. Restate each `open` point with its planned
   outcome, plus remaining work, next action, and any status change. Ask
   only the gaps the points do not settle (one round), then stop; after the
   answers, apply next turn with no new keyword. With no gaps, apply in
   this turn.
2. An `open` point that is a **Material-change** → apply nothing; ask
   `replan-work` or `create-sibling` (`Complete`: `create-sibling` only).
   Stop. The cycle stays `open`; no status change, no journal.
3. Give every `open` point an outcome (**Reviews** outcome). Apply notes
   edits as each point's `where` says (**Reviews** where a change lands).
   Product work → a review milestone `Apply RU<n>`; those points are
   `planned → milestone <k>`. Set `status: closed`.
4. **Status and journal:** one entry only.
   - `Complete` with a new review milestone: `Complete` → `Planning`.
     Rewrite `# Current Plan` / `# Next Steps` as `resume-work` `Complete`
     step 5, without the grill. Append the resume recap citing `RU<n>`.
     Then the **Execution gate**.
   - Any other case (including `Paused` / `Blocked`, and `Complete` without
     product work): no status change; append the `Review` event.
5. **Fix cycle only:** refresh `synced` (`snapshot <slug> --pin`). Run the **Reviews**
   recheck on the open regular cycle and show the result. Say that the next
   `fix-activity` runs the deferred housekeeping.
6. Keep `artifacts/review/` or `artifacts/fix/review/` (overwritten on the
   next run of that pipeline). Delete only via `delete-tmp-files`.

## `verify-plan`

Status: `Planning`. Optional; not required for `approve-plan`. Isolated
**negative** and **positive** critics with different briefs, then a
synthesizer.

Reads: review-policy.md; subagent-contract.md

Follow the `verify-plan` pipeline under **Pipelines** in the contract for
turn stages, question gate, paths, and briefs. Write `inflight.md` (**Inflight pipelines**)
before launch; delete it after the first Read of `synthesis.md`. The parent
Reads only `synthesis.md` and filters **Stops**. Accepted and rejected
proposals become points per **Reviews** (where points go): into the open
regular cycle if one exists (applied later by `apply-review`), else a new
cycle closed this turn. Keep the assigned files and slice dirs (overwrite on
re-run; wipe stale slices). Delete only via `delete-tmp-files`.

## `add-review-comments` / `remove-review-comments`

Status: `Active`, `Paused`, `Blocked`, `Complete`. No status change, no
journal. Comment-only edits need neither the **Execution gate** nor a
`Complete` reopen. Levels: **Engineering while focused** comments.

Reads: building.md#Comments; subagent-contract.md

`add-review-comments` raises comments in the activity diff to review level,
then sets `review-comments: on`. `remove-review-comments` trims them to
default level, then sets `review-comments: off`.

1. Resolve `base-branch` (`activity.md`), else `origin/<base-branch>`.
   Neither exists → say so, suggest fixing the row, stop. Empty activity
   diff → say so; stop.
2. Write `inflight.md` (**Inflight pipelines**). Run the **Comments**
   pipeline in the contract. Scope: lines the activity added or changed;
   comments outside that scope stay as they are.
3. The parent Reads only `comments/verify.md`. Restore every `fail` file
   from its snapshot. Tests `fail` → restore every file. Delete
   `inflight.md`.
4. Set the row only if at least one file kept its edits. Report the files
   changed, and the files restored and why. Running the same command again
   is safe.

## `update-convention`

Status: any (`Complete`: record only; new work still needs `resume-work`).

Reads: notes-files.md

1. The user's text is the source for rules. Translate it into `CONV<n>`
   entries. Ambiguous wording → one confirm question before writing. Setup
   command corrections need no keyword.
2. Add new entries, or rewrite in place (**Notes files**).
3. Show what changed. Do not start engineering from this command.

## `fix-activity`

Status: any. User-invoked only. No status change. Never edits product code.
Usage: `fix-activity [<what to fix> | tidy]`.

Reads: review-policy.md; Consistency check; records.md#activity.md; Journal policy

Load `subagent-contract.md` (`section subagent-contract.md`) before step B
or E2.

This command brings the activity files back in line with reality after
drift since the last sync. Scope: `activity.md`, RD, Design Decisions,
Conventions, `reviews.md`. `notes-by-user.md` is input only. The journal is
never rewritten here (that is `compact-journal`); this command appends only
`Review` and `Renumber` events. Drift comes from user edits to activity
files, from source changes (user edits, rebase, merge, pulled commits), or
as **major drift** (new repo, restructured tree, drastic early changes).

**Terms** (this command only). **Major drift**: `drift.md` says `major: yes`.
**Plan-impacting finding**: passes the step 4 test. **Unclear finding**: a
user edit with two plausible readings, a source change of unknown intent, or a
fact the repo cannot settle.

**Request.** Classify the user's words first. **Targeted**: the user names
an ID, section, path, or fact to fix. **Resync**: bare `fix-activity`, or
plain words such as "out of date". **Tidy**: `tidy`, or plain words that
ask to prune, rewrite, or renumber. A mixed request runs the targeted part
first, then offers the rest.

**Turn order.** Turn 1: classify, run T, then the targeted path, the tidy
path, or gate 1. When gate 1 answers `scan`, B ends the turn; the next turn
reads `drift.md`, runs D and step 2, grills unclear findings, and routes.
The fix-cycle route stops at gate 2. Then the fix-cycle path (E1–E4) or the
inline path (which reuses T and step 2) runs.

**Grill rule.** Grill with [`grill-me`](../grill-me/SKILL.md) on every
unclear finding before the route, and on every plan-impacting finding
before proposing its fix. One question at a time; recommend an answer;
explore the repo first. Classify each answer as plan-impacting, a clear
user edit, or a step 5 item.

### Triage and scans

T. **Triage** (parent, inline, read-only; no sub-agent). Take a fresh
   `snapshot <slug>` as `<now>`. Run A, C, and step 0. Summarize source drift with
   `git diff --stat <synced> <now> -- . ':!.dev-notes'`. Report in ≤ 4
   lines: baseline mode, user edits, changed source paths, consistency
   issues. Baseline `none`: skip the diffs and say so. No findings and no
   targeted request → say the files are in line. Stop.
A. **Baseline**: `base <synced>` prints the **`synced` base** and the mode:
   - `ok`: the base is an ancestor of `HEAD`. Drift = `git diff <synced>
     <now>`.
   - `rewritten`: the commit exists but its base is not an ancestor
     (rebase, force push). Drift = the activity's own changes then vs now:
     `git diff $(git merge-base <synced> <base-branch>) <synced>` against
     the current activity diff. Upstream commits are not drift.
   - `none`: missing row, unknown commit, or no git. Verify everything.
B. **Drift scan.** Write `inflight.md` (**Inflight pipelines**) and run the
   **Drift** pipeline in the contract. Next turn, the parent Reads only
   `fix/drift.md` and deletes `inflight.md`.
C. **Notes drift** (parent). `git diff <synced> <now> --
   .dev-notes/activities/<slug>/`, limited to the scope files. An edit with no
   matching journal event, `revised-by:`, or `RU` point is a **user edit**.
   Ignore a `# Next Steps` `In progress:` line. A clear user edit is truth
   unless it contradicts another file; a contradiction is a finding.
D. **Source drift.** Each `fail` milestone in `drift.md` is a plan-impacting
   finding; the proposed fix unchecks it with `regressed: <evidence>` and
   adds a review milestone. Moved and missing paths are step 2 findings.

### Paths

**Targeted path.**
1. Propose only what the user named, in the step 5 shape. A plan-impacting
   fix adds its `# Current Plan`, `# Milestones`, and `# Next Steps` edits
   to the same proposal. Grill per the grill rule only when the request is
   unclear. Offer `review` once to run the fix-cycle path instead.
2. On yes, run steps 6, 8, and 9. On `review`, treat it as gate 1 `scan`
   and run B; the next turn continues at the route.
3. List the other triage findings, one line each, without acting on them.
   Offer `fix-activity` for drift or `fix-activity tidy` once.

**Tidy path.** The inline path with steps 1, 3, and 7 included. Report
triage drift but do not fix it; when drift exists, recommend a resync
first.

**Resync path.**

G1. **Gate 1.** Baseline `ok` with no changed source paths → skip the gate
    and run the inline path. Otherwise describe the drift scan (one
    scanner, evidence re-runs for checked milestones with changed paths,
    and a review that may follow) and ask `scan`, `inline` (skip the
    scan), or `stop`. Stop the turn.

**Route.** Major drift, any plan-impacting finding, or baseline `none` with
at least one checked milestone → fix-cycle path. Otherwise → inline path.
Baseline `none` with no checked milestone: inline path, verify every fact
in step 2, skip the Setup build.

G2. **Gate 2** (fix-cycle route only). List the findings and the route
    reason. Describe the review (env agent, tests, critic pair,
    synthesizer) and ask `review` (run E1–E4), `inline`, or `stop`. Stop
    the turn. On `inline`, run the inline path; plan-impacting findings
    join the step 5 proposal with their plan edits. On `stop`, `synced`
    stays unchanged.

**Fix-cycle path** (every drift finding goes through review).

E1. Open the fix cycle in `reviews.md` (**Reviews** fix cycle), or refresh
    the open one. Before the launch, record the findings from C, D, 0, and
    2 as `agent` points and the clear user edits as `user` points. A
    regular open cycle stays as is.
E2. Write `inflight.md`. Run the **Review** pipeline with `scope: drift`
    (paths under `fix/`). End the turn.
E3. The parent Reads `fix/review/report.md` and adds its points as `agent`
    points. Env `blocked` → Read `fix/review/env.md`, show it, and add
    `- none (env blocked)` for the report points. Delete `inflight.md`.
    Grill per the grill rule and patch the points with the answers.
E4. Show the cycle. Ask for `apply-review`. Stop. The inline path waits
    for the next `fix-activity` after the fix cycle closes.

**Inline path:** steps 0, 2, 4–6, 8, 9. Steps 1, 3, and 7 run only on the
tidy path; otherwise offer `fix-activity tidy` once after step 9.

### Steps

0. **Consistency.** Find the **Consistency check** issues; add them to the
   step 5 list as `fix:` items.
1. **Prune.** Find redundant entries, entries that fold into another, nits
   recoverable from code or covered elsewhere, superseded entries, and
   stale prose. A pruned milestone keeps its number as a `removed` stub
   (**`activity.md`** Milestones).
2. **Verify** facts against the repo with read-only checks; run nothing
   that changes state:
   - Repo paths in any scope file exist; moved paths resolve via `git log
     --follow` or `rg`.
   - `REF<n>` sources and `artifacts/` copies exist; copies are neither
     missing nor orphaned.
   - Setup and evidence commands name scripts, targets, and test files that
     exist.
   - `branch` and `base-branch` exist locally or on a remote; `status`,
     `conventions`, `review-comments`, and `prior:` are valid tokens.
   - Every cited ID resolves; checked milestones have evidence.
3. **Rewrite.** Find text that breaks **Writing style** or reads unclear
   (vague terms, mixed terms for one concept, long sentences, unclear
   referents). Propose a clearer rewrite that keeps the meaning. When the
   meaning itself is unclear, grill first (one question at a time;
   recommend an answer).
4. **Impact test.** A finding is plan-impacting when both hold (step D
   failures always are): it changes an `RD<n>`, a `CONV<n>` rule, Setup, or
   another load-bearing assumption (a `# Current Design` invariant or a
   Background fact); and the change affects `# Current Plan`,
   `# Milestones`, or `# Next Steps`. On the inline path, a new
   plan-impacting finding from steps 1 or 3 goes to gate 2; when the user
   already chose `inline` there, it joins the step 5 proposal with its plan
   edits.
5. **Propose** one list: ID or section, action (`delete` | `fold into <ID>`
   | `shorten` | `rewrite` | `fix: <new value>` | `flag: <unresolved>`),
   why. Ask yes / no / mods. A change to Goal or Scope is a
   **Material-change**: skip it and prompt.
6. **Apply** only confirmed items. Append-only and `superseded` rules do not
   block pruning; git is the archive. Then record confirmed clear user
   edits (from C) to RD, DC, or CONV entries, and applied targeted
   requests, as `user` points of one new closed regular `RU<n>` cycle
   (`applied → <IDs>`), and append its `Review` event. No such items → no
   cycle.
7. **Renumber** `RD`, `DC`, `CONV`, and `REF` IDs to close gaps (never `RU`
   IDs or milestone numbers). Update every reference in the scope files.
   Append the old → new map to `reviews.md` (**Reviews** renumber log),
   show it, and append a one-line `Renumber` event that points at the log.
8. If `notes-by-user.md` cites removed or renumbered IDs or broken paths,
   tell the user and show the map; do not edit it.
9. **Refresh `synced`** (`snapshot <slug> --pin`) when this run applied at least one
   item. Drift that was reported but not fixed leaves the baseline; say so.
   The fix-cycle path skips this step: `synced` stays unchanged until
   `apply-review` closes the fix cycle, so a re-run before then still sees
   the drift.

## `create-guide`

Status: `Active`, `Complete`. No status change, no journal. Shape and
audience: **User guide**.

Reads: User guide; templates.md#user-guide.md

1. Read `activity.md`, RD, and the `conventions.md` Setup. Read shipped
   user-facing docs only where the guide must stay consistent with them.
2. Write `user-guide.md` (rewrite in place). Use runnable commands from the
   milestone evidence and Setup. Mark unbuilt parts as planned.
3. Show the file. Stop.

## `delete-tmp-files`

Status: any. Also run by `mark-completed`. No status change, no journal.

1. List the temporaries of this activity. For each: path, why it looks
   temporary, default.
   - Reserved dirs default to **delete** when their work is done, else
     **keep**: `review/` and `verify-plan/` when no regular cycle is
     `open`; `fix/` when no fix cycle is `open`; `comments/` when no
     comment pipeline is in flight; `bg/milestone-<n>/` when milestone
     `<n>` is checked.
   - `inflight.md`: never listed; **Inflight pipelines** manages it.
   - The snapshot ref `refs/workon/<slug>`: list only when the status is
     `Complete`; default **delete** with `git update-ref -d`. Leave the
     `synced` row; after git prunes the commit, the baseline reads `none`.
   - Legacy `self-review/` and `self-review.md`: default **delete**.
   - Untracked or gitignored leftovers (scratch dirs, sample outputs,
     dumped test artifacts, isolated-setup envs): default **delete**.
   - Uncertain items: default **keep**.
   - Never list activity files (`activity.md`, `journal.md`, notes files,
     `reviews.md`, `user-guide.md`), `.agents/`, `.cursor/`, shipped
     source, real tests, docs, or scripts. List other tracked files only if
     the user points at them.
2. Ask yes / no / mods. Delete only the confirmed set. Confirmed tracked
   paths allow `git rm`; no other `git rm`.
3. Show what was deleted.

## `compact-journal`

Status: any. Not auto-run from `mark-completed`. If already within budget,
say so and stop.

Reads: Journal policy

1. The default budget is ~12 `##` headings; the user may name another
   number.
2. Keep the newest entries verbatim (about half the budget: the last ~7
   when targeting ~12). Prefer recent `Complete`, `Replan`, and review
   events.
3. Merge older entries into a few summary headings a future agent can use:
   shipped outcomes (paths, behavior, decisions, accepted gaps); one line
   per milestone or review cycle (`Milestone 2: <outcome>`, `RU3: 4
   applied, 1 rejected`); one line `paused N, resumed N, completed N`. Drop
   plan and status prose that `activity.md` already holds.
4. Show the proposed compacted file. Write in place only after the user
   nods. Git is the archive unless the user asks for an `artifacts/`
   snapshot.

## `query-work` / `no-query-work`

Status: any. Status unchanged. `query-work` sets a session flag that lasts
until `no-query-work` or session end (**Stops** query mode).

Under the flag, every mutation is blocked: files, git writes, sub-agent
output files, and mutating keywords. Allowed: `help`, `no-query-work`,
list, details, reads, and `resume-work` on `Planning` / `Approved` /
`Active` (reload only). Skip the **Session probe**; report pending repairs
instead. Do not record review points the user states; after
`no-query-work`, ask whether to record them. On a blocked request, say
query mode is on and ask for `no-query-work`.

## `help`

Status: any; read-only; no focused activity needed.

- `help`: tell the user what to do next in the current state; cap ~5 lines:
  one state line (slug, status, `conventions`), then 1–3 next actions from
  the state table. Check rows top-down; the first match wins. End with one
  line: `help intro` for basics, `help all` for every command.
- `help intro`: teach the basic path in ≤ 8 lines, naming only these steps:
  1. Describe the work in plain words (e.g. `workon add CSV export`).
     Answer the questions, then review the drafted files.
  2. `approve-plan`: accept the plan. Answer `yes` to accept the rules too.
  3. `start-building`: the agent builds and tests.
  4. `mark-completed`: close the work when the tests pass.

  Add: type `help` at any time for the next step. Teach no other commands.
- `help all`: print the command map below. If an activity is focused, mark
  the commands its status allows (`Status:` lines in the extracted
  heading). Rows with `Status: any`, `n/a`, or no heading (natural
  language) are always allowed.
- `help <command>`: explain that command in 2–5 sentences from its heading
  (`section <command>`): when to use it, what it changes, and what it needs
  first.

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
`apply-review`; `review-comments: on` at `Active` with all milestones
checked → `remove-review-comments`; `Planning` with no `verify-plan` this
session → `verify-plan`.

**Command map**

| Group | Command | What it does |
|---|---|---|
| Start and plan | natural language | Create, list, switch, or show details of an activity |
| | `replan-work` | Reopen in-flight scope → `Planning` |
| | `create-sibling` | New `Planning` activity derived from this one |
| | `import-activity` | Adopt activity files from elsewhere → `Planning` (`Complete` kept) |
| Gates and lifecycle | `approve-plan` | `Planning` → `Approved` |
| | `conventions-ok` | Sign off rules + Setup (one-time) |
| | `start-building` | `Approved` → `Active`; needs `conventions: ok` |
| | `pause-work` | → `Paused` + journal recap |
| | `resume-work` | Unpause, unblock, reopen `Complete`, or reload context |
| | `mark-completed` | → `Complete` + journal + cleanup |
| Review | `start-review` | Open or refresh a review cycle; automated by default, `manual` on request |
| | `apply-review` | Apply and close one open cycle (fix cycle first) |
| | `verify-plan` | Critics + synthesis of the plan; apply on confirm |
| Comments | `add-review-comments` | Raise comments in the activity diff to review level; `review-comments: on` |
| | `remove-review-comments` | Trim comments in the activity diff to default level; `review-comments: off` |
| Notes upkeep | `update-convention` | Add or rewrite convention rules |
| | `fix-activity [<what to fix> \| tidy]` | Fix what the user names, or resync after drift; cheap triage first; asks before each pipeline; prune, rewrite, renumber only on `tidy` |
| | `compact-journal` | Shorten the journal in place |
| Output and cleanup | `create-guide` | Write `user-guide.md` for humans |
| | `delete-tmp-files` | List activity temporaries; delete on confirm |
| Session | `help` / `help intro` / `help all` / `help <command>` | Next steps / the four-step basic path / this map / explain one command |
| | `query-work` / `no-query-work` | Read-only session on / off |
