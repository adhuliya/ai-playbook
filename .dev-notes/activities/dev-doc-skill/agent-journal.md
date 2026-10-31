# Journal

## Created: Documentation pipeline (→ Planning)

- goal: record the problem and the solutions for formal multi-format documents
- next: grill the typesetting engine

## Review: Optional starters and browser preview

- applied: RU1
- next: review the outline, then `approve-plan`

## Review: Scratch render hiccups

- applied: RU2
- evidence: `artifacts/scratch/direct.pdf`, `report-from-pandoc.pdf`, `deck.pdf`

## Review: Sharp diagrams and clear flow labels

- applied: RU3
- evidence: `artifacts/scratch/flow.png` at 300 ppi, free path labels

## Review: Skill notes for general render fixes

- applied: RU4
- evidence: `artifacts/rendering-pitfalls.md`

## Fix: Sequence diagram clipped on Marp slide

- cause: Chronos PNG taller than 16:9 content area; Marp img CSS did not cap height
- fix: `_par(..., show-bottom: false)` + `img { max-height: 380px; … }` in deck style
- evidence: `artifacts/scratch/deck.pdf` slide 7; note in `artifacts/rendering-pitfalls.md`

## Fix: Report figure width, code gaps, Pandoc section numbers

- cause: Fletcher wider than text measure; `raw.line` full-width boxes inherited `par.spacing`; Pandoc Typst default `sectionnumbering: none`
- fix: scale/tighten flow chart; number lines via `it.lines` in `apply`; YAML `section-numbering: "1.1"`
- evidence: `direct.pdf`, `report-from-pandoc.pdf`; notes in `artifacts/rendering-pitfalls.md`

## Fix: Marp deck code line numbers

- cause: Marp/highlight.js emits one `<code>` block; no built-in line-number fence
- fix: `marp-engine.mjs` wraps lines in `.code-line`; CSS counters; build with `--engine`
- evidence: `artifacts/scratch/deck.pdf` slide 4; note in `artifacts/rendering-pitfalls.md`

## Fix: Best-fit figures + tight Marp code rows

- cause: fixed `scale(72%)` / `%` widths undersized diagrams; Marp theme `pre`/`td` padding made numbered code look double-spaced
- fix: `fit-box` / `fit-image` (width target + height cap + optional no-upscale); deck code via Typst `code.png` (fixed export width); denser raw leading
- evidence: `direct.pdf`, `deck.pdf` slide 4; notes in `artifacts/rendering-pitfalls.md`

## Trial: Typst / Touying deck (drop Marp candidate)

- built: `artifacts/scratch/deck.typ` → `deck-touying.pdf` (7 slides, 16:9)
- uses: Touying 0.6.1 simple theme, shared `apply` + `fit-box`, vector Fletcher/CeTZ/Chronos
- gains vs Marp: line-numbered code without engine/PNG; diagrams stay vector; one style path with reports

## Decision: Drop Marp (RU5.1 / DC12 finalized)

- user: drop Marp; record the reason
- reason: third layout brain + CSS fights; no native line numbers; raster diagram shims; agent-unfriendly screenshot loop — see DC12
- applied: RD1/3/5/8/9, DC01–03/09/11/12, DD1–DD6, REF3/13 historical, REF15, CONV, rendering-pitfalls, M1/M2 tests
- evidence: `deck-touying.pdf`; Marp scratch kept only as superseded artifacts

## Port: Pitch + pixhawk styling into Typst pipeline (transfer gate)

- tokens: `artifacts/scratch/theme/tokens.typ` (navy/saffron/…, Fira)
- report: `theme/report.typ` — 2cm, running head, Fira (pixhawk); body via `apply`
- deck: Touying metropolis + `pitch-title-slide` / `card` / `keynum` (beamerthemeajitpitch)
- restyle: `artifacts/styling.md`; compile: `scratch/compile.sh` (`--font-path` TeX Fira)
- evidence: `direct.pdf`, `deck.pdf`, `report-from-pandoc.pdf`; previews `preview-style-*`
- gate: styling imitation accepted → activity ready to transfer out of repo; session end

## Draft: Cross-platform install guide for the skill

