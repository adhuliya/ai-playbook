---
name: dev-view-md
description: >-
  Quickly view a markdown file that contains mermaid diagrams as a browsable
  HTML page, and/or extract its mermaid diagrams to standalone .mmd/.svg/.png
  files for outside use. Use when the user asks to preview, view, render, or
  open a markdown file (especially one with mermaid/diagrams), convert it to
  HTML, or extract/export its diagrams.
---

# dev-view-md

Two scripts in `scripts/`, runnable on macOS or Linux. Both degrade
gracefully (clear error + install hint, or a text fallback) instead of
hard-failing when an optional tool is missing.

## 1. HTML quick view (browser, link or local path)

```bash
scripts/view_html.sh FILE.md [--serve] [--remote] [--port N] [--no-open] [--out FILE.html]
```

- Default: writes `FILE.html` next to `FILE.md` (self-contained; vendored
  `mermaid.min.js` copied alongside it) and opens it as a `file://` path.
- `--serve`: starts a local HTTP server (`python3 -m http.server`, falling
  back to `npx http-server`) bound to `127.0.0.1` and opens/prints a
  `http://127.0.0.1:PORT/...` link — useful for keeping a stable link while
  re-running the script after edits.
- `--remote`: same as `--serve` but binds `0.0.0.0` instead, so other devices
  on your LAN can open it too; prints the machine's LAN IP in the URL when
  detectable. Implies `--serve`. Prints a warning since this exposes the
  server beyond localhost.
- An **Index** of headings through level 3 is placed at the top (`pandoc --toc`).
  Each entry links to that heading.
- Diagrams render client-side via mermaid.js — no `mmdc`/network needed.
- No `pandoc`? Falls back to a minimal built-in markdown→HTML converter
  (headings, index, fenced code, bold/italic, links) — degraded but functional.

## 2. Extract/convert diagrams for outside use

```bash
scripts/extract_diagrams.py FILE.md [--out-dir DIR] [--formats mmd,svg,png] [--no-install]
```

Writes `<name>_diagram<N>.<ext>` per mermaid block into `<md_basename>_diagrams/`
(or `--out-dir`). Raw `.mmd` source is always written; `.svg`/`.png` are
rendered via `mmdc` (mermaid-cli) when available. If `mmdc` is missing and
`npm` exists, it is auto-installed (`npm install -g @mermaid-js/mermaid-cli`).
Use `--formats mmd` to skip rendering entirely.

## Notes

- Both scripts share `scripts/mermaid_common.py` (mermaid fence parsing, mmdc
  discovery/auto-install/render).
- `scripts/vendor/mermaid.min.js` is the vendored mermaid.js used by the HTML
  view. If missing, `build_html.py` falls back to loading it from a CDN.
- Install hints printed on failure:
  - macOS: `brew install pandoc`, `brew install node`
  - Linux: `sudo apt install pandoc nodejs npm`
