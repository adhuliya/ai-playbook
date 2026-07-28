# oopsla23/ — dev guide

## Purpose

Self-contained OOPSLA'23 submission of the SPAN work (ACM `acmart` format).
Frozen/historical: not actively built by the repo's edit hook (see root guide
Invariants) and not the current writeup target.

## Invariants

- Fully self-contained: own `main.tex`, `acmart.cls`, `ACM-Reference-Format.bst`,
  own `Makefile`. Does not `\input` or depend on any root-level `.tex`/`.sty` files.
- Several sections in `main.tex` are commented out (`overview`, `examples_policy`,
  `properties`) — the `.tex` files exist but are unused in the current build.

## Layout

| Path | Role |
|------|------|
| `main.tex` | Document driver (ACM `acmart`, double-blind review options) |
| `*.tex` | Sections, largely earlier drafts of the root paper's sections |
| `etaps_download/` | Vendored third-party template files (`llncs.cls`, samples) — reference only |
| `gitsync` | Ad hoc sync script, not part of the LaTeX build |
| `not-for-git/`, `resources/` | Local scratch/asset files |

## Build / test / run

- From this directory: `make` (builds `main.pdf`), `make show`, `make clean`.

## Related

- `../` (repo root) — current, actively-maintained version of this same work
