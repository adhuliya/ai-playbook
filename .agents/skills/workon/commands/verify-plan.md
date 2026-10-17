# `verify-plan`

Status: `Planning`. Optional; not required for `approve-plan`. Isolated
**negative** and **positive** critics with different briefs, then a
synthesizer.

Reads: policy/reviews.md, policy/apply-timing.md, policy/launch.md, policy/inflight.md, policy/paths.md, policy/parent-reads.md, policy/critic-pair.md, pipelines/verify-plan.md

Follow the `verify-plan` pipeline (`pipelines/verify-plan.md`) for turn
stages, question gate, paths, and briefs. Write `inflight.md` (**Inflight
pipelines**) before launch; delete it after the first Read of `synthesis.md`. The parent
Reads only `synthesis.md` and filters **Stops**. Accepted and rejected
proposals become points per **Reviews** (where points go): into the open
regular cycle if one exists (applied later by `apply-review`), else a new
cycle closed this turn. Keep the assigned files and slice dirs (overwrite on
re-run; wipe stale slices). Delete only via `delete-tmp-files`.
