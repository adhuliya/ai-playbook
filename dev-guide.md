# repository root -- Dev-Guide

Shared agent rules/skills (Cursor, Codex, Claude Code), per-project overlays, and sync into target repos.

## Notes

- For work under a path, open the deepest `dev-guide.md` on the ancestor chain.
- Vision, scope, terms: `.dev-notes/definition.md` (not duplicated here).
- Sync from a **target** root:
  `/path/to/ai-playbook/scripts/sync-playbook.sh --project <name> [--yes] [--force] [--ignore-submodules]`
- Sync from the **playbook** root (all or one project for this machine):
  `./scripts/sync-playbook.sh [--project <name>] [--yes] [--force] [--ignore-submodules]`
- Machine syncmap only: `./scripts/sync-playbook.sh --machine [--yes] [--force]`
- Read-only state with inodes: add `--stats` to any of the above (no writes, no prompts).
- Smoke: `./tests/smoke-test-sync-guides.sh`, `./tests/smoke-test-sync-submodule-guides.sh`, and `./tests/smoke-test-sync-marshal.sh`
- Create/maintain guides with the `dev-guides` skill (target repo only).
- New/changed skills, rules, subagents must work in Claude Code, Codex, and Cursor (`.dev-notes/definition.md` Principles). Checklist: skills = `SKILL.md` with only `name` + `description` frontmatter (other fields optional and ignorable); rules = plain markdown, no `.mdc` frontmatter; refer to paths as `.agents/...`, not `.cursor/...`; don't name one tool's built-in tools or subagent API — use the harness-neutral terms in `.agents/rules/dev-main.md` (add a row there if a new concept is needed); subagents need both `.claude/agents/*.md` and `.codex/agents/*.toml`.
- Portable assets go in `.agents/` (rules = plain markdown, always-on; skills = `SKILL.md`). Subagents: `.claude/agents/*.md` (Claude + Cursor) plus a `.codex/agents/*.toml` copy — edit both together. Cursor-only extras (hooks) go in `.cursor/`. Moving a file between asset dirs is safe: sync prunes the stale target copy.
- Domain vocabulary: `.dev-notes/vocabulary.md` (`build-vocabulary` skill).

## Artifacts

| Name | Description |
|------|-------------|
| `README.md` | Sync usage and layout entrypoint |
| `AGENTS.md` | Pointer to `.agents/dev-guide.md` (same line sync appends in targets) |
| `.agents/` | Shared rules, skills, and their index — `.agents/dev-guide.md` |
| `.claude/agents/`, `.codex/agents/` | Shared subagents (same agent in `.md` and `.toml` form) |
| `.dev-notes/seed-prompt.md` | Recreate playbook from scratch (`seed-prompt` skill) |
| `projects.txt` | Registered target project keys (sync creates it; personal, kept on your own branch) |
| `machines/` | Per-machine `projects.txt`, `project-modules.txt`, `syncmap.txt`, `ignoresync.txt`, `aliases.txt` |
| `ignoresync.txt` | Global sync ignores (paths, `__pycache__/`, `*.pyc`, …) |
| `scripts/sync-playbook.sh` | Hard-link sync into targets + `--machine` syncmap |
| `tests/smoke-test-sync-guides.sh` | Smoke test for in-tree guide sync |
| `tests/smoke-test-sync-submodule-guides.sh` | Smoke test for nested-git dev-guide sync |
| `tests/smoke-test-sync-marshal.sh` | Smoke test for marshal sync behaviors |
| `artifacts/live-notes/` | Per project `<name>/`: `dev-notes/` (+ hub `dev-guides/`), `ignoresync.txt`, optional overlays `.agents/` `.claude/` `.codex/` `.cursor/` (win on clash) |
| `artifacts/dev-notes-structure/` | Scaffold for new live-notes trees |
