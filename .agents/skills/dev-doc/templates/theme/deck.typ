// Touying metropolis + navy/saffron deck chrome:
// navy frametitle, saffron progress, Fira Sans, full-bleed title.
#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "tokens.typ": *
#import "components.typ": *

/// Shared init: Fira + pitch colors + report `apply` for tables/code.
/// Pass the imported `apply` from style-overrides.typ.
#let pitch-deck-setup(
  apply: body => body,
  footer: [Scratch deck · confidential draft],
  title: [Scratch deck],
  subtitle: [Typst + Touying],
  author: [Doc pipeline],
  date: none,
  body,
) = {
  set text(font: font-sans, weight: "light", size: deck-text-size, fill: ink)
  set strong(delta: 300)
  show: metropolis-theme.with(
    aspect-ratio: "16-9",
    footer: footer,
    footer-progress: true,
    config-common(new-section-slide-fn: none),
    config-info(
      title: title,
      subtitle: subtitle,
      author: author,
      date: date,
    ),
    config-colors(
      primary: saffron,
      primary-light: saffron-soft,
      secondary: navy,
      neutral-lightest: paper,
      neutral-dark: navy-light,
      neutral-darkest: ink,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: font-sans, weight: "light", size: deck-text-size, fill: ink)
        show heading: set text(fill: navy, weight: "semibold")
        set list(marker: text(fill: saffron)[▶])
        show: apply
        body
      },
    ),
  )
  body
}

/// Full-bleed navy title page with saffron rule.
#let pitch-title-slide(
  title: none,
  subtitle: none,
  author: none,
  date: none,
) = touying-slide-wrapper(self => {
  let info = self.info
  let t = if title != none { title } else { info.title }
  let s = if subtitle != none { subtitle } else { info.subtitle }
  let a = if author != none { author } else { info.author }
  let d = if date != none { date } else { info.date }

  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: navy,
      margin: 0pt,
      header: none,
      footer: none,
    ),
  )

  let body = {
    place(right, rect(width: 28%, height: 100%, fill: navy-light))
    pad(left: 1.4cm, top: 2.8cm, right: 3.2cm, bottom: 1.5cm)[
      #block(width: 2.4cm, height: 3pt, fill: saffron)
      #v(0.55em)
      #text(font: font-sans, weight: "bold", size: 28pt, fill: paper, t)
      #if s != none {
        v(0.45em)
        text(font: font-sans, weight: "medium", size: 16pt, fill: saffron, s)
      }
      #v(1.4em)
      #if a != none {
        text(size: 12pt, fill: paper, a)
      }
      #if d != none {
        v(0.25em)
        text(size: 10pt, fill: paper.transparentize(25%), d)
      }
    ]
  }
  touying-slide(self: self, body)
})

/// Navy divider slide (appendix / section break).
#let pitch-divider-slide(title, subtitle: none) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: navy, margin: 0pt, header: none, footer: none),
  )
  let body = {
    pad(left: 1.4cm, top: 3.2cm)[
      #block(width: 2.4cm, height: 3pt, fill: saffron)
      #v(0.5em)
      #text(font: font-sans, weight: "bold", size: 26pt, fill: paper, title)
      #if subtitle != none {
        v(0.4em)
        text(font: font-sans, weight: "medium", size: 14pt, fill: paper.transparentize(30%), subtitle)
      }
    ]
  }
  touying-slide(self: self, body)
})
