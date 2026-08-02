# repository root -- Dev-Guide

C + Go monorepo: slang lowers C to SPIR protobuf; span loads, links, and analyzes SPIR.

## Notes

- Pipeline: C → (slang) → SPIR protobuf → (span) → analysis results.
- Open the deepest `dev-guide.md` on the path you are editing; prefer the live tree over stale rows here.
- Build/test: root `Makefile` — `make help`, `all`, `span`, `slang`, `test`, `test-span`, `test-slang`, `gen`, `clean`, `docker-build`, `docker-run`.
- Project vision: `.dev-notes/definition.md`. Guides: `dev-guides` skill in target repo.

## Artifacts

| Name | Description |
|------|-------------|
| `Makefile` | Top-level build and test entry |
| `README.md` | Purpose, SPIR overview, setup |
| `slang/` | Clang/LLVM SPIR frontend — see `slang/dev-guide.md` |
| `span/` | Go analyzer module — see `span/dev-guide.md` |
| `tools/` | Standalone utilities — see `tools/dev-guide.md` |
| `scripts/` | Repo-wide helper scripts |
| `docs/` | Design diagrams (drawio) |
| `.dev-notes/` | `definition.md`, `journal.md`, `activities/` |
| `.cursor/rules/`, `.cursor/skills/` | Agent rules and skills |
