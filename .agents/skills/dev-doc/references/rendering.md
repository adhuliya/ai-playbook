# Rendering pitfalls for the skill

General observations from verified compiles (Typst 0.15.1, Pandoc 3.13; Touying 0.6.1 for decks). Read this file when building or fixing a report, deck, or diagram export. Browser pitfalls: `references/browser.md`.

## Skill file placement

- Core `SKILL.md`: revision workflow, which starter to open, when to load a side file.
- `references/rendering.md`: this list.
- `references/install.md`: tool install for macOS / Ubuntu / Windows.
- `references/browser.md`: Typst PDF (reports and decks); structured Markdown→HTML for reports only; Typst `--features html` pitfall.
- `references/latex.md`, `references/docx.md`, `references/gdocs.md`: conversion only.
- Do not bury engine pitfalls only in chat history.

## Pandoc Markdown → Typst

- Use `--standalone` (or `-s`). Without it, title and contents list are missing.
- Pass `--include-before-body` with Typst that runs `#show: apply` after importing a style function. Pandoc's default Typst template sets `#set table(stroke: none)`.
- Section numbers are off by default (`sectionnumbering: none` in the Typst template). Set YAML `section-numbering: "1.1"` or pass `-V section-numbering=1.1` with `--standalone`.
- Table caption: a line that starts with `: ` immediately after the table.
- Figure caption: the image alt text becomes the caption.
- Citations: use Pandoc cite keys with a bibliography (`--citeproc` and `--bibliography`, or Typst `#bibliography` in a hand-written `.typ`). IEEE numbered style worked with `--csl` pointing at an IEEE CSL.
- Do not write `@label` in Markdown for a figure cross-reference. Pandoc turns `@name` into a citation. On Typst 0.15 a citation without a bibliography fails with "the document does not contain a bibliography".
- Raw Typst for diagrams: fenced `{=typst}` blocks, with `--from markdown+raw_attribute`. Import diagram helpers in the before-body file.
- Code in Markdown gets a gray box and line numbers only if the Typst `apply` show rules run. Syntax colors come from Typst's raw highlighter.

## Typst styles (reports, posters, cheat sheets, decks)

- **Tokens live in one file.** Skill: `templates/theme/tokens.typ` (navy/saffron/ink/…, Fira). Do not hard-code hex in entrypoints.
- Report chrome: `templates/theme/report.typ` → `#show: report-setup.with(header-left: …)`. Deck chrome: `templates/theme/deck.typ` → Touying **metropolis** + `pitch-title-slide` / components.
- Export styles as `#let apply(body) = { ...; body }` and use `#show: apply` (or `#show: apply.with(...)`).
- `#include "styles.typ"` does **not** style content that follows the include in the parent file. Set and show rules in an included file stay scoped to that include.
- `#import "styles.typ"` alone also does not apply rules; import the `apply` function and invoke it with `#show: apply`.
- Tables: set a visible `stroke` and optional header `fill`. Do not rely on Pandoc's borderless default.
- Code blocks:
  - Do **not** number lines with `#show raw.line: box(width: 100%)[…]` (or a full-width `grid`) under a justified body. Each line becomes its own paragraph and inherits large `par.spacing`, so the listing looks double- or triple-spaced. Setting `par(spacing: …)` around `#it` does not fix it.
  - Number lines inside `#show raw.where(block: true)` by iterating `it.lines` and placing `line.number` + `line.body` in stacked boxes; set `par(leading: 0.45em, spacing: 0pt, justify: false)` in that rule.
  - `#show raw: set text(font: font-mono, size: …)` using the token (Fira Mono). Pass `--font-path` when Fira is not on the system font set.
  - Keep left align / `justify: false` for code so indentation stays visible.
- **Pandoc + report chrome:** Pandoc's Typst `conf()` paints the title *before* `--include-before-body`. Do **not** put `#set page` / `#show: report-setup` (which sets page) in before-body after that title float — Typst starts a new page and leaves a nearly blank first page (title + page number only). Put page chrome in `--include-in-header` (`templates/pandoc-page.typ` → `#show: report-page.with(...)`) and body style in before-body (`templates/pandoc-before.typ` → `#show: report-style` + `#show: apply`). Set YAML `mainfont` / `codefont` / `fontsize` / `papersize` / `margin` / `linkcolor` so the title block matches. Without `--font-path`, Fira is missing and Typst falls back to a serif.
- Cross-refs inside Typst: `@label` for figures and listings is fine once the label exists. Do not write `Table @tools` or the text becomes "Table Table 1".
- Bibliography: `#bibliography("refs.bib", style: "ieee")` (or another built-in / CSL). Cite with `@key` in Typst source.

## Diagrams

- Prefer drawing in Typst: **Fletcher** (flow), **Chronos** (sequence), **CeTZ** (waveforms/geometry). Embed as **vector** in Typst report and Touying deck PDFs. Size with `fit-box` / `fit-image` from `templates/style-overrides.typ`.
- Optional raster: `typst compile --format png --ppi 300` only when a PNG is required. Do not use a low-DPI `pdftoppm` pass as the canonical export.
- Do not hard-code a shrink factor like `scale(72%)` on diagrams. Use a best-fit helper (`fit-box` / `fit-image`):
  1. Measure the body's natural size.
  2. Scale uniformly to the target text width (default `100%`).
  3. If the scaled height would exceed a height cap (default ~48% of the page content box), shrink further so height wins.
  4. For bitmaps, set `upscale: false` so a small PNG is not blown up; for drawn diagrams, leave `upscale: true` so a short figure can grow to the text width.
  - Fixed `%` on `image(...)` or a one-shot `scale` either overflows the margin or leaves the figure too small. Wrap `#figure(fit-box(diagram), …)` (and `fit-image` for files).
- Wide Fletcher diagrams still need readable natural spacing; `fit-box` then brings them into the measure. Check A4, letter, and 16:9 slides.
- Flowchart labels: do not put edge labels on edges that enter a node. Use free label nodes clear of boxes, or a short legend.
- Split report vs deck paths in the figure so edges do not cross the wrong nodes.

## Touying decks

- Import `@preview/touying` and **metropolis** (templates: 0.6.1) — same Beamer base as the pitch theme. Map tokens: `secondary` = navy (frametitle), `primary` = saffron (progress).
- Flat deck (no section interstitial): `config-common(new-section-slide-fn: none)`.
- Full-bleed navy title: `pitch-title-slide` in `templates/theme/deck.typ` (not the stock metropolis title).
- Run shared `#show: apply` inside `config-methods(init: …)` so tables and code match the report.
- Diagrams: `fit-box(...)` on the slide; keep Chronos `show-bottom: false` when height is tight.
- Compile: `typst compile --font-path … deck.typ` (REF1). Formal preview is the PDF.

## Consistency checklist (agent)

Before calling a render done:

1. Report PDF: title, TOC, ruled table, captioned figure, gray code box with line numbers, citations resolve, bibliography present, section numbers if required.
2. Deck PDF: Touying 16:9, table grid, code gutter, vector diagrams inside the slide, caption line if needed.
3. Styles applied via `#show: apply`, not via `#include` of rule-only files.
