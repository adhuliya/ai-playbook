# `start-review`

Status: any. No status change, no journal. Never applies (**Apply timing**).
Usage: `start-review [<milestones>] [manual]`.

Reads: policy/reviews.md, policy/apply-timing.md, shapes/reviews.md

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
   to add points in `reviews.md` or in chat, then run `apply-review`. Stop.
3. **Automated.** Read the launch kit and `pipelines/review.md`
   (**Background sub-agents**). Write `inflight.md` (**Inflight
   pipelines**), then run the **Review** pipeline. A re-run overwrites
   `artifacts/review/`.
4. The parent Reads `review/report.md`, or `review/env.md` when `blocked`
   (then record `- none (env blocked)`). Replace the cycle's
   `open` `agent` points with the report's points (`open`); keep every
   `user` point. A `- none` report → record `- none (agent)`. On env
   `blocked`, keep the `- none (env blocked)` line. Delete
   `inflight.md`.
5. Show the cycle. Say the user MAY add, edit, or strike points, then run
   `apply-review`. Stop.
