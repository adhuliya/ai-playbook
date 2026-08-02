# phdthesis -- Dev-Guide

Self-contained IIT Bombay PhD thesis (`iitbcs.sty`); chapter-based superset of the root paper.

## Notes

- **Invariants:** own `main.tex` and `Makefile`; separate `references.bib` — no root `\input`s. Check `main.tex` active `\input` list before editing (duplicate chapter files exist, e.g. `approach_old.tex`). `_minted-main*` dirs are minted cache — delete/regenerate via `make`, never hand-edit.
- **Macros:** most math/formatting in `thesis.sty` — start there for lookups.
- **Build:** from this dir: `make`, `make show`, `make clean`.
- Superset of same `\cSpan{}` work as repo root paper.

## Artifacts

| Name | Description |
|------|-------------|
| `phdthesis/main.tex` | Chapter driver |
| `phdthesis/thesis.sty` | Custom macros |
| `phdthesis/iitbcs.sty` | IIT format — vendored, do not hand-edit |
| `phdthesis/resource/`, `scripts/` | Figures/scripts (`make tgz`) |
| `phdthesis/reference-files/`, `not-for-git/` | Reference scratch (not built) |
| `dev-guide.md` (repo root) | Current paper version |
