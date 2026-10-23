# Catalog

`.dev-notes/activities/activities.md` lists every activity by slug. Create
it lazily (`# Activities`). Append new entries at the end; do not rewrite or
reorder the file unless asked. An entry is `## <slug>: Short title` plus one
high-level paragraph with no **IDs** and no milestone numbers. It is not a
substitute for `agent-activity.md`. Shape: `shapes/catalog.md`.

On create, derive, or import, append without reading the catalog:

```bash
printf '\n## %s: %s\n\n%s\n' "$slug" "$title" "$para" >> .dev-notes/activities/activities.md
```

When the Goal changes (`replan-work`, `apply-review` if the Goal text
changes, or equivalent), edit that one heading via `rg`. Skip catalog
updates for any other change.

```bash
rg -n -A 8 '^## <slug>:' .dev-notes/activities/activities.md
rg '^## ' .dev-notes/activities/activities.md
```
