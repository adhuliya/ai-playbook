# Sub-agent contract (workon)

Parent pastes a **self-contained** Task prompt. Sub-agents do not see the parent
chat. Chat parent: always `run_in_background: true`. `subagent_type:
generalPurpose`. `model`: inherit unless the user named a listed model.

Apply **Prose density** from `SKILL.md` in every file you write. No essays.
Bullets.

Turn-stage, **Parent reads**, and assigned paths live here. `SKILL.md` does not
restage. Repair notes first (**Notes files** in `SKILL.md`), then freeze
activity/notes files while a pipeline is in flight.

## Shared bans

- Do not grill the user (no questions).
- Do not write `activity.md`, `journal.md`, `requirements.md`,
  `design-choices.md`, `conventions.md`, `user-notes.md`, or `activities.md`.
- Do not Read `requirements.md` or `design-choices.md`. Parent pastes excerpts.
- Do not Read `user-notes.md`.
- Do not `git add` / commit.
- Do not Read a sibling critic file or another worker's slice dir. Do not edit
  code. Read-only inspect/test only if the prompt assigns it. Env MAY run
  documented setup/build commands from the prompt / `conventions.md` Setup;
  MUST NOT invent tooling or edit source.

## Nested children

All workon workers. Depth **1** only (children MUST NOT launch agents).

- **Chat parent:** `run_in_background: true`. Never wait (no AwaitShell, no
  agent-status loops). Blocking the parent interrupts the session.
- **Worker:** MAY split the job MECE and launch children with
  `run_in_background: false` (block, then merge). Brief: lean, self-contained,
  assigned slice path. Child writes **only** that slice file. Shared bans
  apply. No frozen child template — the worker names fields.
- Ready signal = worker's assigned file only. Parent, synthesizer, and sibling
  critics MUST NOT Read slice dirs.
- Re-run: overwrite assigned files; delete stale files in that worker's slice
  dir before launch.

Slice dirs (create as needed):

```text
artifacts/verify-plan/negative/
artifacts/verify-plan/positive/
artifacts/verify-plan/synth/
artifacts/self-review/env/
artifacts/self-review/milestone-<n>/
artifacts/self-review/a/
artifacts/self-review/b/
artifacts/self-review/synth/
artifacts/bg/<stem>/
```

`bg/<stem>/` sits next to `artifacts/bg/<stem>.md`.

## Parent orchestration

Launch independent Tasks in **one** message. Then do parent work that does
not need those results, or end the turn.

### Parent reads

**Status (user asks):** do not inspect the agent. If it was told to write a
file, check **metadata only** (`test -f`, size, mtime). Do not Read the body
for status. No file yet → say so.

Parent **may** Read a body when consuming results (explore notes while
drafting; `synthesis.md` after verify-plan; `self-review.md` after
self-review; `env.md` only when `status: blocked`). Never Read critic bodies,
slice dirs, or milestone test bodies for status. Parent MAY patch
`synthesis.md` during the verify-plan question gate (below). Do not Read
`artifacts/bg/` reports for status.

**Planning:** MAY launch read-only explores (patterns, call sites, one subtree),
then ask the next grill question and end the turn. Output file if needed:
`.dev-notes/activities/<slug>/artifacts/bg/<name>.md` (keep until
`mark-completed` cleanup; committable; never auto-`git add`).

**Implementation:** parent writes code. Background MAY inspect, run named
evidence/tests, or write a short `artifacts/bg/` report. Overlapping writes
forbidden.

**Pass `conventions.md`:** MUST pass the file path to env, test, critic, and
verify-plan synthesizer agents (they MAY Read it). Explore agents only if the
task needs it.

**`verify-plan` turn-stage:**

1. On re-run, delete stale files under `verify-plan/negative/`,
   `verify-plan/positive/`, and `verify-plan/synth/`. Launch **negative** and
   **positive** critics in one message (different briefs). Tell the user they
   are running. End the turn. Repair first, then no activity-file edits while
   this pipeline is in flight.
2. Ready critic file: completion notice, **or** fallback `test -f` plus
   `rg -l '^# Critic (negative|positive)$'` on that path (header check, not a
   body Read). File missing/empty/`rg` miss → not ready. When **both** are
   ready, launch the synthesizer; end the turn. One ready → metadata status
   only; do not launch the synthesizer.
3. Synthesizer writes `synthesis.md`. Parent Reads **only** that file, strips
   proposals that violate workon **Stops**.
