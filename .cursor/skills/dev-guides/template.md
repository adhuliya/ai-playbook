# Dev-guide template

Copy into `.dev-notes/dev-guides/<project-path>/dev-guide.md` (or the repo root
guide at `.dev-notes/dev-guides/dev-guide.md`). Keep under ~100 lines. Fill only
what is true for this directory; delete unused optional sections. No dates.
No Parent/Children blocks — hierarchy is discovered from the filesystem (see the
`dev-guides` skill cookbook).

Section order is deliberate: an agent about to change code needs *what will bite
me* (Purpose, Invariants/Gotchas) before *where things live* and *how to build*.

```markdown
# <Directory name> — dev guide

## Purpose

<1–2 sentences: what this subtree is for>

## Invariants

<!-- dir-specific rules an agent must not invent around; omit if truly none -->

- <correctness/layout rule specific to THIS directory>

## Gotchas

<!-- optional; the things that will surprise or break an agent working here -->

- <non-obvious trap, "don't hand-edit X", "use skill Y for Z", partial support…>

## Layout

<!-- SELECTIVE, not an `ls`. Only entries whose role is non-obvious from the
     name, plus key subdirs. Never aim to be exhaustive. -->

| Path | Role |
|------|------|
| `...` | ... |

## Key entry points

<!-- optional; where to start reading/editing -->

- `path/to/entry` — ...

## Build / test / run

- From repo root: `<build/test command>`
- Or local: `...`

## Related

<!-- optional; REPO-ROOTED paths only; free-flow OK; omit if none -->

- `other/project/path` — why it matters / when to open its guide

## Common tasks

<!-- optional; short commands only -->

```bash
<build/test command>
```
```

### Conventions

- **Core sections** are Purpose, Invariants, Layout, Build/test/run. Everything
  else is optional. You MAY add free-form sections (e.g. `Caveats`, `Background`,
  `Gotchas`) when a directory genuinely needs them — no grill required. Grilling
  is only for changing the *core* required set.
- **Layout** is selective, not a file listing. If a file's role is obvious from
  its name, leave it out. Prefer key subdirs over enumerating leaf files. The
  live tree is authoritative for the full listing.
- **Path scope differs by section:**
  - **Related** MUST use repo-rooted paths — the agent resolves each to
    `.dev-notes/dev-guides/<path>/dev-guide.md`, so a wrong root breaks lookup.
  - **Layout** MAY use dir-relative paths (`analysis.go`) for readability; be
    consistent within the Layout table.
- Ancestor skips are allowed (no guide required at every intermediate folder).
- Do **not** restate guide meta-policy ("prefer live tree", "use the dev-guides
  skill") — that lives in `dev-main.mdc` and applies always.
- **Root guide** variant: a thin structural index only — pipeline (if any),
  top-level path→role Layout, and a build-entrypoint pointer; Related for
  top-level navigation. It does not restate project vision/scope/terms (those
  live in `.dev-notes/definition.md`); link, don't duplicate. Folder detail
  belongs in folder guides.
