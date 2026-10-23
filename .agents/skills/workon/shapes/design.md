# spec-design.md

Policy: **Design document**. Prose per **Writing style**; cite `DD<n>`,
`DC<nn>`, and `RD<n>` with a short gloss on first mention (**IDs**).

```markdown
# Design

## Current Design

<Invariants, boundaries, evidence signals a fresh agent needs to resume or
extend the work. TBD (design stage) before design is drafted.>

## Decisions

### DD1: <title>
- cites: DC01, DC02
- <Current statement a milestone can build from. Hard max ~200 words.>

### DD2: <title>
- cites: DC03
- <One DD may summarize several `implementation-detail` choices.>

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
