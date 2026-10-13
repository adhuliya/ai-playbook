# Planning

Loaded by `create`, `create-sibling`, and `replan-work`, together with
[`notes-files.md`](notes-files.md) and **Test evidence**. Index:
[`SKILL.md`](SKILL.md).

## Planning quality bar

Applies to create, `create-sibling`, and `replan-work`. Grill with
[`grill-me`](../grill-me/SKILL.md): one question at a time, recommend an
answer, and explore the repo instead of asking. Do not skip grilling to
draft files.

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
5. Draft Goal (RD summary), Design, Plan, MECE milestones, evidence, Next
   Steps, and References. Each milestone lists unit cases per part and
   integration cases for the boundaries it completes; the last names the e2e
   (and any interface fake). Note existing tests to extend (**Test evidence**).
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

## Definition bootstrap

Runs once per repo, when `.dev-notes/definition.md` is missing, empty, or
only `TODO`.

1. Read the README and the top-level layout. Do not bulk-read.
2. Ask two or three short questions, one at a time, with a recommended
   answer each: purpose, users, out of scope.
3. Draft `definition.md`: a `# <Project>` H1 and one short paragraph per
   answer, under ~200 words.
4. Show the draft. Write it only after the user confirms or corrects it.
5. Continue at **Project-fit**.

## Create sequence

1. Remind strong model.
2. **Planning quality bar** (includes **draft-check**; `# Scope` after the
   grill, `# Goal` from RD).
3. Write `activity.md` (`conventions: pending`, `review-comments: on`,
   `base-branch` from the grill or `main`, a `synced` snapshot),
   `journal.md` (`# Journal` plus a `Created` event), `requirement-def.md`,
   `design-choices.md`, `conventions.md` (with the Setup H2), and
   `notes-by-user.md` (`# Notes by User` only, unless the user already
   wrote notes). Append one **Catalog** entry.
4. **File review:** show the drafted files; the user challenges RD,
   Conventions, Setup, and plan before `approve-plan` / `conventions-ok`.
   Feedback goes per **Reviews** (where points go); `start-review` is not
   required. Done when the user has seen the files and every feedback
   round is recorded.
5. Revision loop. Then the **Execution gate**.

## Cited context

Runs when the user points at files as initial context or definition
updates (create, derive, `replan-work`, RD changes), not for every source
file touched while building.

1. Use every cited file this session, saved or not.
2. Ask once with a list. For each file: tracked or not, and a hint of whole
   copy vs excerpt. Do not copy until the user chooses; a subset is fine.
3. **Whole copy:** `artifacts/<basename>` at the artifacts root (create the
   dir if needed), never under a reserved name (`templates.md`). On a name
   clash, ask. No secrets. For huge trees, excerpt or skip.
4. **Excerpt:** a new `artifacts/<stem>-excerpt.md` whose header names the
   source and what was kept. For a binary, write markdown of what mattered,
   or a whole copy if the user asked for the file.
5. Every cited file gets a `REF<n>` bullet in `# References` (`copied` /
   `excerpt` / `context-only` plus 1–3 sentences learned). On
   `replan-work`, refresh it if the same files return.
