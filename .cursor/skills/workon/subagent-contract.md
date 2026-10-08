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
- Keep all files after use (committable). Delete only via `delete-tmp-files`.

## Every agent

- Write only the assigned files. Create dirs if needed. Merge child slices
  into the assigned file before exit. Start with the role's H1. No preamble.
- Ask the user nothing.
- Never write activity files: `activity.md`, `journal.md`,
  `requirements.md`, `design-choices.md`, `conventions.md`,
  `notes-by-user.md`, `reviews.md`, `user-guide.md`, `activities.md`.
- Never Read `requirements.md`, `design-choices.md`, `notes-by-user.md`,
  `reviews.md`, or `journal.md`. The parent pastes the needed excerpts.
- Read another agent's file only if the prompt lists it as input. Never Read
  a slice dir that is not yours.
- Edit code only as a milestone worker, inside assigned paths. Run only the
  commands the prompt names. The env agent MAY run documented setup and
  build commands; it MUST NOT invent tooling.
- No `git add` or commit. Follow **Isolated setup** (`SKILL.md`): no system
  installs or changes unless the prompt says the user asked.
- The parent passes the `conventions.md` path to every agent except explores
  that do not need it. Agents MAY Read it.

**Plan packet** (parent pastes): Goal, Scope, Current Design, Current Plan,
Milestones, Next Steps, full ARD, full Design Decisions, and the
`conventions.md` path. Workers, env, test, and explore agents get only the
slices they need.

## Paths and readiness

Root: `.dev-notes/activities/<slug>/artifacts/`. `<n>` is the milestone
number. `<side>` is `positive` or `negative`.

| Role | Assigned file | Ready marker | Slice dir |
|---|---|---|---|
| `verify-plan` critic | `verify-plan/critic-<side>.md` | `^# Critic` | `verify-plan/<side>/` |
| `verify-plan` synthesizer | `verify-plan/synthesis.md` | `^# Synthesis` | `verify-plan/synth/` |
| `self-review` env | `self-review/env.md` | `^status: (ready\|blocked)` | `self-review/env/` |
| `self-review` test | `self-review/milestone-<n>.md` | `^# Milestone` | `self-review/milestone-<n>/` |
| `self-review` critic | `self-review/critic-<side>.md` | `^# Critic` | `self-review/<side>/` |
| `self-review` synthesizer | `self-review.md` | `^# Self-review` | `self-review/synth/` |
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
  drafting, `synthesis.md`, `self-review.md`, `collate.md`, the milestone
  critic pair, and `env.md` only when `blocked`. Never Read job reports, test
  reports, `verify-plan` or `self-review` critic files, or slice dirs.

## Collect vs evaluate

- **Collect:** merge facts (outcomes, paths, pass/fail, joins). One agent.
- **Evaluate:** judge quality, rank options, or decide what to change. Never
  one agent. Launch the **critic pair** in one message: isolated, same input,
  opposite briefs. A **reconciler** weighs both files: the synthesizer
  (`verify-plan`, `self-review`) or the parent (milestone).

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
- where: `activity.md` `# …` | `R<n>` | `DC<nn>` | `CONV<n>` | <path>
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

**Kinds.** Defects: `unmet-ard`, `partial-ard`, `contradiction`,
`resume-hole`, `evidence-gap`, `convention-fight`, `false-done` (claimed
done; evidence disagrees). Taste: `replaceable` (a cheaper path still meets
ARD). Intent: `unclear` (two plausible readings).

**Weights.** `load-bearing`: Goal, ARD, or invariant; do not churn without a
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

- Negative focus: each ARD entry met / partial / unmet / untestable; ARD vs
  design vs plan vs milestones vs conventions; unclear intent; cheaper
  design; resume holes; missing milestone tests, last-milestone e2e, or
  `software-interface` fake.
- Positive focus: testable, correctly kinded ARD; Design Decisions with real
  alternatives; MECE milestones, named e2e, resume-safe Next Steps, real
  invariants.

1. Delete stale slices. Launch the critic pair. Tell the user. End the turn.
2. Both ready → launch the synthesizer (plan packet + both critic paths).
3. Parent Reads only `synthesis.md`. Strip proposals that break **Stops**.
4. **Question gate:** answer from session knowledge and patch
   `synthesis.md`. Grill the rest one at a time (recommend an answer); patch
   again. Unanswered items stay out of apply. `- none` → skip.
5. Show `## Proposals`. Ask all / some / none. Never apply in the turn of
   the first Read. Discard rejected items. Record `SR<n>` (**Reviews**).

### `self-review`

1. Launch the env agent. End the turn.
2. `blocked` → Read `env.md`, show it, stop. `ready` → launch one test agent
   per milestone that claims progress. None → go to step 3.
3. All test reports ready → launch the critic pair. Input: plan packet plus
   `env.md` and test report paths. Critics do not re-run tests or walk the
   repo.
4. Both ready → launch the synthesizer (same input + both critic paths).
5. Parent Reads only `self-review.md`. Show it. Stop. Wait for
   `apply-review`. Never apply in the turn of the first Read.

- Negative focus: false done, plan vs evidence, missing tests, env or setup
  drift, ignored conventions, resume holes, over- or under-scope, claimed
  completion without e2e.
- Positive focus: claims the evidence proves, solid tests, sound setup. Work
  an edit must not undo.

### Milestone

1. Split the milestone into MECE jobs with disjoint write paths (code, tests)
   and one report each. Launch all workers. End the turn.
2. All job reports ready → launch the collator (milestone claim, test cases,
   evidence commands, job report paths).
3. Parent Reads only `collate.md`. `fail` or `conflict` → new job round or an
   inline fix. `pass` → update activity files (**Update cadence**), or go to
   step 4.
4. **Evaluate** when the parent must judge quality, not only record a pass:
   real design latitude, the last milestone, or the user asked. Launch the
   critic pair. Input: milestone claim, ARD and design slices, `collate.md`
   and changed paths (MAY Read). Parent Reads both critic files and
   reconciles. Fix `must` defects in a job round; record the rest.

- Negative focus: unmet ARD, weak or missing tests, convention fights,
  fragile joins, needless complexity.
- Positive focus: clean interfaces, solid tests, simple design. Work the next
  round must not undo.

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
# Self-review

## Evidence
- env: ready | blocked
- milestone <n>: pass | fail | skipped

## Proposals
<same shape as Synthesis; `from: env | tests | negative | synth`>
```

`self-review.md` proposals edit activity files only, not product code.
Empty sections hold `- none`.

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
