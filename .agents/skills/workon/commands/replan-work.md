# `replan-work`

Status: `Planning`, `Approved`, `Active`, `Paused`, `Blocked`.

Reads: policy/activity-kind.md, policy/planning-quality-bar.md, policy/planning-stages.md, policy/references.md, policy/requirement-def.md, policy/design-choices.md, policy/design-document.md, policy/conventions.md, policy/test-evidence.md, policy/material-change.md, policy/journal.md, policy/catalog.md, policy/reminders.md, policy/execution-gate.md, policy/plan-outline.md

This is the in-flight **Material-change**.

1. If the status is not `Planning`, set `Planning` now (this stops
   engineering) and record the reason in `agent-activity.md`. Clear
   `prior:` and any blocker from `notes`.
2. When the user asks to reopen requirements, set `kind: full` and
   `stage: requirements` first (**Planning stages**). Remind the strong
   model. Run steps 1–4 of the **Planning quality bar**. Run **Cited
   context** when files are cited, and refresh stale references
   (**Refresh**). Append a `Replan` event. Prompt `requirements-ok`.
   Stop. Do not rewrite the design or prompt `start-building`.
3. Otherwise follow **Activity kind**. When the new scope is unsafe and
   the user has not picked, append the `Replan` event and stop on the
   choice in **Activity kind**. A later `thin` reply continues at step 4
   and skips the `Replan` event in step 5. Otherwise, on `full`, remind the strong
   model and re-run the **Planning quality bar** from the top. On
   `thin`, keep the rewrite short. Run **Cited context** when files are
   cited, and refresh stale references (**Refresh**).
4. Rewrite RD, `# Scope`, the affected `agent-activity.md` sections,
   `spec-design.md` (**Design document**), and `spec-plan-outline.md`
   (design stage). Append Design Decisions. Update Conventions (rules
   and Setup) from observed facts and user-confirmed rules. If the Goal
   changed, patch that one **Catalog** entry.
5. Append a `Replan` event: why, changed IDs, old status (**Journal
   policy**). Skip it when step 3 already wrote one.
6. On `full`, **File review**, then the **Execution gate** before
   engineering. On `thin`, show the outline and prompt `start-building`.
