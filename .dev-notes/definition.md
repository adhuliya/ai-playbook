# ai-playbook — definition

Vision, scope, and key terms. Repository structure lives in
`dev-guide.md` at the repository root; cold-start rebuild instructions in
`.dev-notes/seed-prompt.md`.

## Vision

A single **source repo** for shared agent assets — rules and skills usable by
Cursor, Codex, and Claude Code — plus optional per-project overlays,
distributed into target repos by one bash script.
Author agent behavior once here; every target repo consumes the same content
without copy-paste drift.

## Scope

In scope:

- Shared always-on **rules** (`.agents/rules/*.md`) and **skills**
  (`.agents/skills/<name>/`), indexed by `.agents/dev-guide.md`; targets reach
  it via a pointer line in `AGENTS.md` (and `CLAUDE.md` when present).
- Subagents in tool-native form: `.claude/agents/*.md` (Claude Code, Cursor)
  and `.codex/agents/*.toml` (Codex). Cursor-only extras in `.cursor/` (hooks).
- Per-project **overlays** (`artifacts/live-notes/<project>/.agents/`,
  `.claude/`, `.codex/`, `.cursor/`; each optional) that add or override
  assets for one target repo.
- A **sync tool** (`scripts/sync-playbook.sh`) that installs assets into target
  repos via per-file hard links (playbook or target cwd), plus optional
  `--machine` syncmap for project-agnostic home/user files.
- Per-machine registry under `machines/<id>/` (project paths, syncmap, ignores).
- Layered `ignoresync.txt` (global / machine / project).
- The scaffold (`artifacts/dev-notes-structure/`) and per-project live notes
  (`artifacts/live-notes/<project>/`).

Out of scope:

- No product application code.
- No build system, package manager, or CI (runtime is **bash + git** only).
- Anything a target repo needs beyond shared assets — that belongs in the target
  repo, not here.

## Key terms

| Term | Meaning |
|------|---------|
| Playbook | This source repo of shared agent assets. |
| Target repo | A separate git repo that consumes assets via sync. |
| Shared asset | A rule/skill under `.agents/`, subagent under `.claude/`/`.codex/`, or Cursor extra under `.cursor/`, installed into every target. |
| Overlay | `artifacts/live-notes/<project>/<dir>/` for `<dir>` in `.agents`, `.claude`, `.codex`, `.cursor` — per-project assets; wins over shared on clashes. |
| Pointer | The line in target `AGENTS.md` / `CLAUDE.md` that sends agents to `.agents/dev-guide.md`. |
| Prune | Deleting a target-only asset-dir file the playbook once shipped but no longer does. |
| Sync | Running `sync-playbook.sh` (playbook cwd, target cwd, or `--machine`). |
| Hard link | How asset **files** land in a target (same-filesystem link, not copy). |
| Live notes | `artifacts/live-notes/<project>/dev-notes/` — target `.dev-notes` counterpart. |
| Scaffold | `artifacts/dev-notes-structure/` — template when live notes are missing. |
| Machine | Host identity (`hostname` / `machines/aliases.txt`) with path + syncmap files. |
| Project modules | `machines/<id>/project-modules.txt` — `project:/abs/nested` treats nested repo guides as that project on this machine. |
| Syncmap | `machines/<id>/syncmap.txt` — playbook path → absolute dest, optional host file (via `--machine`). |
| Source block | Marked `ai-playbook` block sync keeps in a local host file (e.g. `~/.zshrc`) that sources the playbook copy in `~/.playbook/`. |
| Ignoresync | Playbook-root paths / basename-dir / simple globs excluded from project sync (`!` unignore). |

## Principles

- **Thin:** source assets plus one sync script; add nothing that isn't required.
- **Idempotent sync:** re-running is safe; correct hard links are no-ops; broken
  links with identical bytes are re-linked.
- **Conflict direction:** `.dev-notes/` and project `dev-guide.md` prompt playbook vs target; `--force` ⇒ playbook wins. Asset dirs (`.agents/`, `.claude/`, `.codex/`, `.cursor/`) and syncmap stay playbook-only.
- **Non-touch git-tracked targets:** warn and skip when inode/content differs from playbook; already hard-linked copies are silent.
- **Assets one-way:** asset dirs are playbook → target only (stale shipped
  copies pruned); notes/guides stay bidirectional.
- **Tool-neutral first:** portable assets live in `.agents/`; tool dirs hold
  only what has no shared format (subagents, hooks).
- **Works across harnesses (MUST):** every skill, rule, and subagent added here
  must work in at least Claude Code, Codex, and Cursor. Tool-specific features
  are allowed only as optional extras that degrade gracefully, or in a tool dir
  with equivalents for the others where a format exists.
- **Machine syncmap is explicit:** `--machine` only; never mixed into default
  project sync.
- **System files stay local:** `~/.zshrc`, `~/.vimrc`, `~/.tmux.conf` are the
  machine's own; sync only maintains its source block in them.
- **Single operational entry:** all install behavior flows through
  `sync-playbook.sh`.
