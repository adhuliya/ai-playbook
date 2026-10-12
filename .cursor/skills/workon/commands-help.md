# Help commands

Keyword steps for workon.
Read only the heading you are running.
Shared rules and the session probe live in [`SKILL.md`](SKILL.md).
Shapes: [`templates.md`](templates.md).
A bold name follows the index in `SKILL.md`.

## `query-work` / `no-query-work`

Status: any. Session flag; behavior: **Stops**. Status unchanged.

## `help`

Status: any; read-only; no focused activity needed.

- `help`: tell the user what to do next in the current state. Cap ~5 lines:
  one state line (slug, status, `conventions`), then 1–3 next actions from
  the table below. Check rows top-down; the first match wins. End with one
  line: `help intro` for basics, `help all` for every command.
- `help intro`: teach the basic path in ≤ 8 lines. Name only these steps:
  1. Describe the work in plain words (e.g. `workon add CSV export`).
     Answer the questions, then review the drafted files.
  2. `approve-plan` and `conventions-ok`: accept the plan and the rules.
  3. `start-building`: the agent builds and tests.
  4. `mark-completed`: close the work when the tests pass.

  Add: type `help` at any time for the next step. Teach no other commands.
- `help all`: print the **Command map** tables from `SKILL.md`. If an
  activity is focused, mark the commands its status allows (`Status:` lines
  in the command files). Rows with `Status: any`, `n/a`, or no heading (natural language)
  are always allowed.
- `help <command>`: explain that command in 2–5 sentences from that command's heading: when to use it, what it changes, and what it needs first.

| State | Next actions |
|---|---|
| Query mode on | Read and ask freely. `no-query-work` to allow edits. |
| Pipeline in flight | Wait for the named pipeline, or ask to abandon it. |
| Fix cycle `open` | Review its points in `reviews.md`; then `apply-review` (applies drift fixes first). |
| Regular cycle `open` | Add or edit points; then `apply-review`. |
| No focused activity | Name an activity to switch to it, or describe new work to create one. |
| `Planning` | Answer open questions; review the files and give feedback. Then `approve-plan` (and `conventions-ok` if `pending`). |
| `Approved` | `conventions-ok` if `pending`; then `start-building`. |
| `Active` | Give feedback or say continue. `start-review` after a milestone. `mark-completed` when all milestones and the e2e pass and no review cycle is open. `pause-work` to stop. |
| `Paused` | `resume-work`. |
| `Blocked` | Resolve the blocker in `notes` (quote it); then `resume-work`. |
| `Complete` | `resume-work` to fix or extend; `create-guide` if `user-guide.md` is missing. |

Add one optional line when it applies: an `open` review cycle →
`apply-review`; `review-comments: on` at `Active` with all milestones checked
→ `remove-review-comments`; `Planning` with no `verify-plan` this session →
`verify-plan`.
