# repository root -- Dev-Guide

LaTeX repo: main SCP paper at root; sibling folders hold earlier versions of the same research.

## Notes

- Vision: `.dev-notes/definition.md`. Working title: *Science of Computer Programming* (“Synergistic Program Analyzer”).
- **Build:** each LaTeX subtree has its own `Makefile` — run `make` **inside** that directory (`main.pdf`, `make clean`). No repo-wide build.
- **Hook:** `.cursor/hooks/compile-latex-on-edit.py` runs root `make` on any `.tex`/`.cls`/`.sty` edit repo-wide (builds root `main.pdf` only); log: `hooks.output.txt`.
- **Root `main.tex`:** some `\input{...}` sections commented out (`examples_policy`, `properties`, …) — files exist but are not in the build.
- Open `oopsla23/`, `phdthesis/`, `20260223-defence/ppt/` only when cross-version work needs it.

## Artifacts

| Name | Description |
|------|-------------|
| `main.tex` | Root paper driver |
| `resources/` | Shared style and figures |
| `elsarticle*`, `*.bst`, `*.cls` | Vendored Elsevier template — do not hand-edit |
| `oopsla23/` | OOPSLA'23 submission — `oopsla23/dev-guide.md` |
| `phdthesis/` | PhD thesis — `phdthesis/dev-guide.md` |
| `20260223-defence/ppt/` | Defence slides — `20260223-defence/ppt/dev-guide.md` |
| `.cursor/` | Rules, skills, LaTeX hook |
