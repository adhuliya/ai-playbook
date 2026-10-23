# Command map

Printed by `help all`. Keep one row per command; `help.md` names this file.

| Group | Command | What it does |
|---|---|---|
| Start and plan | natural language | Create, list, switch, or show details of an activity |
| | `requirements-ok` | `stage: requirements` → `design` (requirements-first planning) |
| | `replan-work` | Reopen in-flight scope → `Planning` |
| | `create-sibling` | New `Planning` activity derived from this one |
| | `make-full` | Thin → full, same slug, back to `Planning` |
| | `import-activity` | Adopt activity files from elsewhere → `Planning` (`Complete` kept) |
| Gates and lifecycle | `approve-plan` | Full only: `Planning` → `Approved`. Thin: prompt `make-full` or `start-building` |
| | `conventions-ok` | Sign off rules + Setup (one-time) |
| | `start-building` | Thin: `Planning` → `Active`. Full: `Approved` → `Active`; needs `conventions: ok`. Refuses `stage: requirements`. |
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
| | `add-ac` | Draft and append `AC<n>` acceptance criteria for RDs that lack it |
| Output and cleanup | `create-guide` | Write `artifacts/guide-for-users.md` for humans |
| | `detailed-design` | Write a diagram-rich `artifacts/detailed-design.md` from `spec-design.md` |
| | `delete-tmp-files` | List activity temporaries; delete on confirm |
| Session | `user-away` | Say you are leaving; the agent takes permissions early and works to a stopping point |
| | `help` / `help intro` / `help all` / `help <command>` | Next steps / the four-step basic path / this map / explain one command |
| | `query-work` / `no-query-work` | Read-only session on / off |
| | `teach-off` / `teach-brief` / `teach-deep` | How much the agent teaches the task's design and code; default `teach-off` |
