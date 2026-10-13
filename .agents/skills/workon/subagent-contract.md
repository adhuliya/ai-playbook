# Sub-agent contract (workon)

Sub-agents never see the parent chat. Each role has a brief in `briefs/`
that the sub-agent reads itself; the parent names the brief and pastes only
inputs, never brief text. Harness terms (launch, background, foreground,
inherit model) map to your harness per `.agents/rules/dev-main.md`. Honor
**Inflight pipelines** while a pipeline runs. Index: [`SKILL.md`](SKILL.md).

## Launch

Use a general-purpose sub-agent and inherit the model unless the user named
one. From the chat parent, launch in the background and do not wait or
poll. Launch independent sub-agents together (one message where the harness
allows), then do work that does not need them, or end the turn. Stay at
depth 1: a worker may split its job into foreground children, but children
never launch agents (`briefs/common.md`).

**Prompt shape.** Every prompt has these parts, in this order:

```text
Read `.agents/skills/workon/briefs/common.md`, then
`.agents/skills/workon/briefs/<role>.md`, and follow both.
role: <role>   side: positive | negative   pipeline: verify-plan | review | milestone
assigned file: <path>   slice dir: <path>
conventions: <path to conventions.md>
inputs: <paths the brief may read>
<pasted slices: plan packet, or the slices the pipeline step names>
```

`side` and `pipeline` apply to critics and synthesizers. Pass the
`conventions.md` path to every agent except explores that do not need it.

**Plan packet** (pasted by the parent): Goal, Scope, Current Design,
Current Plan, Milestones, Next Steps, the Problem header, full RD, full
Design Decisions, and the `conventions.md` path. Workers, the env agent,
test agents, and explores get only the slices they need.

On a re-run, the agent deletes stale files in its slice directory and
overwrites its assigned files; nothing else is wiped. Keep pipeline files
after use; delete them only through `delete-tmp-files`.

## Inflight pipelines

A pipeline is a `verify-plan`, review (`start-review` or fix cycle),
comment, drift, or milestone run. It is in flight while
`<slug>/artifacts/inflight.md` exists. Planning explores are not pipelines,
and an open review cycle that waits for `apply-review` is not a unit of
work.

`inflight.md` is parent-only scratch (shape: `templates.md#Directory
layout`). Sub-agents never read or write it, and it is never shown as status;
`activity.md` is the user's view of progress. Create it fresh when a unit
starts, overwriting any old one, and record the pipeline, the unit
(`RU<n>`, milestone `<n>`, or command), the launched steps, the expected
final file, and short working notes. Before launch, set `activity.md`
`# Next Steps` item 1 to `In progress: <pipeline> <unit>` so the user sees
it. Delete it when the parent reads the final file (for a milestone, after
the checkpoint that checks it), or when the pipeline ends early (env
`blocked`, abandon), then refresh `# Next Steps`.

While a pipeline is in flight, activity files are frozen except for the
parent's own steps of that pipeline (such as a milestone checkpoint). A
comment pipeline also freezes the files it snapshots; ask the user not to
edit them. The every-turn rules (skipped probe, refused keywords, allowed
reads) are the **Stops** pipeline rule.

## Paths and readiness

Root: `.dev-notes/activities/<slug>/artifacts/`. `<n>` is the milestone
number; `<side>` is `positive` or `negative`. The brief column names the
file under `briefs/`.

| Role | Brief | Assigned file | Ready marker | Slice dir |
|---|---|---|---|---|
| `verify-plan` critic | `critic` | `verify-plan/critic-<side>.md` | `^# Critic` | `verify-plan/<side>/` |
| `verify-plan` synthesizer | `synthesizer` | `verify-plan/synthesis.md` | `^# Synthesis` | `verify-plan/synth/` |
| review env | `env` | `review/env.md` | `^status: (ready\|blocked)` | `review/env/` |
| review test | `test` | `review/milestone-<n>.md` | `^# Milestone` | `review/milestone-<n>/` |
| review critic | `critic` | `review/critic-<side>.md` | `^# Critic` | `review/<side>/` |
| review synthesizer | `synthesizer` | `review/report.md` | `^# Review report` | `review/synth/` |
| fix-cycle review (all four roles above) | same | same names under `fix/review/` | same | same names under `fix/review/` |
| comment snapshot (parent) | — | `comments/before/<path>` | none | none |
| comment editor | `comment-editor` | `comments/job-<k>.md` + assigned files (comments only) | `^# Comments job` | `comments/job-<k>/` |
| comment verifier | `comment-verifier` | `comments/verify.md` | `^# Comments verify` | none |
| drift scanner | `drift-scanner` | `fix/drift.md` | `^# Drift` | `fix/drift/` |
| milestone worker | `worker` | `bg/milestone-<n>/<job>.md` + assigned code/test paths | `^# Job` | `bg/milestone-<n>/<job>/` |
| milestone collator | `collator` | `bg/milestone-<n>/collate.md` | `^# Collate` | none |
| milestone critic | `critic` | `bg/milestone-<n>/critic-<side>.md` | `^# Critic` | `bg/milestone-<n>/<side>/` |
| explore | `explore` | `bg/<name>.md` (optional) | none | `bg/<name>/` |

**Ready** means a completion notice, or `test -f` plus `rg -l '<marker>'`
on the assigned file. Missing, empty, or no match means not ready.

## Parent reads

For status, read metadata only (`test -f`, size, mtime); when the file is
missing, say so. Never read a body to judge status.

