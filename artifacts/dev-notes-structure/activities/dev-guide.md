# .dev-notes/activities -- Dev-Guide

`workon` activity folders for a synced project. Top-level siblings only
(no `activities/<child>/`).

## Notes

- Catalog: `activities.md` — `rg '^## <slug>:'`; do not bulk-read.
- Activity `journal.md` lives at `<slug>/journal.md`.

## Artifacts

| Name | Description |
|------|-------------|
| `.dev-notes/activities/` | Per-activity working context |
| `.dev-notes/activities/activities.md` | High-level catalog (heading + short para per activity); create lazily via `workon` |
| `.dev-notes/activities/<slug>/artifacts/` | Optional flat context snapshots/excerpts |
