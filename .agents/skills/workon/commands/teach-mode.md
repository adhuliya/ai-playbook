# `teach-off` / `teach-brief` / `teach-deep`

Status: any; no focused activity needed. Session flag (**Teach mode**); no
status change, no journal, no file edit. Default `off`.

Controls how much the agent teaches the domain and engineering content of
the current task in its replies: design rationale, implementation
concepts, and tradeoffs. It does not change the one-time workon-concept
gloss in **Guide the user**, and it never adds teaching prose to records
(`agent-activity.md`, `spec-design.md`, code comments follow **Comments** and
**Writing style** regardless of level).

- **`teach-off`** (default): state design and implementation facts
  tersely, as the records already require. Add nothing extra.
- **`teach-brief`:** at natural checkpoints (a new Design Decision, a
  milestone done, a non-obvious construct) add 1-3 sentences on the why or
  the concept, inline in the reply. Do not turn a reply into a lesson.
- **`teach-deep`:** proactively explain reasoning, alternatives
  considered, and relevant concepts as they come up, during planning and
  while writing code; walk through non-trivial code with short inline
  commentary as you write it. Still bounded by **Fewer prompts** and
  **Writing style**; offer to go deeper rather than always doing so.

Switching levels says which one is now active, in one line.
