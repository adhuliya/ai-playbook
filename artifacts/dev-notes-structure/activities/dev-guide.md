# .dev-notes/activities -- Dev-Guide

`workon` activity folders for a synced project. Top-level siblings only
(no `activities/<child>/`).

## Notes

- Catalog: `activities.md` — `rg '^## <slug>:'`; do not bulk-read.
- Activity `journal.md` lives at `<slug>/journal.md`.
- Per-activity notes: `requirements.md`, `design-choices.md`, `conventions.md` (rules + Setup), `user-notes.md`. Legacy `notes.md` splits on first `workon` touch.
- Milestone evidence includes focused tests per outcome and e2e on the last milestone.
- Reserved artifacts `verify-plan/` (`critic-negative.md`, `critic-positive.md`, `synthesis.md`; optional slices), `bg/`, `self-review/`, `self-review.md` are committable; default-delete at `mark-completed` after confirm.

## Artifacts

| Name | Description |
|------|-------------|
| `.dev-notes/activities/` | Per-activity working context |
| `.dev-notes/activities/activities.md` | High-level catalog (heading + short para per activity); create lazily via `workon` |
| `.dev-notes/activities/<slug>/artifacts/` | Context copies at the root; reserved `verify-plan/`, `bg/`, `self-review/`, `self-review.md` |
