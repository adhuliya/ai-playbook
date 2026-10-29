# Apply timing

Nothing applies in the turn that first reads a pipeline result. `verify-plan`
applies after the contract question gate (all / some / none). `apply-review`
applies the open fix cycle, else the open regular cycle, after one round of
gap questions (see that command). `start-review` never applies. It opens or
refreshes a cycle. A chat note does not open a cycle. Follow **Agent notes**.

Planning order in `stage: design`: `start-review` → `apply-review` (if the
user wants the points applied) → `verify-plan` → `approve-plan`. None of
the middle steps is required. In `stage: requirements`, do not offer
`verify-plan` or `approve-plan`. Thin names `make-full`. Full names
`requirements-ok`. After `Active`: `start-review` / `apply-review` only.
