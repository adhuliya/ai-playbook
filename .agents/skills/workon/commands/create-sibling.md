# `create-sibling`

Status: any. The derived `agent-activity.md`, RD, Design Decisions, and
Conventions must stand alone (no "see parent"). Propose the slug
`{parent-slug}-{short-suffix}` in kebab-case; the user may override.

Reads: policy/activity-kind.md, policy/planning-quality-bar.md, policy/planning-stages.md, policy/references.md, policy/requirement-def.md, policy/design-choices.md, policy/design-document.md, policy/conventions.md, policy/test-evidence.md, policy/material-change.md, policy/catalog.md, policy/ids.md, policy/journal.md, policy/reminders.md, policy/plan-outline.md, shapes/journal.md

1. Choose `kind` (**Activity kind**). Default to the parent's kind.
   Requirements first sets `kind: full` and `stage: requirements`. On
   `full`, remind the strong model.
2. Read the source `agent-activity.md`, `spec-req-def.md`,
   `spec-design-choice.md`, `spec-design.md`, `conventions.md`, and `references.md` once; open its journal only if
   it has entries. Do not copy `notes-by-user.md` or `reviews.md`.
3. On `full` and `stage: requirements`, run steps 1–4 of the **Planning
   quality bar**. On `full` and `stage: design`, run the whole bar for
   the new scope as a fresh intake. On `thin`, follow **Activity kind**.
   Do not inherit fuzz.
4. Rewrite all required sections and a fresh RD with its own
   **Problem header**. Write a fresh, standalone `spec-design.md` (own Current
   Design, Decisions from the sibling's own Design Decisions, empty
   Traceability); never "see parent". Copy still-applicable decisions and conventions (rules
   and Setup) inline, not as pointers; the user may drop or rewrite
   conventions on the sibling. Number **IDs** fresh from 1.
5. Create a fresh `notes-by-user.md` (H1 only), a fresh `references.md`
   (copy the REF entries the sibling still needs, renumbered from 1), and a
   fresh `agent-journal.md` with one `Created` event that names the parent slug.
   Write `spec-plan-outline.md` when `stage` is `design`. Set `kind` as chosen, `status: Planning`, `stage` as chosen (default `design`),
   `conventions: pending`, `review-comments: on`, and the new slug. Copy `base-branch`; the user may change it. Provenance
   follows **Complete sibling** (`derived-from:` in `references.md`). Append one **Catalog**
   entry.
6. On `full`, **draft-check:** the derived files stand if the source were
   deleted. On `thin`, skip it.
7. In-flight parent only: mark moved RD entries and milestones `superseded`
   in the parent; status unchanged; no parent journal. If the parent Goal
   changes, that is a **Material-change** (`replan-work`).
8. If step 7 asked for a parent `replan-work`, name that slug and switch
   focus back to it before the keyword. The sibling may already exist.
   Skip the rest of this step.
   Switch focus to the sibling and announce it. Prompt `requirements-ok`
   when `stage` is `requirements`. On `full` and `stage: design`, run
   **File review**. On `thin`, show the outline and prompt
   `start-building`.
