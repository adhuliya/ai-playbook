# Sub-agent contract (workon)

Sub-agents never see the parent chat.
Make each sub-agent prompt self-contained.
Terms (launch, background, foreground, inherit model) map to your harness per the harness-neutral terms in `.agents/rules/dev-main.md`.
Write each output file as a record.
Follow **Writing style** in [`SKILL.md`](SKILL.md).
Paste that style into the prompt.
Honor **Pipeline in flight** while a pipeline runs.

## Launch

Use a general-purpose sub-agent.
Inherit the model unless the user named one.
From the chat parent, launch in the background.
Do not wait or poll.
Launch independent sub-agents together (one message where the harness allows).
Then do work that does not need them, or end the turn.

Stay at depth 1.
A worker may split its job MECE into children.
Children run in the foreground.
The worker blocks, then merges the children.
A child writes only its file in that worker's slice directory.
Children must not launch agents.

On a re-run, overwrite the assigned files.
Delete stale files in the slice directory first.
Do not wipe any other directory.

The parent owns `inflight.md`.
Agents never read or write it.
Keep pipeline files after use.
Delete them only through `delete-tmp-files`.

## Every agent

Write only the assigned files.
Create directories when you need them.
Merge child slices into the assigned file before exit.
Start with the role's H1.
Do not add a preamble.
Ask the user nothing.

Never write an activity file.
Those files are `activity.md`, `journal.md`, `requirement-def.md`, `design-choices.md`, `conventions.md`, `notes-by-user.md`, `reviews.md`, `user-guide.md`, and `activities.md`.

Never read `requirement-def.md`, `design-choices.md`, `notes-by-user.md`, `reviews.md`, or `journal.md`.
The parent pastes the excerpts you need.
Read another agent's file only when the prompt lists it as input.
Never read a slice directory that is not yours.

Edit code only as a milestone worker, and only inside assigned paths.
A comment editor edits only comments, and only inside assigned files.
Run only the commands the prompt names.
The env agent may run documented setup and build commands.
The env agent must not invent tooling.
Do not `git add` or commit.
Do not install into the system or change it unless the prompt says the user asked.

The parent passes the `conventions.md` path to every agent except explores that do not need it.
Those agents may read that file.

**Plan packet** (the parent pastes it): Goal, Scope, Current Design, Current Plan, Milestones, Next Steps, the Problem header, full RD, full Design Decisions, and the `conventions.md` path.
Workers, the env agent, test agents, and explores get only the slices they need.

## Paths and readiness

Root: `.dev-notes/activities/<slug>/artifacts/`.
`<n>` is the milestone number.
`<side>` is `positive` or `negative`.

| Role | Assigned file | Ready marker | Slice dir |
|---|---|---|---|
| `verify-plan` critic | `verify-plan/critic-<side>.md` | `^# Critic` | `verify-plan/<side>/` |
| `verify-plan` synthesizer | `verify-plan/synthesis.md` | `^# Synthesis` | `verify-plan/synth/` |
| review env | `review/env.md` | `^status: (ready\|blocked)` | `review/env/` |
| review test | `review/milestone-<n>.md` | `^# Milestone` | `review/milestone-<n>/` |
| review critic | `review/critic-<side>.md` | `^# Critic` | `review/<side>/` |
| review synthesizer | `review/report.md` | `^# Review report` | `review/synth/` |
| fix-cycle review (all four roles above) | same names under `fix/review/` | same | same names under `fix/review/` |
| comment snapshot (parent) | `comments/before/<path>` | none | none |
| comment editor | `comments/job-<k>.md` + assigned files (comments only) | `^# Comments job` | `comments/job-<k>/` |
| comment verifier | `comments/verify.md` | `^# Comments verify` | none |
| drift scanner | `fix/drift.md` | `^# Drift` | `fix/drift/` |
| milestone worker | `bg/milestone-<n>/<job>.md` + assigned code/test paths | `^# Job` | `bg/milestone-<n>/<job>/` |
| milestone collator | `bg/milestone-<n>/collate.md` | `^# Collate` | none |
| milestone critic | `bg/milestone-<n>/critic-<side>.md` | `^# Critic` | `bg/milestone-<n>/<side>/` |
| explore | `bg/<name>.md` (optional) | none | `bg/<name>/` |

