# `help`

Status: any; read-only; no focused activity needed.

- `help`: tell the user what to do next in the current state; cap ~5 lines:
  one state line (slug, status, `kind`, `stage` when `Planning`, `conventions`), then 1–3 next actions from
  the state table. Check rows top-down; the first match wins. End with one
  line: `help intro` for basics, `help all` for every command.
- `help intro`: teach the basic path in ≤ 8 lines, and no other commands:
  1. Describe the work in plain words (e.g. `workon add CSV export`).
     A clear small request stays `thin`: short files, no grill.
  2. Review the files, then `start-building`. Full: `approve-plan`, then
     `yes`. Requirements first: `requirements-ok` before `approve-plan`.
  3. Reply `continue` to keep going. Thin builds inline. Full builds by
     milestones.
  4. `mark-completed` closes the work when the tests pass.
  Add: type `help` at any time for the next step.
- `help all`: read `commands/help-map.md` and print its command map. If an
  activity is focused, mark the commands its status allows (`Status:` lines
  in the command files). Rows with `Status: any`, `n/a`, or no heading (natural
  language) are always allowed.
- `help <command>`: explain that command in 2–5 sentences from its file
  (`commands/<command>.md`): when to use it, what it changes, and what it needs
  first.

| State | Next actions |
|---|---|
| Query mode on | Read and ask freely. `no-query-work` to allow edits. |
| Pipeline in flight | Wait for the named pipeline, or ask to abandon it. |
| Fix cycle `open` | Review its points in `reviews.md`; then `apply-review` (applies drift fixes first). `Paused` or `Blocked` still needs `resume-work`. |
| Regular cycle `open` | Add or edit points; then `apply-review`. `Paused` or `Blocked` still needs `resume-work`. On full `Planning`, `approve-plan` follows after the cycle closes. |
| No focused activity | Name an activity to switch to it, or describe new work to create one. |
| `Planning`, `stage: requirements` | Answer open questions; review RD and the Problem header. Then `requirements-ok` to start the design half. |
| `Planning`, `kind: thin` | Review the short files (start with `spec-plan-outline.md`). A chat note on the same goal updates those files. Then `start-building`. |
| `Planning` | Answer open questions; review the files (start with `spec-plan-outline.md`) and give feedback. Then `approve-plan` (it offers to accept the conventions if `pending`). |
| `Approved` | `conventions-ok` if `pending`; then `start-building`. |
| `Active` | Reply `continue`, or `mark-completed` when the milestones and the e2e pass. `pause-work` to stop. |
| `Paused` | `resume-work`. |
| `Blocked` | Resolve the blocker in `notes` (quote it); then `resume-work`. |
| `Complete` | `resume-work` to fix or extend; `create-guide` if `artifacts/guide-for-users.md` is missing. |

Add one optional line when it applies: an `open` review cycle →
`apply-review`; `thin` and `Planning`, when they want the grill →
`make-full`; `Active` after a checked milestone → `start-review`;
`review-comments: on` at `Active` with all milestones
checked → `remove-review-comments`; `full` and `Planning` with no
`verify-plan` this session → `verify-plan`.
