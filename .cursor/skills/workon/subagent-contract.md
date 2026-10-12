# Sub-agent contract (workon)

Sub-agents never see the parent chat. Each Task prompt is self-contained.
Every written file is a record (**Writing style** in `SKILL.md`). While a
pipeline runs, activity files are frozen (**Pipeline in flight** in
`SKILL.md`).

## Launch

- `subagent_type: generalPurpose`. `model`: inherit unless the user named a
  listed model.
- Chat parent: `run_in_background: true`. Never wait (no AwaitShell, no
  status loops). Launch independent Tasks in one message. Then do work that
  does not need them, or end the turn.
- Depth 1 only. A worker MAY split its job MECE into children
  (`run_in_background: false`; block, then merge). A child writes only its
  file in the worker's slice dir. Children MUST NOT launch agents.
- Re-run: overwrite assigned files. Delete stale files in the slice dir first.
  The Comments pipeline wipes `comments/` at its step 2; the Drift
  pipeline wipes `fix/drift.md` + `fix/drift/` at its step 1. Nothing else
  is wiped.
- The parent owns `inflight.md` (**Inflight scratch** in `SKILL.md`);
  agents never touch it.
- Keep all files after use (committable). Delete only via `delete-tmp-files`.

## Every agent

- Write only the assigned files. Create dirs if needed. Merge child slices
  into the assigned file before exit. Start with the role's H1. No preamble.
- Ask the user nothing.
- Never write activity files: `activity.md`, `journal.md`,
  `requirement-def.md`, `design-choices.md`, `conventions.md`,
  `notes-by-user.md`, `reviews.md`, `user-guide.md`, `activities.md`.
- Never Read `requirement-def.md`, `design-choices.md`, `notes-by-user.md`,
  `reviews.md`, or `journal.md`. The parent pastes the needed excerpts.
- Read another agent's file only if the prompt lists it as input. Never Read
  a slice dir that is not yours.
- Edit code only as a milestone worker, inside assigned paths. A comment
  editor edits only comments, inside assigned files. Run only the
  commands the prompt names. The env agent MAY run documented setup and
  build commands; it MUST NOT invent tooling.
- No `git add` or commit. Follow **Isolated setup** (`SKILL.md`): no system
  installs or changes unless the prompt says the user asked.
- The parent passes the `conventions.md` path to every agent except explores
  that do not need it. Agents MAY Read it.

**Plan packet** (parent pastes): Goal, Scope, Current Design, Current Plan,
Milestones, Next Steps, the Problem header, full RD, full Design Decisions,
and the
`conventions.md` path. Workers, env, test, and explore agents get only the
slices they need.

## Paths and readiness

Root: `.dev-notes/activities/<slug>/artifacts/`. `<n>` is the milestone
number. `<side>` is `positive` or `negative`.

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

**Ready** = completion notice, or `test -f` plus `rg -l '<marker>'` on the
assigned file. Missing, empty, or no match → not ready.

## Parent reads

- **Status:** metadata only (`test -f`, size, mtime). No file → say so. Never
  Read a body for status.
- **Results:** Read a body only to consume it: explore reports while
  drafting, `synthesis.md`, `review/report.md`, `fix/review/report.md`,
  `comments/verify.md`, `fix/drift.md`, `collate.md`, the milestone critic
  pair, and `env.md` (either review dir) only when `blocked`. Never Read job reports, test reports, `verify-plan` or review
  critic files, comment job reports, snapshots, or slice dirs.

## Collect vs evaluate

- **Collect:** merge facts (outcomes, paths, pass/fail, joins). One agent.
- **Evaluate:** judge quality, rank options, or decide what to change. Never
  one agent. Launch the **critic pair** in one message: isolated, same input,
  opposite briefs. A **reconciler** weighs both files: the synthesizer
  (`verify-plan`, review) or the parent (milestone).

### Critic pair

Both critics: steelman the work before judging. Give a reason and a `where`
for every item. No generic praise, prose nits, or invented requirements.

**Positive critic** (`# Critic positive`): name what stands out as good.
Rank by weight; top ~5. Each item says what breaks if it is removed or
churned. No change proposals. Nothing stands out → `- none`.

```markdown
# Critic positive

## Keep
### <short title>
- weight: load-bearing | strong | nice
- where: `activity.md` `# …` | `RD<n>` | `DC<nn>` | `CONV<n>` | <path>
- why: <what breaks if removed or churned>
```

**Negative critic** (`# Critic negative`): name what you dislike most. Rank
worst first. List every `must`; cap the rest at ~5. Nothing wrong →
`- none`.

