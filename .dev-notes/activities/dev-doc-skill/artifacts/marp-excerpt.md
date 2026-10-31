# Marp excerpt (historical)

**Status:** Marp was dropped from the core pipeline (DC12 / RU5.1). Decks are Typst + Touying. This excerpt remains so agents know what was tried and why not to revive Marp without reading DC12.

Source: https://github.com/marp-team/marp-cli/blob/main/README.md and https://marpit.marp.app/directives and https://marpit.marp.app/theme-css

Kept: commands, theme knobs, and the export pitfalls that motivated the drop.

- One-shot convert, Node 18 or later: `npx @marp-team/marp-cli@latest slide-deck.md -o output.pdf`. Also `-o output.html` and `-o output.pptx`. Watch: `-w`. Preview server: `-s ./slides`.
- PDF, PPTX, and image export need Google Chrome, Microsoft Edge, or Firefox.
- A deck is Markdown split by `---`. Built-in themes: `default`, `gaia`, `uncover`.
- Per deck, the front matter picks the theme and can override CSS:

```markdown
---
theme: base-theme
style: |
  section { background-color: #ccc; color: #123; }
paginate: true
---
```

- A shared theme file is CSS passed as `marp --theme custom-theme.css` or `--theme-set ./themes`.
- `paginate: true` shows the page number and increments it. `false` hides it and still increments. `hold` shows it and does not increment. `skip` hides it and does not increment. Put `paginate` on the second slide, or use `_paginate: false`, to leave the title slide unnumbered.
- Page-number CSS must include `attr(data-marpit-pagination)` in `content`. If it does not, Marpit ignores the whole `content` declaration.
- Ordinary PPTX is rendered slide images. Text in that file is not editable. `--pptx-editable` needs the browser and LibreOffice Impress, drops presenter notes, and the Marp authors warn that complex CSS can fail or look wrong. Use it only when editability matters more than the look.
- Browser preview is server mode: `npx @marp-team/marp-cli@latest -s ./slides`, then open `http://localhost:8080/`. `PORT=5000` changes the port. The response is the render. Server mode does not write that HTML to disk.
- `index.md` or `PITCHME.md` in the served directory is the page at `/`.
- Add `?pdf` to the deck URL for a PDF response. PDF, PPTX, and images still need Chrome, Edge, or Firefox. HTML preview does not.
- An image is visible when it sits in the served directory or a subdirectory. `--allow-local-files` is for a local conversion of Markdown you trust. Do not use it to serve untrusted Markdown. Combined with HTML it can read files on the machine.
- Code line numbers are not built in. Use `--engine` with a functional engine that wraps each highlighted line, plus CSS counters (see scratch `marp-engine.mjs`). A plain deck `style` block cannot invent per-line gutters.
- Watch mode (`-w`) refreshes an HTML file you already opened. It is not the site. The watch socket is not a page to browse.