4. **Question gate** (blocks apply). `## Questions` are leftovers after the
   synthesizer answered what it could.
   - Parent answers from session knowledge (grill history, already-stated
     intent). Patch `synthesis.md`: drop resolved questions; add/adjust
     `## Proposals`. Do not edit critic files or slice dirs.
   - Grill remaining questions one at a time (recommend an answer). After the
     last answer, patch `synthesis.md` again.
   - Unanswered leftover questions: those contested items stay out of apply.
   - If `## Questions` is `- none`, skip grill.
5. Show remaining `## Proposals` (full-sentence confirm). Ask all / some /
   none. Apply only after the user answers. Do not apply in the same turn as
   the first Read of `synthesis.md`. Rejected items discarded (not parked in
   User Notes). **Keep** assigned files and slice dirs (overwrite on re-run).
   Delete only at `mark-completed` cleanup after user confirm.

**`self-review` turn-stage:**

1. Launch **one** env agent. Tell the user it is running. End the turn. No
   activity-file edits while this pipeline is in flight (Repair first, then freeze).
2. Ready `env.md`: completion notice, **or** `test -f` plus `rg` for
   `^status: (ready|blocked)` (header, not a body Read). Missing/empty/`rg`
   miss → not ready. `blocked` → parent Reads `env.md`, shows it, **stops**.
   Do not launch test agents. Do not write `self-review.md`. `ready` → launch
   test agents (one per claimed-progress milestone) in one message; end the
   turn. None claimed → skip tests; launch critics next (step 3).
3. Ready each milestone file: `test -f` plus `rg -l '^# Milestone'` (or the
   assigned H1). When **all** assigned test files are ready (or none were
   launched), launch critic A and critic B in one message; end the turn.
4. When **both** critics are ready (`rg -l '^# Critic'`), launch the
   synthesizer; end the turn.
5. Synthesizer writes `artifacts/self-review.md`. Parent Reads **only** that
   file. Show it. Stop. Wait for `apply-review`. Do not apply in the same
   turn as the first Read. Do not edit activity/notes files from `self-review`.

Keep working files (overwrite on re-run). Committable. Delete only at
`mark-completed` cleanup after user confirm.

Assigned paths:

```text
.dev-notes/activities/<slug>/artifacts/verify-plan/critic-negative.md
.dev-notes/activities/<slug>/artifacts/verify-plan/critic-positive.md
.dev-notes/activities/<slug>/artifacts/verify-plan/synthesis.md

.dev-notes/activities/<slug>/artifacts/self-review.md
.dev-notes/activities/<slug>/artifacts/self-review/env.md
.dev-notes/activities/<slug>/artifacts/self-review/milestone-<n>.md
.dev-notes/activities/<slug>/artifacts/self-review/critic-a.md
.dev-notes/activities/<slug>/artifacts/self-review/critic-b.md
```

`<n>` is the milestone number from `activity.md`. Overwrite those paths.

---

## `verify-plan` critic negative

Isolated. You never see the positive critic or `positive/` slices.

**Write only** the assigned file (overwrite):

`.dev-notes/activities/<slug>/artifacts/verify-plan/critic-negative.md`

Parent gives absolute paths. Create the directory if needed. MAY spawn
depth-1 children into `verify-plan/negative/`; merge into this file before
exit.

**Input (parent pastes):** Goal, Scope, Current Design, Current Plan,
Milestones, Next Steps, full ARD, full Design Decisions. Path to
`conventions.md` (MAY Read). Not User Notes, not journal, not
`requirements.md` / `design-choices.md` files. You MAY Read a path the plan
cites. No extra repo walk.

**Hunt (cover all; one finding, one `kind`):**

- Every ARD entry: met / partial / unmet / untestable
- Cross-check ARD vs Design vs Plan vs Milestones vs Conventions (contradictions)
- Unclear intent: two readings both plausible
- Replaceable design: cheaper path that still meets ARD (`kind: replaceable`)
- Resume holes: a fresh agent could not run the plan as written
- Evidence gaps: milestone tests, last-milestone e2e, `software-interface` fake
- Convention fights
- Steelman the plan, then attack — no strawman, no invented requirements, no
  prose nits

**Kinds:** `unmet-ard` / `partial-ard` / `contradiction` / `resume-hole` /
`evidence-gap` / `convention-fight` = **defects**. `replaceable` = taste /
nicer alternative. `unclear` = missing or conflicting intent; prefer
`propose: clarify: …`.

