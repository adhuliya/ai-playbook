# `replan-work`

Status: `Planning`, `Approved`, `Active`, `Paused`, `Blocked`.

Reads: policy/activity-kind.md, policy/planning-quality-bar.md, policy/planning-stages.md, policy/references.md, policy/requirement-def.md, policy/design-choices.md, policy/design-document.md, policy/conventions.md, policy/test-evidence.md, policy/material-change.md, policy/journal.md, policy/catalog.md, policy/reminders.md, policy/execution-gate.md, policy/plan-outline.md

This is the in-flight **Material-change**.

1. On `Blocked`, quote the blocker and prompt `resume-work`. Stop. Do not
   set `Planning`. Otherwise, if the status is not `Planning`, set `Planning` now
   (this stops engineering) and record the reason in `agent-activity.md`.
   Remove `prior:` from `notes`. Leave other notes text. A pause does not
   have to be resumed first. This command is the exit from `Paused` when
   the scope itself changes.
2. When `stage` is `requirements` and `kind` is `thin`, and the user did
   not ask to reopen requirements, follow **Choose**. A typed `thin` stays
   thin, names `start-building`, and stops. When the user did not type
   `thin`, set `kind` to `full`, follow `commands/make-full.md`, and stop.
   Do not ask the user to type `make-full`. When the user asks to reopen requirements, set `kind: full`
   and `stage: requirements` first (**Planning stages**). When `kind` is
   `full` and `stage` is `requirements`, keep `kind`. Follow **Agent
   notes** (`policy/reviews.md`). Remind the strong model. Run steps 1–4 of the
   **Planning quality bar** for open branches only. Run **Cited
   context** when files are cited, and refresh stale references
   (**Refresh**). Append a `Replan` event. Do not rewrite the design
   files or prompt `start-building`. When a grill branch is open, name
   that question and stop. When none is open, prompt `requirements-ok`
   and stop.
3. Otherwise follow **Activity kind**. When the new scope is unsafe and
   the user has not picked, append the `Replan` event and stop on the
   choice in **Activity kind**. A later `thin` reply continues at step 4
   and skips the `Replan` event in step 5. Otherwise, on `full`, remind the strong
   model and re-run the **Planning quality bar** for open branches only.
   On `thin`, do not run that bar and do not invent test tiers. The e2e
   name follows **Test evidence**. Keep code
   already written. Keep requirements, choices, and constraints that the
   new scope still includes. Run **Cited context** when files are
   cited, and refresh stale references (**Refresh**).
4. Follow **Agent notes** (`policy/reviews.md`). Rewrite RD, `# Scope`, the affected `agent-activity.md` sections,
   `spec-design.md` (**Design document**), and `spec-plan-outline.md`
   (design stage). Keep checked milestones (**agent-activity.md**). Append
   new ones, and mark removed work `superseded`. Append Design Decisions.
   Update Conventions (rules
   and Setup) from observed facts and user-confirmed rules. If the Goal
   changed, patch that one **Catalog** entry.
5. Append a `Replan` event: why, changed IDs, old status (**Journal
   policy**). Skip it when step 3 already wrote one.
6. On `full`, **File review**, then the **Execution gate** before
   engineering. On `thin`, show the outline and prompt `start-building`.
