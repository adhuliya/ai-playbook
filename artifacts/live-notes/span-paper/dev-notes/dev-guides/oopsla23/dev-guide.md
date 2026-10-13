# oopsla23 -- Dev-Guide

Frozen OOPSLA'23 SPAN submission (ACM `acmart`); not the active writeup target.

## Notes

- **Invariants:** self-contained (`main.tex`, `acmart.cls`, own `Makefile`); no root `.tex` dependencies. Several `\input`s commented in `main.tex` (`overview`, `examples_policy`, `properties`).
- Not built by the root edit hook (see repo-root guide).
- **Build:** from this dir: `make`, `make show`, `make clean`.

## Artifacts

| Name | Description |
|------|-------------|
| `oopsla23/main.tex` | ACM driver (review options) |
| `oopsla23/*.tex` | Section drafts |
| `oopsla23/etaps_download/` | Vendored LLNCS samples — reference only |
| `oopsla23/gitsync` | Ad hoc sync script (not LaTeX build) |
| `dev-guide.md` (repo root) | Current maintained version |