**Ready** means a completion notice, or `test -f` plus `rg -l '<marker>'` on the assigned file.
Missing, empty, or no match means not ready.

## Parent reads

For status, read metadata only (`test -f`, size, mtime).
When the file is missing, say so.
Never read a body to judge status.

Read a body only to consume a result.
Read the final file the pipeline step names.
Also read explore reports while you draft.
Read `env.md` only when it says `blocked`.
Do not read job reports, test reports, critic files, comment job reports, snapshots, or slice directories.
On the milestone evaluate step, read both critic files and reconcile them.

## Collect vs evaluate

Use one agent to collect facts.
Facts are outcomes, paths, pass or fail, and joins.
Use a **critic pair** to judge quality, rank options, or decide a change.
Never use one agent to evaluate.
Launch the pair in one message.
Give them the same input and opposite briefs.
The reconciler is the synthesizer for `verify-plan` and review.
The reconciler is the parent for a milestone.

### Critic pair

Both critics steelman the work before they judge.
Give a reason and a `where` for every item.
Do not give generic praise.
Do not file prose nits.
Do not invent requirements.

The positive critic writes `# Critic positive`.
Name what stands out as good.
Rank by weight.
Keep the top ~5.
Say what breaks if that item is removed or churned.
Do not propose changes.
When nothing stands out, write `- none`.
The negative critic writes `# Critic negative`.
Name what you dislike most.
Put the worst item first.
List every `must`.
Cap the rest at ~5.
When nothing is wrong, write `- none`.
Field lists: **Output shapes**.

**Kinds.** Defects: `unmet-rd`, `partial-rd`, `contradiction`, `resume-hole`, `evidence-gap`, `convention-fight`, `false-done` (claimed done; evidence disagrees). Taste: `replaceable` (a cheaper path still meets RD). Intent: `unclear` (two plausible readings).

**Weights.** `load-bearing`: Goal, RD, or an invariant. Do not churn it without a shown defect. `strong`: keep it unless a defect wins. `nice`: a `should` fix may win.

### Reconcile

A defect beats a Keep.
Taste loses to a Keep.
When a defect and a taste item depend on user intent, ask a question.
Propose no change in that case.
Output changes only.
Do not write "negative says" or "positive says".
Mention a Keep only as `keep: honored` or `overridden` on a change that touches it.
The synthesizer may add one item (`from: synth`) for an evident `must` both critics missed.

## Pipelines

Turn-stage: launch a step, then end the turn. Start the next step only when
every file of the current step is ready. One of two ready → report status
only.

### `verify-plan`

Critic input: plan packet. Critics MAY Read paths the plan cites; no other
repo walk.

- Negative focus: each RD entry met / partial / unmet / untestable; RD vs
  design vs plan vs milestones vs conventions; unclear intent; cheaper
  design; resume holes; missing unit or integration tests, last-milestone e2e, or
  `software-interface` fake.
- Positive focus: testable, correctly kinded RD; Design Decisions with real
  alternatives; MECE milestones, named e2e, resume-safe Next Steps, real
  invariants.

1. Delete stale slices. Launch the critic pair. Tell the user.
2. Both ready → launch the synthesizer (plan packet + both critic paths).
3. Parent Reads only `synthesis.md`. Strip proposals that break **Stops**.
4. **Question gate:** answer from session knowledge and patch
   `synthesis.md`. Grill the rest one at a time (recommend an answer); patch
   again. Unanswered items stay out of apply. `- none` → skip.
5. Show `## Proposals`. Ask all / some / none. Never apply in the turn of
   the first Read. Record each proposal as an `agent` point: accepted
   ones per **Reviews** (where points go), rejected ones `rejected: <why>`.

### Review (`start-review` and fix cycle)

`<dir>` = `review/` for `start-review`; `fix/review/` for a fix cycle, so
a regular review's files stay intact. Scope: the cycle's `scope:`
(milestones, `plan`, or `drift`). Input adds the scoped milestones and the
activity diff path list (`base-branch`). `scope: drift`: input adds
`fix/drift.md`; scoped milestones are those `drift.md` maps changes to;
critics judge whether the activity files still match the drifted repo.

