# .dev-notes/activities -- Dev-Guide

`workon` activity folders and context for agent sessions. Top-level siblings
only (no `activities/<child>/`).

## Notes

- `activities.md` is a high-level catalog. Slice with `rg '^## <slug>:'`; do not bulk-read. Heading plus one high-level paragraph per activity.
- Per-activity notes (not `notes.md`): `requirements.md` (RD entries), `design-choices.md` (append-only decisions), `conventions.md` (binding rules + Setup/build/test/install; ≤~500 words; `conventions-ok` gates `start-building`), `notes-by-user.md` (user-owned). Lazy `reviews.md` (`RU<n>.<m>` Review Update cycles; one kind for user and self reviews; points may change a requirement, design decision, convention, or the implementation). Optional `user-guide.md` (human guide; `create-guide` only). Entries use stable IDs (`RD<n>`, `DC<nn>`, `CONV<n>`, `REF<n>`). Next step: `help`; basics: `help intro`; command list: `help all`. Legacy `notes.md` / `user-notes.md` are repaired on first `workon` touch.
- Cited context files: ask with a list (whole copy vs excerpt); chosen files go in `<slug>/artifacts/` (flat root). Uncopied files still inform define/design/plan; every cited file gets a `# References` learned bullet. Reserved `verify-plan/`, `bg/`, `self-review/`, and `self-review.md` are review/env records (committable; deleted via `delete-tmp-files` (also run by `mark-completed`) after confirm). Not context copies.
- Activity `journal.md` (`<slug>/journal.md`): append-only event timeline (created, approved, building, milestone checked, review recorded, replan, blocked, pause, resume, complete, renumber). Short entries that point at IDs. Compact with `compact-journal`.
- Milestone evidence: unit tests per part, integration tests per boundary, runnable e2e on the last milestone; extend existing tests when goals match. `software-interface` peers that cannot run live get an in-repo test double.
- `self-review` writes `artifacts/self-review.md` only (plus working files under `self-review/`). `apply-review` applies remaining proposals to activity files.
- `verify-plan` writes `artifacts/verify-plan/` (`critic-negative.md`, `critic-positive.md`, `synthesis.md`; optional slice subdirs). Parent reads synthesis only.

## Artifacts

| Name | Description |
|------|-------------|
| `.dev-notes/activities/` | Per-activity working notes (created by `workon` skill) |
| `.dev-notes/activities/activities.md` | High-level catalog: heading + short para per activity; `rg`, do not bulk-read |
| `.dev-notes/activities/<slug>/artifacts/` | Context copies at the root; reserved `verify-plan/`, `bg/`, `self-review/`, `self-review.md` |
