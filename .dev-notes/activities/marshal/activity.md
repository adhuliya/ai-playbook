# Marshal playbook sync gaps

| Key | Value |
|---|---|
| status | Complete |
| slug | marshal |
| branch | feature/marshal |
| ticket | none |
| notes | |

# Goal

Harden `scripts/sync-playbook.sh` for playbook/target sync, machine registry, ignores, syncmap, and nested-git `dev-guide.md` handling.

# Scope

Shipped: hard-link repair; per-machine `projects.txt` / `syncmap.txt` / `ignoresync.txt`; `--machine` syncmap; layered ignores; nested submodule guide policy (`--ignore-submodules`, `project-modules.txt`, path inference); smokes and docs.

# Background and Special Notes

- Smoke harnesses use `SYNC_PLAYBOOK_HOSTNAME` for isolated machine dirs.
- Submodule guide prompts are not satisfied by `--yes`.
- Reopen via `resume-work` → Planning for fixes or extensions (`replan-work` if material).

# Current Design

### Core sync (`scripts/sync-playbook.sh`)

| Mode | Behavior |
|---|---|
| Playbook cwd | Sync paths from `machines/<id>/projects.txt` (optional `--project`). |
| Target cwd | Sync current repo (`--project` required). |
| `--machine` | `syncmap.txt` only. |

- Hard links; `--force` for content conflicts; git-tracked target paths skipped (warn only when not already hard-linked to playbook).
- `.cursor/` one-way; `.dev-notes/` + guides bidirectional (except nested policy below).
- New machine scaffold: `projects.txt`, `project-modules.txt`, `syncmap.txt`, `ignoresync.txt`.

### Nested `dev-guide.md`

| Piece | Behavior |
|---|---|
| `--ignore-submodules` | Skip nested guide paths (no prompts). |
| `machines/<id>/projects.txt` | Abs path match on nested root ⇒ that project’s hub (queued nested pass). |
| `machines/<id>/project-modules.txt` | `project:/abs/nested` ⇒ same-project hub paths under parent sync root. |
| Unmapped | Interactive skip / same project (`m`) / separate project (`p`). |

Must-not-break: playbook cwd detection via script inode; hard-link semantics on same filesystem.

Touched: `scripts/sync-playbook.sh`, `tests/smoke-test-sync-*.sh`, `README.md`, `dev-guide.md`, `.dev-notes/definition.md`.

# Current Plan

None (scope complete).

# Milestones

1. [x] Machine registry + syncmap + marshal smoke
   - evidence: `./tests/smoke-test-sync-marshal.sh`

2. [x] Nested guides + `project-modules.txt` + `--ignore-submodules`
   - evidence: `./tests/smoke-test-sync-submodule-guides.sh`

3. [x] Guides smoke still green
   - evidence: `./tests/smoke-test-sync-guides.sh`

4. [x] Docs aligned
   - evidence: `README.md`, `dev-guide.md`, `.dev-notes/definition.md`

# Next Steps

1. Fill `machines/$(hostname)/projects.txt` and `project-modules.txt` for real nested checkouts.
2. Validate: `./tests/smoke-test-sync-submodule-guides.sh` (and other sync smokes).
3. Bugfixes: `scripts/sync-playbook.sh` first, then matching smoke under `tests/`.

# References

- `scripts/sync-playbook.sh`
- `machines/`, `projects.txt`, `ignoresync.txt`
- `tests/smoke-test-sync-marshal.sh`, `tests/smoke-test-sync-guides.sh`, `tests/smoke-test-sync-submodule-guides.sh`
- `.dev-notes/definition.md`
