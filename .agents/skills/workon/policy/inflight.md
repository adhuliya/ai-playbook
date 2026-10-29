# Inflight pipelines

A pipeline is a `verify-plan`, review (`start-review` or fix cycle),
comment, drift, or milestone run. It is in flight while
`<slug>/artifacts/inflight.md` exists. Planning explores are not pipelines,
and an open review cycle that waits for `apply-review` is not a unit of
work.

`inflight.md` is parent-only scratch (shape: `shapes/layout.md`). Sub-agents never read or write it. Live lines go to `artifacts/sub-agents-log.txt`.
`agent-activity.md` is the user's view of the activity. Create `inflight.md` fresh when a unit
starts, overwriting any old one, and record the pipeline, the unit
(`RU<n>`, `M<n>`, or command), the launched steps, the expected
final file, and short working notes. Before launch, set `agent-activity.md`
`# Next Steps` item 1 to `In progress: <pipeline> <unit>` so the user sees
it. Delete it when the parent reads the final file (for a milestone, after
the checkpoint that checks it). For `verify-plan`, delete it only after
all / some / none is recorded, or when synthesis is `- none`. Also delete
it when env is `blocked`. On abandon, run the steps below first.
Then refresh `# Next Steps`.

While a pipeline is in flight, activity files are frozen except for the
parent's own steps of that pipeline (such as a milestone checkpoint). A
comment pipeline also freezes the files it snapshots; ask the user not to
edit them. The every-turn rules (skipped session start, refused keywords, allowed
reads) are the **Stops** pipeline rule.

## Pause and resume

`pause-work` sets `Paused` and does not delete or rewrite `inflight.md`.
Sub-agents keep running. They may write only their assigned outputs.
They still must not write activity files or `inflight.md`. Do not kill them.

While `Paused`, do not finish the unit. Do not check a milestone, record
points, enter the question gate, or delete `inflight.md`. Prompt
`resume-work`.

On `resume-work`, after `prior:` is restored, finish only when this chat
has a completion notice for this launch's final file (**Paths and
readiness**). A ready marker on disk is not that notice. Run only the
parent end step. Do not relaunch. After that step, follow **Continue
mode** only when the status is `Active` and `inflight.md` is gone.

With no notice, or in a new chat, do not read the final file and do not
follow **Continue mode**. In the launching chat, they may wait. If they
abandon, name the re-run keyword and do not launch it in that turn.
`auto` does not start work on that turn.

Abandon leaves the status unchanged, so `Paused` stays until
`resume-work`. When `pipeline:` is `comments`, copy each
`comments/before/<path>` file over its working file. Do not set
`review-comments`. Warn that a still-running editor may write a restored
file again. Then delete `inflight.md`. Remove `In progress:` and put the
re-run keyword in `# Next Steps`. Leave an unchecked milestone unchecked.
Do not roll back any other product code. An open review cycle stays open.
Do not record this run's points. Abandon does not unpause.

Re-run keywords: `verify-plan`; `start-review`; `fix-activity`; the
comment command named in `unit:`; an unchecked `M<n>` names `continue`.
