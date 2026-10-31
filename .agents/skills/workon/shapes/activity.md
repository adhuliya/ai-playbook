# agent-activity.md

The title and metadata table run through the `notes` row (15 lines in the
shape below), so listing stays greppable.

```markdown
# <Human Title>

| Key | Value |
|---|---|
| status | Planning |
| kind | thin |
| stage | design |
| conventions | pending |
| review-comments | on |
| continue | ask |
| slug | my-activity |
| branch | none |
| base-branch | main |
| ticket | none |
| notes | |

# Goal

<Short summary of spec-req-def.md. RD is authoritative.>

# Scope

<One or two paragraphs: whole activity scope and how it fits the project.>

# Background and Special Notes

<Context plus durable global notes.>

# Current Design

See `spec-design.md`.

# Current Plan

<Approach currently believed correct. On Complete-reopen: legacy verify, then
delta steps starting at the new requirement.>

# Milestones

- [ ] M1: <Outcome A>
  <What it does, in a few sentences, and which directories or modules it touches.>
  - reads: RD1, DD1
  - tests:
    - unit <part>: <case>: <what it asserts>
    - integration <boundary>: <case>: <what it asserts>
    - extend `<existing test path>`: <case added>
  - evidence:
    - `<test command>`
- [ ] M2: <Outcome B — last is e2e confirmation of the Goal>
  <What it confirms, and which parts of the project tree the end-to-end check covers.>
  - reads: RD2, DD2, REF1
  - tests:
    - unit <part>: <case>: <what it asserts>
    - e2e <path>: <what it asserts>
  - evidence:
    - `<e2e command>`
    - fake (if `software-interface` peer is not live): `<test-double path>`
- [ ] M3: Apply RU1 (review milestone; **Reviews**)
  <What the correction does, and which parts of the project tree it touches.>
  - reads: RD1, DD1
  - [ ] <MECE step> (RU1.1, RU1.3)
  - [ ] <MECE step> (RU1.2)
  - tests:
    - <case tied to the points>: <what it asserts>
  - evidence:
    - `<test command>`
- M4: removed: <why> (pruned by `fix-activity`; unchecked only; number kept)
- [x] M5: <checked outcome a later milestone partly replaces>
  <What it did, and which parts of the project tree it touched.>
  - reads: RD1, DD1
  - tests:
    - <case>: <what it asserts>
  - Superseded by: M6 — <aspect>

# Next Steps

1. <Immediate task, or `In progress: <pipeline> <unit>` while a pipeline runs>
2. <Immediate task>
```
