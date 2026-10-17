# Inflight pipelines

A pipeline is a `verify-plan`, review (`start-review` or fix cycle),
comment, drift, or milestone run. It is in flight while
`<slug>/artifacts/inflight.md` exists. Planning explores are not pipelines,
and an open review cycle that waits for `apply-review` is not a unit of
work.

`inflight.md` is parent-only scratch (shape: `shapes/layout.md`). Sub-agents never read or write it, and it is never shown as status;
`activity.md` is the user's view of progress. Create it fresh when a unit
starts, overwriting any old one, and record the pipeline, the unit
(`RU<n>`, `M<n>`, or command), the launched steps, the expected
final file, and short working notes. Before launch, set `activity.md`
`# Next Steps` item 1 to `In progress: <pipeline> <unit>` so the user sees
it. Delete it when the parent reads the final file (for a milestone, after
the checkpoint that checks it), or when the pipeline ends early (env
`blocked`, abandon), then refresh `# Next Steps`.

While a pipeline is in flight, activity files are frozen except for the
parent's own steps of that pipeline (such as a milestone checkpoint). A
comment pipeline also freezes the files it snapshots; ask the user not to
edit them. The every-turn rules (skipped session start, refused keywords, allowed
reads) are the **Stops** pipeline rule.
