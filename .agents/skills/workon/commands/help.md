# `help`

Status: any; read-only; no focused activity needed.

- `help`: tell the user what to do next in the current state; cap ~5 lines:
  one state line (slug, status, `kind`, `stage` when `Planning`, `conventions`), then 1–3 next actions from
  the state table. Check rows top-down; the first match wins. End with one
  line: `help intro` for basics, `help all` for every command.
- `help intro`: teach the basic path in ≤ 8 lines, naming only these steps:
  1. Describe the work in plain words (e.g. `workon add CSV export`).
     A clear small request stays `thin`: short files, no grill.
  2. Review the files. `start-building` starts implementation.
     A `full` activity uses `approve-plan` first, then `yes` for the rules.
  3. The agent builds inline when `thin`, and through milestones when `full`.
  4. `mark-completed`: close the work when the tests pass.

  Add: type `help` at any time for the next step. Teach no other commands.
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
| Fix cycle `open` | Review its points in `reviews.md`; then `apply-review` (applies drift fixes first). |
| Regular cycle `open` | Add or edit points; then `apply-review`. |
| No focused activity | Name an activity to switch to it, or describe new work to create one. |
| `Planning`, `kind: thin` | Review the short files (start with `spec-plan-outline.md`). Then `start-building`. `make-full` adds the grill and the other gates. |
| `Planning`, `stage: requirements` | Answer open questions; review RD and the Problem header. Then `requirements-ok` to start the design half. |
| `Planning` | Answer open questions; review the files (start with `spec-plan-outline.md`) and give feedback. Then `approve-plan` (it offers to accept the conventions if `pending`). |
| `Approved` | `conventions-ok` if `pending`; then `start-building`. |
| `Active` | Give feedback or say continue. `start-review` after a milestone. `mark-completed` when all milestones and the e2e pass and no review cycle is open. `pause-work` to stop. |
| `Paused` | `resume-work`. |
| `Blocked` | Resolve the blocker in `notes` (quote it); then `resume-work`. |
| `Complete` | `resume-work` to fix or extend; `create-guide` if `artifacts/guide-for-users.md` is missing. |

Add one optional line when it applies: an `open` review cycle →
`apply-review`; `review-comments: on` at `Active` with all milestones
checked → `remove-review-comments`; `full` and `Planning` with no
`verify-plan` this session → `verify-plan`.
