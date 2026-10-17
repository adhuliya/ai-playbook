# Apply timing

Nothing applies in the turn that first reads a pipeline result. `verify-plan`
applies after the contract question gate (all / some / none). `apply-review`
applies the open fix cycle, else the open regular cycle, after one round of
gap questions (see that command). `start-review` never applies; it opens or
refreshes a cycle. Chat feedback with an open regular cycle becomes `user`
points for `apply-review`; with none open it applies this turn (where
points go).

Planning order: `start-review` → `apply-review` (if the user wants the
points applied) → `verify-plan` → `approve-plan`. None of the middle steps
is required. After `Active`: `start-review` / `apply-review` only.
