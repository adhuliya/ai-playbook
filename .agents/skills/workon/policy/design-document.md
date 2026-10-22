# Design document

`<slug>/design.md` is the lean design reference, for an agent (or a
technical reader) to load instead of re-deriving the design from
`design-choices.md` and the code. Parent-only. Shape: `shapes/design.md`.
It replaces the old `# Current Design` section of `activity.md`;
`activity.md` keeps that heading only as a one-line pointer to this file.

Required sections, in order: Current Design, Decisions, Test Plan,
Traceability.

- **Current Design:** the execution handoff (invariants, boundaries,
  evidence signals) that `# Current Design` used to hold in `activity.md`.
  About 150 words. These are the invariants every milestone honors.
  A decision only some milestones need is a `DD<n>` under Decisions.
  Chosen-vs-alternatives still live only in `design-choices.md`.
- **Decisions:** one `### DD<n>: <title>` per current statement (**IDs**).
  Rewrite the block in place when that statement changes. Hard max ~200
  words. A bullet `- cites: DC01, DC02` names the `DC<nn>` entries it rests
  on. Those entries hold the alternatives and why they lost. A milestone
  lists the `DD` on its `reads:` line and does not list the `DC`. Several
  `implementation-detail` choices may share one DD. When a `DC` is
  superseded, point `cites:` at the new entry and rewrite the DD body.
  Keep the DD in agreement with `design-choices.md`.
- **Test Plan:** one `TC<n>` line per `RD<n>` (**IDs**: shares `RD<n>`'s
  number), naming the unit, integration, e2e, and interface-fake cases
  planned for it (**Test evidence**). Drafted with the milestones
  (**Planning quality bar** step 5) and kept in the same words as the
  matching milestone test bullets in `activity.md`; this is the single
  list of case names, not a second plan. Grows only when the plan grows
  (`replan-work`, a review milestone).
- **Traceability:** one row per `RD<n>` / `TC<n>` pair, listing the Test
  Plan's case names for it. Each case name carries a status tag:
  `(planned for M<n>)` once its milestone is drafted, flipped to `(done by
  M<n>)` (or `(implemented by M<n>)`, pick one term per activity and keep
  it) the turn that milestone is checked. The Paths column stays `TBD`
  until then, then lists the paths that milestone touched. A
  `software-interface` RD's fake path goes in Paths once built. This
  section does not require an `AC<n>` on the RD (`add-ac`); it traces
  whatever the Test Plan and milestones say.

In `stage: requirements`, Current Design, Test Plan, and Traceability hold
`TBD (design stage)`. Decisions still gains a `DD<n>` when a choice is
made, citing that `DC<nn>` (**Planning stages**).

Update at the same checkpoints as `activity.md` (**Update cadence**), plus
whenever a `design-choices.md` entry is added or superseded, and whenever
a milestone is checked (flip its Traceability tags from `planned for` to
`done by`/`implemented by` and fill Paths). Keep it in sync before pause,
complete, or handoff.

`create-sibling` writes a fresh, standalone `design.md` (own Current
Design, Decisions from the sibling's own Design Decisions, empty
Traceability); never "see parent".
