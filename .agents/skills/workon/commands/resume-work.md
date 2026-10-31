# `resume-work`

Status: any. **Optional-remind** `apply-review` and `fix-activity`; this
command does not close an open cycle.

Reads: policy/activity-kind.md, policy/paused-blocked.md, policy/material-change.md, policy/journal.md, policy/reminders.md, policy/execution-gate.md, policy/plan-outline.md, policy/design-document.md, policy/inflight.md, shapes/journal.md

## `Paused` / `Blocked`

1. Read `agent-activity.md`, `spec-design.md`, and RD / Design Decisions / Conventions. Refresh
   stale references (**Refresh**, `policy/references.md`). Open the journal only if it has entries.
2. Summarize concisely: objective, design, conventions, status,
   discoveries, remaining work, next action, branch hint. `Blocked`: restate
   the blocker. When `inflight.md` exists, name its pipeline and unit.
3. Wait for explicit confirmation (`Blocked`: that the blocker is resolved).
4. Restore `prior:` (**Paused vs Blocked**). When that policy says to ask,
   ask and stop. Append the resume recap only after the status is restored.
   Then read the remainder in this order. Read `# Next Steps` in
   `agent-activity.md`. Then read `artifacts/agent-notes.md` when it
   exists. Then read `artifacts/inflight.md` when it exists. When
   `artifacts/inflight.md` exists, go to step 5 and skip the rest of
   this step. When a `working:` line is a grill question, read
   `policy/grill.md` and ask it next. Do not ask the user to repeat it.
   Continue from the rest of that remainder.
5. When `artifacts/inflight.md` exists, follow **Inflight pipelines**.
   The `notes:` line says what the unit still owed. Do not continue to
   step 6.
   - A completion notice for this launch's final file, in this chat, is
     a safe finish. Run only that parent end step. Do not relaunch.
     That step names the next keyword. Follow **Continue mode** only
     when the status is `Active` and `inflight.md` is gone.
   - No notice, or a new chat: do not read the final file. Do not follow
     **Continue mode**. Waiting works only in the launching chat. If
     they abandon, name the re-run keyword. `auto` does not start work
     on this turn. Do not launch the re-run in this turn.
6. Name the next keyword. Also remind the strong model when `kind` is
   `full` and the status is `Planning`. Skip this step when step 5 ran.
   - An `open question:` stays open in every stage. Do not prompt
     `requirements-ok`, `approve-plan`, or `start-building`.
   - An `unfinished requirement:` is repeated for any kind. Do not prompt
     `start-building`.
   - `stage: requirements` and `kind: thin`: set `kind` to `full` and
     continue. Do not prompt `make-full`.
   - `stage: requirements`, `kind: full`, no open branch, and RD looks
     complete: prompt `requirements-ok`.
   - `full`, `Planning`, and `stage: design`: prompt `approve-plan`.
   - `thin`, `Planning`, and `stage: design`: prompt `start-building`.
   - `Approved` and `conventions: pending`: prompt `conventions-ok`.
   - `Approved` and `conventions: ok`: prompt `start-building`.
   - `Active`: follow **Continue mode**.

## `Planning` / `Approved` / `Active`

Reload context only: steps 1–2 above. No status change, no journal.
When `inflight.md` exists, name the pipeline. They can wait, abandon, or
`pause-work`. Do not name a gate keyword. Otherwise use step 6 for the
next keyword. Do not prompt `start-building` while `stage` is
`requirements`.

## `Complete`

The activity stays `Complete` until the choice is clear; do not journal
yet. This is the **Complete stay-on-slug** or sibling fork
(**Material-change**).

1. Same reads as above.
2. Take the issue in free text. Do not prompt `make-full` while the
   status is `Complete`. When `kind` is `thin` and the new request is
   still one clear outcome, skip the grill. When the request is unsafe
   and the user typed `thin`, keep `thin` and skip the grill. Do not ask
   the user to pick. Otherwise grill: outcome,
   why now, in / out, paths, risk, evidence.
3. Classify: minor stay-on-slug vs major `create-sibling`. Do not
   transition silently.
4. **Sibling:** prompt `create-sibling`. After the user writes it, follow
   that command. Stop; do not reopen this slug.
5. **Stay:** after the user confirms this slug, reopen `Complete` →
   `Planning`. Append the resume recap (`Complete` → `Planning`). When
   the request is unsafe and the user did not type `thin`, set `kind`
   to `full`. Do not ask the user to pick. Preserve the shipped design and
   checked milestones. Rewrite `# Current Plan`. Lead `# Next Steps`
   with the exit keyword from step 6, then a high-level legacy verify (re-run or
   spot-check old evidence; do not redo those milestones), then delta
   steps that start at the new requirement, including steps that undo
   earlier work. Mark undone milestones `superseded`. Update RD and
   Design Decisions (`replaces:` when a choice flips). Tighten Conventions
   only if the user states a new or changed rule (Setup: best-effort
   refresh) and `spec-plan-outline.md`. Set `stage: design`.
6. On `full`, **File review** (`policy/planning-stages.md`) and prompt
   `approve-plan` (**Execution gate**). On `thin`, show the delta and
   prompt `start-building`. When this resume continues a `make-full`
   that stopped on `Complete`, follow `commands/make-full.md`. Do not
   ask the user to type that keyword. The exit
   keyword is item 1 of `# Next Steps`.
