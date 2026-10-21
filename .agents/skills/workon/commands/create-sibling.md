# `create-sibling`

Status: any. The derived `activity.md`, RD, Design Decisions, and
Conventions must stand alone (no "see parent"). Propose the slug
`{parent-slug}-{short-suffix}` in kebab-case; the user may override.

Reads: policy/planning-quality-bar.md, policy/planning-stages.md, policy/references.md, policy/requirement-def.md, policy/design-choices.md, policy/design-document.md, policy/conventions.md, policy/test-evidence.md, policy/material-change.md, policy/catalog.md, policy/ids.md, policy/journal.md, policy/reminders.md, policy/plan-outline.md, shapes/journal.md

1. Remind strong model.
2. Read the source `activity.md`, `requirement-def.md`,
   `design-choices.md`, `design.md`, `conventions.md`, and `references.md` once; open its journal only if
   it has entries. Do not copy `notes-by-user.md` or `reviews.md`.
3. Run the **Planning quality bar** for the new scope as a fresh intake; do
   not inherit fuzz.
4. Rewrite all required sections and a fresh RD with its own
   **Problem header**. Write a fresh, standalone `design.md` (own Current
   Design, Decisions from the sibling's own Design Decisions, empty
   Traceability); never "see parent". Copy still-applicable decisions and conventions (rules
   and Setup) inline, not as pointers; the user may drop or rewrite
   conventions on the sibling. Number **IDs** fresh from 1.
5. Create a fresh `notes-by-user.md` (H1 only), a fresh `references.md`
   (copy the REF entries the sibling still needs, renumbered from 1), and a
   fresh `journal.md` with one `Created` event that names the parent slug.
   Write `plan-outline.md`. Set `status: Planning`, `stage: design`,
   `conventions: pending`, `review-comments: on`, and the new slug. Copy `base-branch`; the user may change it. Provenance
   follows **Complete sibling** (`derived-from:` in `references.md`). Append one **Catalog**
   entry.
6. **draft-check:** the derived files stand if the source were deleted.
7. In-flight parent only: mark moved RD entries and milestones `superseded`
   in the parent; status unchanged; no parent journal. If the parent Goal
   changes, that is a **Material-change** (`replan-work`).
8. Switch focus to the sibling and announce it. **File review** and the
   revision loop.
