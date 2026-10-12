# Upkeep commands

Keyword steps for workon.
Read only the heading you are running.
Shared rules and the session probe live in [`SKILL.md`](SKILL.md).
Shapes: [`templates.md`](templates.md).
A bold name follows the index in `SKILL.md`.

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

Read `review-policy.md` and `subagent-contract.md` before these steps.
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

**Turn order:**
- Turn 1: A, B. Launching B ends the turn.
- Turn 2: read `drift.md`; C, D, 0, 2; grill unclear findings; route.
- Then the fix-cycle path (E1–E4) or the inline path (1, 3–9; reuse the
  step 0 and 2 results).

A. **Baseline** from the `synced` row and its **`synced` base**:
   - `ok`: the base is an ancestor of `HEAD`. Drift = `git diff <synced>`
     (working tree vs snapshot).
   - `rewritten`: the commit exists but its base is not an ancestor
     (rebase, force push). Drift = the activity's own changes then vs now:
     `git diff $(git merge-base <synced> <base-branch>) <synced>` against
     the current activity diff. Upstream commits are not drift.
   - `none`: missing row, unknown commit, or no git. Verify everything.
B. **Drift scan:** write `inflight.md` (**Inflight scratch**); run the
   **Drift** pipeline in the contract. Next turn, parent Reads only
   `fix/drift.md`; delete `inflight.md`.
C. **Notes drift** (parent): diff the scope files against `synced`. An
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

**Route:** major drift, any plan-impacting finding, or baseline `none`
with at least one checked milestone → **fix-cycle path**. Else →
**inline path**. Baseline `none` with no checked milestone: inline path,
verify every fact in step 2, skip the Setup build.

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
E4. Show the cycle. Ask for `apply-review`. Stop. Steps 1 and 3–9 wait for
    the next `fix-activity` after the fix cycle closes.

**Inline path:**

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

   On the inline path, a plan-impacting finding from steps 1 or 3 switches
   to the fix-cycle path (E1). A change to Goal or Scope is
   **Material-change**: skip it and prompt.
5. Show one proposal list: ID or section, action (`delete` | `fold into <ID>`
   | `shorten` | `rewrite` | `fix: <new value>` | `flag: <unresolved>`), why.
   Ask yes / no / mods.
6. Apply only confirmed items. Append-only and `superseded` rules do not
   block pruning. Git is the archive. A change to Goal or Scope is
   **Material-change**: skip it and prompt. Then record confirmed clear
   user edits (from C) to RD, DC, or CONV entries as `user` points of one
   new closed regular `RU<n>` cycle (`applied → <IDs>`), and append its
   `Review` event. No such edits → no cycle.
7. Renumber `RD`, `DC`, `CONV`, and `REF` IDs to close gaps (never `RU`
   IDs or milestone numbers). Update every reference in the scope files.
   Append the old → new map to `reviews.md` (**Reviews** renumber log) and
   show it. Append a one-line `Renumber` event pointing at that log.
8. If `notes-by-user.md` cites removed or renumbered IDs or broken paths, tell
   the user and show the map; do not edit it.
9. Refresh `synced` (**`activity.md`** snapshot). The fix-cycle path skips
   this step: `synced` stays unchanged until `apply-review` closes the fix
   cycle, so a re-run before then still sees the drift.

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
   - Legacy `self-review/`, `self-review.md`: **default delete**.
   - Untracked / gitignored leftovers (scratch dirs, sample outputs, dumped
     test artifacts, isolated-setup envs): **default delete**.
   - Uncertain items: **default keep**.
   - **Never** list activity files (`activity.md`, `journal.md`, notes files,
     `reviews.md`, `user-guide.md`), `.cursor/`, shipped source, real tests,
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
