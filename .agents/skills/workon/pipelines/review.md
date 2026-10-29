# Review (`start-review` and fix cycle)

`<dir>` is `review/` for `start-review` and `fix/review/` for a fix cycle,
so a regular review's files stay intact. Scope is the cycle's `scope:`
(milestones, `plan`, or `drift`). Input adds the scoped milestones and the
activity diff path list (`base-branch`). With `scope: drift`, input adds
`fix/drift.md`; the scoped milestones are those `drift.md` maps changes to,
and critics judge whether the activity files still match the drifted repo.

1. `scope: plan` → go to step 3. Else launch the env agent.
2. `blocked` → do not launch tests or critics. If `status` is `Paused`,
   prompt `resume-work` and stop (**Inflight pipelines**). Otherwise the
   parent records the cycle (`start-review` step 4, or `fix-activity`
   E3), including `- none (env blocked)`, and deletes `inflight.md`.
   `ready` → launch one test agent per scoped milestone; none → go to
   step 3.
3. All test reports ready → write `<dir>packet.md` (**Plan packet**), then
   read **Critic focus**. Launch those critics (`pipeline: review`) with
   the packet path plus `env.md` and the test report paths (if any).
   Critics MAY Read the scoped changed paths; they do not re-run tests or
   walk the rest of the repo.
4. Every critic file ready → launch the synthesizer (same input + every
   critic path).
5. If `status` is `Paused`, prompt `resume-work` and stop (**Inflight
   pipelines**). The parent Reads only `<dir>report.md` and records the
   points in the cycle that launched the pipeline (`start-review` step 4,
   or `fix-activity` E3). Never apply in the turn of the first Read.
