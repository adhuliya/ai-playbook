# AI Playbook

Shared Cursor rules/skills plus per-project overlays, distributed by
`scripts/sync-playbook.sh` (per-file hard links).

## Sync

### From a target repo

```bash
/path/to/ai-playbook/scripts/sync-playbook.sh --project <name> [--yes] [--force] [--ignore-submodules]
```

### From the playbook root

```bash
./scripts/sync-playbook.sh [--project <name>] [--yes] [--force] [--ignore-submodules]
```

Uses `machines/<id>/projects.txt` (`project:/abs/path`). No `--project` ⇒ all
paths for this machine. Missing paths: update / skip / delete (`--yes` ⇒ skip).

### Machine home-file map (separate)

```bash
./scripts/sync-playbook.sh --machine [--yes] [--force]
```

Processes `machines/<id>/syncmap.txt` only (`playbook-rel:/abs/dest`).

### Flags

| Flag | Meaning |
|------|---------|
| `--yes` | Admin defaults (register project/path; skip missing paths). Not content conflicts or nested-guide prompts. |
| `--ignore-submodules` | Skip `dev-guide.md` under nested `.git` (no prompts). |
| `--force` | Content conflict ⇒ playbook wins (re-link dest). |

Machine id = `hostname`, optional `machines/aliases.txt`. New host gets empty
`projects.txt` / `project-modules.txt` / `syncmap.txt` / `ignoresync.txt`.

### Behavior notes

- Same inode: no-op. Same bytes, different inode: re-link. Different bytes: prompt or `--force`.
- `.cursor/`: playbook → target only. `.dev-notes/` + project `dev-guide.md`: bidirectional.
- Nested git under a target (submodules): `dev-guide.md` is not synced via the parent hub unless `machines/<id>/project-modules.txt` marks the nested path as the same project (`project:/abs/nested`). Otherwise match `project:/abs/path` in `machines/<id>/projects.txt` (many paths per project) or resolve interactively. Use `--ignore-submodules` to skip nested guides entirely.
- Target git-tracked paths: warn when inode differs from playbook; already hard-linked copies are left silent.
- Ignores: `ignoresync.txt` (global), `machines/<id>/ignoresync.txt`, `artifacts/live-notes/<project>/ignoresync.txt`. Full playbook-root paths; `!` unignore. Not applied to `--machine`.

See `./scripts/sync-playbook.sh --help` and `.dev-notes/definition.md`.

## Layout

| Path | Role |
|------|------|
| `projects.txt` | Project keys |
| `machines/` | Per-machine paths, project-modules, syncmap, ignores, aliases |
| `ignoresync.txt` | Global sync ignores |
| `.cursor/` | Shared rules/skills |
| `<name>.cursor/` | Per-project overlay |
| `artifacts/live-notes/<name>/` | Live `.dev-notes` + optional `ignoresync.txt` |
| `tests/smoke-test-sync-*.sh` | Smoke tests |
