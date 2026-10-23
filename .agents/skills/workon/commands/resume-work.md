# `resume-work`

Status: any. **Optional-remind** `apply-review` and `fix-activity`; this
command does not close an open cycle.

Reads: policy/activity-kind.md, policy/paused-blocked.md, policy/material-change.md, policy/journal.md, policy/reminders.md, policy/execution-gate.md, policy/plan-outline.md, policy/design-document.md, shapes/journal.md

## `Paused` / `Blocked`

1. Read `agent-activity.md`, `spec-design.md`, and RD / Design Decisions / Conventions. Refresh
   stale references (**Refresh**, `policy/references.md`). Open the journal only if it has entries.
2. Summarize concisely: objective, design, conventions, status,
   discoveries, remaining work, next action, branch hint. `Blocked`: restate
   the blocker.
3. Wait for explicit confirmation (`Blocked`: that the blocker is resolved).
4. Restore `prior:` (**Paused vs Blocked**) and append the resume recap.
5. Reminders: `full` and `Planning` → strong model; `thin` and `Planning`
   → `start-building`; `Approved` → `conventions-ok` / `start-building`.

## `Planning` / `Approved` / `Active`

Reload context only: steps 1–2 above. No status change, no journal.
`Planning` with `stage: requirements`: remind `requirements-ok` when RD
looks complete. Do not prompt `start-building` in that stage. `Planning`
with `kind: thin`: prompt `start-building`.

## `Complete`

The activity stays `Complete` until the choice is clear; do not journal
yet. This is the **Complete stay-on-slug** or sibling fork
(**Material-change**).

1. Same reads as above.
2. Take the issue in free text. Do not prompt `make-full` while the
   status is `Complete`. When `kind` is `thin` and the new request is
   still one clear outcome, skip the grill. When the request is unsafe,
   skip the grill until the user picks below. Otherwise grill: outcome,
   why now, in / out, paths, risk, evidence.
3. Classify: minor stay-on-slug vs major `create-sibling`. Do not
   transition silently.
4. **Sibling:** prompt `create-sibling`. After the user writes it, follow
   that command. Stop; do not reopen this slug.
5. **Stay:** after the user confirms this slug, reopen `Complete` →
   `Planning`. Append the resume recap (`Complete` → `Planning`). When
   the request is unsafe and the user has not picked, set `# Next Steps`
   to the choice in **Activity kind** and stop before the rewrite. A
   later `thin` reply continues here. Preserve the shipped design and
   checked milestones. Rewrite
   `# Current Plan` / `# Next Steps` as a high-level **legacy verify**
   (re-run or spot-check old evidence; do not redo those milestones), then
   **delta steps** that start at the new requirement, including steps that
   undo earlier work. Mark undone milestones `superseded`. Update RD and
   Design Decisions (`replaces:` when a choice flips). Tighten Conventions
   only if the user states a new or changed rule (Setup: best-effort
   refresh) and `spec-plan-outline.md`. Set `stage: design`.
6. On `full`, **File review** (`policy/planning-stages.md`) and the
   **Execution gate**. On `thin`, show the delta and prompt
   `start-building`.
