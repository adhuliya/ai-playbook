# Project structure — dev guide

This is the **canonical high-level map** of the repository. It is an overview,
not an exhaustive listing. For work under a path, open the deepest matching
folder guide under `.dev-notes/dev-guides/` instead of reading everything here.
Prefer the live tree if this file disagrees; fix clearly stale one-liners in the
same change. Create/maintain guides with the `dev-guides` skill. Scheme:
[`.cursor/rules/dev-guide.mdc`](../../.cursor/rules/dev-guide.mdc).

## Pipeline

```
C sources  --(slang: Clang AST)-->  SPIR protobuf (spir.proto)
         --(span: load / link / analyze)-->  analysis results
```

- **slang** (C++ / Clang / LLVM): frontend that lowers C to SPIR protobuf.
- **span** (Go): analyzer that loads SPIR, optionally links TUs, runs analyses.
- **SPIR** (`span/pkg/spir`): runtime IR + `spir.proto` wire format shared by both.

## Repository root

| Path | Role |
|------|------|
| `README.md` | Project purpose, SPIR overview, docker/setup notes |
| `Makefile` | Top-level build/test/gen for slang, span, and protos |
| `.dev-notes/` | Project notes (`definition.md`, `journal.md`, `dev-guides/`, `activities/`, …) |
| `.dev-notes/definition.md` | Project vision, scope, key terms |
| `.dev-notes/journal.md` | Append-only design journal (`journal` skill; `condense-journal` with approval) |
| `.dev-notes/dev-guides/` | Hierarchical structure guides (this tree) |
| `.devcontainer/` | Dev container |
| `.vscode/` | Editor tasks/settings |
| `.cursor/rules/` | Persistent agent rules |
| `.cursor/skills/` | Agent skills (`dev-guides`, `journal`, `build-slang`, …) |
| `docs/` | Design diagrams (drawio), not API docs |
| `prompts/` | Historical / planning prompts |
| `misc/` | Scratch samples (not production) |
| `not-for-git/` | Local-only corpora (gitignored); SPEC helpers under `spec-2017/` |
| `scripts/` | Repo-wide helper scripts |
| `tools/` | Small standalone utilities |
| `slang/` | Clang/LLVM SPIR frontend (C++) |
| `span/` | Go analyzer module |

## Build and test

- Prefer root `Makefile` targets: `all`, `span`, `slang`, `test`, `test-span`,
  `test-slang`, `gen`, `clean`, `docker-build`, `docker-run`.
- Run `make help` for the current target list.
- Subtree build/test details: open that folder’s `dev-guide.md` when present.

## Related

- `slang` — frontend layout, build, caveats
- `span` — Go module layout and packages
- `tools` — standalone utilities
