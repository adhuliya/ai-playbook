# Install the dev-doc tools

Core path: **Typst**, **Pandoc**, and **Fira** fonts. Scratch used Typst 0.15.1 and Pandoc 3.13; prefer those or newer from the same major line.

## What you need

| Tool | Role | Required? |
|------|------|-----------|
| **Typst** CLI | Compile `.typ` reports, posters, cheat sheets, decks | Yes |
| **Pandoc** | Markdown → Typst (and DOCX / LaTeX structure exports) | Yes (reports + Office/LaTeX export) |
| **Fira Sans** + **Fira Mono** | Default theme fonts (`templates/theme/tokens.typ`) | Yes for the default look |
| **Touying** | Slide theme (`@preview/touying`) | Yes for decks — fetched by Typst on first compile |
| PDF viewer | Open the formal preview | Yes (any system viewer) |
| **poppler** (`pdftoppm`) | Raster page previews for checks | Optional |
| TeX Live / BasicTeX / MiKTeX | Beamer/article **export** rebuild, or TeX-tree Fira | Optional (not needed for Typst PDF) |

Network: first `typst compile` of a deck downloads Touying into the Typst package cache.

## Quick check

```bash
typst --version
pandoc --version
typst fonts | grep -i fira
```

Want lines naming **Fira Sans** and **Fira Mono**. If missing, install fonts below or pass `--font-path` / `TYPST_FONT_PATHS`.

---

## Core install

### macOS

```bash
brew install typst
brew install pandoc
brew install --cask font-fira-sans font-fira-mono
# optional: brew install poppler
```

Or use binaries from [Typst releases](https://github.com/typst/typst/releases) and [pandoc.org/installing.html](https://pandoc.org/installing.html).

### Linux (Ubuntu)

```bash
sudo snap install typst
# Prefer current Pandoc .deb from pandoc.org/installing.html
sudo apt update
sudo apt install fonts-fira-sans fonts-fira-mono
# optional: sudo apt install poppler-utils
```

Fallback: unpack Typst linux amd64 from releases into `/usr/local/bin`; `sudo apt install pandoc` if the distro package is acceptable.

### Fonts without a package

Copy Fira `.otf`/`.ttf` into the system font dir, or pass `--font-path` to a folder of those files (including a TeX Live `…/fonts/opentype/public/fira` tree if TeX is present).

## Touying (no separate installer)

Decks import `@preview/touying`. First compile needs network once; then offline for that package version. Pinned in templates: Touying **0.6.1** with Typst **0.15.1**.

## DOCX / Google Docs / LaTeX exports

| Export | Extra tools |
|--------|-------------|
| DOCX | Pandoc only |
| Google Docs | Produce DOCX, then open/upload in Drive |
| LaTeX source | Pandoc `-t latex` or Beamer — **no** TeX to *write* the `.tex` |
| Rebuild `.tex` → PDF | TeX Live / BasicTeX / MiKTeX (optional) |

## Smoke test

```bash
pandoc report.md --standalone --pdf-engine=typst -o report.pdf   # REF4
typst compile deck.typ                                           # REF1; add --font-path if needed
```

Formal preview is the PDF (see `references/browser.md`).

## Sources

- Typst install / CLI: [typst/typst README](https://github.com/typst/typst/blob/main/README.md) (REF1)
- Pandoc install: [pandoc.org/installing.html](https://pandoc.org/installing.html) (REF4)
- Touying: [Typst Universe / Touying](https://typst.app/universe/package/touying/) (REF15)
- Theme fonts: `templates/theme/tokens.typ`

---

## Appendix: Windows

Prefer **winget** or official installers. Open a new terminal after install.

```powershell
winget install --id Typst.Typst
winget install --source winget --exact --id JohnMacFarlane.Pandoc
```

Install **Fira Sans** and **Fira Mono** from an OFL release (right-click Install). If Typst still misses them:

```powershell
$env:TYPST_FONT_PATHS = "C:\path\to\fira\otf"
typst fonts
```

Optional: poppler for `pdftoppm`; MiKTeX / TeX Live only to rebuild LaTeX/Beamer PDFs.

## Appendix: optional TeX

Install TeX only to rebuild exported `.tex` → PDF locally:

- macOS: `brew install --cask basictex`
- Ubuntu: `sudo apt install texlive`
- Windows: MiKTeX or TeX Live
