# Formal docs (dev-doc): User Guide

## What it does

**dev-doc** is an agent skill that sets up and converts formal documents without forcing one tool for every format:

- **Reports** — revise in Pandoc Markdown; PDF via Typst
- **Decks** — revise in Typst + Touying; PDF via Typst
- **Posters / cheat sheets** — Typst templates
- **On request** — Word (DOCX), LaTeX/Beamer, Google Docs (via DOCX), and report HTML preview

You pick formats once; the skill scaffolds a work folder with build/preview scripts. After that you author in that folder **without** keeping the skill loaded. Reinvoke only for export, preview/server help, install, or another starter kind.

Page layout of the Typst PDF is not preserved in office exports: those keep headings, lists, tables, figures, and code as structure.

## Skill structure

Installed under `.agents/skills/dev-doc/`:

| Path | Role |
|------|------|
| `SKILL.md` | Short router: first-invoke questions, when to reinvoke, pointers to side files |
| `templates/` | Starters (`report.md`, `deck.typ`, `poster.typ`, `cheatsheet.typ`), shared theme, Pandoc helpers, DOCX filters + `reference.docx`, diagram PNGs |
| `references/` | Task-scoped notes (browser, DOCX, LaTeX, Google Docs, install, render pitfalls) — open only when needed |
| `preview/` + `serve.sh` | Report Markdown→HTML preview UI; sole skill entry is `./serve.sh` |
| `scripts/scaffold.sh` | Creates a user workdir for the formats you named |
| `scripts/export-docx.sh` / `compile.sh` | DOCX export and sample compiles |
| `scripts/verify.sh` | Maintainer checks (regenerates `sample/` binaries; those files are gitignored) |
| `sample/` | Verify output only — see `sample/README.md` |

Agents should load `SKILL.md` first, then only the `references/*.md` file for the current task.

## How to use

### Prerequisites

Install Typst and Pandoc (see skill `references/install.md`). Optional: a TeX tree for Fira fonts used in samples. Do not install tools into the system unless you asked for that.

### First invoke (with an agent)

Say **dev-doc** (or ask to set up a report/deck). Answer once:

1. **Where** to create the work directory
2. **Which formats** among: `report`, `deck`, `poster`, `cheatsheet`, `html`, `docx`, `latex`

The agent runs (from the skill folder):

```bash
./scripts/scaffold.sh /path/you/named --formats=report,deck,html,docx
```

Then open that directory’s `BUILD.md` and use its `scripts/build.sh` / `scripts/serve-preview.sh`. Stop using the skill for day-to-day editing.

### Day-to-day in your workdir

```bash
./scripts/build.sh all          # or: report | deck | poster | cheatsheet | docx | latex
./scripts/serve-preview.sh      # report HTML only (if you scaffolded html)
```

- **Report source:** `report.md` (+ `refs.bib`, `assets/`)
- **Deck source:** `deck.typ`
- **Page-faithful preview:** open the PDF from `build.sh`, or `typst watch` / `typst compile` on a `.typ` file
- **Structured HTML preview (reports):** `serve-preview.sh` → `http://127.0.0.1:<port>/preview/`

### Cite vs cross-ref (reports)

| Intent | Markdown |
|--------|----------|
| Bibliography | `@key` or `[@key]` with `refs.bib` |
| Figure / table / section in DOCX | `{fig:id}` `{tbl:id}` `{sec:id}` — not `@` |
| Figure / table / section in Typst PDF | Typst `@label` in `.typ` or a documented `{=typst}` block |

Bare `@name` in Markdown is always a bibliography cite.

### Exports (reinvoke or run yourself)

- **DOCX:** `./scripts/build.sh docx` in the workdir, or skill `./scripts/export-docx.sh`. Expect numbered sections, Figure/Table N captions, styled tables/code, bibliography, and resolved `{fig|tbl|sec:…}` refs. Apple Pages is fine for viewing; disputed styling → Word/LibreOffice.
- **LaTeX:** full article (`pandoc --standalone -t latex`) for report/poster/cheat; Beamer for decks. Structure only — not a Typst page clone.
- **Google Docs:** build DOCX, upload to Drive, edit in place or Save as Google Docs (`references/gdocs.md`).

### Escape hatch

A hand-written `.typ` report is allowed only when Markdown cannot express the layout.

## How to test

From the skill folder:

```bash
cd .agents/skills/dev-doc
./scripts/verify.sh all
```

Expect `VERIFY OK (all)`. That regenerates PDFs/DOCX/TeX under `sample/` (gitignored).

Scaffold smoke:

```bash
./scripts/scaffold.sh /tmp/my-docs --formats=report,html,docx
cd /tmp/my-docs && ./scripts/build.sh report
```

## How to explain

**Pitch:** One skill scaffolds formal docs — Markdown→Typst reports and Typst/Touying decks — then stays out of the way while you write. Office and LaTeX are explicit exports that keep structure, not pixel layout.

**Demo (≈5 minutes):**

1. Scaffold `report,html,docx` into a temp folder  
2. `build.sh report` → open PDF  
3. `serve-preview.sh` → show HTML preview URL  
4. `build.sh docx` → open in Pages/Word; point at Figure N / References  

**Limits:** Decks have no HTML preview (PDF only). Marp is not supported. Exports drop columns/card positions/exact spacing. Maintainer `verify.sh` is for the skill tree, not required in every user workdir.
