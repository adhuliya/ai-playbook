# ai-playbook — definition

Vision, scope, and key terms. Repository structure lives in
`dev-guide.md` at the repository root; operational behavior lives in `prompt.md`.

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
- A **sync tool** (`scripts/sync-playbook.sh`) that installs assets into a target
  repo via per-file hard links plus a `.dev-notes` symlink.
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
| Sync | Running `sync-playbook.sh` from a target repo root to install assets. |
| Hard link | How asset **files** land in a target (same-filesystem link, not copy). |
| Live notes | `artifacts/live-notes/<project>/dev-notes/` — the target's `.dev-notes` symlink destination. |
| Scaffold | `artifacts/dev-notes-structure/` — template used when live notes are missing. |
| Manifest | `.cursor/.sync-playbook-manifest` in a target — union list of synced paths. |

## Principles

- **Thin:** source assets plus one sync script; add nothing that isn't required.
- **Idempotent sync:** re-running is safe; already-correct paths are no-ops.
- **Non-destructive:** pre-existing divergent target paths are skipped unless
  `--overwrite`; stale manifest entries are warned about, never deleted.
- **Single operational entry:** all install behavior flows through
  `sync-playbook.sh`, run from the target repo root.
