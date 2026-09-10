# Sub-agent contract (workon)

Parent pastes a **self-contained** Task prompt. Sub-agents do not see the parent
chat. Always `run_in_background: true`. `subagent_type: generalPurpose`. `model`:
inherit unless the user named a listed model.

Apply **Prose density** from `SKILL.md` in every file you write. No essays.

## Shared bans

- Do not grill the user (no questions).
- Do not write `activity.md`, `journal.md`, `notes.md`, or `activities.md`.
- Do not `git add` / commit.
- Do not Read a sibling critic file (critics). Do not edit code. Read-only
  inspect/test only if the prompt assigns it.

## Parent orchestration

Always `run_in_background: true`. Never wait on a Task (no AwaitShell, no
agent-status loops). Blocking the parent interrupts the session.

Launch independent Tasks in **one** message. Then do parent work that does
not need those results, or end the turn.

**Status (user asks):** do not inspect the agent. If it was told to write a
file, check **metadata only** (`test -f`, size, mtime). Do not Read the body
for status. No file yet → say so.

Parent **may** Read a body when consuming results (explore notes while
drafting; `synthesis.md` after verify-plan). Never Read critic bodies.

**Planning:** MAY launch read-only explores (patterns, call sites, one subtree),
then ask the next grill question and end the turn. Output file if needed:
`.dev-notes/activities/<slug>/artifacts/bg/<name>.md` (ephemeral; never
`git add`).

**Implementation:** parent writes code. Background MAY inspect, run named
evidence/tests, or write a short `artifacts/bg/` report. Overlapping writes
forbidden.

**`verify-plan` turn-stage:**

1. Launch critic A and critic B in one message. Tell the user they are
   running. End the turn. No activity-file edits while this pipeline is in
   flight.
2. Ready critic file: completion notice, **or** fallback `test -f` plus
   `rg -l '^# Critic'` on that path (header check, not a body Read). File
   missing/empty/`rg` miss → not ready. When **both** are ready, launch the
   synthesizer; end the turn. One ready → metadata status only; do not launch
   the synthesizer.
3. Synthesizer writes `synthesis.md`. Parent Reads **only** that file, strips
   proposals that violate workon hard constraints. Show the proposals
   (full-sentence confirm). Ask all / some / none. Apply only after the user
   answers. Do not apply in the same turn as the first Read of `synthesis.md`.
   Rejected items discarded (not parked in User Notes). Delete the three files
   after accept or reject.

Ephemeral paths (overwrite on re-run; never `git add`):

```text
.dev-notes/activities/<slug>/artifacts/verify-plan/critic-a.md
.dev-notes/activities/<slug>/artifacts/verify-plan/critic-b.md
.dev-notes/activities/<slug>/artifacts/verify-plan/synthesis.md
```

---

## `verify-plan` critic (A or B)

Identical brief, isolated. You never see the other critic.

**Write only** the assigned file (overwrite):

- A: `.dev-notes/activities/<slug>/artifacts/verify-plan/critic-a.md`
- B: `…/critic-b.md`

Parent gives absolute paths. Create the directory if needed.

**Input (parent pastes):** Goal, Scope, Current Design, Current Plan,
Milestones, Next Steps, ARD, Design Decisions, Conventions. Not User Notes,
not journal. You MAY Read a path the plan cites. No extra repo walk.

**Rubric:** contradictions; missing evidence; over/under-scope; unmade
decisions; fresh-agent resume holes; steps that cannot run as written;
conventions the plan ignores or fights.

Return **only** this file body:

```markdown
# Critic A

## Findings

### <short title>
- severity: must | should | drop
- where: `activity.md` `# Current Plan` | `notes.md` `## …` / `### …`
- issue: <one to three short bullets>
- propose: <concrete edit>
```

Use `Critic B` as the H1 when you are B. `drop` = not worth acting on; still
list it so the synthesizer can discard it. No preamble, no chat transcript.

---

## `verify-plan` synthesizer

**Read** `critic-a.md` and `critic-b.md` (absolute paths from parent).
**Write only** `…/verify-plan/synthesis.md` (overwrite).

Merge, dedupe, resolve deadlocks. Final list = actionable edits only.

**Deadlock:** critics conflict → pick one side + one-line why, or drop if both
weak. No leftover "A says / B says." Never average into mush.

Strip `drop` items. Severity on kept items: `must` | `should`.

```markdown
# Synthesis

## Proposals

### <short title>
- severity: must | should
- where: `activity.md` `# …` | `notes.md` `## …` / `### …`
- change: <the edit>
- why: <one line>
- from: a | b | both
- deadlock: none | picked a because … | picked b because … | dropped (both weak)
```

If nothing survives: `# Synthesis` plus `## Proposals` and `- none`.

---

## Read-only explore / inspect (planning or implementation)

Optional. Write a short report only if the parent named an output path under
`.dev-notes/activities/<slug>/artifacts/bg/<name>.md`. Otherwise return a
tight bullet list in the Task result.

Do not overlap another agent’s assigned paths. Implementation inspect MAY run
the evidence commands the parent named; do not invent a second test suite.
Do not modify source.
