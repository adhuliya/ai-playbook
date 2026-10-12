# AI Playbook

Shared agent rules/skills (Cursor, Codex, Claude Code) plus per-project
overlays, distributed by `scripts/sync-playbook.sh` (per-file hard links).

## How agents find the assets

| Tool | Skills | Always-on rules |
|------|--------|-----------------|
| Cursor | `.agents/skills/` (native) | `AGENTS.md` → `.agents/dev-guide.md` → `.agents/rules/` |
| Codex | `.agents/skills/` (native) | same pointer chain |
| Claude Code | via `.agents/dev-guide.md` (no native `.agents/skills` yet) | `AGENTS.md` (or `CLAUDE.md`) → same chain |

Sync appends one pointer line to the target's `AGENTS.md` (created if
missing; also `CLAUDE.md` when present without `@AGENTS.md`).

Subagents have no shared format: `.claude/agents/*.md` serves Claude Code and
Cursor; Codex needs a `.codex/agents/*.toml` copy (keep both in step; Codex
loads project agents only for trusted projects). Cursor-only extras (hooks)
stay in `.cursor/`.

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
| `--force` | Content conflict ⇒ playbook wins (re-link dest). Bidirectional paths otherwise prompt playbook vs target. |
| `--stats` | Read-only sync state (machine, `--project`, or `--machine` syncmap): per-dir counts, then one line per file with playbook + target inode (equal ⇒ hard-linked). Tags: `=` in sync, `>` playbook → target (default for everything except `.dev-notes/` and project `dev-guide.md`), `<` target → playbook, `?` both changed (sync prompts), `~` re-link, `x` prune, `o` target-only, `!` git-tracked. |

Machine id = `hostname`, optional `machines/aliases.txt`. New host gets empty
`projects.txt` / `project-modules.txt` / `syncmap.txt` / `ignoresync.txt`.

### Behavior notes

- Same inode: no-op. Same bytes, different inode: re-link. Different bytes: `.dev-notes/` and project `dev-guide.md` prompt playbook vs target; `.agents/`, `.claude/`, `.codex/`, `.cursor/` and `--machine` prompt playbook-only; `--force` ⇒ playbook.
- `.agents/`, `.claude/`, `.codex/`, `.cursor/`: playbook → target only. `.dev-notes/` + project `dev-guide.md`: bidirectional.
- Prune: target-only files in those asset dirs that the playbook once shipped (still hard-linked to a playbook asset, or content found in playbook git history at that path) are deleted, so moves/renames in the playbook propagate. User-authored files and target git-tracked files are never pruned.
- Nested git under a target (submodules): `dev-guide.md` is not synced via the parent hub unless `machines/<id>/project-modules.txt` marks the nested path as the same project (`project:/abs/nested`). Otherwise match `project:/abs/path` in `machines/<id>/projects.txt` (many paths per project) or resolve interactively. Use `--ignore-submodules` to skip nested guides entirely.
- Target git-tracked paths: warn when inode differs from playbook; already hard-linked copies are left silent.
- Ignores: `ignoresync.txt` (global), `machines/<id>/ignoresync.txt`, `artifacts/live-notes/<project>/ignoresync.txt`. Playbook-root paths, anywhere dir/basename patterns (`__pycache__/`, `.DS_Store`), and simple globs (`*.pyc`); `!` unignore. Not applied to `--machine`.
- Target `.agents/.sync-playbook-excluded`: regenerated each sync; `TGIT_TRACKED:` / `SYNC_IGNORED:` lines for playbook-managed paths skipped (target-git-tracked or ignoresync).

See `./scripts/sync-playbook.sh --help` and `.dev-notes/definition.md`.

## Layout

| Path | Role |
|------|------|
| `projects.txt` | Project keys |
| `machines/` | Per-machine paths, project-modules, syncmap, ignores, aliases |
| `ignoresync.txt` | Global sync ignores |
| `AGENTS.md` | Playbook's own pointer to `.agents/dev-guide.md` (not synced) |
| `.agents/` | Shared `dev-guide.md`, `rules/` (always-on), `skills/` |
| `.claude/agents/`, `.codex/agents/` | Shared subagents (Claude/Cursor `.md`, Codex `.toml`) |
| `.cursor/` | Shared Cursor-only extras (none yet; hooks live in overlays) |
| `artifacts/live-notes/<name>/` | Everything per project: `dev-notes/` (live `.dev-notes`), optional `ignoresync.txt`, and optional overlays `.agents/`, `.claude/`, `.codex/`, `.cursor/` (each mirrors the target dir; wins on clash; create only what the project needs) |
| `tests/smoke-test-sync-*.sh` | Smoke tests |