- wrote: `artifacts/install.md` → skill `references/install.md` (DD4, REF16, M1)
- covers: Typst, Pandoc, Fira Sans/Mono on macOS, Ubuntu, Windows; Touying via package fetch; optional poppler/TeX
- sources: Typst README, pandoc.org/installing, scratch versions 0.15.1 / 3.13

## Scrub: no skill dependency on aparajit `docs/`

- user: skill must not cite `docs/`; styling copy is done
- added: CONV4; starters/styling/REF7/activity scope point only at `artifacts/`
- transfer: still OK — activity is self-contained for ai-playbook

## Review: Plan pass agent-review (high level)

- applied: RU6 (all proposals)
- next: `approve-plan`

## Approved: Plan locked (Planning → Approved)

- milestones: 3 (M1 core/starters/browser, M2 conversions, M3 sample e2e)
- note: planning done; strong model optional

## Building: Start skill build (Approved → Active)

- skill: `.agents/skills/doc-pipeline/`
- continue: auto; user-away

## Milestone: M1 core skill (Active)

- evidence: `.agents/skills/doc-pipeline/scripts/verify.sh m1`
- paths: SKILL.md, templates/, preview/, references/{browser,rendering,install}.md

## Milestone: M2 conversions (Active)

- evidence: `verify.sh m2` → latex + docx structure
- paths: references/{latex,docx,gdocs}.md; sample/report.{tex,docx}

## Milestone: M3 sample e2e (Active)

- evidence: `verify.sh m3` / `verify.sh all` → VERIFY OK
- next: user reviews `artifacts/away-return.md`, then `mark-completed`

## Review: Preview UX, rename, rich DOCX (RU7)

- applied/planned: RU7 → M4; RD3/RD6/RD8, DC16–DC18
- next: build M4 (`dev-doc`, serve UX, rich DOCX)

## Milestone: M4 Apply RU7 (Active)

- evidence: `.agents/skills/dev-doc/scripts/verify.sh m4` / `all` → VERIFY OK
- paths: skill renamed `dev-doc`; rich DOCX; serve UX
- next: `mark-completed`

## Review: DOCX polish, serve, scaffold intake (RU8)

- planned → M5; RU8.4 noted (Pages OK)
- next: build M5

## Milestone: M5 Apply RU8 (Active)

- evidence: `dev-doc/scripts/verify.sh m5` / `all` → VERIFY OK
- next: `mark-completed`

## Review: DOCX scholarly structure (RU9)

- planned → M6 (bib, captions, section nums, lists, xrefs)
- next: build M6

## Milestone: M6 Apply RU9 (Active)

- evidence: `dev-doc/scripts/verify.sh m6` / `all` → VERIFY OK
- next: `mark-completed`

## Review: Objectives + skill-tree bloat (RU10)

- applied: RD7/DC22/latex full article; Traceability `dev-doc`; product → M7 (trim first)
- next: build M7

## Milestone: M7 Apply RU10 (Active)

- evidence: `dev-doc/scripts/verify.sh all` → VERIFY OK; collate pass after scaffold swatch join fix
- paths: sample binaries gitignored; pid junk gone; thinner docs; deck vector; scaffold assets/swatch
- next: `mark-completed`

## Review: Purge Marp from skill (RU11)

- planned → M8; skill-only (activity history kept)
- next: build M8

## Milestone: M8 Apply RU11 (Active)

- evidence: `rg -i marp .agents/skills/dev-doc` empty; `verify.sh all` → VERIFY OK
- next: `mark-completed`

## Complete: Formal docs skill (dev-doc) (Active → Complete)

Shipped `.agents/skills/dev-doc/`: Pandoc→Typst reports, Typst+Touying decks, posters/cheat sheets, report HTML preview, scholarly DOCX, standalone LaTeX/Beamer, feature-intake scaffold. Activity slug `dev-doc-skill`. Commits `fec9ca0` (skill), `e6467aa` (activity). Evidence: `cd .agents/skills/dev-doc && ./scripts/verify.sh all` → VERIFY OK. Guide: `artifacts/guide-for-users.md`. Accepted gaps: no deck HTML viewer; office exports are structure-only. Marp removed from skill tree (history retained in activity REF/DC).
