# .dev-notes/activities -- Dev-Guide

`workon` activity folders and context for agent sessions. Top-level siblings
only (no `activities/<child>/`).

## Notes

- `activities.md` is a high-level catalog. Slice with `rg '^## <slug>:'`; do not bulk-read. Heading plus one high-level paragraph per activity.
- Per-activity `notes.md`: `Requirement Definition` (activity definition), `Design Decisions` (chosen + alternatives), `Conventions` (binding, living), `User Notes` (user-owned).
- Cited context files: ask with a list (whole copy vs excerpt); chosen files go in `<slug>/artifacts/` (flat root). Uncopied files still inform define/design/plan; every cited file gets a `# References` learned bullet. Ephemeral `verify-plan/` and `bg/` subdirs are not context copies. Never `git add` or commit those two subdirs.
- Activity `journal.md` (`<slug>/journal.md`): append on `pause-work` / `resume-work` / `mark-completed`. Compact with `compact-journal`.
- Milestone evidence: focused tests per outcome; last milestone has runnable e2e. `software-interface` peers that cannot run live get an in-repo test double.

## Artifacts

| Name | Description |
|------|-------------|
| `.dev-notes/activities/` | Per-activity working notes (created by `workon` skill) |
| `.dev-notes/activities/activities.md` | High-level catalog: heading + short para per activity; `rg`, do not bulk-read |
| `.dev-notes/activities/<slug>/artifacts/` | Context copies at the root; ephemeral `verify-plan/` and `bg/` |
