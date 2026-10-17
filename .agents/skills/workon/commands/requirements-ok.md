# `requirements-ok`

Status: `Planning` with `stage: requirements`. If `stage` is already
`design`, report it and stop.

Reads: policy/planning-stages.md, policy/planning-quality-bar.md, policy/execution-gate.md, policy/journal.md, shapes/journal.md

1. Needs RD that is current and reviewed: the **Problem header** (a
   `## Problem:` heading in RD) exists and no grill branch is open. If not,
   send the user back to **File review**.
2. Set `stage: design`. Append a `Requirements` event (RD count, DC count).
3. Run the design half of the **Planning quality bar** (steps 5–6 and the
   remaining grill), write `plan-outline.md`, and run **File review**.
4. End with the **Execution gate** prompts: `approve-plan` next.
