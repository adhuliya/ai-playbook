# workon templates

Shapes only; policy lives behind the bold names in the [`SKILL.md`](SKILL.md)
index. Agent-written files are records (**Writing style**).

## Directory layout

```text
.dev-notes/activities/
    activities.md
    <slug>/
        activity.md
        journal.md
        requirement-def.md
        design-choices.md
        conventions.md
        notes-by-user.md
        reviews.md              # lazy
        user-guide.md           # create-guide only
        artifacts/              # copies flat; reserved names below
```

A whole copy sits at the artifacts root as `<basename>`; an excerpt is
`<stem>-excerpt.md` with a header that names the source and what was kept.
The reserved directories are `verify-plan/`, `bg/`, `review/`, `comments/`,
and `fix/`, and the reserved file is `inflight.md`; never use a reserved
name for a cited copy. File roles: **Paths and readiness**. `inflight.md`
is parent scratch (**Inflight pipelines**):

```markdown
# Inflight

- pipeline: start-review | fix-cycle review | verify-plan | comments | drift | milestone
- unit: RU<n> | milestone <n> | <command>
- launched: <steps launched so far>
- final: <path of the final file>
- notes: <short working notes>
```

## activity.md

The title and metadata table sit in the first ~10 lines so listing stays
greppable.

```markdown
# <Human Title>

| Key | Value |
|---|---|
| status | Planning |
| conventions | pending |
| review-comments | on |
| slug | my-activity |
| branch | none |
| base-branch | main |
| synced | none |
| ticket | none |
| notes | |

# Goal

<Short summary of requirement-def.md. RD is authoritative.>

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

3. [ ] Apply RU1 (review milestone; **Reviews**)
   - [ ] <MECE step> (RU1.1, RU1.3)
   - [ ] <MECE step> (RU1.2)
   - evidence:
     - `<test command>`

4. removed: <why> (pruned by `fix-activity`; number kept)

# Next Steps

1. <Immediate task, or `In progress: <pipeline> <unit>` while a pipeline runs>
2. <Immediate task>

# References

- REF1: <docs, specs, commits, issues, related slugs, …>
- REF2: `path/to/input` — context-only | copied (`artifacts/<name>`) | excerpt (`artifacts/<stem>-excerpt.md`)
  Learned: <1–3 sentences>
- `derived-from: <parent-slug>` — siblings only; non-load-bearing
```

## journal.md

Events, write-on, and caps: **Journal policy**. A normal event is a `##`
heading plus at most 3 bullets.

```markdown
# Journal

## Created: Add CSV export (→ Planning)
- goal: export report rows as CSV from the CLI
- from: derived-from `report-api` | imported from `<source>` (omit if new)
```

Pause / resume recaps:

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

The `Complete` entry:

```markdown
## Complete: <short work title> (Active → Complete)

<Shipped outcomes, technical decisions, discoveries, accepted gaps.
Repo paths and evidence pointers.>
```

## activities.md

Policy: **Catalog**.

```markdown
# Activities

High-level catalog. Details live in each activity folder.

## marshal: Marshal playbook sync gaps

Harden playbook/target sync for machine registry, ignores, syncmap, and nested-git guide handling.
```

## Notes files

Policy (Repair, enums, precedence, who drafts): **Notes files**. Omit
`revised-by:` until a review point changes the entry (RD, CONV) or caused
it (DC), then list each revising point. Omit `replaces:` on a first
decision.

```markdown
# Requirement Definition

## Problem: <problem title>

<One paragraph, under ~100 words: the problem this activity solves, why it
matters, and how it fits the project in `.dev-notes/definition.md`.>

## RD1: <title>
- kind: end-user-interface | software-interface | internal-behavior
- <description>
- revised-by: RU<n>.<m>
```

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

```markdown
# Notes by User

<User free-form information for this activity.>
```

## reviews.md

Policy: **Reviews**. `status:` is required on every new cycle. `scope:`
applies to `start-review` and fix cycles; other cycles MAY omit it. `kind:
fix` appears only on fix cycles. A cycle with no points holds `- none`;
after an automated pass with no findings, `- none (agent)`; after env
`blocked`, `- none (env blocked)`.

```markdown
# Reviews

## RU1: <short topic>

status: closed
scope: milestones 1–2 | plan

state: <status, current milestone. Changes since the previous RU cycle:
IDs added/changed, work built. 1–2 short paragraphs; deltas only.>

- RU1.1 (agent): <point> — applied → RD2 (revised), DC04 (replaces DC03)
- RU1.2 (user): <point> — rejected: <why>
- RU1.3 (agent): <point> — noted: <why no action>
- RU1.4 (user): <point> — planned → milestone 3

## RU3: <short drift topic>

kind: fix
status: open
scope: drift <synced>..HEAD

state: <drift summary from `fix/drift.md`>

- RU3.1 (agent): <drift finding> — open
- RU3.2 (user): <user edit> — open
```

Renumber log (`fix-activity`):

```markdown
## Renumber 1
- RD4 → RD3, DC07 → DC05
```

## user-guide.md

Policy: **User guide**. Prose per **Writing style**; omit empty sections.

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

`ticket` is omitted on purpose (token economy); include it if the user asks.

```markdown
| title | status | slug | branch | notes |
|---|---|---|---|---|
| Add export endpoint | Active | add-export-endpoint | feature/add-export-endpoint | waiting on API review |
```
