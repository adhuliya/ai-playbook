# `verify-plan`

Status: `Planning`. Optional; not required for `approve-plan`. Isolated
**negative** and **positive** critics with different briefs, then a
synthesizer.

Reads: policy/launch.md, policy/inflight.md, policy/paths.md, policy/parent-reads.md, policy/critic-pair.md, pipelines/verify-plan.md

Follow the `verify-plan` pipeline (`pipelines/verify-plan.md`) for turn
stages, question gate, paths, and briefs. Write `inflight.md` (**Inflight
pipelines**) before launch. Delete it after all / some / none is
recorded, or when synthesis is `- none`. Do not delete it on the first
Read of `synthesis.md`. The parent
Reads only `synthesis.md` and filters **Stops**. After all / some / none,
or on `- none`, prompt `approve-plan`. When the cycle stayed `open`,
prompt `apply-review` instead. Just before you record points, read
`policy/reviews.md` and `policy/apply-timing.md`. Accepted and rejected
proposals become points per **Reviews** (where points go): into the open
regular cycle if one exists (applied later by `apply-review`), else a new
cycle closed this turn. Keep the assigned files and slice dirs (overwrite on
re-run; wipe stale slices). Delete only via `delete-tmp-files`.
