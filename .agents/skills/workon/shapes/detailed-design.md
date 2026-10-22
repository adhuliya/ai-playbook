# `artifacts/detailed-design.md`

Policy: `commands/detailed-design.md`. Prose per **Writing style**. The
file stands on its own: vocabulary terms, and a sentence that still stands
when the reader skips an ID. An `RD` or `DD` id may follow a name in
parentheses. Omit a section with nothing to show.

```markdown
# <Feature title>: Detailed Design

## Overview

<A few sentences: what this builds and which boundaries it keeps.>

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

<The choices in words: what was chosen, what was not built, and why.
An ID may follow the name in parentheses.>

## Open questions

<Known gaps or risks still unresolved. Omit when none.>
```