1. `scope: plan` → go to step 3. Else launch the env agent.
2. `blocked` → the pipeline ends; `<dir>env.md` is its final file. Read it,
   show it, stop. `ready` → launch one test agent per scoped milestone.
   None → go to step 3.
3. All test reports ready → launch the critic pair. Input: plan packet plus
   `env.md` and test report paths (if any). Critics MAY Read the scoped
   changed paths; they do not re-run tests or walk the rest of the repo.
4. Both ready → launch the synthesizer (same input + both critic paths).
5. Parent Reads only `<dir>report.md`. It records the points in the cycle
   that launched the pipeline (`start-review` step 4, or `fix-activity`
   E3). Never apply in the turn of the first Read.

- Negative focus: false done, plan vs evidence, missing tests, env or setup
  drift, ignored conventions, resume holes, over- or under-scope, claimed
  completion without e2e, joins with earlier milestones, comments below
  the `review-comments` level.
- Positive focus: claims the evidence proves, solid tests, sound setup. Work
  an edit must not undo.

### Milestone

In flight from step 1 until the milestone is checked or abandoned, across
job rounds and the critic pair (`inflight.md` stays).

1. Split the milestone into MECE jobs with disjoint write paths (code, tests)
   and one report each. Launch all workers.
2. All job reports ready → launch the collator (milestone claim, test cases,
   evidence commands, job report paths).
3. Parent Reads only `collate.md`. `fail` or `conflict` → new job round or an
   inline fix. Do not check the milestone while a job round is open.
   `pass` → step 4 if it applies; then update activity files
   (**Update cadence**), check the milestone, and delete `inflight.md`.
4. **Evaluate** when the parent must judge quality, not only record a pass:
   real design latitude, the last milestone, or the user asked. Launch the
   critic pair. Input: milestone claim, RD and design slices, `collate.md`
   and changed paths (MAY Read). Parent Reads both critic files and
   reconciles. Fix `must` defects in a job round; record the rest.

- Negative focus: unmet RD, weak or missing unit or integration tests, new
  tests that duplicate an existing test's goal, convention fights, style
  that breaks from the surrounding code, fragile joins, needless complexity.
- Positive focus: clean interfaces, solid tests, simple design. Work the next
  round must not undo.

### Comments (`add-review-comments`, `remove-review-comments`)

Target level: review (`add-review-comments`) or default
(`remove-review-comments`). Level rules: **Engineering while focused** in `building.md`.
Paste those rules into every brief.

1. Base = `git merge-base HEAD <base-branch>` (`<base-branch>` as resolved
   by the command: local, else `origin/`). Files = `git diff
   --name-only <base>` plus new untracked files (`git ls-files --others
   --exclude-standard`). Drop activity files, `.dev-notes/`, generated, and
   binary files. Ask the user if an untracked file looks unrelated.
2. Delete the old `comments/`. Copy each file to `comments/before/<path>`
   (the snapshot).
3. Split files MECE into jobs (no shared file). Each brief: target level,
   the level rules, assigned files, and their hunks (`git diff -U0 <base> --
   <file>`; a new file is one hunk). Launch all editors.
4. All job reports ready → launch the verifier (file list, snapshot root,
   Setup build and test commands).
5. Parent Reads only `comments/verify.md` (`add-review-comments` /
   `remove-review-comments` steps 3–4).

**Editor rules:**

- Edit only comments (docstrings count) that sit in or directly above an
  assigned hunk. Never change code, strings, blank-line layout outside
  comments, or comments outside the hunks.
- Review level: add or extend comments to that level. Default level: delete
  or shorten comments down to that level; keep every default-level comment.
- Do not run commands. Do not touch unassigned files.

**Verifier rules:** for each file, diff the snapshot against the current
file. `pass` = every changed line is a comment or whitespace in the file's
language. Then run the Setup build and test commands once. The verifier
does not edit files.

### Drift (`fix-activity`)

One drift scanner; it collects, it does not judge. Read-only for source and
activity files. It MAY split evidence runs into children.

