# Design Decisions

## DC01: Pandoc + Typst revise; other formats export
- level: design-choice
- revised-by: RU5.1, DC12
- chosen: Pandoc Markdown → Typst for reports (and Typst for poster/cheat sheet). Decks are Typst + Touying. LaTeX, Google Docs, and DOCX are explicit exports. Marp is not in the revision path.
- why: one layout engine for reports and decks. See DC12 for why Marp was dropped.
- alternatives:
  - Typst and Marp as dual core (earlier DC01): dropped — RU5.1.
  - XeLaTeX and Beamer as the revision path: LaTeX stays an export (REF7).
  - Typst's built-in Markdown parser, as `doc-pipeline.md` states: not in the Typst reference (REF8).

## DC02: One skill file per aspect
- level: design-choice
- revised-by: RU5.1
- chosen: a core file for Pandoc Markdown reports and Typst (including Touying decks). Separate files for LaTeX, Google Docs, and DOCX. A conversion file is read only for that conversion.
- why: the user asked that Google Docs notes be loaded only when converting to Google Docs. The same split keeps LaTeX and DOCX pitfalls out of the core revision steps.
- alternatives:
  - one file for every format: every revision would carry export pitfalls the current task does not use.
  - core still names Marp: obsolete after RU5.1.

## DC03: Report Markdown vs deck Typst
- level: design-choice
- revised-by: RU5.1, DC12
- chosen: a report is Pandoc Markdown compiled to Typst. A deck is Typst source with Touying (not Markdown). Shared color tokens go into one Typst style (`apply` / theme config). A hand-written `.typ` report is allowed when Markdown cannot express the layout.
- why: Pandoc is the Markdown→Typst bridge for prose reports (REF4). Decks need Typst layout control; Touying proved it in scratch (`deck-touying.pdf`). Marp's separate Markdown dialect is gone (DC12).
- alternatives:
  - Marp Markdown decks (earlier DC03): dropped — RU5.1.
  - Typst source for reports too: drops the Markdown report role the user kept.

## DC04: Four starters, Pointal cheat sheet
- level: design-choice
- status: superseded
- revised-by: RU1.1, RU6
- chosen: (superseded) Four starters as a required club — replaced by DC08. Pointal cheat-sheet look (landscape card mosaic, optional card span, keyword color ≠ accent) remains normative in RD5 / DD3.
- why: RU1.1 / DC08 — work starts with one kind; club rejected.
- alternatives:
  - report and deck only: leaves out the poster and the sheet the user asked to include.
  - Winston Chang's equal three columns (REF11): a popular programming sheet, and a poorer match to REF9.

## DC08: Start with one starter
- replaces: DC04
- revised-by: RU1.1, RU6
- level: design-choice
- chosen: the skill keeps four starter kinds available. A work starts with the kind the user names. Further kinds are added when asked. Cheat sheet follows Pointal mosaic (REF9); card may span; keyword color separate from accent (from superseded DC04).
- why: the user said the four are not a required set.
- alternatives:
  - every work includes all four: the rejected club.
  - the skill offers only one kind: a later kind becomes a new design.

## DC09: Browser preview notes
- revised-by: RU1.2, RU5.1
- level: design-choice
- chosen: `references/browser.md` is read only when a browser preview is requested. Page-faithful view is the Typst PDF (reports and decks). Structured HTML is a first-class Markdown→HTML path for **reports only** (not Typst HTML export). Marp server-mode notes are historical only (REF13).
- why: user asked for report HTML as a proper skill path; deck HTML/PNG deferred; Typst HTML export is still incomplete (REF12).
- alternatives:
  - preview steps inside the core file: every revision would carry server pitfalls.
  - Typst HTML as the only browser path: incomplete and not page-faithful (REF12).

## DC10: Override the borderless Typst table
- revised-by: RU2.1
- level: design-choice
- chosen: the Markdown-to-Typst path keeps Pandoc's standalone template and sets table stroke to a visible grid. Captions use Pandoc's `: ` line for tables and the image alt text for figures. Bibliography cites use `[@key]`; figure/table/section refs use Typst labels (documented), not bare Pandoc `@name` as a figure pointer.
- why: a scratch compile on Typst 0.15.1 showed a borderless table, a missing contents list without `--standalone`, and a failed compile when `@stages` became `#cite`.
- alternatives:
  - accept `stroke: none`: the table does not match the direct Typst sample.
  - write the whole report as `.typ` and skip Pandoc: drops the Markdown report role in DC03.

