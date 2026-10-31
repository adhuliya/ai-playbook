// Shared Typst styles. Import `apply` and use `#show: apply`.
// Do not `#include` this file: set/show rules in an included file do not
// style content that follows the include in the parent document.
//
// Colors and fonts come from theme/tokens.typ — change tokens there, not here.

#import "theme/tokens.typ": *

/// Best-fit scale for a figure body (diagram or image).
///
/// Logic:
/// 1. Measure the body's natural size.
/// 2. Target width = `width` of the available layout (default full text width).
/// 3. Scale uniformly so the body meets that width (grow or shrink).
/// 4. If the scaled height would exceed `max-height` of the page content
///    area, shrink further so height wins (still uniform).
/// 5. `upscale: false` caps the factor at 100% (bitmaps that should not
///    be blown up). Diagrams usually leave `upscale: true`.
#let fit-box(
  body,
  width: 100%,
  max-height: 48%,
  upscale: true,
) = layout(size => {
  let natural = measure(body)
  if natural.width == 0pt or natural.height == 0pt {
    body
  } else {
    let resolve(dim, total) = {
      if type(dim) == ratio {
        dim * total
      } else if type(dim) == relative {
        dim.ratio * total + dim.length
      } else {
        dim
      }
    }
    let target-w = resolve(width, size.width)
    let target-h = resolve(max-height, size.height)
    let factor = target-w / natural.width
    if natural.height * factor > target-h {
      factor = target-h / natural.height
    }
    if not upscale {
      factor = calc.min(factor, 1.0)
    }
    scale(reflow: true, factor * 100%, body)
  }
})

/// Raster/vector file: same best-fit, but no upscale by default.
#let fit-image(path, width: 100%, max-height: 40%, upscale: false, ..args) = {
  fit-box(
    image(path, ..args),
    width: width,
    max-height: max-height,
    upscale: upscale,
  )
}

#let apply(body) = {
  set table(
    inset: 6pt,
    stroke: 0.45pt + rule,
    fill: (_, y) => if y == 0 { surface } else { none },
  )
  show table.cell.where(y: 0): set text(weight: "bold", fill: navy)

  show raw: set text(font: font-mono, size: 8.5pt)

  show raw.where(block: false): box.with(
    fill: surface,
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Do not style raw.line with box(width: 100%) under a document
  // `#set par(justify: true)`: each line becomes its own paragraph and
  // inherits large par.spacing. Number lines by iterating `it.lines`.
  show raw.where(block: true): it => {
    // Tight leading: 0.55em matched body text; 0.45em reads like an IDE.
    set par(leading: 0.45em, spacing: 0pt, justify: false)
    set align(left)
    block(
      width: 100%,
      fill: surface,
      stroke: 0.45pt + rule,
      inset: (x: 6pt, y: 5pt),
      radius: 3pt,
    )[
      #for line in it.lines {
        box(width: 100%)[
          #box(
            width: 2.0em,
            align(right, text(fill: muted, size: 7.5pt)[#line.number]),
          )
          #h(0.55em)
          #line.body
        ]
      }
    ]
  }

  body
}
