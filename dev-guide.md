# repository root -- Dev-Guide

Shared Cursor rules/skills, per-project overlays, and sync into target repos.

## Notes

- For work under a path, open the deepest `dev-guide.md` on the ancestor chain.
- Vision, scope, terms: `.dev-notes/definition.md` (not duplicated here).
- Sync from a **target** root:
  `/path/to/ai-playbook/scripts/sync-playbook.sh --project <name> [--yes] [--force] [--ignore-submodules]`
- Sync from the **playbook** root (all or one project for this machine):
  `./scripts/sync-playbook.sh [--project <name>] [--yes] [--force] [--ignore-submodules]`
- Machine syncmap only: `./scripts/sync-playbook.sh --machine [--yes] [--force]`
- Smoke: `./tests/smoke-test-sync-guides.sh`, `./tests/smoke-test-sync-submodule-guides.sh`, and `./tests/smoke-test-sync-marshal.sh`
- Create/maintain guides with the `dev-guides` skill (target repo only).
- Domain vocabulary: `.dev-notes/vocabulary.md` (`build-vocabulary` skill).

## Artifacts

| Name | Description |
|------|-------------|
| `README.md` | Sync usage and layout entrypoint |
| `.dev-notes/seed-prompt.md` | Recreate playbook from scratch (`seed-prompt` skill) |
| `projects.txt` | Registered target project keys |
| `machines/` | Per-machine `projects.txt`, `project-modules.txt`, `syncmap.txt`, `ignoresync.txt`, `aliases.txt` |
| `ignoresync.txt` | Global sync ignore paths |
| `scripts/sync-playbook.sh` | Hard-link sync into targets + `--machine` syncmap |
| `tests/smoke-test-sync-guides.sh` | Smoke test for in-tree guide sync |
| `tests/smoke-test-sync-submodule-guides.sh` | Smoke test for nested-git dev-guide sync |
| `tests/smoke-test-sync-marshal.sh` | Smoke test for marshal sync behaviors |
| `.cursor/rules/` | Agent rules: `dev-main` (always); `dev-git`, `iloop` (on invoke) |
| `.cursor/skills/` | Shared skills (`build-vocabulary`, `curate-knowledge`, `dev-guides`, `journal`, `knowledge`, `seed-prompt`, …) |
| `artifacts/live-notes/` | Per-project `.dev-notes` + hub `dev-guides/` store |
| `artifacts/dev-notes-structure/` | Scaffold for new live-notes trees |
| `<name>.cursor/` | Per-project `.cursor` overlay (wins on clash) |
| `.cursor/skills/build-vocabulary` | `.dev-notes/vocabulary.md` glossary workflow |
| `.cursor/skills/dev-guides` | Guide format and maintenance workflow |
