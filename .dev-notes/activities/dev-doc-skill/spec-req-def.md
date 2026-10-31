# Requirement Definition

## Problem: Formal documents that survive export

Aparajit holds polished documents: a Beamer poster and presentation with a shared TikZ overlay rule, and a Pixhawk report built from Markdown. The revision workflow for later documents is Pandoc Markdown through Typst for reports, and Typst + Touying for decks. Marp was tried and dropped (DC12). LaTeX, Google Docs, and DOCX are produced only when a conversion is requested. Those exports can drop layout, style, or review markup unless the pitfalls are known. This activity records the problem, the solution, and the tool facts the skill will need. The skill is built in this playbook under `.agents/skills/`. Processor, RTOS, and PX4 scope stays unchanged.

## RD1: Revision workflow
- kind: end-user-interface
- revised-by: RU5.1
- A report is Pandoc Markdown. Pandoc's Typst writer compiles it (REF4). A hand-written `.typ` file is allowed when Markdown cannot express the layout.
- A slide deck is Typst + Touying (REF15). It is not Marp Markdown.
- Color values for one document are applied through shared Typst styles (`apply` / Touying `config-colors`) (REF2, REF15).

## RD2: Explicit conversions
- kind: end-user-interface
- LaTeX, Google Docs, DOCX, and other office formats are produced only when that conversion is requested.
- Those formats are not the files under revision.
- A Google or Microsoft plugin may perform a conversion on a machine that has it. The local Pandoc path remains the documented default (REF4, REF5).

## RD6: Office export keeps structure
- kind: end-user-interface
- revised-by: RU7.5, RU8.1, RU8.5, RU9
- A DOCX or Google Docs export keeps headings, lists, tables, images/diagrams, and code as styled text.
- DOCX quality bar (not presence-only):
  - **Data tables:** visible grid; header row **bold + background fill**.
  - **Code:** a **shaded/bordered code box** with line numbers — must **not** look like a multi-column data table.
  - **Figures and diagrams:** Markdown images and Office-export PNGs appear as drawings.
  - **Bibliography:** citeproc runs; a References section appears when the source cites keys.
  - **Captions:** figures and tables show **Figure N** / **Table N** labels with numbers.
  - **Sections:** section/subsection numbering in the DOCX (e.g. 1, 1.1).
  - **Lists:** bullet Markdown → bullets; ordered Markdown → numbered Word lists.
  - **Cross-refs:** figure/table/section references resolve to numbered text in the DOCX (export-time resolution is enough).
- Verify with precise asserts on a regenerated sample.
- Columns, card positions, and exact spacing may change. Apple Pages may view DOCX; disputed style → Word/LibreOffice.
- The Docs path follows REF5: edit the DOCX in place, or save a Docs copy. Tracked changes and suggestions follow REF6.

## RD7: LaTeX export keeps structure
- kind: end-user-interface
- revised-by: RU10.21
- A report, poster, or cheat sheet exports to a **full** LaTeX article source (`\documentclass{article}` / `pandoc --standalone -t latex`). A deck exports to Beamer frames.
- Body-only fragments without a document class do not meet this requirement.
- The export keeps headings, lists, tables, figures, and code. It does not rebuild the Typst or Touying page.
- The `visible on` overlay rule stays in the LaTeX notes for a hand-written Beamer file (REF7). Generated LaTeX does not have to use it.

## RD3: Skill files load per aspect
- kind: software-interface
- revised-by: RU7.2, RU8.3
- The skill is named **`dev-doc`** (folder `.agents/skills/dev-doc/`).
- On invoke: **ask once** which formats/features are needed (report PDF, deck PDF, poster, cheat sheet, HTML preview, DOCX, LaTeX, …), then scaffold at the **path the user names** with starters plus simple build/preview scripts for those choices. After setup, continue authoring **without** reloading the skill. Reinvoke only for conversion, preview/server help, install, or other pipeline tasks.
- The skill is split into files so an agent reads only what the current user task needs.
- `SKILL.md` is the router: short core workflow, then which side file to open for the task (preview, export, install, render pitfalls, starters).
- Conversion, browser preview, install, and long pitfall notes each live in their own file and stay unread unless that task is asked.
- Do not dump Drive steps, overlay rules, install matrices, or long checklists into the core.

