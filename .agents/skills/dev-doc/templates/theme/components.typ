// Deck UI macros: badge, headline, keynum, card, source, tbd.
#import "tokens.typ": *

#let badge(fill, label) = box(
  fill: fill,
  inset: (x: 4pt, y: 2pt),
  radius: 1.5pt,
  text(fill: paper, size: 6.5pt, weight: "bold", font: font-sans, label),
)

#let demo = badge(ok-green, [DEMONSTRATED])
#let target = badge(target-blue, [TARGET SPEC])
#let roadmap = badge(roadmap-violet, [ROADMAP])
#let estimate = badge(muted, [ESTIMATE])

#let tbd(label) = text(fill: tbd-red, weight: "medium")[[TBD: #label]]

#let headline(body) = {
  text(font: font-sans, weight: "medium", size: 1.05em, fill: navy, body)
  v(0.55em)
}

#let keynum(value, label, source) = block(
  width: 100%,
  fill: surface,
  inset: (left: 10pt, rest: 8pt),
  radius: 3pt,
  stroke: (left: 3pt + saffron),
)[
  #text(font: font-sans, weight: "bold", size: 1.35em, fill: navy, value)
  #v(2pt)
  #text(size: 0.72em, fill: ink, label)
  #v(1pt)
  #text(size: 0.55em, fill: muted, source)
]

#let card(accent, title, body) = block(
  width: 100%,
  fill: surface,
  inset: (top: 10pt, rest: 8pt),
  radius: 3pt,
  stroke: (top: 2.5pt + accent),
)[
  #text(font: font-sans, weight: "medium", size: 0.85em, fill: navy, title)
  #v(3pt)
  #text(size: 0.72em, fill: ink, body)
]

#let source-line(body) = text(size: 0.55em, fill: muted)[Sources: #body]
