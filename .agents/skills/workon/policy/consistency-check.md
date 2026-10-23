# Consistency check

Agent-run after user edits, and step 0 of `fix-activity`. No keyword, no
status change, no journal.

1. Check `agent-activity.md`, RD, Design Decisions, Conventions, `spec-design.md`, and
   `reviews.md` against each other: broken or duplicate **IDs**, Problem
   header vs Goal and Scope, Goal vs RD, `spec-design.md`'s Current Design and
   Decisions vs `spec-design-choice.md`, plan and milestones vs RD, Setup vs
   rules. A real milestone (not `TBD (design stage)`, not `removed`) with
   no `reads:` line is a fix. A missing `AC<n>` is not a finding. Flag, as
   a suggestion (not a block), a `spec-design.md` Traceability row that is stale
   against the milestones and paths (a `TC<n>` tag that still says
   `planned for` after its milestone is checked, or vice versa), an
   `AC<n>` no `TC<n>` or path satisfies, a `reads:` line with no `DD`, a
   `design-choice` `DC` that no `DD` cites, or a `cites:` that names a `DC`
   some other entry replaces.
2. For each issue, name the ID or section, the smallest edit, and why. Ask
   yes / no / mods. Apply only confirmed fixes; do not reword beyond the
   fix.
3. A fix that changes Goal or Scope is a **Material-change**: skip it and
   prompt.
4. `notes-by-user.md` is input only. If it cites stale IDs or contradicts
   the files, tell the user; do not edit it.

Never prune, rewrite, or renumber here; that needs `fix-activity`.
