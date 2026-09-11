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
        user-notes.md
        artifacts/              # copies flat; reserved: verify-plan/, bg/, self-review/
```

No child activity directories. Siblings are top-level slugs.

**`artifacts/`:** whole copies as `<basename>` at the root; excerpts as
`<stem>-excerpt.md` (header = source path + what was kept). Reserved
(committable; delete only at `mark-completed` cleanup after confirm):
`verify-plan/` (`critic-negative.md`, `critic-positive.md`, `synthesis.md`;
optional `negative/`, `positive/`, `synth/` slices), `bg/` (optional
`<stem>/` slices next to `<stem>.md`), `self-review/` (`env.md`,
`milestone-<n>.md`, `critic-a.md`, `critic-b.md`; optional `env/`,
`milestone-<n>/`, `a/`, `b/`, `synth/` slices), and `self-review.md`. Do
not use `self-review.md` as a cited-copy name.

## activity.md

Metadata table in the **first ~10 lines** (title + table) so listing stays greppable.

```markdown
# <Human Title>

| Key | Value |
|---|---|
| status | Planning |
| slug | my-activity |
| branch | none |
| ticket | none |
| notes | |

# Goal

<Short summary of requirements.md. ARD is authoritative.>

# Scope

<One or two paragraphs: whole activity scope and how it fits the project.
Set after initial grilling; near-fixed. Major in-flight change = `replan-work`.>

# Background and Special Notes

<Context plus durable global notes.>

# Current Design

<Latest agreed design only. After `mark-completed`, shipped handoff.>

# Current Plan

<Approach currently believed correct. On Complete-reopen: legacy verify, then
delta steps starting at the new requirement.>

# Milestones

MECE outcomes. Apply **Test evidence** in `SKILL.md`. Keep checked items on
reopen; append new; mark removed work `superseded`.

1. [ ] <Outcome A>
   - tests:
     - <case>: <what it asserts>
   - evidence:
     - `<test command>`

2. [ ] <Outcome B — last is e2e confirmation of the Goal>
   - tests:
     - e2e <path>: <what it asserts>
   - evidence:
     - `<e2e command>`
     - fake (if `software-interface` peer is not live): `<test-double path>`

# Next Steps

1. <Immediate task>
2. <Immediate task>

# References

- <docs, specs, commits, issues, related slugs, …>
- `path/to/input` — context-only | copied (`artifacts/<name>`) | excerpt (`artifacts/<stem>-excerpt.md`)
  Learned: <1–3 sentences>
- `derived-from: <parent-slug>` — siblings only; non-load-bearing
```

## journal.md

Write-on and caps: **Journal policy** in `SKILL.md`. Until the first write:

```markdown
# Journal
```

### Pause / resume recap (~8–12 lines)

```markdown
## Pause (Active → Paused)

- why: <one line>
- done: <1–3 bullets>
- next: <single start step>
- watch: <one blocker or risk>
```

```markdown
## Resume (Paused → Active)

- done: <1–3 bullets>
- next: <single start step>
```

```markdown
## Resume (Complete → Planning)

- why: <the understood issue>
- delta: <what the new work is>
- next: <start step of new implementation>
- watch: <legacy verify, or omit>
```

### `mark-completed` entry

Heading names the **work slice** and carries the transition tick
(`(<from> → Complete)`). Body is shipped outcomes, paths, decisions,
lessons, accepted gaps — no separate tick line.

```markdown
## <Short work title> (Active → Complete)

<Shipped outcomes, technical decisions, discoveries, accepted gaps.
Repo paths and evidence pointers.>
```

Sibling provenance lives in derived `activity.md` `# References`
(`derived-from: <slug>`), not in the journal. Sibling journal starts as
`# Journal` only.

## activities.md

Create lazily. Append-only for new activities. Never bulk-read —
**Catalog** in `SKILL.md`.

```markdown
# Activities

High-level catalog. Details live in each activity folder.

## marshal: Marshal playbook sync gaps

Harden playbook/target sync for machine registry, ignores, syncmap, and nested-git guide handling.
```

## Notes files

Legacy split, Repair, enums, precedence: **Notes files** in `SKILL.md`.
Agent best-effort drafts all except `user-notes.md`. Bullets. Promote old
`###` entries to `##`. Agent-written files use **Prose density**.

### requirements.md

```markdown
# Requirement Definition

## <title>
- kind: end-user-interface | software-interface | internal-behavior
- <description>
```

### design-choices.md

```markdown
# Design Decisions

## <decision title>
- level: design-choice | major-implementation-detail | implementation-detail
- chosen: <what>
- why: <compelling reason>
- alternatives:
  - <alt>: <why not>
- replaces: <old decision title>
```

Omit `replaces:` on a first decision.

### conventions.md

Target ≤ ~500 words.

```markdown
# Conventions

## <short title>
- <2–5 bullets: the rule>

## Setup, build, test and install notes
- setup: `<command>`
- build: `<command>`
- test: `<command>`
- install: `<command>`
```

### user-notes.md

Aim ≤ ~500 words. User-owned; do not prune.

```markdown
# User Notes

<User free-form information for this activity.>
```

## List output (agent → user)

```markdown
| title | status | slug | branch | notes |
|---|---|---|---|---|
| Add export endpoint | Active | add-export-endpoint | feature/add-export-endpoint | waiting on API review |
```

`ticket` is omitted on purpose (token economy); include it if the user asks.

## Details output (no resume)

1. Full path to `activity.md`
2. First ~20 lines of that file
3. Stop
