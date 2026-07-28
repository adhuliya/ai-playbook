# 20260223-defence/ppt/ — dev guide

## Purpose

Self-contained Beamer slide deck for the thesis defence talk, summarizing the
same `\cSpan{}` work as the root paper and thesis.

## Invariants

- Fully self-contained: own `main.tex`, own `Makefile`, own `theme.sty` /
  `presentation.sty`. Does not depend on root-level files.
- `notes.txt` holds freeform speaker/planning notes, not part of the build.

## Layout

| Path | Role |
|------|------|
| `main.tex` | Beamer document driver; `\input`s the frame files below |
| `*.tex` (top-level) | Individual sections/examples included as frames (e.g. `spanExample1.tex`, `overview.tex`) |
| `codes/` | Source-code snippets shown in slides |
| `resource/` | Figures/scripts used by slides |

## Build / test / run

- From this directory: `make` (builds `main.pdf`), `make show`, `make clean`.

## Related

- `../../` (repo root) — full paper this talk summarizes
