// Report page chrome: Fira, 2cm margins, running head + rule, centered page.
// Palette for headings, links, and captions comes from tokens.typ.
#import "tokens.typ": *

/// Page geometry + running head/footer only (no body text rules).
/// Use as `#show: report-page.with(...)` in Pandoc `--include-in-header`
/// so it runs *before* Pandoc's `conf()` title float. A later
/// `#show: report-setup` / `set page` in `--include-before-body` after that
/// title forces a nearly blank first page.
#let report-page(
  header-left: [Scratch report],
  header-right: [draft for review],
  paper: "a4",
  margin: report-margin,
  body,
) = {
  set page(
    paper: paper,
    margin: margin,
    header: {
      set text(size: 8.5pt, style: "italic", fill: muted, font: font-sans)
      grid(
        columns: (1fr, 1fr),
        align: (left, right),
        header-left,
        header-right,
      )
      v(2pt)
      line(length: 100%, stroke: 0.3pt + rule)
    },
    footer: context {
      set align(center)
      set text(size: 9pt, fill: muted, font: font-sans)
      counter(page).display()
    },
  )
  body
}

/// Body type, heading, link, and caption rules (no `set page`).
/// Pair with `#show: apply` from style-overrides.typ for tables/code.
#let report-style(
  text-size: report-text-size,
  body,
) = {
  set text(font: font-sans, size: text-size, fill: ink, weight: "regular")
  set par(justify: true, leading: 0.65em)
  set heading(numbering: "1.1")

  show heading: set text(font: font-sans, fill: navy, weight: "semibold")
  show link: set text(fill: navy-light)
  show figure.caption: set text(size: 0.9em, fill: muted)
  show figure.caption: it => {
    text(weight: "bold", fill: navy)[#it.supplement #context it.counter.display(): ]
    it.body
  }

  body
}

/// Full report chrome: page + body style. Use for hand-written `.typ` reports
/// (`direct.typ`). For Pandoc, prefer `report-page` in header-includes and
/// `report-style` in include-before-body (see `pandoc-page.typ`).
#let report-setup(
  header-left: [Scratch report],
  header-right: [draft for review],
  paper: "a4",
  margin: report-margin,
  text-size: report-text-size,
  body,
) = {
  show: report-page.with(
    header-left: header-left,
    header-right: header-right,
    paper: paper,
    margin: margin,
  )
  show: report-style.with(text-size: text-size)
  body
}
