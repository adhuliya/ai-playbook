# .dev-notes/activities -- Dev-Guide

`workon` activity folders for a synced project. Top-level siblings only
(no `activities/<child>/`).

## Notes

- Catalog: `activities.md` — `rg '^## <slug>:'`; do not bulk-read.
- Activity `journal.md` lives at `<slug>/journal.md`.
- Per-activity `notes.md` headings: Requirement Definition, Design Decisions, Conventions, User Notes.
- Milestone evidence includes focused tests per outcome and e2e on the last milestone.
- Never `git add` or commit `<slug>/artifacts/verify-plan/` or `<slug>/artifacts/bg/`.

## Artifacts

| Name | Description |
|------|-------------|
| `.dev-notes/activities/` | Per-activity working context |
| `.dev-notes/activities/activities.md` | High-level catalog (heading + short para per activity); create lazily via `workon` |
| `.dev-notes/activities/<slug>/artifacts/` | Context copies at the root; ephemeral `verify-plan/` and `bg/` |