Input (parent pastes): baseline mode, `synced` commit and its base,
`base-branch`, each milestone with its paths and evidence commands, paths
cited in `# Current Design` and `REF<n>` bullets, Setup build and test
commands.

1. Delete old `fix/drift.md` and `fix/drift/` (keep `fix/review/`). Launch
   the scanner.
2. Ready → parent Reads only `fix/drift.md` (`fix-activity` step B).

Scanner rules:

- Changed paths, by baseline:
  - `ok`: `git diff --name-status <synced>` (working tree vs snapshot).
  - `rewritten`: compare `git diff --name-status $(git merge-base <synced>
    <base-branch>) <synced>` with the current activity diff. Report paths
    whose activity changes differ. Ignore upstream-only changes.
  - `none`: the current activity diff against `base-branch`.
  Group paths by milestone, else `other`.
- Moved paths: `git log --follow` or `rg`. Missing: cited paths that no
  longer exist.
- Re-run the evidence of each checked milestone whose paths changed.
  Baseline `none` with checked milestones → re-run every checked milestone
  and the Setup build. No checked milestone → skip runs.
- `major: yes` when any holds: baseline `none` with checked milestones;
  baseline `rewritten` and most activity paths changed; about a third or
  more of cited paths missing; the Setup build or a test fails; the
  top-level layout changed; `base-branch` missing.

### Planning explores

MAY launch read-only explores (patterns, call sites, one subtree), then ask
the next grill question and end the turn. Report to `bg/<name>.md` if the
parent named it; else return a tight bullet list. Explores do not overlap
assigned paths and do not modify source.

## Output shapes

Start with the role's H1.
An empty section holds `- none`.
Name `where` as an activity-file entry or a product path.

```markdown
# Critic positive
## Keep
### <short title>
- weight: load-bearing | strong | nice
- where: `activity.md` `# …` | `RD<n>` | `DC<nn>` | `CONV<n>` | <path>
- why: <what breaks if removed or churned>

# Critic negative
## Findings
### <short title>
- kind: <kind>
- severity: must | should
- where: <same style>
- issue: <1–3 bullets: what is wrong and why it matters>
- propose: <concrete edit, or `clarify: <ambiguity>`>

# Synthesis
## Proposals
### <short title>
- severity: must | should
- where: <same style>
- change: <the edit>
- why: <one line>
- from: negative | synth
- keep: none | honored `<title>` | overridden `<title>` because <defect>
## Questions
### <short title>
- ask: <one decision>
- recommend: <best guess>
- why-it-matters: <which proposal this unlocks or kills>

# Review report
## Evidence
- scope: milestones <list> | plan | drift <synced>..HEAD
- env: ready | blocked | skipped
- milestone <n>: pass | fail | skipped
## Proposals
<same fields as Synthesis; `from: env | tests | negative | synth`>

# Env
status: ready | blocked
## Used
- <command or toolchain>
## Findings
- <bullet>

# Milestone <n>
- claim: <what the plan claims>
- result: pass | fail | blocked
- evidence: `<command>`: <one-line outcome>

# Job <name>
- result: done | partial | blocked
- changed: <paths>
- tests: `<command>`: <one-line outcome>
- notes: <interface assumptions, open issues>

# Collate milestone <n>
- result: pass | fail | conflict
- evidence: `<command>`: <one-line outcome>
- joins: <gaps, overlaps, interface mismatches; or none>
- next: <fix jobs, or none>

# Comments job <k>
- result: done | partial | blocked
- changed: <paths>
- notes: <skipped files, unclear comments; or none>

# Comments verify
- result: pass | fail
- files: `<path>`: pass | fail: <first non-comment changed line>
- tests: `<command>`: pass | fail: <one-line outcome>

# Drift
- baseline: ok | rewritten | none
- range: <synced>..HEAD + uncommitted
- changed: milestone <n> | other: <paths>
- moved: <old → new; or none>
- missing: <cited paths; or none>
- evidence: milestone <n>: `<command>`: pass | fail: <one line> | skipped
- major: yes | no — <trigger>
```

`blocked` means documented setup or build cannot run.
`blocked` also means no documented command exists and discovery failed.
Test agents run the named commands only.
Do not add a second suite.
Do not edit source.
