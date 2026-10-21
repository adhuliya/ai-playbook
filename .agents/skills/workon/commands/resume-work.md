# `resume-work`

Status: any. **Optional-remind** `apply-review` and `fix-activity`; this
command does not close an open cycle.

Reads: policy/paused-blocked.md, policy/material-change.md, policy/journal.md, policy/reminders.md, policy/execution-gate.md, policy/plan-outline.md, policy/design-document.md, shapes/journal.md

## `Paused` / `Blocked`

1. Read `activity.md`, `design.md`, and RD / Design Decisions / Conventions. Refresh
   stale references (**Refresh**, `policy/references.md`). Open the journal only if it has entries.
2. Summarize concisely: objective, design, conventions, status,
   discoveries, remaining work, next action, branch hint. `Blocked`: restate
   the blocker.
3. Wait for explicit confirmation (`Blocked`: that the blocker is resolved).
4. Restore `prior:` (**Paused vs Blocked**) and append the resume recap.
5. Reminders: `Planning` → strong model; `Approved` → `conventions-ok` /
   `start-building`.

## `Planning` / `Approved` / `Active`

Reload context only: steps 1–2 above. No status change, no journal.
`Planning` with `stage: requirements`: remind `requirements-ok` when RD
looks complete.

## `Complete`

The activity stays `Complete` until the choice is clear; do not journal
yet. This is the **Complete stay-on-slug** or sibling fork
(**Material-change**).

1. Same reads as above.
2. Take the issue in free text, then grill: outcome, why now, in / out,
   paths, risk, evidence.
3. Classify: minor stay-on-slug vs major `create-sibling`. Do not
   transition silently.
4. **Sibling:** prompt `create-sibling`. After the user writes it, follow
   that command. Stop; do not reopen this slug.
5. **Stay:** after the user confirms this slug, reopen `Complete` →
   `Planning`. Preserve the shipped design and checked milestones. Rewrite
   `# Current Plan` / `# Next Steps` as a high-level **legacy verify**
   (re-run or spot-check old evidence; do not redo those milestones), then
   **delta steps** that start at the new requirement, including steps that
   undo earlier work. Mark undone milestones `superseded`. Update RD and
   Design Decisions (`replaces:` when a choice flips). Tighten Conventions
   only if the user states a new or changed rule (Setup: best-effort
   refresh) and `plan-outline.md`. Set `stage: design`.
6. Then append the resume recap (`Complete` → `Planning`; `next:` is the
   first delta step).
7. **File review** (`policy/planning-stages.md`) and the **Execution gate**.
