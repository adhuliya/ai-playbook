# design.md

Policy: **Design document**. Prose per **Writing style**; cite `DC<nn>` and
`RD<n>` with a short gloss on first mention (**IDs**).

```markdown
# Design

## Current Design

<Invariants, boundaries, evidence signals a fresh agent needs to resume or
extend the work. TBD (design stage) before design is drafted.>

## Decisions

- DC01 (<gloss>): <one line, or the full choice for `design-choice` level>
- DC02 (<gloss>): <...>
- Other `implementation-detail` choices: <one summarizing line>

## Test Plan

- TC1 (RD1, <gloss>): unit <part>: <case name>; integration <boundary>: <case name>
- TC2 (RD2, <gloss>): e2e: <case name>
- Interface fakes: TC<n> (RD<n>, <gloss>): <fake path>

## Traceability

| RD | TC | Test cases | Paths |
|---|---|---|---|
| RD1 | TC1 | unit: <case name> (planned for M1); integration: <case name> (planned for M1) | TBD |
| RD2 | TC2 | e2e: <case name> (done by M2) | <paths M2 touched> |
```
