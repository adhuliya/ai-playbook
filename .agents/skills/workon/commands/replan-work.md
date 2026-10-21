# `replan-work`

Status: `Planning`, `Approved`, `Active`, `Paused`, `Blocked`.

Reads: policy/planning-quality-bar.md, policy/planning-stages.md, policy/references.md, policy/requirement-def.md, policy/design-choices.md, policy/design-document.md, policy/conventions.md, policy/test-evidence.md, policy/material-change.md, policy/journal.md, policy/catalog.md, policy/reminders.md, policy/execution-gate.md, policy/plan-outline.md

This is the in-flight **Material-change**.

1. Remind strong model. If the status is not `Planning`, set `Planning` now
   (this stops engineering) and record the reason in `activity.md`. Clear
   `prior:` and any blocker from `notes`.
2. Re-run the **Planning quality bar** from the top. When the user asks to
   reopen requirements, set `stage: requirements` (**Planning stages**).
   Run **Cited context** when files are cited, and refresh stale references
   (**Refresh**).
3. Rewrite RD, `# Scope`, the affected `activity.md` sections, `design.md`
   (**Design document**), and
   `plan-outline.md` (design stage). Append
   Design Decisions. Update Conventions (rules and Setup) from observed
   facts and user-confirmed rules. If the Goal changed, patch that one
   **Catalog** entry.
4. Append a `Replan` event: why, changed IDs, old status (**Journal policy**).
5. **File review**, then the **Execution gate** before engineering.