## RD4: Tool facts come from the guides
- kind: internal-behavior
- Commands, style knobs, and pitfalls in the skill come from the cited usage guides (REF1–REF7) and from verified scratch renders (REF14).
- A claim that the guides do not support is left out. The built-in Typst Markdown parser in `doc-pipeline.md` is one such claim (REF8).
- A general render fix that helps a later agent is written into `artifacts/rendering-pitfalls.md` and becomes `references/rendering.md` in the skill.

## RD5: Starter kinds, used one at a time
- kind: end-user-interface
- revised-by: RU1.1, RU6.1
- The skill offers four starter kinds: a report, a slide deck, a poster, and a cheat sheet.
- A work starts with the one kind the user names. Other kinds are added when the user asks. A work is not required to hold all four.
- The report starter is Pandoc Markdown plus shared Typst theme. Poster and cheat sheet are Typst templates. The deck is Typst + Touying. Structures follow the local documents and `artifacts/starter-templates.md`.
- The cheat sheet follows the Pointal card layout (REF9). It does not follow the plain three-column sheet (REF11).
- Each starter accepts the document's colors. The default tokens are ink, primary, accent, surface, and muted. Primary is navy `#0B1F3A` and accent is saffron `#F29F05`, defined in `artifacts/scratch/theme/tokens.typ` (see `artifacts/styling.md`). The Python wording in REF9 is not reused.

## RD8: Browser preview
- kind: end-user-interface
- revised-by: RU5.1, RU7.1
- Browser preview is a first-class skill path. Notes live in `references/browser.md` and are read only for that task. The preview server binds `0.0.0.0` by default for remote hosts.
- **Reports — page-faithful:** Typst PDF via `typst compile` / `typst watch` (REF1).
- **Reports — structured HTML:** client Markdown→HTML (skill `preview/`) with theme tokens, figure/table numbers, citations, and bibliography. This HTML path is for reports only. One clear entrypoint (`serve.sh` at skill root and/or `preview/serve.sh`). Default URL opens the preview UI with assets resolving (no 404 for template images). On address-already-in-use, always print a check URL for the **port actually discussed**; choice (2) text must name the port being rebound (not a stale default); choice (1) may move to the next free port and print that URL.
- **Decks:** page-faithful Typst PDF only (`typst compile` / open the PDF). No Markdown→HTML, PDF-iframe UI, or PNG carousel in the skill for now. Typst `--features html` on Touying left an empty body in scratch — pitfall only (REF12, `artifacts/scratch/web-preview/deck-findings.md`).

## RD9: Rich blocks and cross-references
- kind: end-user-interface
- revised-by: RU5.1
- A Markdown report is converted with `pandoc --standalone`. The title and the contents list then appear. Without `--standalone`, both are absent.
- Tables have a visible grid. Pandoc's Typst template sets `stroke: none`, so the skill overrides it.
- A table caption is a line that starts with `: ` after the table. An image's alt text becomes the figure caption.
- The document can reference figures, tables, sections, and bibliography entries as needed. The skill documents the safe syntax for each.
- **Bibliography cites** in Pandoc Markdown use `[@key]` / `@key` with a bibliography file.
- **Figure, table, and section cross-refs** use Typst labels (`@label` in `.typ`, or a documented Markdown-safe pattern such as a labeled `{=typst}` figure). Bare `@name` in Markdown is always a cite, never a figure number — that Pandoc trap is called out so agents do not confuse the two.
- A fenced code block is highlighted with line numbers via Typst `apply` rules. It has no caption unless it is wrapped as a figure.
- Deck diagrams are Typst vector (Fletcher/CeTZ/Chronos) sized with `fit-box`. Optional PNG export at ≥300 ppi is only when a raster is required.
- Flowchart edge labels that enter a box are avoided. Path names sit as free labels clear of nodes.
- Typst styles are applied with `#show: apply` from an imported function. `#include` of a styles file does not style content that follows the include.
- Section numbers in Pandoc→Typst need YAML `section-numbering` (or `-V`); the template default is `none`.
