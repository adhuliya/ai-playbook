# Repo root — dev guide

## Purpose

Thin structural index. The repo root itself holds the main paper (target:
*Science of Computer Programming*, working title "Synergistic Program
Analyzer"). Sibling top-level folders hold earlier/related writeups of the
same research. See `.dev-notes/definition.md` for the project definition.

## Invariants

- Every buildable LaTeX subtree (root, `oopsla23/`, `phdthesis/`,
  `20260223-defence/ppt/`) has its own `Makefile`. Build any of them from
  *inside that directory*: `make` builds `main.pdf`, `make clean` removes
  build artifacts. There is no repo-wide build command.
- The `afterFileEdit` hook (`.cursor/hooks/compile-latex-on-edit.py`) runs
  `make` from the repo root whenever any `.tex`/`.cls`/`.sty` file anywhere in
  the repo is edited — including files under `oopsla23/`, `phdthesis/`, and
  `20260223-defence/ppt/`. It only ever builds the root `Makefile` target
  (`main.pdf`), so edits in those subfolders trigger a root build, not their
  own. Results are logged to `hooks.output.txt` at the root.
- `main.tex` has several `\input{...}` sections commented out (e.g.
  `examples_policy`, `properties`); the corresponding `.tex` files exist but
  are not part of the current build.

## Layout

| Path | Role |
|------|------|
| `main.tex` | Root paper's document driver; `\input`s the `*.tex` files below it |
| `*.tex` (root-level) | Root paper's sections (introduction, approach, experiments, proofs, ...) |
| `resources/` | Shared style (`myarticle.sty`) and figures for the root paper |
| `elsarticle*`, `*.bst`, `*.cls` | Elsevier journal template files (vendored, do not hand-edit) |
| `oopsla23/` | Prior OOPSLA'23 submission — self-contained (own `main.tex`, `acmart.cls`, own `Makefile`) |
| `phdthesis/` | PhD thesis — self-contained (own `main.tex`, chapters, own `Makefile`) |
| `20260223-defence/ppt/` | Thesis defence slide deck — self-contained (own `main.tex`, Beamer, own `Makefile`) |
| `20260223-defence/ppt/scp_extension.txt`, `extension*.txt` | Freeform planning/scratch notes |
| `.cursor/` | Agent tooling: rules, skills, and the LaTeX-build-on-edit hook |

## Build / test / run

- From repo root: `make` (builds `main.pdf` via `pdflatex -shell-escape` +
  `bibtex`), `make show` (build + open in viewer), `make clean`.

## Related

Open only when a task genuinely needs cross-version comparison (e.g. porting a
proof or figure) — do not read these proactively:

- `oopsla23/` — earlier conference version of the same `\cSpan{}` work
- `phdthesis/` — full thesis version, superset of the paper's content
- `20260223-defence/ppt/` — slide summary of the same work
