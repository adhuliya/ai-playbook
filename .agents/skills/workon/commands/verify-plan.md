# `verify-plan`

Status: `Planning`. Optional; not required for `approve-plan`. Isolated
negative and positive critics, then a synthesizer.

Reads: policy/launch.md, policy/inflight.md, policy/paths.md, policy/parent-reads.md, policy/critic-pair.md, pipelines/verify-plan.md

When `stage` is `requirements`, do not launch. Thin: prompt `make-full`.
Full: prompt `requirements-ok`.

Follow the `verify-plan` pipeline for stages, the question gate, paths,
and briefs. Write `inflight.md` (**Inflight pipelines**) before launch.
Do not delete it on the first Read of `synthesis.md`. Delete it after
all / some / none is recorded, or when synthesis is `- none`. If
`status` is `Paused`, prompt `resume-work` and stop (**Inflight
pipelines**).

After all / some / none, or on `- none`, prompt `approve-plan`. When
the cycle stayed `open`, prompt `apply-review` instead. Just before you
record points, read `policy/reviews.md` and `policy/apply-timing.md`.
Follow **Agent notes**. Record per **Reviews** (where points go).
