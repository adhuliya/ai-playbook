# Seed prompt — recreate ai-playbook

Paste into a fresh empty repo / agent session. Goal: rebuild this Cursor playbook, not a product app.

## What it is

A **source repo** of shared Cursor skills/rules plus per-project overlays.
Target repos pull content via a bash sync script (hard links + `.dev-notes`
symlink). No npm/Python package; runtime is **bash + git**.

## Layout

```
ai-playbook/
├── README.md
├── prompt.md
├── projects.txt                 # known project keys (one per line; start empty)
├── .gitignore                   # un-ignore .cursor/ and .dev-notes/ if globally ignored
├── .cursor/
│   ├── rules/                   # shared rules (*.mdc)
│   └── skills/<name>/SKILL.md   # shared skills (+ any helper files)
├── <project>.cursor/            # OPTIONAL top-level overlay (manual); maps to target .cursor/
│   ├── rules/
│   └── skills/
├── scripts/
│   └── sync-playbook.sh         # ONLY operational entry (run FROM target repo root)
├── artifacts/
│   ├── live-notes/<project>/dev-notes/   # target .dev-notes symlink destination
│   └── dev-notes-structure/     # scaffold when a project's live-notes is missing
│       ├── definition.md
│       ├── journal.md           # project-global append-only major-change log
│       ├── activities/dev-guide.md
│       ├── dev-guides/dev-guide.md
│       ├── knowledge/dev-notes.md
│       └── artifacts/dev-notes.md
└── .dev-notes/                  # playbook's own notes (not synced as shared skills)
    ├── definition.md
    ├── journal.md
    ├── activities/
    ├── dev-guides/
    ├── knowledge/
    └── artifacts/
```

## Sync contract (`scripts/sync-playbook.sh`)

- CLI: `--project <name> [--overwrite] [--yes]`
- Run from **target** repo root; cwd must contain a **`.git` directory** (else error).
- Playbook root = resolve from the script’s own path (`BASH_SOURCE` / realpath).
- **Files**: per-file hard links under real directories. **Directories**: symlink only for `.dev-notes`.
- Hard-link failure: warn, continue, list failures at end, exit non-zero. Expect same filesystem.
- Shared install: all regular files under playbook `.cursor/skills/` and `.cursor/rules/`.
- Overlay: top-level `<project>.cursor/**` → target `.cursor/**`. Final source per path =
  overlay if present, else shared. Same-run and re-runs compare against that final source
  (idempotent; overlay does not require `--overwrite` forever).
- Missing overlay: warn, shared-only. Create `<project>.cursor` manually when needed.
- `.dev-notes` → absolute symlink to `artifacts/live-notes/<project>/dev-notes`
  (path computed from playbook root). Auto-scaffold from `dev-notes-structure` if missing;
  never re-scaffold over an existing live-notes tree.
- Idempotency: already hard-linked to final source, or `.dev-notes` already correct → no-op.
- Conflicts: only **pre-existing** divergent target paths. Without `--overwrite`: warn, skip,
  finish run, list conflicts, exit 1. With `--overwrite`: replace then link.
- Manifest: target `.cursor/.sync-playbook-manifest` — flat path list (one per line),
  **union across runs** (never drop older entries). Stale paths: warn only, never delete.
- Unknown `--project`: append to `projects.txt` after confirm / `--yes`.
- Always print exact gitignore paths (union of all manifest entries): `.dev-notes` and
  `.cursor/<rel>`, plus the `git config --global core.excludesFile` one-liner.

## Minimal bootstrap order

1. Create layout above; stub `README.md`, empty `projects.txt`, playbook `.gitignore`.
2. Add shared skills/rules as needed (author separately from sync).
3. Implement `sync-playbook.sh` to the contract above.
4. Seed `artifacts/dev-notes-structure/`, copy once to playbook `.dev-notes/`.
5. Add `<project>.cursor` overlays only when a project needs extra skills/rules.

Do not invent a build system, package.json, or CI unless asked.
Keep the playbook thin: source assets + one sync script.
