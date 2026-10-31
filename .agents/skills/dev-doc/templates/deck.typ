// Deck starter: Typst + Touying metropolis + shared tokens.
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "style-overrides.typ": apply, fit-box, fit-image
#import "theme/deck.typ": pitch-deck-setup, pitch-title-slide, pitch-divider-slide
#import "theme/tokens.typ": navy, saffron, muted, ink, surface
#import "theme/components.typ": card, keynum, headline

#show: pitch-deck-setup.with(
  apply: apply,
  footer: [Sample deck · confidential draft],
  title: [Sample deck],
  subtitle: [Typst + Touying],
  author: [Doc pipeline],
)

#pitch-title-slide()

== Pipeline

#headline[One style path for reports and decks.]

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0.6em,
  card(navy, [Report], [Pandoc → Typst · report chrome · Fira]),
  card(saffron, [Deck], [Touying metropolis · navy title · saffron bar]),
  card(muted, [Tokens], [Edit theme/tokens.typ only]),
)

== Key numbers

#headline[Callouts use the shared `keynum` helper.]

#grid(
  columns: (1fr, 1fr),
  gutter: 0.8em,
  keynum([1 path], [Shared `apply` for tables and code], [style-overrides.typ]),
  keynum([2 cm], [Report margin · default geometry], [theme/report.typ]),
)

== Table

#align(center)[
  #table(
    columns: (1.1fr, 1fr, 1.6fr),
    align: left,
    table.header([Stage], [Tool], [What it keeps]),
    [Report], [Pandoc → Typst], [Page layout],
    [Deck], [Typst / Touying], [Slide layout],
    [Office], [Pandoc], [Structure],
  )
]

== Figure

#align(center)[
  #fit-image("assets/swatch.png", width: 45%, max-height: 55%, upscale: true)
  #v(0.4em)
  #text(size: 0.7em, fill: muted)[Navy and saffron swatch]
]

== Vector diagram

#headline[Fletcher vector sized with `fit-box`.]

#align(center)[
  #fit-box(
    {
      set text(size: 9pt)
      diagram(
        node-stroke: 0.8pt + navy,
        node-fill: surface,
        edge-stroke: 0.8pt + navy,
        spacing: (18mm, 10mm),
        node((0, 0), [Markdown], name: <md>, fill: white),
        node((1.4, 0), [Pandoc], name: <pd>, fill: luma(245)),
        node((2.8, 0), text(fill: white)[Typst], name: <ty>, fill: navy),
        node((4.0, 0), [PDF], name: <pdf>, fill: white),
        edge(<md>, <pd>, "-|>"),
        edge(<pd>, <ty>, "-|>"),
        edge(<ty>, <pdf>, "-|>"),
      )
    },
    width: 85%,
    max-height: 45%,
    upscale: true,
  )
]

== Code

```python
def greet(name: str) -> str:
    if not name:
        raise ValueError("empty name")
    return f"Hello, {name}"
```

#pitch-divider-slide([Appendix], subtitle: [Styling lives in theme/])
