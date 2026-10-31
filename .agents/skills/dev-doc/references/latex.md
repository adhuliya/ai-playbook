# LaTeX / Beamer export

Load only when the user asks for LaTeX or Beamer. Do not export by default.

## Structure (not page layout)

| Source kind | LaTeX shape |
|-------------|-------------|
| Report | full `article` (`\documentclass{article}`) |
| Poster | full `article` |
| Cheat sheet | full `article` |
| Deck | Beamer frames |

Exports keep headings, lists, tables, figures, and code. They do **not** rebuild the Typst or Touying page.

Report / poster / cheat sheet exports are **full article sources** (`pandoc --standalone -t latex`, or equivalent): the `.tex` must include `\documentclass{article}` (or a class that yields a complete article document). Body fragments without a document class do not meet RD7.

## Pandoc commands

```bash
# Report / poster / cheat sheet → full article
pandoc report.md --standalone -t latex -o report.tex
pandoc poster-notes.md --standalone -t latex -o poster.tex   # if content is Markdown

# Deck structure → Beamer (from Markdown outline or converted notes)
pandoc deck-outline.md -t beamer -o deck.tex
```

For a Typst-only poster or cheat sheet, export by translating content to Markdown/LaTeX structure, or use Pandoc on a Markdown twin — do not expect pixel-identical layout.

## Beamer overlays (hand-written only)

Wrapping a TikZ node in `\only` / `\uncover` drops its box; later overlays jump. Prefer `visible on=<spec>` / `invisible on=<spec>` (opacity 0, box kept).

A frame that uses `listings` style must be `\begin{frame}[fragile]`.

Generated LaTeX does **not** have to reproduce Typst overlays.

## Shared preamble note

One preamble / theme for a poster+presentation pair: input shared TeX **after** `\documentclass` (and after `beamerposter` on a poster). The shared file must not contain its own `\documentclass`.
