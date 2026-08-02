# repository root -- Dev-Guide

Shared Cursor rules/skills, per-project overlays, and sync into target repos.

## Notes

- For work under a path, open the deepest `dev-guide.md` on the ancestor chain.
- Vision, scope, terms: `.dev-notes/definition.md` (not duplicated here).
- No build. Run sync from a **target repo root**:
  `/path/to/ai-playbook/scripts/sync-playbook.sh --project <name> [--yes]`
- Guide sync smoke test: `./scripts/smoke-test-sync-guides.sh`
- Create/maintain guides with the `dev-guides` skill (target repo only).

## Artifacts

| Name | Description |
|------|-------------|
| `README.md` | Sync usage and layout entrypoint |
| `.dev-notes/seed-prompt.md` | Recreate playbook from scratch (`seed-prompt` skill) |
| `projects.txt` | Registered target project keys |
| `scripts/sync-playbook.sh` | Hard-link sync into targets |
| `scripts/smoke-test-sync-guides.sh` | Smoke test for in-tree guide sync |
| `.cursor/rules/` | Always-applied rules (`dev-main`, `dev-git`) |
| `.cursor/skills/` | Shared skills (`dev-guides`, `journal`, `seed-prompt`, …) |
| `artifacts/live-notes/` | Per-project `.dev-notes` + hub `dev-guides/` store |
| `artifacts/dev-notes-structure/` | Scaffold for new live-notes trees |
| `<name>.cursor/` | Per-project `.cursor` overlay (wins on clash) |
| `.cursor/skills/dev-guides` | Guide format and maintenance workflow |
