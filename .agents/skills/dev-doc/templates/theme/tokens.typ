// Shared palette and type tokens.
// Source of truth for report + deck. Change values here only; do not
// hard-code rgb("#…") in report.typ, deck.typ, or style-overrides.typ.
// Restyle: edit a token below, then recompile. See ../../styling.md.

#let navy = rgb("#0B1F3A")
#let navy-light = rgb("#1D3A63")
#let saffron = rgb("#F29F05")
#let saffron-soft = rgb("#FDF1DC")
#let ink = rgb("#25303F")
#let muted = rgb("#6B7787")
#let surface = rgb("#F3F5F8")
#let rule = rgb("#D5DBE3")
#let paper = rgb("#FFFFFF")

#let ok-green = rgb("#2E8B57")
#let target-blue = rgb("#2F6DB5")
#let roadmap-violet = rgb("#7A5FA8")
#let tbd-red = rgb("#C0392B")

// Fira lives in the TeX tree. Pass --font-path to typst compile
// (see theme/fonts.typ and ../../styling.md).
#let font-sans = "Fira Sans"
#let font-mono = "Fira Mono"

#let report-text-size = 10pt
#let report-margin = 2cm
#let deck-text-size = 20pt
