# AI Playbook

Shared Cursor rules/skills plus per-project overlays. Target repos pull content
with a bash sync script (per-file hard links + a `.dev-notes` symlink).

## Sync into a target repo

From the **target git repo root** (must contain a `.git/` directory):

```bash
/path/to/ai-playbook/scripts/sync-playbook.sh --project <name> [--overwrite] [--yes]
```

- Playbook root is derived from the script’s location (call it from anywhere by path).
- Safe to re-run: paths already linked to the correct final source are no-ops.
- Unknown `--project`: confirm, or pass `--yes` to append to `projects.txt`.
- Optional overlay: top-level `<name>.cursor/` in the playbook maps onto target `.cursor/` and wins on clashes.
- Missing live-notes: auto-scaffolded from `artifacts/dev-notes-structure/`.
- Conflicts (pre-existing divergent paths): skipped unless `--overwrite`; listed at end.
- Hard-link failures: warned, listed at end, exit non-zero.

Sync prints `=== gitignore ===` with the
`git config --global core.excludesFile '~/.gitignore_global'` one-liner, then the
exact path list (current + older manifest entries).

## Layout

See `prompt.md` for the full contract.