```markdown
# Critic negative

## Findings
### <short title>
- kind: <kind>
- severity: must | should
- where: <same style>
- issue: <1–3 bullets: what is wrong and why it matters>
- propose: <concrete edit, or `clarify: <ambiguity>`>
```

**Kinds.** Defects: `unmet-rd`, `partial-rd`, `contradiction`,
`resume-hole`, `evidence-gap`, `convention-fight`, `false-done` (claimed
done; evidence disagrees). Taste: `replaceable` (a cheaper path still meets
RD). Intent: `unclear` (two plausible readings).

**Weights.** `load-bearing`: Goal, RD, or invariant; do not churn without a
shown defect. `strong`: keep unless a defect. `nice`: a `should` fix may win.

### Reconcile

- A defect beats a Keep. Taste loses to a Keep.
- Defect vs taste depends on user intent → ask a question; propose no change.
- Output changes only. No "negative says / positive says". A Keep appears
  only as `keep: honored` or `overridden` on a change that touches it.
- The synthesizer adds its own item (`from: synth`) only for an evident
  `must` defect that both critics missed.

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

1. Delete stale slices. Launch the critic pair. Tell the user. End the turn.
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

1. `scope: plan` → go to step 3. Else launch the env agent. End the turn.
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
   and one report each. Launch all workers. End the turn.
2. All job reports ready → launch the collator (milestone claim, test cases,
   evidence commands, job report paths).
3. Parent Reads only `collate.md`. `fail` or `conflict` → new job round or an
   inline fix. `pass` → step 4 if it applies; then update activity files
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
(`remove-review-comments`). Level rules: **Engineering while focused**
comments in `SKILL.md`; the parent pastes them into every brief.

1. Base = `git merge-base HEAD <base-branch>` (`<base-branch>` as resolved
   by the command: local, else `origin/`). Files = `git diff
   --name-only <base>` plus new untracked files (`git ls-files --others
   --exclude-standard`). Drop activity files, `.dev-notes/`, generated, and
   binary files. Ask the user if an untracked file looks unrelated.
2. Delete the old `comments/`. Copy each file to `comments/before/<path>`
   (the snapshot).
3. Split files MECE into jobs (no shared file). Each brief: target level,
   the level rules, assigned files, and their hunks (`git diff -U0 <base> --
   <file>`; a new file is one hunk). Launch all editors. End the turn.
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
   the scanner. End the turn.
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

```markdown
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
```

```markdown
# Review report

## Evidence
- scope: milestones <list> | plan | drift <synced>..HEAD
- env: ready | blocked | skipped
- milestone <n>: pass | fail | skipped

## Proposals
<same shape as Synthesis; `from: env | tests | negative | synth`>
```

Each proposal becomes one `agent` point in the open cycle. `where` names an
activity file entry or a product path; product work becomes a review
milestone at `apply-review`. Empty sections hold `- none`.

```markdown
# Env

status: ready | blocked

## Used
- <command or toolchain>

## Findings
- <bullet>
```

`blocked` = documented setup or build cannot run, or no documented command
exists and discovery failed.

```markdown
# Milestone <n>

- claim: <what the plan claims>
- result: pass | fail | blocked
- evidence:
  - `<command>`: <one-line outcome>
```

Test agents run the named commands only. No second suite. No source edits.

```markdown
# Job <name>

- result: done | partial | blocked
- changed: <paths>
- tests: `<command>`: <one-line outcome>
- notes: <interface assumptions, open issues>
```

Workers follow **Engineering while focused** (`SKILL.md`) and run their
job's tests.

```markdown
# Collate milestone <n>

- result: pass | fail | conflict
- evidence:
  - `<command>`: <one-line outcome>
- joins: <gaps, overlaps, interface mismatches; or none>
- next: <fix jobs, or none>
```

The collator collects only: it checks joins and runs the evidence commands.
It does not edit code or judge quality.

```markdown
# Comments job <k>

- result: done | partial | blocked
- changed: <paths>
- notes: <skipped files, unclear comments; or none>
```

```markdown
# Comments verify

- result: pass | fail
- files:
  - `<path>`: pass | fail: <first non-comment changed line>
- tests: `<command>`: pass | fail: <one-line outcome>
```

```markdown
# Drift

- baseline: ok | rewritten | none
- range: <synced>..HEAD + uncommitted
- changed:
  - milestone <n> | other: <paths>
- moved: <old → new; or none>
- missing: <cited paths; or none>
- evidence:
  - milestone <n>: `<command>`: pass | fail: <one line> | skipped
- major: yes | no — <trigger>
```
