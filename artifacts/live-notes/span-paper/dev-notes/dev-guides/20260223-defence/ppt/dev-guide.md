# 20260223-defence/ppt -- Dev-Guide

Self-contained Beamer deck for the thesis defence; summarizes `\cSpan{}` work.

## Notes

- **Invariants:** own `main.tex`, `Makefile`, `theme.sty`, `presentation.sty` — no root file dependencies. `notes.txt` is speaker notes, not built.
- **Build:** from this dir: `make`, `make show`, `make clean`.

## Artifacts

| Name | Description |
|------|-------------|
| `20260223-defence/ppt/main.tex` | Beamer driver |
| `20260223-defence/ppt/*.tex` | Frame sections |
| `20260223-defence/ppt/codes/` | Slide code snippets |
| `20260223-defence/ppt/resource/` | Slide figures |
| `dev-guide.md` (repo root) | Full paper this talk summarizes |
