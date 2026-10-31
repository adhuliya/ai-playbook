// Landscape poster: title band + three columns of cards.
#import "theme/tokens.typ": *
#import "style-overrides.typ": apply

#set page(paper: "a3", flipped: true, margin: 1.2cm)
#set text(font: font-sans, size: 11pt, fill: ink)
#show: apply

#let block-card(title, body) = block(
  width: 100%,
  stroke: 0.6pt + rule,
  radius: 3pt,
  clip: true,
)[
  #block(width: 100%, fill: navy, inset: 8pt)[
    #text(fill: paper, weight: "bold", size: 12pt, title)
  ]
  #block(width: 100%, fill: surface, inset: 10pt, body)
]

#block(width: 100%, fill: navy, inset: (x: 14pt, y: 12pt), radius: 3pt)[
  #text(fill: paper, weight: "bold", size: 22pt)[Sample poster]
  #h(1em)
  #text(fill: saffron, size: 12pt)[Doc pipeline · Typst starter]
]
#v(0.6em)
#line(length: 100%, stroke: 1.5pt + saffron)
#v(0.8em)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  block-card([Goals], [
    - One landscape page
    - Shared navy / saffron tokens
    - Three equal columns
  ]),
  block-card([Method], [
    Edit `theme/tokens.typ` for brand colors.
    Body text uses Fira Sans; code uses Fira Mono.
  ]),
  block-card([Results], [
    ```python
    print("poster ok")
    ```
    Export to LaTeX article only when asked.
  ]),
)
