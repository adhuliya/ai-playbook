# `artifacts/detailed-design.md`

Policy: `commands/detailed-design.md`. Prose per **Writing style**; `DC<nn>`
and `RD<n>` citations are fine here (an artifact, not shipped work or
`guide-for-users.md`). Omit a section with nothing to show.

```markdown
# <Feature title>: Detailed Design

## Overview

<A few sentences: what this builds and how design.md's Current Design maps
to it.>

## Architecture

\`\`\`mermaid
graph TD
  A[Component] --> B[Component]
\`\`\`

<1-3 sentences on what the diagram shows.>

## Key flows

\`\`\`mermaid
sequenceDiagram
  participant U as Caller
  participant S as Component
  U->>S: request
  S-->>U: response
\`\`\`

<One diagram per non-trivial flow or state machine, each with 1-3 lines of
caption. Use `sequenceDiagram`, `flowchart`, `stateDiagram-v2`, or
`classDiagram`, whichever fits the flow.>

## Decisions in depth

<Expand the DC<nn> entries that need more than design.md's one-line
synthesis: alternatives considered, why this one won.>

## Open questions

<Known gaps or risks still unresolved. Omit when none.>
```
