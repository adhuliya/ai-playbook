# Styling: change tokens consistently

Default look is fully defined under `artifacts/scratch/theme/`. Edit tokens there; do not look up aparajit `docs/` (CONV4).

| Surface | Where it lives | Look |
|---------|----------------|------|
| Report | `theme/report.typ` + tokens | Fira Sans / Mono, 10pt, 2cm margins, italic running head + 0.3pt rule, centered page number, navy links, bold caption labels |
| Deck | `theme/deck.typ` + `theme/components.typ` + tokens | Navy / saffron / ink / muted / surface / rule, Fira Sans Light + SemiBold, navy frametitle, saffron progress, full-bleed navy title, card / keynum / headline |

## Single source of truth

Edit **`artifacts/scratch/theme/tokens.typ` only** for colors and font family names.

| Token | Default | Role |
|-------|---------|------|
| `navy` | `#0B1F3A` | Primary / frametitle / headings |
| `navy-light` | `#1D3A63` | Title-page side panel, links |
| `saffron` | `#F29F05` | Accent / progress / list markers |
| `saffron-soft` | `#FDF1DC` | Soft fill behind saffron |
| `ink` | `#25303F` | Body text |
| `muted` | `#6B7787` | Secondary text, footer, heads |
| `surface` | `#F3F5F8` | Table header, code box, cards |
| `rule` | `#D5DBE3` | Borders / head rule |
| `font-sans` | `Fira Sans` | Body + UI |
| `font-mono` | `Fira Mono` | Code |

Do **not** paste `rgb("#…")` into `direct.typ`, `deck.typ`, `style-overrides.typ`, or Pandoc before-body. Import the token.

## Layer map

```
theme/tokens.typ          colors + font names + default sizes
theme/report.typ          report page chrome (header/footer/margins)
theme/deck.typ            Touying metropolis wiring + pitch title/divider
theme/components.typ      card, keynum, headline, badge
style-overrides.typ       apply + fit-box (tables, code) — imports tokens
```

- Report entry: `#show: report-setup.with(...)` then `#show: apply`.
- Deck entry: `#show: pitch-deck-setup.with(apply: apply, ...)` then `#pitch-title-slide()`.
- Pandoc: YAML `mainfont` / `margin` / … for the template title block; `--include-in-header=pandoc-page.typ` for `report-page` (before title); `--include-before-body=pandoc-before.typ` for `report-style` + `apply` (no second `set page`).

## How to restyle later

1. **Swap brand colors** — change hex values in `tokens.typ`. Recompile report and deck. Cards/keynums pick up accents via imports.
2. **Swap fonts** — change `font-sans` / `font-mono`. Ensure Typst can see the files (`--font-path` or system install). Update `compile.sh` / `TYPST_FIRA_PATH` if needed (`artifacts/install.md`).
3. **Report geometry** — `report-margin`, `report-text-size` in tokens, or pass `margin:` / `text-size:` into `report-setup.with(...)`. Header strings are arguments, not tokens.
4. **Deck chrome** — `pitch-deck-setup` maps tokens into Touying `config-colors` (`secondary` = navy frametitle, `primary` = saffron progress). Title page layout lives in `pitch-title-slide`; edit that function for a different title composition.
5. **Tables / code only** — edit `apply` in `style-overrides.typ`; keep using token names for fills and strokes.

## Compile with Fira

Fira may be a system font or a folder of OpenType files. Typst does not search a TeX tree unless you pass `--font-path`.

```bash
cd artifacts/scratch
./compile.sh all          # direct.pdf + deck.pdf
./compile.sh pandoc       # report-from-pandoc.pdf
# or:
export TYPST_FIRA_PATH=/path/to/fira/opentype
typst compile --font-path "$TYPST_FIRA_PATH" direct.typ
```

See `artifacts/install.md` for macOS / Ubuntu / Windows font install.

## Checklist after a restyle

1. Report PDF: Fira body, 2cm margins, ruled header, navy headings, surface table header, mono code gutter.
2. Deck PDF: navy title page + saffron rule, navy slide headers, saffron progress strip, Fira Light body, shared table/code look.
3. No hard-coded hex left outside `tokens.typ` (except temporary probes).
