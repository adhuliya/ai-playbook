# Dev-guide template

Copy into `.dev-notes/dev-guides/<project-path>/dev-guide.md` (or the repo root
guide at `.dev-notes/dev-guides/dev-guide.md`). Keep under ~100 lines. Fill only
what is true for this directory; delete unused optional sections.
Do not put dates in the guide.
Do not put Parent/Children blocks — hierarchy is discovered via the filesystem
(see the `dev-guides` skill cookbook).

```markdown
# <Directory name> — dev guide

## Purpose

<1–3 sentences: what this subtree is for>

## Layout

| Path | Role |
|------|------|
| `...` | ... |

## Build / test / run

- From repo root: `<build/test command>`
- Or local: `...`

## Invariants

- <correctness or layout rules agents must not invent around>
- Prefer live tree over this file; fix clearly stale one-liners in the same
  change; use the `dev-guides` skill (+grill) for material rewrites

## Related

<!-- optional; project paths only; free-flow OK; omit if none -->

- `other/project/path` — when to open its guide / why it matters

## Key entry points

<!-- optional -->

- `path/to/entry` — ...

## Common tasks

<!-- optional; short commands only -->

```bash
<build/test command>
```
```

### Conventions

- **Layout** table paths are real project paths (relative to this directory or
  repo-rooted — be consistent within the file).
- **Related** names project directories only; agent opens
  `.dev-notes/dev-guides/<path>/dev-guide.md` if that file exists.
- Ancestor skips are allowed (no guide required at every intermediate folder).
- **Root guide** variant: keep it a thin index — pipeline (if any), top-level
  Layout roles, and build-entrypoint pointer. Omit deep Purpose/Invariants;
  add Related only when needed for navigation. Folder detail belongs in
  folder guides.
