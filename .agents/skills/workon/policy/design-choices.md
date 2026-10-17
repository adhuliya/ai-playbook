# `design-choices.md`

H1: `# Design Decisions`. Entries: `## DC<nn>: <title>`. Parent-only and
append-only (except `fix-activity`): append when a real choice is made,
never delete or rewrite history, and supersede with a new entry that says
`replaces: DC<nn>`. Skip micro-choices recoverable from code. Hard max ~200
words per entry. `level` is exactly one of:

- `design-choice`: a UI or software-facing contract (same coverage as RD
  `end-user-interface` / `software-interface`). Feeds a future design
  document.
- `major-implementation-detail`: internal, but individually mentioned in
  that document. Test: costly if unknown, or reversal ripples across
  components.
- `implementation-detail`: internal; summarized (not copied) in that
  document.

When unsure between adjacent levels, pick the higher; the user may
downgrade.
