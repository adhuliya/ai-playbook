# `fix-activity`

Status: any. User-invoked only. No status change. Never edits product code.
Usage: `fix-activity [<what to fix> | tidy]`.

Reads: policy/reviews.md, policy/apply-timing.md, policy/consistency-check.md, policy/activity-md.md, policy/journal.md, policy/ids.md

Before step B or E2, also read the launch kit (`policy/launch.md`,
`policy/inflight.md`, `policy/paths.md`, `policy/parent-reads.md`,
`policy/critic-pair.md`) and the pipeline file: `pipelines/drift.md` for B,
`pipelines/review.md` for E2.

This command brings the activity files back in line with reality after
changes the agent did not see. Scope files: `activity.md`,
`plan-outline.md`, RD, Design Decisions, Conventions, `references.md`,
`reviews.md`. `notes-by-user.md` is input only. The journal is never
rewritten here (that is `compact-journal`); this command appends only
`Review` and `Renumber` events. Drift comes from user edits to activity
files, from source changes (user edits, rebase, merge, pulled commits), or
as **major drift** (new repo, restructured tree, drastic early changes).
There is no stored baseline: the user says what changed, and cheap checks
fill the gaps.

**Terms** (this command only). **Known changes**: the user's answer to
step Q. **Drift scope**: the paths or areas that the known changes and the
basic checks flag, or `all`. **Major drift**: `drift.md` says `major: yes`.
**Plan-impacting finding**: passes the step 4 test. **Unclear finding**: a
user edit with two plausible readings, a source change of unknown intent, or
a fact the repo cannot settle.

**Request.** Classify the user's words first. **Targeted**: the user names
an ID, section, path, or fact to fix. **Resync**: bare `fix-activity`, or
plain words such as "out of date". **Tidy**: `tidy`, or plain words that
ask to prune, rewrite, or renumber. A mixed request runs the targeted part
first, then offers the rest.

**Turn order.** Turn 1: classify, ask Q (Resync only), run T, then the
targeted path, the tidy path, or gate 1. When gate 1 answers `scan`, B ends
the turn; the next turn reads `drift.md`, runs D and step 2, grills unclear
findings, and routes. The fix-cycle route stops at gate 2. Then the
fix-cycle path (E1–E4) or the inline path (which reuses T and step 2) runs.

**Grill rule.** Grill with [`grill-me`](../../grill-me/SKILL.md), asked per
**Asking**, on every unclear finding before the route, and on every
plan-impacting finding before proposing its fix. One question at a time;
explore the repo first. Classify each answer as plan-impacting, a clear
user edit, or a step 5 item.

## Triage and scans

Q. **Known changes** (Resync only; skip when the user already said what
   changed). Ask what changed that the agent may not know: source areas,
   activity files edited by hand, a pulled or rebased branch. Options:
   `Nothing I know of (Recommended)` (run the basic checks only), `Source
   changed` (the user names where), `Activity files edited`, and `Not sure`
   (verify everything). The user's own words refine the answer.
T. **Triage** (parent, inline, read-only; no sub-agent). Run one batched
   shell call (**Fewer prompts**):

   ```bash
   s=.dev-notes/activities/<slug>; b=$(git log -1 --format=%H -- "$s"); git status --short; git diff --stat HEAD -- "$s"; [ -z "$b" ] || git log --oneline "$b"..HEAD -- . ':!.dev-notes' | head -20
   ```

   An empty `b` means the notes were never committed: say there is no
   history baseline and rely on Q. Then run step 0 and the path checks of
   step 2 (cited and milestone paths exist; `base-branch` exists). Set the
   **drift scope**: Known changes, plus commits since `b` that touch cited or
   milestone paths, plus `all` when the user is `Not sure`. Report in ≤ 4
   lines: user edits, flagged source paths, consistency issues, the drift
   scope. An empty scope with no findings and no targeted request → say the
   files are in line. Stop.
B. **Drift scan.** Write `inflight.md` (**Inflight pipelines**) and run the
   **Drift** pipeline with the drift scope. Next turn, the parent Reads only
   `fix/drift.md` and deletes `inflight.md`.
