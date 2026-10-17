# `help`

Status: any; read-only; no focused activity needed.

- `help`: tell the user what to do next in the current state; cap ~5 lines:
  one state line (slug, status, `stage` when `Planning`, `conventions`), then 1–3 next actions from
  the state table. Check rows top-down; the first match wins. End with one
  line: `help intro` for basics, `help all` for every command.
- `help intro`: teach the basic path in ≤ 8 lines, naming only these steps:
  1. Describe the work in plain words (e.g. `workon add CSV export`).
     Answer the questions, then review the drafted files.
  2. `approve-plan`: accept the plan. Answer `yes` to accept the rules too.
  3. `start-building`: the agent builds and tests.
  4. `mark-completed`: close the work when the tests pass.

  Add: type `help` at any time for the next step. Teach no other commands.
- `help all`: print the command map below. If an activity is focused, mark
  the commands its status allows (`Status:` lines in the command
  files). Rows with `Status: any`, `n/a`, or no heading (natural
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
| `Planning`, `stage: requirements` | Answer open questions; review RD and the Problem header. Then `requirements-ok` to start the design half. |
| `Planning` | Answer open questions; review the files (start with `plan-outline.md`) and give feedback. Then `approve-plan` (it offers to accept the conventions if `pending`). |
| `Approved` | `conventions-ok` if `pending`; then `start-building`. |
| `Active` | Give feedback or say continue. `start-review` after a milestone. `mark-completed` when all milestones and the e2e pass and no review cycle is open. `pause-work` to stop. |
| `Paused` | `resume-work`. |
| `Blocked` | Resolve the blocker in `notes` (quote it); then `resume-work`. |
| `Complete` | `resume-work` to fix or extend; `create-guide` if `guide-for-users.md` is missing. |

Add one optional line when it applies: an `open` review cycle →
`apply-review`; `review-comments: on` at `Active` with all milestones
checked → `remove-review-comments`; `Planning` with no `verify-plan` this
session → `verify-plan`.

**Command map**

| Group | Command | What it does |
|---|---|---|
| Start and plan | natural language | Create, list, switch, or show details of an activity |
| | `requirements-ok` | `stage: requirements` → `design` (requirements-first planning) |
| | `replan-work` | Reopen in-flight scope → `Planning` |
| | `create-sibling` | New `Planning` activity derived from this one |
| | `import-activity` | Adopt activity files from elsewhere → `Planning` (`Complete` kept) |
| Gates and lifecycle | `approve-plan` | `Planning` → `Approved` |
| | `conventions-ok` | Sign off rules + Setup (one-time) |
| | `start-building` | `Approved` → `Active`; needs `conventions: ok` |
| | `pause-work` | → `Paused` + journal recap |
| | `resume-work` | Unpause, unblock, reopen `Complete`, or reload context |
| | `mark-completed` | → `Complete` + journal + cleanup |
| Review | `start-review` | Open or refresh a review cycle; automated by default, `manual` on request |
| | `apply-review` | Apply and close one open cycle (fix cycle first) |
| | `verify-plan` | Critics + synthesis of the plan; apply on confirm |
| Comments | `add-review-comments` | Raise comments in the activity diff to review level; `review-comments: on` |
| | `remove-review-comments` | Trim comments in the activity diff to default level; `review-comments: off` |
| Notes upkeep | `update-convention` | Add or rewrite convention rules |
| | `fix-activity [<what to fix> \| tidy]` | Fix what the user names, or resync after drift; asks what changed, then cheap triage; asks before each pipeline; prune, rewrite, renumber only on `tidy` |
| | `compact-journal` | Shorten the journal in place |
| Output and cleanup | `create-guide` | Write `guide-for-users.md` for humans |
| | `delete-tmp-files` | List activity temporaries; delete on confirm |
| Session | `user-away` | Say you are leaving; the agent takes permissions early and works to a stopping point |
| | `help` / `help intro` / `help all` / `help <command>` | Next steps / the four-step basic path / this map / explain one command |
| | `query-work` / `no-query-work` | Read-only session on / off |
