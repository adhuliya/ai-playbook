# Apply timing

Nothing applies in the turn that first reads a pipeline result. In
`Planning`, `agent-review` applies after the question gate (all / some /
none). Outside `Planning`, `agent-review` never applies. It runs only when
the user types it. Do not offer it, and do not require it. `apply-review`
applies the open fix cycle, else the open regular cycle, after one round of
gap questions (see that command). `start-review` never applies and never
launches critics. It opens or refreshes a cycle for user points. A chat
note does not open a cycle. Follow **Agent notes**.

Planning order in `stage: design`: `start-review` → `apply-review` (if the
user wants the points applied) → `approve-plan`. None of the middle steps
is required. `agent-review` is not part of this order. In `stage:
requirements`, do not offer `approve-plan`. Follow **Choose**. A typed
`thin` names `start-building`. When `kind` is `thin` and the user did
not type `thin`, set `kind` to `full`, follow `commands/make-full.md`,
and name `requirements-ok`. Full names `requirements-ok`. After `Active`, the review order is
`start-review`, then `apply-review`. `continue`, building, `pause-work`,
and `mark-completed` follow their own commands.
