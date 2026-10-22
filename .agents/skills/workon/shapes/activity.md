# activity.md

The title and metadata table sit in the first ~10 lines so listing stays
greppable.

```markdown
# <Human Title>

| Key | Value |
|---|---|
| status | Planning |
| stage | design |
| conventions | pending |
| review-comments | on |
| slug | my-activity |
| branch | none |
| base-branch | main |
| ticket | none |
| notes | |

# Goal

<Short summary of requirement-def.md. RD is authoritative.>

# Scope

<One or two paragraphs: whole activity scope and how it fits the project.>

# Background and Special Notes

<Context plus durable global notes.>

# Current Design

See `design.md`.

# Current Plan

<Approach currently believed correct. On Complete-reopen: legacy verify, then
delta steps starting at the new requirement.>

# Milestones

- [ ] M1: <Outcome A>
  - reads: RD1, DD1
  - tests:
    - unit <part>: <case>: <what it asserts>
    - integration <boundary>: <case>: <what it asserts>
    - extend `<existing test path>`: <case added>
  - evidence:
    - `<test command>`
- [ ] M2: <Outcome B — last is e2e confirmation of the Goal>
  - reads: RD2, DD2, REF1
  - tests:
    - unit <part>: <case>: <what it asserts>
    - e2e <path>: <what it asserts>
  - evidence:
    - `<e2e command>`
    - fake (if `software-interface` peer is not live): `<test-double path>`
- [ ] M3: Apply RU1 (review milestone; **Reviews**)
  - reads: RD1, DD1
  - [ ] <MECE step> (RU1.1, RU1.3)
  - [ ] <MECE step> (RU1.2)
  - evidence:
    - `<test command>`
- M4: removed: <why> (pruned by `fix-activity`; number kept)

# Next Steps

1. <Immediate task, or `In progress: <pipeline> <unit>` while a pipeline runs>
2. <Immediate task>
```
