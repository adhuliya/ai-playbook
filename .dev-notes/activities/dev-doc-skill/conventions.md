# Conventions

## CONV1: Record the solution here

- This activity writes the problem and the solution.
- The documentation skill is **`dev-doc`** under `.agents/skills/dev-doc/`.
- Keep starters and references under that skill tree; do not cite aparajit `docs/`.
- revised-by: RU7.2

## CONV4: No aparajit `docs/` cites in the skill

- After transfer, starters and references must stand alone under the activity / skill tree.
- Do not point the skill at aparajit `docs/` (pitch deck, pixhawk report, poster, presentation, shared TeX).
- Visual language already lives in `artifacts/scratch/theme/` and `artifacts/styling.md`.

## CONV2: Tool facts follow the guides

- A command, flag, or pitfall is written only when a REF states it, or when a scratch render proves it and REF14 / `artifacts/rendering-pitfalls.md` records it.
- `doc-pipeline.md` is context. Where it disagrees with REF1 or REF4, the guide wins.

## CONV3: General render fixes go into the skill notes

- When a scratch adjustment is useful beyond this one file, append it to `artifacts/rendering-pitfalls.md` in the same turn.
- That file is the draft of the skill’s `references/rendering.md`.
- Do not leave durable engine traps only in chat.

## Setup, build, test and install notes

Do not install Typst, Pandoc, or TeX unless asked. Use a local prefix or a `PATH` override if a later check needs a tool. Marp is not part of the core path (DC12).

Cross-platform install draft for the skill: `artifacts/install.md` → `references/install.md` (macOS, Ubuntu, Windows). Keep commands aligned with REF1 / REF4 / REF16.

Guide commands, for the skill record, not run unless asked:

- Typst: `brew install typst` (macOS), Snap or release binary (Ubuntu), `winget install --id Typst.Typst` (Windows); then `typst compile file.typ` (REF1). Decks: Touying metropolis (REF15). Scratch: `artifacts/scratch/compile.sh` passes `--font-path` for TeX-tree Fira.
- Pandoc to Typst PDF: `pandoc report.md --pdf-engine=typst -o report.pdf` (REF4). Prefer `--standalone`, YAML `section-numbering`, and YAML `mainfont`/`margin` so the Pandoc title matches `theme/tokens.typ` (see `artifacts/styling.md`).
- Typst formal preview: `typst compile file.typ` or `typst watch file.typ`. HTML watch is experimental: `typst watch file.typ --format html --features html` (REF12).

Core scratch builds (skill record), not run unless asked:

- `artifacts/scratch/compile.sh` — Typst report + Touying deck with Fira `--font-path`.
- Pandoc report: `pandoc report.md --standalone --pdf-engine=typst` with before-body and YAML fonts/margins (`artifacts/install.md`, `artifacts/styling.md`).