## DC11: Diagram fit and clear flow labels
- revised-by: RU3.1, RU5.1
- level: major-implementation-detail
- chosen: draw Fletcher/CeTZ/Chronos in Typst and embed as vector in reports and Touying decks. Use `fit-box` / `fit-image` for best-fit scale. Flow path names are free labels. Styles use `#import "...": apply` and `#show: apply`. Optional PNG at ≥300 ppi only when a raster is required.
- why: decks no longer need Marp raster shims (RU5.1). Reports still benefit from `fit-box`. Free labels avoid Fletcher clip under nodes.
- alternatives:
  - PNG-only for every slide figure: needed under Marp; obsolete for Touying.
  - edge labels with `label-pos` near the source: still clipped nodes in scratch.

## DC12: Drop Marp; decks are Typst + Touying
- level: design-choice
- revised-by: RU5.1
- status: finalized
- replaces: Marp half of earlier DC01 and DC03
- chosen: Marp is removed from the revision workflow. A deck is Typst + Touying (`artifacts/scratch/deck.typ`). Reports stay Pandoc Markdown → Typst. Core tools are Pandoc and Typst only.
- why (reason for the drop):
  1. **Third layout brain.** Marp CSS/theme defaults fought agent edits (code line height, `pre code { display: inline }`, table zebra on line gutters).
  2. **No native line numbers.** Needed a custom `--engine` or a Typst PNG shim to match report listings.
  3. **Diagrams forced through raster.** Vector Fletcher/CeTZ/Chronos had to become 300 ppi PNGs, with clip/`max-height` traps on 16:9 slides.
  4. **Agent unfriendly.** Fixes showed up only after PDF screenshots; Pandoc+Typst(+Touying) share one `apply` / `fit-box` path and compile errors stay in one ecosystem.
  - Scratch proof: Touying deck has numbered code and vector figures without Marp (`deck-touying.pdf`).
- alternatives:
  - keep Marp for Markdown-native slides: rejected — RU5.1.
  - Quarto for both: not chosen; still another stack on top of Pandoc.

## DC05: Navy and saffron defaults
- level: design-choice
- chosen: five tokens, `ink`, `primary`, `accent`, `surface`, `muted`. Defaults match the investor deck: primary `#0B1F3A`, accent `#F29F05`, ink `#25303F`, muted `#6B7787`, surface `#F3F5F8`. A document may replace any token. Cheat-sheet cards use these tokens and tints of primary and accent, unless the document supplies more hues.
- why: the user chose the pitch-deck pair as the starter default. The poster blue and amber stay available as a per-document override.
- alternatives:
  - poster blue `#00468C` and amber `#C87800`: the shared poster theme, not the chosen default.
  - neutral ink and one blue: drops the saffron accent until a document sets it.

## DC06: Office export keeps structure
- level: design-choice
- status: superseded
- revised-by: RU7.5
- chosen: (superseded) Structure-only DOCX without visual fidelity bar — replaced by DC16.
- why: RU7.5 — bare Pandoc DOCX lacked table rules, code box/line numbers, and reliable figures.
- alternatives:
  - match the PDF, including columns and cards: the office formats do not offer that.

## DC16: Richer DOCX conversion
- replaces: DC06
- revised-by: RU7.5
- status: superseded
- chosen: (superseded) First rich-DOCX pass — table grid + 2-col numbered code + Markdown image. Replaced by DC19 after RU8 visual review.
- why: RU8.1/RU8.5 — code looked like a data table; header unstyled; no diagrams.
- alternatives:
  - structure-only XML presence checks: rejected.

## DC19: Precise DOCX conversion and checks
- replaces: DC16
- revised-by: RU8.1, RU8.5
- level: design-choice
- chosen: DOCX export must deliver (1) data tables with **header bold + fill** and grid, (2) **code as a shaded/bordered box** with line numbers **without** multi-column table chrome, (3) **diagrams** as embedded drawings (PNG twins from Typst diagrams for Office). Verify with precise XML/style asserts + regenerated `sample/report.docx`. Pages OK to view; Word/LibreOffice for style disputes.
- why: RU8.1 / RU8.5 — no lame conversion.
- alternatives:
  - keep 2-column code tables: rejected (looks like data).
  - PDF-only for diagrams: rejected for Office path.

## DC07: LaTeX export keeps structure
- level: design-choice
- chosen: a report, poster, or cheat sheet becomes a LaTeX article. A deck becomes Beamer frames. The export keeps headings, lists, tables, figures, and code, and it does not rebuild the Typst/Touying layout. The overlay rule in REF7 stays in the LaTeX notes for hand-written Beamer.
- why: the user chose a structure source. Pandoc already writes LaTeX and Beamer. Rebuilding the poster in TikZ would fight DC01.
- alternatives:
  - generated LaTeX rebuilds the poster and the deck, including TikZ and overlays: a second typesetting path.
  - drop LaTeX from the skill: the user still wants that conversion.