Read a body only to consume a result: the final file the pipeline step
names, explore reports while you draft, `env.md` only when it says
`blocked`, and both critic files on the milestone evaluate step (then
reconcile them per **Reconcile** in `briefs/synthesizer.md`). Do not read
job reports, test reports, critic files, comment job reports, snapshots, or
slice directories otherwise.

## Collect vs evaluate

Use one agent to collect facts: outcomes, paths, pass or fail, and joins.
Use a **critic pair** to judge quality, rank options, or decide a change;
never one agent. Launch the pair in one message with the same input and
opposite `side` values; `briefs/critic.md` carries both briefs and the
focus list for each pipeline. The reconciler is the synthesizer for
`verify-plan` and review, and the parent for a milestone.

## Pipelines

Turn-stage: launch a step, then end the turn. Start the next step only
when every file of the current step is ready; with one of two ready,
report status only.

### `verify-plan`

Critic input: the plan packet. Critics MAY Read paths the plan cites; no
other repo walk.

1. Delete stale slices. Launch the critic pair (`pipeline: verify-plan`).
   Tell the user.
2. Both ready → launch the synthesizer (plan packet + both critic paths).
3. The parent Reads only `synthesis.md` and strips proposals that break
   **Stops**.
4. **Question gate:** answer from session knowledge and patch
   `synthesis.md`. Grill the rest one at a time (recommend an answer) and
   patch again. Unanswered items stay out of apply. `- none` → skip.
5. Show `## Proposals`. Ask all / some / none. Never apply in the turn of
   the first Read. Record each proposal as an `agent` point: accepted ones
   per **Reviews** (where points go), rejected ones `rejected: <why>`.

### Review (`start-review` and fix cycle)

`<dir>` is `review/` for `start-review` and `fix/review/` for a fix cycle,
so a regular review's files stay intact. Scope is the cycle's `scope:`
(milestones, `plan`, or `drift`). Input adds the scoped milestones and the
activity diff path list (`base-branch`). With `scope: drift`, input adds
`fix/drift.md`; the scoped milestones are those `drift.md` maps changes to,
and critics judge whether the activity files still match the drifted repo.

1. `scope: plan` → go to step 3. Else launch the env agent.
2. `blocked` → the pipeline ends and `<dir>env.md` is its final file: read
   it, show it, stop. `ready` → launch one test agent per scoped
   milestone; none → go to step 3.
3. All test reports ready → launch the critic pair (`pipeline: review`)
   with the plan packet plus `env.md` and the test report paths (if any).
   Critics MAY Read the scoped changed paths; they do not re-run tests or
   walk the rest of the repo.
4. Both ready → launch the synthesizer (same input + both critic paths).
5. The parent Reads only `<dir>report.md` and records the points in the
   cycle that launched the pipeline (`start-review` step 4, or
   `fix-activity` E3). Never apply in the turn of the first Read.

### Milestone

In flight from step 1 until the milestone is checked or abandoned, across
job rounds and the critic pair (`inflight.md` stays).

1. Split the milestone into MECE jobs with disjoint write paths (code,
   tests) and one report each. Launch all workers.
2. All job reports ready → launch the collator (milestone claim, test
   cases, evidence commands, job report paths).
3. The parent Reads only `collate.md`. `fail` or `conflict` → a new job
   round or an inline fix; do not check the milestone while a job round is
   open. `pass` → step 4 if it applies; then update the activity files
   (**Update cadence**), check the milestone, and delete `inflight.md`.
4. **Evaluate** when the parent must judge quality, not only record a pass:
   real design latitude, the last milestone, or the user asked. Launch the
   critic pair (`pipeline: milestone`) with the milestone claim, RD and
   design slices, `collate.md`, and the changed paths (MAY Read). The
   parent Reads both critic files and reconciles. Fix `must` defects in a
   job round; record the rest.

### Comments (`add-review-comments`, `remove-review-comments`)

Target level: review (`add-review-comments`) or default
(`remove-review-comments`); the editor brief loads the level rules.

1. Base = `git merge-base HEAD <base-branch>` (`<base-branch>` as the
   command resolved it: local, else `origin/`). Files = `git diff
   --name-only <base>` plus new untracked files (`git ls-files --others
   --exclude-standard`). Drop activity files, `.dev-notes/`, generated, and
   binary files. Ask the user if an untracked file looks unrelated.
2. Delete the old `comments/`. Copy each file to `comments/before/<path>`
   (the snapshot).
3. Split the files MECE into jobs (no shared file). Each prompt: target
   level, assigned files, and their hunks (`git diff -U0 <base> --
   <file>`; a new file is one hunk). Launch all editors.
4. All job reports ready → launch the verifier (file list, snapshot root,
   Setup build and test commands).
5. The parent Reads only `comments/verify.md` (`add-review-comments` /
   `remove-review-comments` steps 3–4).

### Drift (`fix-activity`)

One drift scanner collects and does not judge. Input (pasted by the
parent): baseline mode, the `synced` commit and its base, the fresh
snapshot `<now>`, `base-branch`, each milestone with its paths and
evidence commands, paths cited in `# Current Design` and `REF<n>` bullets,
and the Setup build and test commands.

1. Delete the old `fix/drift.md` and `fix/drift/` (keep `fix/review/`).
   Launch the scanner.
2. Ready → the parent Reads only `fix/drift.md` (`fix-activity` step B).

### Planning explores

The parent MAY launch read-only explores (patterns, call sites, one
subtree), then ask the next grill question and end the turn. An explore
reports to `bg/<name>.md` when the parent named it; else it returns a tight
bullet list.
