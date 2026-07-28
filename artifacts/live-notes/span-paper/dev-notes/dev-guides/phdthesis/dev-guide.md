# phdthesis/ — dev guide

## Purpose

Self-contained PhD thesis, IIT Bombay format (`iitbcs.sty`). Superset of the
root paper's content, organized as chapters instead of sections.

## Invariants

- Fully self-contained: own `main.tex`, own `Makefile`. Does not depend on
  root-level `.tex`/`.sty`/`.bib` files (its `references.bib` is separate).
- Several `_minted-main*` directories are `minted`-package build cache
  (generated, gitignored-in-spirit) — never hand-edit; safe to delete and
  regenerate via `make`.
- Some chapter `.tex` files are superseded duplicates kept for reference
  (e.g. `approach_old.tex`, `introduction_thesis.tex` vs `introduction.tex`) —
  check `main.tex`'s active `\input` list before editing a section.

## Layout

| Path | Role |
|------|------|
| `main.tex` | Document driver; `\chapter`+`\input` per chapter |
| `*.tex` (top-level) | Thesis chapters and appendices |
| `resource/`, `scripts/` | Thesis-specific figures/scripts (kept by the `Makefile`'s `tgz` target) |
| `reference-files/`, `not-for-git/` | Reference/scratch material, not built |
| `_minted-main*/` | Generated `minted` cache — ignore |
| `thesis.sty` | Custom LaTeX commands: most math and formatting macros used across the thesis are defined here |
| `iitbcs.sty` | IIT Bombay thesis format; vendored/unchanged, do not hand-edit |
| `numdef.sty`, `pst-rel-points.sty` | Supporting custom macro/style files |

## Key entry points

- `thesis.sty` — start here when looking up or adding a math/formatting macro

## Build / test / run

- From this directory: `make` (builds `main.pdf`), `make show`, `make clean`.

## Related

- `../` (repo root) — current paper version; the thesis is a superset covering
  the same `\cSpan{}` formalism in more depth
