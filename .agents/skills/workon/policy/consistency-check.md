# Consistency check

Agent-run after user edits, and step 0 of `fix-activity`. No keyword, no
status change, no journal.

1. Check `activity.md`, RD, Design Decisions, Conventions, `design.md`, and
   `reviews.md` against each other: broken or duplicate **IDs**, Problem
   header vs Goal and Scope, Goal vs RD, `design.md`'s Current Design and
   Decisions vs `design-choices.md`, plan and milestones vs RD, Setup vs
   rules. Flag, as a suggestion (not a block), a `design.md` Traceability
   row that is stale against the milestones and paths (a `TC<n>` tag that
   still says `planned for` after its milestone is checked, or vice
   versa), or an `AC<n>` no `TC<n>` or path satisfies.
2. For each issue, name the ID or section, the smallest edit, and why. Ask
   yes / no / mods. Apply only confirmed fixes; do not reword beyond the
   fix.
3. A fix that changes Goal or Scope is a **Material-change**: skip it and
   prompt.
4. `notes-by-user.md` is input only. If it cites stale IDs or contradicts
   the files, tell the user; do not edit it.

Never prune, rewrite, or renumber here; that needs `fix-activity`.