Return **only** this file body:

```markdown
# Critic negative

## Findings

### <short title>
- kind: unmet-ard | partial-ard | contradiction | unclear | replaceable | resume-hole | evidence-gap | convention-fight
- severity: must | should | drop
- where: `activity.md` `# Current Plan` | `requirements.md` `## …` | `design-choices.md` `## …` | `conventions.md` `## …`
- issue: <one to three short bullets>
- propose: <concrete edit, or `clarify:` plus the ambiguity>
```

`drop` = not worth acting on; still list it so the synthesizer can discard it.
If nothing is wrong: `## Findings` plus `- none`. No preamble, no chat
transcript.

---

## `verify-plan` critic positive

Isolated. You never see the negative critic or `negative/` slices.

**Write only** the assigned file (overwrite):

`.dev-notes/activities/<slug>/artifacts/verify-plan/critic-positive.md`

Parent gives absolute paths. Create the directory if needed. MAY spawn
depth-1 children into `verify-plan/positive/`; merge into this file before
exit.

**Input:** same packet as the negative critic. MAY Read `conventions.md` and a
path the plan cites. No extra repo walk. No change proposals.

**Hunt:**

- Well-specified ARD: testable, correct `kind`, unambiguous
- Design Decisions that record real alternatives
- Plan benefits that would hurt if churned (MECE milestones, named e2e,
  resume-safe Next Steps, real invariants)
- Rank `load-bearing` first
- Every Keep names the failure if removed
- Hollow plan → `## Keep` plus `- none`
- Ban generic “good plan.”

```markdown
# Critic positive

## Keep

### <short title>
- weight: load-bearing | strong | nice
- where: `activity.md` `# …` | `requirements.md` `## …` | `design-choices.md` `## …` | `conventions.md` `## …`
- why: <what breaks if this is removed or churned>
- keep: <the element, or the property that must survive an edit>
```

- `load-bearing`: Goal / ARD / invariant. Synthesizer does not churn it unless
  a **defect** is shown.
- `strong`: well-specified; keep unless a defect.
- `nice`: real praise; a `should` improvement may still win.

If nothing is worth keeping: `## Keep` plus `- none`. No preamble.

---

## `verify-plan` synthesizer

**Read** `critic-negative.md` and `critic-positive.md` (absolute paths from
parent). **Write only** `…/verify-plan/synthesis.md` (overwrite). MAY spawn
depth-1 children into `verify-plan/synth/`; merge into this file before exit.
MUST NOT Read slice dirs.

**Input (parent pastes):** same plan packet as the critics (Goal, Scope,
Current Design, Current Plan, Milestones, Next Steps, full ARD, full Design
Decisions, path to `conventions.md`) **plus** the two critic file paths. Not
User Notes, not journal, not `requirements.md` / `design-choices.md` files.
No extra repo walk.

**Judgment:**

- **Defect** beats Keep (even if the positive critic praised that area).
- **Taste / `replaceable`** that still meets ARD loses to Keep.
- **Cannot tell** defect vs taste without user intent → no proposal for that
  item; emit a question instead.
- Answer what you can from the packet + the two reviews first. Emit only
  serious, pertinent leftover questions. No cap. Not a dumping ground.
- `## Proposals` = **changes only**. No preserve-proposals. A Keep that
  nothing threatens does not appear. `keep: honored …` only when an edit was
  reshaped so the Keep still holds.
- `from: synth` **only** for a `must` defect already evident in the pasted
  packet (unmet/partial ARD, contradiction, unrunnable step, missing
  last-milestone e2e, convention fight). No new taste, no `replaceable`, no
  second hunt pass that restates the negative critic. Prefer merge / drop /
  reshape of what the critics wrote.
- No leftover “negative says / positive says.”

```markdown
# Synthesis

## Proposals

### <short title>
- severity: must | should
- where: `activity.md` `# …` | `requirements.md` `## …` | `design-choices.md` `## …` | `conventions.md` `## …`
- change: <the edit>
- why: <one line>
- from: negative | both | synth
- keep: none | honored `<keep title>` | overridden `<keep title>` because defect

## Questions

