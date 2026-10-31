# `help`

Status: any; read-only; no focused activity needed.

- `help`: one state line (slug, status, `kind`, `stage` when `Planning`,
  `conventions`). Query mode and an open review cycle are banners. The
  status row still supplies the next keyword. A pipeline in flight stays
  exclusive. Use the **Guide the user**
  close. In flight, name `artifacts/sub-agents-log.txt`. End with
  `help intro`, `help files`, `help all`.
- `help intro`: teach the basic path in ≤ 8 lines, and no other commands.
  1. Describe the work in plain words (e.g. `workon add CSV export`).
     A clear small request stays a short plan: short files, no grill.
  2. Review the files. A small clear plan: `start-building`. A deeper plan: `approve-plan`, then `yes` if asked, then `start-building`. Requirements: `requirements-ok`. The agent deepens a thin requirements plan before that.
  3. Reply `continue` to keep going. Thin builds inline. Full builds by
     milestones.
  4. `mark-completed` closes the work when the tests pass.
  Add: type `help` at any time for the next step.
- `help all`: read `commands/help-map.md` and print its command map. If an
  activity is focused, mark the commands its status allows (`Status:` lines
  in the command files). Rows with `Status: any`, `n/a`, or no heading (natural
  language) are always allowed.
- `help files`: explain the folder from `SKILL.md` Records and
  `shapes/layout.md`, plus `artifacts/sub-agents-log.txt`. Name the slug.
  No file bodies.
- `help <command>`: explain that command in 2–5 sentences. The file is
  `commands/<command>.md`, or the shared file `SKILL.md` step 3 names.
  `grill-me` is `policy/grill.md`. When the command is `verify-plan`, say
  that it is retired and explain `agent-review`. When the command is
  `continue`, there is no `commands/continue.md`. Explain that `continue`
  is the Active engineering turn in `commands/build.md`. When the command
  is `draft-check`, say it is not a command. Point at step 6 of
  `policy/planning-quality-bar.md`. Otherwise say when to use
  the command, what it changes, and what it needs first. `files` is the
  folder mode above, not a command.

| State | Next actions |
|---|---|
| Query mode on | Read and ask freely. `no-query-work` to allow edits. |
| Pipeline in flight | `pause-work` keeps the pipeline. Next is `resume-work`. Or wait, or ask to abandon. |
| Fix cycle `open` | Review its points in `reviews.md`; then `apply-review` (applies drift fixes first). `Paused` or `Blocked` still needs `resume-work`. |
| Regular cycle `open` | Add or edit points, then `apply-review`. `Paused` or `Blocked` still needs `resume-work`. After it closes: requirements names `requirements-ok`, a deeper design names `approve-plan`, and a short design names `start-building`. |
| No focused activity | Name an activity to switch to it, or describe new work to create one. |
| `Planning`, `stage: requirements` | Answer open questions. Review RD and the Problem header. Then `requirements-ok`. The agent deepens a short plan first when the request needs it. |
| `Planning`, `kind: thin` | Review the short files (start with `spec-plan-outline.md`). A same-Goal note follows **Agent notes**. Then `start-building`. |
| `Planning` | Answer open questions. Review the files, starting with `spec-plan-outline.md`. Feedback follows **Agent notes**. Then `approve-plan` (it offers to accept the conventions if `pending`). |
| `Approved` | `conventions-ok` if `pending`; then `start-building`. |
| `Active` | `continue` when that row is `ask` or missing. When `auto`, the next building turn starts the remaining work. This help reply does not. `mark-completed` when the milestones and the e2e pass. `pause-work` to stop. |
| `Paused` | `resume-work`. |
| `Blocked` | Resolve the blocker in `notes` (quote it); then `resume-work`. |
| `Complete` | `create-guide` if `artifacts/guide-for-users.md` is missing. Otherwise the status is `Complete`. `start-review` for a bug fix or other minor in-scope point. `resume-work` reopens this slug. `create-sibling` for major new work. |

Add one optional line when it applies: an `open` review cycle →
`apply-review`; a short `Planning` design names `start-building`, and a
deeper one names `approve-plan` or `requirements-ok`.
`Active` or `Complete` after a checked milestone →
`start-review`; `review-comments: on` at `Active` with all milestones
checked → `remove-review-comments`.
