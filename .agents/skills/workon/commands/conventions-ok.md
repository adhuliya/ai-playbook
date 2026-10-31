# `conventions-ok`

Status: `Planning`, `Approved`. Also `Active` when `kind` is `thin`. If
already `conventions: ok`, report and stop (**Execution gate**).

Reads: policy/conventions.md, policy/execution-gate.md

1. When the user already said `yes` to approve-plan's "Accept the
   conventions too?" offer, accept that yes. Go to step 2. Skip the rest
   of this step. Do not ask for `conventions-ok` again. When the user
   said `review`, run the review in the next sentences. If the rules are
   sparse or Setup is empty, and this fill was not shown in an earlier
   turn: fill them best-effort from the repo, show the diff, and ask the
   user to review and write `conventions-ok` again. Stop. If the fill was
   already shown, go to step 2.
2. Set `conventions: ok` in `agent-activity.md`. No journal, no status change.
3. If `stage` is `requirements` and `kind` is `thin`, follow
   **Choose**. A typed `thin` stays thin, names `start-building`, and
   stops. Otherwise set `kind` to `full`, follow `commands/make-full.md`,
   name `requirements-ok`, and stop. Do not ask the user to type
   `make-full`. If `stage` is `requirements` and `kind` is `full`,
   prompt `requirements-ok`. If `kind` is `full`, the status is
   `Planning`, and `stage` is `design`, prompt `approve-plan`. If
   `Approved`, or if `kind` is `thin`, the status is `Planning`, and
   `stage` is `design`, ask for `start-building`. Thin
   and `Active`: no planning keyword. Follow **Continue mode**.
