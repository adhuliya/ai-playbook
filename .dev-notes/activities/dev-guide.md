# .dev-notes/activities -- Dev-Guide

`workon` activity folders and context for agent sessions. Top-level siblings
only (no `activities/<child>/`).

## Notes

- `activities.md` is a high-level catalog. Slice with `rg '^## <slug>:'`; do not bulk-read. Heading plus one high-level paragraph per activity.
- Per-activity notes (not `notes.md`): `requirement-def.md` (Problem header + RD entries), `design-choices.md` (append-only decisions), `conventions.md` (binding rules + Setup/build/test/install; ≤~500 words; `conventions-ok` gates `start-building`), `notes-by-user.md` (user-owned). Lazy `reviews.md` (`RU<n>.<m>` Review Update cycles; one kind for automated, manual, and mixed reviews; at most one `open` regular cycle plus one `open` fix cycle from `fix-activity` on major drift, applied first; the user may edit open cycles; points may change a requirement, design decision, convention, or the implementation). `plan-outline.md` (derived plan overview), `references.md` (all `REF<n>`), and optional `guide-for-users.md` (human guide; `create-guide` only). Milestones are `M1`, `M2`, … Entries use stable IDs (`RD<n>`, `DC<nn>`, `CONV<n>`, `REF<n>`). Next step: `help`; basics: `help intro`; command list: `help all`. Legacy `notes.md` / `user-notes.md` are repaired on first `workon` touch.
- Cited context files: ask with a list (whole copy vs excerpt); chosen files go in `<slug>/artifacts/` (flat root). Uncopied files still inform define/design/plan; every cited file gets a `# References` learned bullet. Reserved `verify-plan/`, `bg/`, `review/`, `comments/`, and `fix/` are pipeline records; `artifacts/inflight.md` is agent-only scratch marking a running pipeline (user progress lives in `activity.md`) (committable; deleted via `delete-tmp-files` (also run by `mark-completed`) after confirm). Not context copies.
- Activity `journal.md` (`<slug>/journal.md`): append-only event timeline (created, approved, building, milestone checked, review recorded, replan, blocked, pause, resume, complete, renumber). Short entries that point at IDs. Compact with `compact-journal`.
- Milestone evidence: unit tests per part, integration tests per boundary, runnable e2e on the last milestone; extend existing tests when goals match. `software-interface` peers that cannot run live get an in-repo test double.
- `start-review` opens or refreshes the open `RU<n>` cycle in `reviews.md` (automated by default via `artifacts/review/`; `manual` skips sub-agents). `apply-review` applies and closes it.
- `add-review-comments` / `remove-review-comments` change only comments in the activity diff (vs `base-branch`) via sub-agents; snapshot and verifier under `artifacts/comments/`. `activity.md` row `review-comments` tracks the level.
- `verify-plan` writes `artifacts/verify-plan/` (`critic-negative.md`, `critic-positive.md`, `synthesis.md`; optional slice subdirs). Parent reads synthesis only.

## Artifacts

| Name | Description |
|------|-------------|
| `.dev-notes/activities/` | Per-activity working notes (created by `workon` skill) |
| `.dev-notes/activities/activities.md` | High-level catalog: heading + short para per activity; `rg`, do not bulk-read |
| `.dev-notes/activities/<slug>/artifacts/` | Context copies at the root; reserved `verify-plan/`, `bg/`, `review/`, `comments/`, `fix/` |
