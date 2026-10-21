# Update cadence

Records are for durability, not a live log.

- `activity.md`: on a scope, design, or plan change, a milestone reached, a
  blocker, and before pause, complete, or handoff. A checked milestone also
  appends a `Milestone` event.
- `plan-outline.md`: in the same edit as any change to `# Current Plan` or
  `# Milestones` (**Plan outline**).
- `design.md` (**Design document**): in the same edit as any Current
  Design change, whenever a Design Decision is added or superseded, when
  the Test Plan grows with the milestones, and whenever a milestone is
  checked (flip its Traceability tags `planned for` → `done by`, or the
  activity's chosen term, and fill Paths). Always sync it before pause,
  complete, or handoff, like `activity.md`.
- RD whenever requirements change; it must be current before `approve-plan`.
- Design Decisions when an important choice is made.
- Conventions (rules and Setup) when observed, confirmed, or tightened.
- `references.md`: when a source is cited or refreshed (**References**).
- `activities.md`: **Catalog**. `journal.md`: **Journal policy**.
- `reviews.md`: when points change, follow **Reviews** (where points go).
- Always sync before `pause-work`, `mark-completed`, or handoff.
- After user edits to activity files, run the **Consistency check**.
