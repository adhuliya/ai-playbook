# Marshal playbook sync gaps

| Key | Value |
|---|---|
| status | Complete |
| slug | marshal |
| branch | feature/marshal |
| ticket | none |
| notes | |

# Goal

Close operational gaps in `scripts/sync-playbook.sh`: hard-link repair, playbook-side multi-project sync with a per-machine path registry, layered `ignoresync.txt`, explicit `--machine` syncmap, smoke harnesses, and matching docs.

# Scope

Hardened the existing sync tool (shared Cursor assets → targets via hard links; bash + git only): inode repair after broken links; run from playbook root against per-machine project paths; hierarchical ignores; separate `--machine` syncmap; `--yes` vs `--force`; automated smokes under `tests/`; definition/README/dev-guide updates.

Out of scope (unchanged): new asset types, CI/package managers, per-machine-project ignore files, default syncmap during project sync, auto-fixing target git-tracked collisions.

# Background and Special Notes

- Targets are not expected to commit hard-linked playbook files; content conflicts after inode break usually come from playbook git ops.
- Smoke harnesses isolate machines via `SYNC_PLAYBOOK_HOSTNAME`.
- Host scaffold: `machines/Anshumans-MacBook-Pro.local/` (empty paths/syncmap until filled by operator).
- Accepted gap: root `ignoresync.txt` has no entries yet (add when needed).
- Future bugs or scheme changes: reopen via `resume-work` → Planning (do not jump Complete → Active). Use `replan-work` / derive if scope is material.

# Current Design

Shipped behavior in `scripts/sync-playbook.sh`:

| Mode | Behavior |
|---|---|
| Playbook cwd | Sync all (or `--project`) paths from `machines/<id>/projects.txt`. No syncmap. |
| Target cwd | Sync that repo only (`--project` required); may register `project:pwd`. No syncmap. |
| `--machine` | Syncmap-only; incompatible with `--project`. |

- Machine id = `hostname` (+ `machines/aliases.txt`); new host gets empty `projects.txt` / `syncmap.txt` / `ignoresync.txt`.
- Hard links: same inode no-op; same bytes re-link; content conflict prompts (playbook wins) or `--force`.
- `.cursor/`: playbook → target only. `.dev-notes/` + project guides: bidirectional. Syncmap: one-way.
- Target git-tracked paths: warn, never touch.
- Ignores: global + machine + `artifacts/live-notes/<project>/ignoresync.txt`; full playbook-root paths; `!` unignore; not applied to syncmap.
- Must-not-break: hard-link semantics on same filesystem; playbook cwd detection via same inode as `scripts/sync-playbook.sh`.

Touched paths: `scripts/sync-playbook.sh`, `ignoresync.txt`, `machines/`, `tests/smoke-test-sync-*.sh`, `.dev-notes/definition.md`, `README.md`, `dev-guide.md`.

# Current Plan

Complete. No further planned implementation in this activity.

# Milestones

1. [x] Machine registry + dual entry + `--machine` syncmap
   - evidence: `./scripts/sync-playbook.sh --help`; `./tests/smoke-test-sync-marshal.sh`

2. [x] Hard-link repair, conflicts, ignores, git-tracked warn
   - evidence: `./tests/smoke-test-sync-marshal.sh`

3. [x] Domain directionality + docs
   - evidence: marshal smoke + `.dev-notes/definition.md` / `README.md` / `dev-guide.md`

4. [x] Marshal smoke harness green
   - evidence: `./tests/smoke-test-sync-marshal.sh`; `./tests/smoke-test-sync-guides.sh`

# Next Steps

Minor-fix / operator runway (not open milestones):

1. Fill `machines/$(hostname)/projects.txt` (`span:/abs/...`, etc.) and sync from playbook root.
2. Add `syncmap.txt` lines (e.g. `scripts/agent.zshrc:…`) → `./scripts/sync-playbook.sh --machine`.
3. Fastest validation: `./tests/smoke-test-sync-marshal.sh` and `./tests/smoke-test-sync-guides.sh`.
4. Safest first edit targets on bugfix: `scripts/sync-playbook.sh`, then matching smoke under `tests/`.
5. Resume from Complete: `resume-work` on `marshal`; describe the fix/improvement; expect reopen to Planning then Execution gate (`approve-plan` → `start-building`). Material scheme changes → `replan-work` or derive.

# References

- `.dev-notes/definition.md`
- `scripts/sync-playbook.sh`
- `projects.txt`
- `machines/`
- `ignoresync.txt`
- `tests/smoke-test-sync-marshal.sh`
- `tests/smoke-test-sync-guides.sh`
- `scripts/agent.zshrc`
