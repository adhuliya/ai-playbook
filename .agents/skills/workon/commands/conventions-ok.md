# `conventions-ok`

Status: `Planning`, `Approved`. If already `conventions: ok`, report and
stop (**Execution gate**).

Reads: policy/conventions.md, policy/execution-gate.md

1. If the rules are sparse or Setup is empty, and this fill was not shown in
   an earlier turn: fill them best-effort from the repo, show the diff, and
   ask the user to review and write `conventions-ok` again. Stop. If the
   fill was already shown, go to step 2.
2. Set `conventions: ok` in `agent-activity.md`. No journal, no status change.
3. If `Approved`, or if `kind` is `thin` and the status is `Planning`,
   ask for `start-building`.
