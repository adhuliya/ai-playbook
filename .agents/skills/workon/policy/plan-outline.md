# Plan outline

`spec-plan-outline.md` is a short overview of the plan for human and agent
review. It is derived: `agent-activity.md` wins on conflict, and the outline is
rewritten. Shape: `shapes/plan-outline.md`.

- **Content:** about 100 words on what the activity builds, the approach,
  and the final check, in plain words a reader can follow without the
  other activity files. Then a list, with sub-lists where it helps, that
  shows how the plan is structured: one item per milestone `M<n>` with its
  outcome, parts, and test tiers. Name decisions in words, including what
  they rule out. An `RD` or `DD` id may follow a name in parentheses. Each
  group points to the place for detail (`agent-activity.md` `# Milestones`,
  `M<n>`). Use `.dev-notes/vocabulary.md` terms when that file exists.
- **Structure only.** No done marks, no dates, no copied detail. Drop a
  `removed` milestone from the list.
- **Write** it when the plan is first drafted (design stage of create,
  `create-sibling`, `replan-work`, `import-activity`). **Rewrite** it in the
  same edit whenever `# Current Plan` or `# Milestones` changes (**Update
  cadence**).
- Show it first at **File review**; it makes the plan cheap to review.
- It is not part of the handoff (**Portability**).
