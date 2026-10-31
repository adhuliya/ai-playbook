# Starter templates

Four starter kinds. A work starts with one and adds others when asked. A document may replace any color token. Defaults live in `artifacts/scratch/theme/tokens.typ` (ink `#25303F`, navy `#0B1F3A`, saffron `#F29F05`, surface `#F3F5F8`, muted `#6B7787`, Fira). How to restyle: `artifacts/styling.md`. Do not cite aparajit `docs/` (CONV4).

## Report

Scratch: `artifacts/scratch/` with `theme/report.typ` + `style-overrides.typ` (and Pandoc `report.md` + `pandoc-before.typ`).

- Title, author, and date.
- Numbered sections and an optional contents list.
- Running header and a centered page number.
- Body text, figures, tables, and a monospace code block (Fira Mono).
- Typst template. Source may be Pandoc Markdown (`report.md` YAML carries mainfont/margin for the Pandoc title block).

## Deck

Scratch: `artifacts/scratch/deck.typ` + `theme/deck.typ` (Touying metropolis).

- Typst + Touying metropolis (REF15). Not Marp (DC12).
- Navy full-bleed title (`pitch-title-slide`), navy frametitle, saffron progress; optional `card` / `keynum`.
- Flat deck: `new-section-slide-fn: none`. Footer with page number; title freezes the counter.
- 16:9.

## Poster

Structure for the Typst poster starter (no external TeX tree):

- Large landscape page.
- Title band, then a rule.
- Three columns of blocks. A block has a colored title bar and a light body.
- A figure scales to the column width.
- Colors from `theme/tokens.typ`.

## Cheat sheet

Layout target: `artifacts/python-cheat-sheet-format.png` (Laurent Pointal, Python 3 Cheat Sheet, Mémento v2.0.6, CC BY 4.0). Official page: https://perso.lisn.upsaclay.fr/pointal/python/memento/

The starter copies the layout, not the Python text.

- Landscape, one page unless the content needs another.
- A title bar across the top: document title, and a small credit or version line.
- Colored cards in a mosaic. A card has a colored header and a white body. A wide card may span more than one column. This is not a single equal three-column flow.
- Examples sit in monospace. A keyword, a string, and a comment can use three distinct colors.
- Thin rules separate rows inside a card.
- Type stays small. The sheet still has margins and does not clip a card.

Other popular sheets, not the starter:

- Winston Chang, LaTeX cheat sheet: landscape, three equal columns, little color. https://wch.github.io/latexsheet/
- CTAN `cheatsheet` class: landscape, a chosen column count, compact sections. https://ctan.org/pkg/cheatsheet

Use Pointal when the sheet is a dense colored reference. Use the plain three-column pattern only when the user asks for a printer-simple sheet.
