# Install the dev-doc tools

Draft of the skill file `references/install.md`. Covers the **core** path (Pandoc → Typst reports, Typst + Touying decks) on macOS, Ubuntu, and Windows. Marp is not installed (DC12).

Scratch on this machine used **Typst 0.15.1** and **Pandoc 3.13**. Prefer those or newer from the same major line. Package-manager versions can lag; when in doubt, use the official binary or installer.

## What you need

| Tool | Role | Required? |
|------|------|-----------|
| **Typst** CLI | Compile `.typ` reports, posters, cheat sheets, decks | Yes |
| **Pandoc** | Markdown → Typst (and DOCX / LaTeX structure exports) | Yes (reports + Office/LaTeX export) |
| **Fira Sans** + **Fira Mono** | Default theme fonts (`theme/tokens.typ`) | Yes for the default look |
| **Touying** | Slide theme (`@preview/touying`) | Yes for decks — fetched by Typst on first compile |
| PDF viewer | Open the formal preview | Yes (any system viewer) |
| **poppler** (`pdftoppm`) | Raster page previews for checks | Optional |
| TeX Live / BasicTeX / MiKTeX | Beamer/article **export** rebuild, or TeX-tree Fira | Optional (not needed for Typst PDF) |

Network: first `typst compile` of a deck downloads Touying into the Typst package cache. Offline machines need that cache already present.

## Quick check

After install:

```bash
typst --version
pandoc --version
typst fonts | grep -i fira
```

On Windows PowerShell, use `Select-String` instead of `grep`:

```powershell
typst fonts | Select-String -Pattern fira -CaseSensitive:$false
```

You want lines naming **Fira Sans** and **Fira Mono**. If missing, install the fonts (below) or pass `--font-path` / `TYPST_FONT_PATHS` to a folder of `.otf`/`.ttf` files.

---

## macOS

### Typst

```bash
brew install typst
```

Or download a binary from [Typst releases](https://github.com/typst/typst/releases) and put it on `PATH`. Update later with `typst update` when using the release binary.

### Pandoc

```bash
brew install pandoc
```

Or use the macOS installer from [pandoc.org/installing.html](https://pandoc.org/installing.html).

### Fira fonts

```bash
brew install --cask font-fira-sans font-fira-mono
```

Typst then finds them via the system font set. Alternative: copy OpenType files into `~/Library/Fonts`, or point at a TeX Live Fira tree:

```bash
typst compile --font-path /opt/homebrew/Cellar/texlive/*/share/texmf-dist/fonts/opentype/public/fira deck.typ
```

(Scratch `compile.sh` uses that TeX path when Homebrew fonts are absent.)

### Optional

```bash
brew install poppler          # pdftoppm
# TeX only if you will rebuild Beamer/article exports locally:
# brew install --cask basictex
```

---

## Linux (Ubuntu)

### Typst

Prefer a current binary (Ubuntu packages and snaps can lag):

```bash
# Official Snap (simple on Ubuntu)
sudo snap install typst

# Or: download the linux amd64 archive from
# https://github.com/typst/typst/releases
# unpack, then:
#   sudo install -m 755 typst /usr/local/bin/typst
```

Also: [Typst on Repology](https://repology.org/project/typst/versions), or `cargo install --locked typst-cli` with a Rust toolchain.

### Pandoc

Distro packages are often old. For a current release, install the `.deb` from [pandoc.org/installing.html](https://pandoc.org/installing.html):

```bash
# Replace $DEB with the downloaded pandoc-*-amd64.deb
sudo dpkg -i "$DEB"
```

Fallback (may be outdated):

```bash
sudo apt update
sudo apt install pandoc
```

### Fira fonts

```bash
sudo apt update
sudo apt install fonts-fira-sans fonts-fira-mono
# If those packages are missing on your Ubuntu release, install OpenType
# files into ~/.local/share/fonts/ and run:
#   fc-cache -fv
```

Verify with `typst fonts | grep -i fira`. Or pass `--font-path` to a directory of Fira `.otf` files (including a TeX Live `…/fonts/opentype/public/fira` tree if TeX is installed).

### Optional

```bash
sudo apt install poppler-utils   # pdftoppm
# TeX only for local LaTeX/Beamer rebuilds:
# sudo apt install texlive
```

---

## Windows (basic)

Prefer **winget** or the official installers. Run a new terminal after install so `PATH` updates.

### Typst

```powershell
winget install --id Typst.Typst
```

Or unpack the Windows archive from [Typst releases](https://github.com/typst/typst/releases) into a folder on `PATH`. Release builds support `typst update`.

### Pandoc

```powershell
winget install --source winget --exact --id JohnMacFarlane.Pandoc
```

Alternatives: the MSI from [pandoc.org/installing.html](https://pandoc.org/installing.html), or `choco install pandoc`.

### Fira fonts

1. Download **Fira Sans** and **Fira Mono** (Open Font License) from the [Fira project](https://carrois.com/fira/) or a known OFL release zip.
2. Select the `.otf` / `.ttf` files → right-click **Install** (or **Install for all users**).
3. Restart the terminal (and editor) so Typst rescans fonts.

If Typst still does not list Fira:

```powershell
$env:TYPST_FONT_PATHS = "C:\path\to\fira\otf"
typst fonts
typst compile deck.typ
```

(Or pass `--font-path` on each compile.)

### Optional

- **poppler:** e.g. `choco install poppler` or a Windows poppler build that provides `pdftoppm.exe` on `PATH`.
- **MiKTeX / TeX Live:** only if you rebuild LaTeX/Beamer exports on the machine ([pandoc installing notes](https://pandoc.org/installing.html)).

---

## Touying (no separate installer)

Decks import `@preview/touying`. On first compile, Typst downloads the package into its cache (needs network once). After that, compiles work offline for that package version.

Pinned in scratch: Touying **0.6.1** with Typst **0.15.1**. Bump the import only when you have checked the package against your Typst version.

## DOCX / Google Docs / LaTeX exports

| Export | Extra tools |
|--------|-------------|
| DOCX | Pandoc only (optional reference `.docx` later in the skill) |
| Google Docs | Produce DOCX, then open/upload in Drive (browser; no CLI plugin required) |
| LaTeX source | Pandoc `-t latex` or Beamer notes — **no** TeX install to *write* the `.tex` |
| Rebuild `.tex` → PDF | TeX Live / BasicTeX / MiKTeX on that OS (optional path) |

## Smoke test

```bash
# Report (Pandoc → Typst PDF)
pandoc report.md --standalone --pdf-engine=typst -o report.pdf

# Deck (Touying; add --font-path if Fira is not system-installed)
typst compile deck.typ
```

Open both PDFs in a viewer. Formal preview is the PDF, not Typst HTML (see browser notes).

## Sources

- Typst install: [typst/typst README](https://github.com/typst/typst/blob/main/README.md) (REF1)
- Pandoc install: [pandoc.org/installing.html](https://pandoc.org/installing.html) (REF4)
- Touying: [Typst Universe / Touying](https://typst.app/universe/package/touying/) (REF15)
- Theme fonts and `--font-path`: `artifacts/styling.md`
