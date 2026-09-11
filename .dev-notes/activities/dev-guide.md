# .dev-notes/activities -- Dev-Guide

`workon` activity folders and context for agent sessions. Top-level siblings
only (no `activities/<child>/`).

## Notes

- `activities.md` is a high-level catalog. Slice with `rg '^## <slug>:'`; do not bulk-read. Heading plus one high-level paragraph per activity.
- Per-activity notes (not `notes.md`): `requirements.md` (ARD), `design-choices.md` (append-only decisions), `conventions.md` (binding rules + Setup/build/test/install; ≤~500 words), `user-notes.md` (user-owned). Legacy `notes.md` splits on first `workon` touch.
- Cited context files: ask with a list (whole copy vs excerpt); chosen files go in `<slug>/artifacts/` (flat root). Uncopied files still inform define/design/plan; every cited file gets a `# References` learned bullet. Reserved `verify-plan/`, `bg/`, `self-review/`, and `self-review.md` are review/env records (committable; default-delete at `mark-completed` after confirm). Not context copies.
- Activity `journal.md` (`<slug>/journal.md`): append on `pause-work` / `resume-work` / `mark-completed`, and on `apply-review` when that command resumes. Compact with `compact-journal`.
- Milestone evidence: focused tests per outcome; last milestone has runnable e2e. `software-interface` peers that cannot run live get an in-repo test double.
- `self-review` writes `artifacts/self-review.md` only (plus working files under `self-review/`). `apply-review` applies remaining proposals to activity files.
- `verify-plan` writes `artifacts/verify-plan/` (`critic-negative.md`, `critic-positive.md`, `synthesis.md`; optional slice subdirs). Parent reads synthesis only.

## Artifacts

| Name | Description |
|------|-------------|
| `.dev-notes/activities/` | Per-activity working notes (created by `workon` skill) |
| `.dev-notes/activities/activities.md` | High-level catalog: heading + short para per activity; `rg`, do not bulk-read |
| `.dev-notes/activities/<slug>/artifacts/` | Context copies at the root; reserved `verify-plan/`, `bg/`, `self-review/`, `self-review.md` |
