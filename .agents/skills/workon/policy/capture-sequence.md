# Capture sequence

Use when `capture-work` creates an activity for work already started or
finished outside workon. Do not run product engineering (**Execution
gate**).

1. On `full`, remind strong model. On `thin`, skip that reminder.
2. Take the user's work definition: objective, claimed progress, remaining
   work, and what "done" means. When the message lacks it, ask once:

   > In free text, define the work to capture: objective, what you believe
   > already landed, what remains, constraints, and what "done" looks like.

3. Choose `kind` (**Activity kind**). Default `stage: design`. Requirements
   first sets `kind: full` and `stage: requirements` (**Planning stages**).
4. Assess the repo against that definition: paths, `git` diff against the
   intended `base-branch`, tests, and any named PR or commit. Separate
   claimed from verified. Do not invent progress without evidence.
5. Grill every open capture branch (**Grill**, **Asking**). Branches cover:
   goal and done condition; verified landings (paths, commands, evidence);
   remaining work; requirements to capture as RD; design choices already
   made (`DC` / `DD`); conventions and Setup already in play; tests that
   exist or still need names (**Test evidence**); the milestone map (done
   vs remaining); slug and `base-branch`. On `full`, also **Project-fit**
   (and **Definition bootstrap** when needed). On `thin`, ask only a
   branch the repo cannot answer. When the repo answers a branch, do not
   ask. Write each settled fact to its home record in the same turn.
   Unsettled notes with no home yet go to **Agent notes** as `working:`.
6. Read each record's shape (`shapes/`, named in its policy) just before
   you write that record. Write `agent-activity.md` (`kind` as chosen,
   `stage` as chosen, default `design`; `conventions: pending`,
   `review-comments: on`, `continue: ask`, `base-branch` from the grill or
   `main`), `agent-journal.md` (`# Journal` plus a `Created` event:
   captured from outside workon; claimed vs verified; remaining),
   `spec-req-def.md`, `spec-design-choices.md`, `spec-design.md`
   (**Design document**), `conventions.md` (with the Setup H2),
   `references.md` (one `REF<n>` per cited item), and `notes-by-user.md`
   (`# Notes by User` only, unless the user already wrote notes). In
   `stage: design`, also write `spec-plan-outline.md` (**Plan outline**).
   Check a milestone only when evidence supports it. Leave remaining work
   unchecked. Do not set `Complete`. Append one **Catalog** entry.
7. On `thin`, show `spec-plan-outline.md` and the Goal, then prompt
   `start-building`. When this message already contains `start-building`,
   read `commands/start-building.md` and follow it. On `full` and
   `stage: requirements`, prompt `requirements-ok` once no grill branch is
   open. On `full` and `stage: design`, **File review**, then the
   **Execution gate**. When every milestone is already checked, still
   follow those gates; after `start-building`, prompt `mark-completed`.
