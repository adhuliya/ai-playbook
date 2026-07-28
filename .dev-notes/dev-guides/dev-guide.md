# ai-playbook — dev guide

Structural index for the repo. For work under a path, open the deepest matching
folder guide under `.dev-notes/dev-guides/`. Project vision/scope/terms live in
[`.dev-notes/definition.md`](../definition.md), not here.

## Pipeline

```
ai-playbook (rules + skills + per-project overlays)
   --(scripts/sync-playbook.sh: hard links + .dev-notes symlink)-->  target repo
```

## Repository root

| Path | Role |
|------|------|
| `README.md` | Sync usage + layout entrypoint |
| `prompt.md` | Full sync/overlay contract (authoritative behavior spec) |
| `projects.txt` | Known target-project names |
| `.cursor/rules/` | Always-applied agent rules (`dev-main`, `dev-git`) |
| `.cursor/skills/` | Agent skills (`dev-guides`, `journal`, `grill-me`, …) |
| `.cursor/agents/` | Agent definitions |
| `scripts/sync-playbook.sh` | The sync tool (hard-links content into a target repo) |
| `artifacts/dev-notes-structure/` | Scaffold template for a fresh target `.dev-notes/` |
| `artifacts/live-notes/` | Per-project live `.dev-notes` trees (e.g. `span/`) |
| `<name>.cursor/` | Per-project `.cursor` overlay; wins on clashes during sync |

## Build / test / run

No build. Run the sync from a **target repo root**:

```bash
/path/to/ai-playbook/scripts/sync-playbook.sh --project <name> [--overwrite] [--yes]
```

## Related

- `.cursor/skills/dev-guides` — how these guides are created/maintained
