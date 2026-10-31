# LaTeX and Beamer excerpt

Source: captured export rules for the skill (REF7). Self-contained — do not open aparajit `docs/` (CONV4). Read this only for an explicit LaTeX or Beamer conversion.

- Shared TeX for a poster or presentation: one preamble, one theme, optional macros/graphics, input **after** `\documentclass` (and after `beamerposter` on a poster). The preamble must not contain its own `\documentclass`.
- Theme colors: define a small set (e.g. primary, accent, light) plus per-part accents. Graphics should use those definitions so a restyle stays consistent.
- Beamer plus TikZ pitfall: wrapping a TikZ node in `\only` or `\uncover` drops its box, so later overlays jump. Prefer `visible on=<spec>` and `invisible on=<spec>` (opacity 0, box kept).
- A frame that uses the `listings` style (e.g. `asm`) must be `\begin{frame}[fragile]`.
- Optional alternate LaTeX report path: Pandoc → XeLaTeX with figures compiled one TikZ file at a time to PDF/PNG, then included. The **core** skill path is Pandoc → Typst, not that XeLaTeX tree.