### <short title>
- about: <keep-vs-change conflict, or unclear intent>
- where: <same where style>
- ask: <one decision>
- recommend: <synthesizer's best guess>
- why-it-matters: <which proposal this unlocks or kills>
- from: negative | positive | both
```

If nothing decided: `## Proposals` plus `- none`. If no leftover questions:
`## Questions` plus `- none`.

---

## `self-review` env agent

**Write only** `…/artifacts/self-review/env.md` (overwrite). Create the
directory if needed. MAY spawn depth-1 children into `self-review/env/`.

**Input (parent pastes):** Setup section + named build/test commands from
the plan; path to `conventions.md` (MAY Read). MAY inspect the repo for the
project’s documented bootstrap. MAY run those **documented** setup/build
commands. MUST NOT edit source, activity files, or invent tooling.

**Job:** get a working env, or block. Weed out env issues before tests.

```markdown
# Env

status: ready | blocked

## Used
- <command or toolchain bullet>

## Findings
- <bullet>
```

`blocked` if setup/build cannot run as documented (or no documented command
exists and discovery failed). No preamble.

---

## `self-review` test agent (one milestone)

**Write only** the assigned `…/artifacts/self-review/milestone-<n>.md`.
MAY spawn depth-1 children into `self-review/milestone-<n>/`.

**Input (parent pastes):** that milestone’s claims, test/evidence commands,
paths, what to look for; working commands/cwd from env `ready`; path to
`conventions.md` (MAY Read). Run **those** commands. Do not invent a second
suite. Do not edit source.

```markdown
# Milestone <n>

- claim: <what the plan claims>
- result: pass | fail | blocked
- evidence:
  - `<command>`: <one-line outcome>
- notes: <optional bullets>
```

---

## `self-review` critic (A or B)

Identical brief, isolated. You never see the other critic. Do **not** re-run
tests or walk the rest of the repo.

**Write only** the assigned file (overwrite):

- A: `…/artifacts/self-review/critic-a.md`
- B: `…/critic-b.md`

MAY spawn depth-1 children into `self-review/a/` or `self-review/b/`.

**Input (parent pastes):** Goal, Scope, Current Design, Current Plan,
Milestones, Next Steps, full ARD, full Design Decisions; paths to `env.md`
and milestone reports (MAY Read those); path to `conventions.md` (MAY Read).

**Rubric:** false “done”; plan vs evidence; missing tests; env/setup drift;
conventions ignored; resume holes; over/under-scope; last milestone without
e2e when claimed complete.

```markdown
# Critic A

## Findings

### <short title>
- severity: must | should | drop
- where: `activity.md` `# Current Plan` | `requirements.md` `## …` | `design-choices.md` `## …` | `conventions.md` `## …`
- issue: <one to three short bullets>
- propose: <concrete edit>
```

Use `Critic B` as the H1 when you are B. `where` may also be
`artifacts/self-review.md` only if the proposal is “record this evidence in
the activity files”. `drop` = still list it so the synthesizer can discard
it. No preamble.

---

## `self-review` synthesizer

**Read** `critic-a.md`, `critic-b.md`, `env.md`, and the milestone reports
(absolute paths from parent). **Write only**
`.dev-notes/activities/<slug>/artifacts/self-review.md` (overwrite). MAY spawn
depth-1 children into `self-review/synth/`. MUST NOT Read slice dirs.

Merge, dedupe, resolve deadlocks. Actionable activity-file edits only (not
product-code patches). Strip `drop`. Severity: `must` | `should`.

```markdown
# Self-review

## Evidence
- env: ready | blocked
- milestone <n>: pass | fail | skipped
- <one-line command outcomes as needed>

## Proposals

### <short title>
- severity: must | should
- where: `activity.md` `# …` | `requirements.md` `## …` | `design-choices.md` `## …` | `conventions.md` `## …`
- change: <the edit>
- why: <one line>
- from: env | tests | a | b | both | synth
- deadlock: none | picked a because … | picked b because … | dropped (both weak)
```

If nothing survives: `# Self-review`, `## Evidence` (keep the facts),
`## Proposals`, `- none`.

---

## Read-only explore / inspect (planning or implementation)

Optional. Write a short report only if the parent named an output path under
`.dev-notes/activities/<slug>/artifacts/bg/<name>.md`. Otherwise return a
tight bullet list in the Task result. MAY spawn depth-1 children into
`artifacts/bg/<stem>/`.

Do not overlap another agent’s assigned paths. Implementation inspect MAY run
the evidence commands the parent named; do not invent a second test suite.
Do not modify source.
