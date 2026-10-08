# workon templates

Shapes only. Policy: [`SKILL.md`](SKILL.md) (**Named policy** headings).
Sequences: [`commands.md`](commands.md). Do not copy policy here.

## Directory layout

```text
.dev-notes/activities/
    activities.md
    <slug>/
        activity.md
        journal.md
        requirements.md
        design-choices.md
        conventions.md
        notes-by-user.md
        reviews.md              # lazy
        user-guide.md           # create-guide only
        artifacts/              # copies flat; reserved: verify-plan/, bg/, self-review/
```

**`artifacts/`:** whole copies as `<basename>` at the root; excerpts as
`<stem>-excerpt.md` (header = source path + what was kept). Reserved names:
`verify-plan/` (`critic-negative.md`, `critic-positive.md`, `synthesis.md`;
optional `negative/`, `positive/`, `synth/` slices), `bg/` (optional
`<stem>/` slices next to `<stem>.md`; `milestone-<n>/` job reports,
`collate.md`, optional `critic-negative.md` / `critic-positive.md`),
`self-review/` (`env.md`, `milestone-<n>.md`, `critic-negative.md`,
`critic-positive.md`; optional `env/`, `milestone-<n>/`, `negative/`,
`positive/`, `synth/` slices), and `self-review.md`. Full table: **Paths and
readiness** in [`subagent-contract.md`](subagent-contract.md). Do not use
`self-review.md` as a cited-copy name.

## activity.md

Metadata table in the **first ~10 lines** (title + table) so listing stays greppable.

```markdown
# <Human Title>

| Key | Value |
|---|---|
| status | Planning |
| conventions | pending |
| slug | my-activity |
| branch | none |
| ticket | none |
| notes | |

# Goal

<Short summary of requirements.md. RD is authoritative.>

# Scope

<One or two paragraphs: whole activity scope and how it fits the project.>

# Background and Special Notes

<Context plus durable global notes.>

# Current Design

<Latest agreed design only. After `mark-completed`, shipped handoff.>

# Current Plan

<Approach currently believed correct. On Complete-reopen: legacy verify, then
delta steps starting at the new requirement.>

# Milestones

1. [ ] <Outcome A>
   - tests:
     - unit <part>: <case>: <what it asserts>
     - integration <boundary>: <case>: <what it asserts>
     - extend `<existing test path>`: <case added>
   - evidence:
     - `<test command>`

2. [ ] <Outcome B — last is e2e confirmation of the Goal>
   - tests:
     - unit <part>: <case>: <what it asserts>
     - e2e <path>: <what it asserts>
   - evidence:
     - `<e2e command>`
     - fake (if `software-interface` peer is not live): `<test-double path>`

3. [ ] Apply RU1 (review milestone; **Reviews** in `SKILL.md`)
   - [ ] <MECE step> (RU1.1, RU1.3)
   - [ ] <MECE step> (RU1.2)
   - evidence:
     - `<test command>`

# Next Steps

1. <Immediate task>
2. <Immediate task>

# References

- REF1: <docs, specs, commits, issues, related slugs, …>
- REF2: `path/to/input` — context-only | copied (`artifacts/<name>`) | excerpt (`artifacts/<stem>-excerpt.md`)
  Learned: <1–3 sentences>
- `derived-from: <parent-slug>` — siblings only; non-load-bearing
```

## journal.md

Events, write-on, and caps: **Journal policy** in `SKILL.md`.

```markdown
# Journal

## Created: Add CSV export (→ Planning)
- goal: export report rows as CSV from the CLI
- from: derived-from `report-api` | imported from `<source>` (omit if new)
```

### Event entry

```markdown
## Milestone: CSV writer (Active)
- done: milestone 2; `go test ./export/...` green
- found: quoting needs RFC 4180 mode → DC04

## Review: RU2 (Planning)
- 5 points: applied 3 → RD4, DC03; rejected 1; open 1
- added milestone `Apply RU2`

## Blocked: upstream API (Active → Blocked)
- blocker: `/v2/rows` returns 500 on large pages
- next: retry after upstream fix
```

### Pause / resume recap

```markdown
## Pause: <short why> (Active → Paused)

- why: <one line>
- done: <1–3 bullets>
- next: <single start step>
- watch: <one blocker or risk>
```

```markdown
## Resume: <short title> (Paused → Active)

- done: <1–3 bullets>
- next: <single start step>
```

```markdown
## Resume: <short title> (Complete → Planning)

- why: <the understood issue>
- delta: <what the new work is>
- next: <start step of new implementation>
- watch: <legacy verify, or omit>
```

### `Complete` entry

```markdown
## Complete: <short work title> (Active → Complete)

<Shipped outcomes, technical decisions, discoveries, accepted gaps.
Repo paths and evidence pointers.>
```

## activities.md

Policy: **Catalog** in `SKILL.md`.

```markdown
# Activities

High-level catalog. Details live in each activity folder.

## marshal: Marshal playbook sync gaps

Harden playbook/target sync for machine registry, ignores, syncmap, and nested-git guide handling.
```

## Notes files

Policy (Repair, enums, precedence, who drafts): **Notes files** in
`SKILL.md`. Agent-written files are records (**Writing style**).

### requirements.md

```markdown
# Requirement Definition

## RD1: <title>
- kind: end-user-interface | software-interface | internal-behavior
- <description>
- revised-by: RU<n>.<m>
```

Omit `revised-by:` until a review point changes the entry. List each revising
point. Same rule on `CONV` entries.

### design-choices.md

```markdown
# Design Decisions

## DC01: <decision title>
- level: design-choice | major-implementation-detail | implementation-detail
- chosen: <what>
- why: <compelling reason>
- alternatives:
  - <alt>: <why not>
- replaces: DC<nn>
- revised-by: RU<n>.<m>
```

Omit `replaces:` on a first decision. Omit `revised-by:` unless a review point
caused the entry.

### conventions.md

```markdown
# Conventions

## CONV1: <short title>
- <2–5 bullets: the rule>
- revised-by: RU<n>.<m>

## Setup, build, test and install notes
- setup: `<command>`
- build: `<command>`
- test: `<command>`
- install: `<command>`
```

### notes-by-user.md

```markdown
# Notes by User

<User free-form information for this activity.>
```

## reviews.md

Policy: **Reviews** in `SKILL.md`.

```markdown
# Reviews

## RU1: <short topic>

state: <status, current milestone. Changes since the previous RU cycle:
IDs added/changed, work built. 1–2 short paragraphs; deltas only.>

- RU1.1: <point> — applied → RD2 (revised), DC04 (replaces DC03)
- RU1.2: <point> — rejected: <why>
- RU1.3: <point> — open

## RU2: <short topic>

state: <deltas since RU1>

- RU2.1: <point> — applied → CONV2 (revised)
- RU2.2: <point> — applied → code (milestone `Apply RU2`)

## Renumber 1
- RD4 → RD3, DC07 → DC05
```

## user-guide.md

Policy: **User guide** in `SKILL.md`. Prose per **Writing style**. Omit
empty sections.

```markdown
# <Feature title>: User Guide

## What it does
<Problem solved and the behavior the user sees.>

## How to use
<Steps, commands, inputs, outputs, options.>

## How to test
<Runnable commands with expected results. Include the e2e check.>

## How to explain
<Short pitch, key concepts, a demo script, limits and known gaps.>
```

## List output (agent → user)

```markdown
| title | status | slug | branch | notes |
|---|---|---|---|---|
| Add export endpoint | Active | add-export-endpoint | feature/add-export-endpoint | waiting on API review |
```

`ticket` is omitted on purpose (token economy); include it if the user asks.
