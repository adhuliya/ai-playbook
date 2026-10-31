# Plan Outline

The skill lets an author revise a report in Markdown and compile it with Typst (via Pandoc), and revise a slide deck in Typst with Touying. Marp is not used (DC12). It offers four starter kinds: a report, a poster, a cheat sheet, and a deck. A work starts with one kind and adds another when asked. Navy and saffron are the default colors.

Previews are first-class: Typst PDF (page-faithful) for reports and decks; structured Markdown→HTML for **reports only** (theme tokens, figure/table numbers, citations, bibliography; server on `0.0.0.0`). Decks open as Typst PDF — no deck HTML/PNG viewer in the skill for now. Typst’s own HTML export stays a pitfall note only (empty on Touying). Documents can cite the bibliography and cross-ref figures, tables, and sections; the skill documents cite vs label syntax (Pandoc `@key` is a cite, not a figure number).

Skill files are split so each user task loads only the files it needs (`SKILL.md` as router). A Markdown report uses a visible table grid, a contents list, and section numbers when set. Deck diagrams stay vector. LaTeX, Word, and Google Docs are produced only when asked, and they keep the text structure. The skill is built in this playbook under `.agents/skills/`. The last check builds the starter the work began with, and one Word file with heading, list, table, image, and styled code.

- Core, starters, browser (PDF + report HTML), RD9 polish (details: `agent-activity.md` M1)
  - M1: core router, Pandoc Markdown report starter, other starters, browser + HTML assets, rendering/install, rich-block tests — parts: report, deck, poster, cheat sheet, browser, rendering; tests: unit, integration
- Conversions only (details: `agent-activity.md` M2)
  - M2: LaTeX, Word, and Google Docs — parts: one file each; tests: unit, integration, fakes
- Sample (details: `agent-activity.md` M3)
  - M3: PDF for the starter in use, and a full-structure Word file — e2e: `sample-work`
- Decisions: Pandoc Markdown report default; Touying decks; report HTML beside PDF; cite vs label; file-split; RU6 applied.
- More: `agent-activity.md` `# Current Plan`
- Apply RU7 (details: `agent-activity.md` M4)
  - M4: rename to `dev-doc`, serve UX, rich DOCX — tests: unit, e2e
- Apply RU8 (details: `agent-activity.md` M5)
  - M5: precise DOCX, serve fixes, feature intake scaffold — tests: unit, e2e
- Apply RU9 (details: `agent-activity.md` M6)
  - M6: DOCX bib/captions/numbering/lists/xrefs — tests: unit, e2e

- M7: Apply RU10 (trim + objective gaps) — done