## DC13: Structured HTML preview is first-class
- level: design-choice
- chosen: ship a Markdown→HTML browser preview (from `artifacts/scratch/web-preview/`) as part of the skill for **reports only**. Bind `0.0.0.0` by default. Keep Typst PDF as the page-faithful preview for reports and decks. Treat Typst `--features html` as a pitfall note only. Do not ship deck.html / PNG carousel as skill assets.
- why: user rejected “experimental only” for report HTML; later chose report HTML only (deck extras deferred).
- alternatives:
  - PDF-only browser story: rejected for reports.
  - Deck PDF-iframe / PNG viewer in the skill: deferred (see superseded DC15).
  - Typst HTML export as the skill HTML path: incomplete (REF12).

## DC15: Deck browser via PDF (and optional PNG slides)
- level: design-choice
- status: superseded
- revised-by: RU6
- chosen: (historical only — non-normative) Explored PDF-iframe / PNG carousel for decks. Not skill policy. Live rule: decks = Typst PDF; report HTML only (DC13 / DD5). Scratch: `web-preview/deck.html`, `deck-findings.md`.
- why: user chose report HTML only; RU6 dropped DC15 from DD5 cites.
- alternatives:
  - PDF embed + PNG slides in the skill: deferred.
  - Typst HTML for decks: empty body in probe.
  - Bring back Marp `-s` for HTML slides: rejected (DC12).

## DC17: Preview server UX and port conflict
- revised-by: RU7.1
- level: major-implementation-detail
- chosen: `serve.sh` documents purpose; default URL opens the report preview UI (index), not a bare listing. On port-in-use: always print a check URL; interactively offer (1) keep existing / try next free ports, or (2) kill our recorded prior PID and rebind. Never kill an unrelated process without that choice.
- why: RU7.1 — Address-already-in-use and confusing directory listing.
- alternatives:
  - always kill whatever holds the port: unsafe.
  - fail only with a message: weaker than offering a choice.

## DC18: Skill name `dev-doc` and one-shot setup usage
- revised-by: RU7.2, RU8.3
- level: design-choice
- chosen: skill id/folder is `dev-doc`. First invoke runs a **feature intake**, then scaffolds at the **user-named path** with scripts for chosen formats; authoring continues without the skill; reinvoke for conversion/preview/install/pipeline tasks only.
- why: RU7.2 + RU8.3 usage model.
- alternatives:
  - keep name `doc-pipeline`: rejected.
  - require the skill on every edit turn: rejected.
  - always scaffold only inside the skill tree: rejected (RU8.3).

## DC20: Preview server root and port messaging
- revised-by: RU8.2
- level: major-implementation-detail
- chosen: single clear serve entry; HTTP root such that preview + `templates/` assets resolve (no swatch 404); port-busy prompts always cite the **relevant** port (busy port and/or port actually started).
- why: RU8.2.
- alternatives:
  - serve only `preview/` and ignore outside assets: rejected.

## DC21: DOCX scholarly structure
- revised-by: RU9
- level: design-choice
- chosen: DOCX export runs citeproc + section numbering; figures/tables get Figure/Table numbers; ordered/bullet lists preserved; cross-refs resolve to numbered labels at export (not requiring live Word REF fields).
- why: RU9.1–RU9.5.
- alternatives:
  - leave cites/captions Typst-only: rejected for Office path.
  - require pandoc-crossref binary: optional; skill ships a Lua filter so it works without extra installs.

## DC14: Cite vs label for cross-references
- level: design-choice
- chosen: documents may cite bibliography keys and cross-ref figures, tables, and sections. Skill docs spell the syntax. Pandoc Markdown `@name` / `[@name]` is bibliography only; Typst `@label` (in `.typ` or documented Markdown-safe form) is for numbered objects.
- why: user needs full cross-refs; the old “no `@name`” line was a Pandoc trap, not a ban on references.
- alternatives:
  - ban all `@` in Markdown: blocks bibliography cites the pipeline already uses.
  - rely on Pandoc `@fig` for figures: Pandoc treats it as a cite and breaks Typst without a bib entry.

## DC22: LaTeX article is a full document
- level: design-choice
- replaces: (clarifies DC07)
- revised-by: RU10.21
- chosen: Pandoc LaTeX export for report/poster/cheat uses `--standalone` (or equivalent) so the `.tex` is a complete article with `\documentclass`. Fragments are rejected by verify.
- why: RU10 reco; RD7 “article source” means a compilable article, not a body snippet.
- alternatives:
  - body fragment only: lighter file, fails “article source” wording and Beamer/article symmetry.
