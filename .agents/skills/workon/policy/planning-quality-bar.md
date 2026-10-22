# Planning quality bar

Applies to create, `create-sibling`, and `replan-work`. In
`stage: requirements`, run steps 1–4 only (**Planning stages**). Grill with
[`grill-me`](../../grill-me/SKILL.md): one question at a time, asked per
**Asking** (recommended option first), and explore the repo instead of
asking. Do not skip grilling to draft files.

The order is mandatory:

1. **Project-fit** against `.dev-notes/definition.md`. Do not proceed until
   it fits. When the file is missing, empty, or only `TODO`, run
   **Definition bootstrap** first.
2. **Intake:** free-text scope (objective, in / out, constraints, done).
   Then write the **Problem header** in `requirement-def.md`.
3. Grill the remaining branches: goal, success, scope, constraints,
   assumptions, risks, interfaces, non-goals. Classify each requirement and
   write RD as it becomes clear. Record Design Decisions as they are made.
   Draft Conventions (rules and Setup) best-effort from repo and activity
   facts; the user corrects.
4. If the user cited files, run **Cited context**.
5. Draft Goal (RD summary), `design.md` (**Design document**: Current
   Design, `DD<n>` blocks that cite their `DC` entries, a `TC<n>` Test
   Plan, and a Traceability table with every case tagged `(planned for
   M<n>)`), Plan, MECE milestones (`M1`, `M2`, …), evidence, Next Steps,
   and `plan-outline.md`. Each real milestone has a `reads:` line
   (**activity.md**). Cited sources go to
   `references.md`. Each milestone lists unit cases per part and
   integration cases for the boundaries it completes; the last names the e2e
   (and any interface fake). Use the same case names in the milestone test
   bullets and in `design.md`'s `TC<n>` Test Plan and Traceability. Note
   existing tests to extend (**Test evidence**).
6. **draft-check:** the parent re-reads the drafted files before user
   review. No critics; this is not the `start-review` pipeline.

Required project-fit prompt (or equivalent):

> Before scope: how does this activity fit the larger project? State the
> problem and lay it out against the project scope in `.dev-notes/definition.md`.

Required intake prompt (or equivalent):

> In free text, define this activity's scope: objective, in-scope work,
> out-of-scope boundaries, constraints, and what "done" looks like.

If the current message already supplied both, acknowledge and continue
grilling.
