# Notes files

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
