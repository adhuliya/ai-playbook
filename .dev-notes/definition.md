# ai-playbook — definition

Vision, scope, and key terms. Repository structure lives in
`dev-guide.md` at the repository root; cold-start rebuild instructions in
`.dev-notes/seed-prompt.md`.

## Vision

A single **source repo** for shared Cursor assets — rules and skills — plus
optional per-project overlays, distributed into target repos by one bash script.
Author agent behavior once here; every target repo consumes the same content
without copy-paste drift.

## Scope

In scope:

- Shared Cursor **rules** (`.cursor/rules/*.mdc`) and **skills**
  (`.cursor/skills/<name>/`).
- Per-project **overlays** (`<project>.cursor/`) that add or override assets for
  one target repo.
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
| Playbook | This source repo of shared Cursor assets. |
| Target repo | A separate git repo that consumes assets via sync. |
| Shared asset | A rule/skill under `.cursor/` installed into every target. |
| Overlay | `<project>.cursor/` — per-project assets; wins over shared on clashes. |
| Sync | Running `sync-playbook.sh` (playbook cwd, target cwd, or `--machine`). |
| Hard link | How asset **files** land in a target (same-filesystem link, not copy). |
| Live notes | `artifacts/live-notes/<project>/dev-notes/` — target `.dev-notes` counterpart. |
| Scaffold | `artifacts/dev-notes-structure/` — template when live notes are missing. |
| Machine | Host identity (`hostname` / `machines/aliases.txt`) with path + syncmap files. |
| Syncmap | `machines/<id>/syncmap.txt` — playbook path → absolute dest (via `--machine`). |
| Ignoresync | Playbook-root paths excluded from project sync (`!` unignore). |

## Principles

- **Thin:** source assets plus one sync script; add nothing that isn't required.
- **Idempotent sync:** re-running is safe; correct hard links are no-ops; broken
  links with identical bytes are re-linked.
- **Playbook wins on forced conflict:** divergent content prompts unless `--force`.
- **Non-touch git-tracked targets:** warn and skip paths tracked in the target.
- **Cursor one-way:** `.cursor/` is playbook → target only; notes/guides stay
  bidirectional.
- **Machine syncmap is explicit:** `--machine` only; never mixed into default
  project sync.
- **Single operational entry:** all install behavior flows through
  `sync-playbook.sh`.
