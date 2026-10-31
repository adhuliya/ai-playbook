# Command map

Printed by `help all`. Keep one row per command; `help.md` names this file.

| Group | Command | What it does |
|---|---|---|
| Start and plan | natural language | Create, list, switch, or show details of an activity |
| | `requirements-ok` | `stage: requirements` → `design` (requirements-first planning) |
| | `replan-work` | Reopen in-flight scope → `Planning` |
| | `create-sibling` | New `Planning` activity derived from this one |
| | `make-full` | If typed: thin → full, same slug, back to `Planning`. The agent also runs that upgrade without asking, unless the user typed `thin`. |
| | `import-activity` | Adopt activity files from elsewhere → `Planning` (`Complete` kept) |
| Gates and lifecycle | `approve-plan` | Full only: `Planning` → `Approved`. Thin: follow **Choose**. A typed `thin`, or a `kind` that stays `thin`, names `start-building`. When **Choose** sets `full`, follow `commands/make-full.md` without asking, and name `approve-plan` or `requirements-ok`. |
| | `conventions-ok` | Sign off rules + Setup (one-time) |
| | `start-building` | Thin design: `Planning` → `Active`. Full: `Approved` → `Active`; needs `conventions: ok`. Refuses `stage: requirements` and full `Planning`. |
| | `continue` | Active engineering turn (`commands/build.md`). Not a reserved keyword |
| | `pause-work` | → `Paused` + journal recap. Allowed while a pipeline is in flight; next keyword is `resume-work` |
| | `resume-work` | Unpause, unblock, reopen `Complete`, or reload context |
| | `mark-completed` | → `Complete` + journal + cleanup |
| Review | `start-review` | Open or refresh a cycle for the user's points. No critics |
| | `agent-review` | Optional, and never offered. It states a recommended review and asks a short multi-select before critics launch, so the user can drop a slice or replace the set. Findings are `(agent-review)` |
| | `apply-review` | Apply and close one open cycle (fix cycle first) |
| Comments | `add-review-comments` | Raise comments in the activity diff to review level; `review-comments: on` |
| | `remove-review-comments` | Trim comments in the activity diff to default level; `review-comments: off` |
| Notes upkeep | `update-convention` | Add or rewrite convention rules |
| | `fix-activity [<what to fix> \| tidy]` | Fix what the user names, or resync after drift. First it states the recommended fix and asks a short multi-select the user can trim or replace. Then cheap triage, and it asks again before each pipeline. Prune, rewrite, and renumber only on `tidy` |
| | `compact-journal` | Shorten the journal in place |
| | `add-ac` | Draft and append `AC<n>` acceptance criteria for RDs that lack it |
| Output and cleanup | `create-guide` | Write `artifacts/guide-for-users.md` for humans |
| | `detailed-design` | Write a diagram-rich `artifacts/detailed-design.md` from `spec-design.md` |
| | `delete-tmp-files` | List activity temporaries; delete on confirm |
| Session | `user-away` | Say you are leaving; the agent takes permissions early and works to a stopping point |
| | `help` / `help intro` / `help files` / `help all` / `help <command>` | Next steps / the basic path / the activity folder and its files / this map / explain one command |
| | `query-work` / `no-query-work` | Read-only session on / off |
| | `teach-off` / `teach-brief` / `teach-deep` | How much the agent teaches the task's design and code; default `teach-off` |
| | `grill me` / `grill-me` | Interview open decision branches, one question at a time |
| | `auto-continue` / `ask-continue` | After a milestone, start the next one, or wait for `continue` |
