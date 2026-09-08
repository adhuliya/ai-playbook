# .dev-notes/activities -- Dev-Guide

`workon` activity folders and context for agent sessions.

## Notes

- `activities.md` is a high-level catalog. Slice with `rg '^## <slug>:'`; do not bulk-read. One-liner per activity.
- Per-activity `notes.md`: `Requirement Definition` (activity definition), `Design Decisions` (chosen + alternatives), `User Notes` (user-owned).
- Cited context files: ask with a list (whole copy vs excerpt); chosen files go in `<slug>/artifacts/` (flat). Uncopied files still inform define/design/plan; every cited file gets a `# References` learned bullet.

## Artifacts

| Name | Description |
|------|-------------|
| `.dev-notes/activities/` | Per-activity working notes (created by `workon` skill) |
| `.dev-notes/activities/activities.md` | High-level catalog: heading + short para per activity; `rg`, do not bulk-read |
| `.dev-notes/activities/<slug>/artifacts/` | Optional flat snapshots/excerpts of user-cited context files |
