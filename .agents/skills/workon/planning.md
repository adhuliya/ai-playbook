# Planning

Read this file to create, derive, or replan an activity.
Also read [`notes-files.md`](notes-files.md) before you write the notes files.
Read [`building.md`](building.md) before you write milestone tests.
Index: [`SKILL.md`](SKILL.md).

## Planning quality bar

Applies to create, `create-sibling`, `replan-work`.

Use [`grill-me`](../grill-me/SKILL.md): one question at a time, recommend an
answer, explore the repo instead of asking. Do not skip grilling to draft files.

**Order (mandatory):**

1. **Project-fit** against `.dev-notes/definition.md`. Do not proceed until it fits.
   When the file is missing, empty, or only `TODO`, run **Definition bootstrap** first.
2. **Intake:** free-text scope (objective, in/out, constraints, done).
   Then write the **Problem header** in `requirement-def.md`.
3. Grill remaining branches: goal, success, scope, constraints, assumptions,
   risks, interfaces, non-goals. Classify each requirement and write RD as it
   becomes clear. Record Design Decisions as they are made. Best-effort
   Conventions (rules + Setup) from repo/activity facts; user corrects.
4. If the user cited files, run **Cited context**.
5. Draft Goal (RD summary) / Design / Plan / MECE milestones / evidence /
   Next Steps / References. Each milestone lists unit cases per part and
   integration cases for the boundaries it completes; the last names e2e (and
   any interface fake). Note existing tests to extend (**Test evidence**).
6. **draft-check:** parent re-reads the drafted files before user review. No
   critics; not the `start-review` pipeline.

Required project-fit prompt (or equivalent):

> Before scope: how does this activity fit the larger project? State the
> problem and lay it out against the project scope in `.dev-notes/definition.md`.

Required intake prompt (or equivalent):

> In free text, define this activity's scope: objective, in-scope work,
> out-of-scope boundaries, constraints, and what "done" looks like.

If the current message already supplied both, acknowledge and continue grilling.

## Definition bootstrap

Runs once per repo, when `.dev-notes/definition.md` is missing, empty, or only `TODO`.

1. Read the README and the top-level layout. Do not bulk-read.
2. Ask two or three short questions, one at a time: purpose, users, out of scope.
   Recommend an answer for each.
3. Draft `definition.md`: a `# <Project>` H1 and one short paragraph per answer.
   Keep it under ~200 words.
4. Show the draft. Write it only after the user confirms or corrects it.
5. Continue at **Project-fit**.

## Create sequence

1. Remind strong model.
2. **Planning quality bar** (includes **draft-check**; `# Scope` after the
   grill, `# Goal` from RD).
3. Write `activity.md` (`conventions: pending`, `review-comments: on`,
   `base-branch` from the grill or `main`, `synced` snapshot),
   `journal.md` (`# Journal` plus a `Created` event),
   `requirement-def.md`, `design-choices.md`, `conventions.md` (include
   Setup H2), `notes-by-user.md` (`# Notes by User` only unless the user
   already wrote notes). Append one **Catalog** entry.
4. **File review:** show the drafted files; the user challenges RD,
   Conventions, Setup, and plan before `approve-plan` / `conventions-ok`.
   Feedback goes per **Reviews** (where points go). `start-review` is not
   required. Done when the user has seen the files and every feedback
   round is recorded.
5. Revision loop. Then **Execution gate**.

## Cited context

When the user points at files as initial context or definition updates (create,
derive, `replan-work`, RD changes — not every source file touched while building):

1. Use every cited file **this session**, saved or not.
2. Ask **once** with a list. For each: tracked or not, hint whole copy vs excerpt.
   Do not copy until the user chooses. Subset OK.
3. **Whole copy:** `artifacts/<basename>` at the artifacts **root** (create dir
   if needed). Never under a reserved name (`templates.md`). Name clash: ask.
   No secrets. Huge trees: excerpt or skip.
4. **Excerpt:** new `artifacts/<stem>-excerpt.md` (header: source + what was kept).
   Binary: markdown of what mattered, or whole copy if the user asked for the file.
5. Every cited file gets a `REF<n>` bullet in `# References` (`copied` /
   `excerpt` / `context-only` + 1–3 sentences learned). On `replan-work`,
   refresh if the same files return.
