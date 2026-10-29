# `conventions-ok`

Status: `Planning`, `Approved`. Also `Active` when `kind` is `thin`. If
already `conventions: ok`, report and stop (**Execution gate**).

Reads: policy/conventions.md, policy/execution-gate.md

1. If the rules are sparse or Setup is empty, and this fill was not shown in
   an earlier turn: fill them best-effort from the repo, show the diff, and
   ask the user to review and write `conventions-ok` again. Stop. If the
   fill was already shown, go to step 2.
2. Set `conventions: ok` in `agent-activity.md`. No journal, no status change.
3. If `stage` is `requirements` and `kind` is `thin`, prompt
   `make-full`. If `stage` is `requirements` and `kind` is `full`,
   prompt `requirements-ok`. If `kind` is `full`, the status is
   `Planning`, and `stage` is `design`, prompt `approve-plan`. If
   `Approved`, or if `kind` is `thin`, the status is `Planning`, and
   `stage` is `design`, ask for `start-building`. Thin
   and `Active`: no planning keyword. Follow **Continue mode**.
