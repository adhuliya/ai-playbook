// Pointal-style landscape cheat sheet: title bar + colored card mosaic.
#import "theme/tokens.typ": *
#import "style-overrides.typ": apply

#set page(paper: "a4", flipped: true, margin: 0.7cm)
#set text(font: font-sans, size: 8pt, fill: ink)
#show: apply

#let keyword = rgb("#0B7A75") // distinct from accent (saffron)

#let sheet-card(accent, title, body, span: 1) = grid.cell(
  colspan: span,
  block(
    width: 100%,
    height: 100%,
    stroke: 0.4pt + rule,
    radius: 2pt,
    clip: true,
  )[
    #block(width: 100%, fill: accent, inset: (x: 6pt, y: 4pt))[
      #text(fill: paper, weight: "bold", size: 8.5pt, title)
    ]
    #block(width: 100%, fill: paper, inset: 6pt, body)
  ],
)

#block(width: 100%, fill: navy, inset: (x: 10pt, y: 7pt), radius: 2pt)[
  #text(fill: paper, weight: "bold", size: 14pt)[Sample cheat sheet]
  #h(1fr)
  #text(fill: paper.transparentize(20%), size: 8pt)[v0.1 · Pointal mosaic layout]
]
#v(0.45em)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  rows: (auto, auto),
  gutter: 6pt,
  sheet-card(navy, [Basics], [
    - Start with one starter kind
    - Reports: Pandoc Markdown → Typst
    - Decks: Typst + Touying
  ]),
  sheet-card(saffron, [Compile], [
    `typst compile file.typ`\
    `pandoc … --pdf-engine=typst`
  ]),
  sheet-card(navy-light, [Tokens], [
    Primary `#0B1F3A` · Accent `#F29F05`\
    Edit `theme/tokens.typ` only
  ]),
  sheet-card(muted, [Preview], [
    PDF for reports and decks\
    HTML browser for *reports* only
  ]),
  sheet-card(keyword, [Code colors], [
    Keyword ≠ accent. Example:\
    ```python
    x = "str"  # comment
    ```
  ], span: 2),
  sheet-card(navy, [Wide card], [
    A card may span more than one column (Pointal mosaic).
    Thin rules separate dense rows inside a card when needed.
  ], span: 2),
)
