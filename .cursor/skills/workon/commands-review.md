# Review commands

Keyword steps for workon.
Read only the heading you are running.
Shared rules and the session probe live in [`SKILL.md`](SKILL.md).
Shapes: [`templates.md`](templates.md).
A bold name follows the index in `SKILL.md`.

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
