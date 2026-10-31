# `agent-review`

Status: any. Optional. Do not offer it, and do not require it. No journal
unless the Planning pass closes a cycle (**Journal policy**).
Usage: `agent-review`.

Reads: policy/reviews.md, policy/apply-timing.md, shapes/reviews.md

Run this only when the user types `agent-review`. Do not start it from
`start-review`, a milestone pass, or a chat note. The activity state picks
the pass. Do not ask which pass.

If `status` is `Paused` or `Blocked` and `prior:` is missing, ask which
status to restore (**Paused vs Blocked**) and stop. `Planning`, or
`Paused` / `Blocked` with `prior: Planning`, uses the plan pass. Every
other status uses the milestone pass.

## Depth

This menu asks the depth for the `agent-review` the user already typed.
Do not show it for any other keyword. Run step 0 of the matching pass
before the menu. If step 0 stops, do not ask the depth. Do not run step
1 on that turn. A stop ends the turn. After a step 0 yes, do not launch.

When the milestone pass has nothing checked, say so and stop. Do not
show the menu. A checked milestone is not `removed` or `superseded`.

A named depth is milestone ids, `plan only`, `requirements only`, `since
last review`, `just finished`, or a custom limit. `plan only` means the
whole plan, and `requirements only` means the requirements and the
Problem header. `since last review` means the `start-review` default,
and `just finished` means the milestone just checked. If the user
already named a depth, skip the menu. When that depth is `just finished`
and no milestone was just checked, say so and stop. For any other named
depth, run step 1.

When the user did not name a depth, stop before any launch. Build two to
four options that can be combined. Omit a slice that is not in the
activity. Do not list every milestone when a group names them. Use one
option for a group of more than three milestones, and name the ids in
the question. Use the first rule that matches. Mark each option in the
recommended set.

- Plan pass (`Planning`, or `prior: Planning`): offer requirements and
  the Problem header, and design statements, when those records exist.
  Offer one named open question when it is load-bearing. Mark every
  slice of the whole plan as recommended. Do not offer a milestone slice
  when nothing is checked.
- An open regular cycle with a milestone `scope:` from `start-review`:
  offer the milestone just checked when it sits inside that scope and is
  not the whole scope, and offer the rest of that scope as one group.
  Mark both recommended. Do not offer a wider scope. Use a wider scope
  only when the user names it.
- No open milestone `scope:`, and at least one milestone is checked:
  offer the milestones checked since the newest earlier regular cycle
  (**Reviews**), the milestone just checked when it is not already that
  whole set, and earlier checked milestones as one group. Mark the
  since-last-review set recommended.

When two or more slices remain, ask one multi-select (**Asking**). The
question states the recommended set and why in one sentence. Also say
the shared limits once. Critics run on the selected scope only. Findings
are tagged `(agent-review)`. This pass does not edit product code. It
does not change a checked milestone. On the milestone pass, this pass
only records points. On the plan pass, when no regular cycle is already
open, it can apply after all / some / none. On the plan pass, when a
regular cycle is already open, this pass only records points. Use the
apply rule in **Reviews**. Do not invent a new apply rule.

Each option names the records, milestones, or question it adds.
Selected options are the depth. Unselected options are dropped. Free
text replaces the set, may change the scope or add a limit, and is still
the chosen depth. An empty selection stops the command. If the choice
names no depth yet, ask for it in plain chat and stop. When fewer than
two real slices exist, do not invent one. State the plan and why, then
ask yes / no / mods (**Asking**). `Yes` accepts that plan. `No` stops
the command. `Modify` replaces the plan. Do not launch critics on this
turn.

Step 1 records the chosen depth as `scope:` before the pipeline. When
every plan slice is selected, `scope:` stays `plan` and **Critic focus**
stays the full assignment. A narrower set limits **Critic focus** to the
selected slices. Requirements and the Problem header use `requirements`.
Design statements use `design choices`. Milestone ids and a custom
question go on that `focus:` list. Keep `pipeline: verify-plan` for the
plan pass. Keep `pipeline: review` for the milestone pass. After the
choice, the next turn starts at step 1.

## Plan pass

Use this when `status` is `Planning`, or when `prior:` is `Planning`. It
reviews the plan.

0. `stage: requirements` → do not launch. Follow **Choose**. A typed
   `thin` names `start-building`. When `kind` is `thin` and the user did
   not type `thin`, set `kind` to `full`, follow `commands/make-full.md`,
   and name `requirements-ok`. Full: prompt `requirements-ok`. Stop.
1. Open or refresh the regular cycle. Keep every `(user)` point. Set
   `scope:` to the chosen depth. A cycle this pass opens is not a cycle
   that stayed `open`. Read the launch kit and `pipelines/verify-plan.md`
   (**Background sub-agents**). Write `inflight.md` with pipeline
   `verify-plan`. Run that pipeline. Do not delete `inflight.md` on the
   first Read of `synthesis.md`. Delete it after all / some / none is
   recorded, or when `## Proposals` is `- none` (no proposals). Do not
   treat an empty `## Questions` as an empty review. If `status` is
   `Paused`, prompt `resume-work` and stop (**Inflight pipelines**).
2. Just before you record points, follow **Agent notes**. Tag every point
   `(agent-review)`. Record per **Reviews**. When `## Proposals` is
   `- none`, leave `artifacts/agent-notes.md`.
3. Prompt `approve-plan` only after all / some / none, or when
   `## Proposals` is `- none`. When the cycle stayed `open`, prompt
   `apply-review` instead.

## Milestone pass

Use this for every other status. It checks the milestones in scope
against the requirements and the design. It never applies.

0. A fix cycle is `open` → warn that the results will need the recheck and
   suggest `apply-review` first. Stop; continue next turn only after a yes.
1. If a regular cycle is `open`, keep every `(user)` point. Set `scope:`
   to the chosen depth. When that depth is the `start-review` scope, keep
   its joins. Do not widen a `start-review` scope unless the user named
   a wider depth. If no regular cycle is `open`, append a new `RU<n>`
   with `status: open` and that `scope:`. Update `state:` to name this
   pass. Follow **Agent notes**.
2. Read the launch kit and `pipelines/review.md` (**Background
   sub-agents**). Write `inflight.md`, then run the **Review** pipeline.
   A re-run overwrites `artifacts/review/`.
3. If `status` is `Paused`, prompt `resume-work` and stop (**Inflight
   pipelines**). The parent Reads `review/report.md`, or `review/env.md`
   when `blocked`. Replace `open` `(agent-review)` points with the report's
   points. Tag each new point `(agent-review)`. Keep every `(user)` point.
   A `- none` report → `- none (agent-review)`. On env `blocked`, record
   `- none (env blocked)`. Delete `inflight.md`.
4. Show the cycle. The user may add points, then type `apply-review`.
   Stop. Do not start another pass.