C. **Notes drift** (parent). Uncommitted edits in the activity folder
   (`git diff HEAD -- .dev-notes/activities/<slug>/`, limited to the scope
   files) plus the edits Q names. An edit with no matching journal event,
   `revised-by:`, or `RU` point is a **user edit**. Ignore a `# Next Steps`
   `In progress:` line. A clear user edit is truth unless it contradicts
   another file; a contradiction is a finding.
D. **Source drift.** Each `fail` milestone in `drift.md` is a plan-impacting
   finding; the proposed fix unchecks it with `regressed: <evidence>` and
   adds a review milestone. Moved and missing paths are step 2 findings.

## Paths

**Targeted path.**
1. Propose only what the user named, in the step 5 shape. A plan-impacting
   fix adds its `# Current Plan`, `# Milestones`, and `# Next Steps` edits
   to the same proposal. Grill per the grill rule only when the request is
   unclear. Offer `review` once to run the fix-cycle path instead.
2. On yes, run steps 6 and 8. On `review`, treat it as gate 1 `scan` with
   the named paths as the scope and run B; the next turn continues at the
   route.
3. List the other triage findings, one line each, without acting on them.
   Offer `fix-activity` for drift or `fix-activity tidy` once.

**Tidy path.** The inline path with steps 1, 3, and 7 included. Report
triage drift but do not fix it; when drift exists, recommend a resync
first.

**Resync path.**

G1. **Gate 1.** An empty drift scope → skip the gate and run the inline
    path. Otherwise describe the drift scan (one scanner, evidence re-runs
    for checked milestones inside the scope, and a review that may follow;
    for `all`, every checked milestone and the Setup build run, which is
    the expensive case) and ask `scan`, `inline` (skip the scan), or
    `stop`. Stop the turn.

**Route.** Major drift or any plan-impacting finding → fix-cycle path.
Otherwise → inline path. An `all` scope with no checked milestone: inline
path, verify every fact in step 2, skip the Setup build.

G2. **Gate 2** (fix-cycle route only). List the findings and the route
    reason. Describe the review (env agent, tests, critic pair,
    synthesizer) and ask `review` (run E1–E4), `inline`, or `stop`. Stop
    the turn. On `inline`, run the inline path; plan-impacting findings
    join the step 5 proposal with their plan edits.

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

**Inline path:** steps 0, 2, 4–6, 8. Steps 1, 3, and 7 run only on the
tidy path; otherwise offer `fix-activity tidy` once after step 8.

## Steps

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
     `stage`, `conventions`, `review-comments`, and `prior:` are valid
     tokens.
   - Every cited ID resolves; checked milestones have evidence.
3. **Rewrite.** Find text that breaks **Writing style** or reads unclear
   (vague terms, mixed terms for one concept, long sentences, unclear
   referents). Propose a clearer rewrite that keeps the meaning. When the
   meaning itself is unclear, grill first (one question at a time, per
   **Asking**).
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
   why. Ask yes / no / mods (**Asking**). A change to Goal or Scope is a
   **Material-change**: skip it and prompt.
6. **Apply** only confirmed items. Append-only and `superseded` rules do not
   block pruning; git is the archive. A plan edit also rewrites
   `plan-outline.md`. Then record confirmed clear user edits (from C) to RD,
   DC, or CONV entries, and applied targeted requests, as `user` points of
   one new closed regular `RU<n>` cycle (`applied → <IDs>`), and append its
   `Review` event. No such items → no cycle.
7. **Renumber** `RD`, `DC`, `CONV`, and `REF` IDs to close gaps (never `RU`
   IDs or milestone numbers). Update every reference in the scope files.
   Append the old → new map to `reviews.md` (**Reviews** renumber log),
   show it, and append a one-line `Renumber` event that points at the log.
8. If `notes-by-user.md` cites removed or renumbered IDs or broken paths,
   tell the user and show the map; do not edit it. Drift that was reported
   but not fixed shows again on the next run; say so.
