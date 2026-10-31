# Reviews

## RU1: Optional starters and browser preview

status: closed
scope: plan

state: Planning, no milestone checked. RU1 adds RD8 and replaces the four-starter club. DC08 replaces DC04. DD3, DD4, and DD5 match. Browser research is in REF12 and REF13.

- RU1.1 (user): The four starters are not a required set. A work starts with one kind and adds others when asked. — applied → RD5, DC08, DD3, M1
- RU1.2 (user): Document how to preview in a browser, including the server pitfalls, so a later agent can follow the research. — applied → RD8, DC09, DD4, DD5, REF12, REF13, M1

## RU2: Scratch render hiccups

status: closed
scope: plan

state: Planning. A scratch report and deck were compiled with Typst 0.15.1, Pandoc 3.13, and Marp CLI 4.5.1. RU2 records the failures as RD9.

- RU2.1 (user): Note render hiccups as requirements that smooth the pipeline. — applied → RD9, DC10, DD6, M2

## RU3: Sharp diagrams and clear flow labels

status: closed
scope: plan

state: Planning. Scratch diagrams were soft at low DPI, and the report edge label sat under Pandoc.

- RU3.1 (user): Raise diagram export resolution, and clear labels that hide behind the Pandoc block. — applied → RD9, DC11, artifacts/scratch/export-diagrams.sh

## RU4: Skill notes for general render fixes

status: closed
scope: plan

state: Planning. User asked that general adjustments useful to future agents be recorded for the skill.

- RU4.1 (user): Note general observations in the details that become part of the skill. — applied → RD4, CONV3, DD4, REF14, artifacts/rendering-pitfalls.md, M1

## RU5: Drop Marp; Typst / Touying decks

status: closed
scope: plan

state: Planning. Scratch Touying deck (`deck-touying.pdf`) matched the Marp sample with vector diagrams and numbered code. User approved dropping Marp.

- RU5.1 (user): Drop Marp. Keep Pandoc + Typst. Record the reason for the drop. — applied → RD1, RD3, RD5, RD8, RD9, DC01, DC02, DC03, DC09, DC11, DC12, DD1–DD6, REF3 (historical), REF13 (historical), REF15, CONV notes, M1 tests

## RU6: Plan pass agent-review (high level)

status: closed
scope: plan

state: Planning, stage design, no milestone checked. Since RU5: playbook transfer, report Markdown→HTML first-class (reports only), cross-ref cite-vs-label, file-split router, Pandoc blank-page fix, DC15 superseded for deck PNG/iframe. User asked high-level agent-review; chose all proposals (including M3 full RD6 DOCX).

- RU6.1 (agent-review): Report starter is Pandoc Markdown, not pure `.typ` — applied → RD5, DD3, M1
- RU6.2 (agent-review): Move RD9 polish tests into M1; keep M2 conversion-only — applied → M1, M2, Traceability RD9
- RU6.3 (agent-review): DC04 superseded; Pointal live under DC08 / DD3 — applied → DC04, DC08, DD3
- RU6.4 (agent-review): Next Steps mid-build resume contract — applied → agent-activity `# Next Steps`
- RU6.5 (agent-review): Drop superseded DC15 from DD5 cites — applied → DD5, DC15
- RU6.6 (agent-review): Remove DC11 from DD4 cites — applied → DD4
- RU6.7 (agent-review): CONV4 gated by `no-aparajit-docs` test — applied → M1, TC3
- RU6.8 (agent-review): Fill Traceability Paths — applied → Traceability
- RU6.9 (agent-review): RD3 load-shaped fake beside plugin stub — applied → M2, TC3
- RU6.10 (agent-review): Extend M3 e2e DOCX to full RD6 structure — applied → M3, TC6
- RU6.11 (agent-review): LaTeX article for poster or cheat sheet — applied → M2, TC7
- RU6.12 (agent-review): `typ-report-escape` unit — applied → M1, TC1
- RU6.13 (agent-review): RD9 caption and apply units in M1 — applied → M1, TC9

## RU7: Preview UX, skill rename, DOCX check, diagrams Q

status: closed
scope: milestones M1–M3

state: Active, M1–M3 checked. Skill shipped as `.agents/skills/doc-pipeline/`. User returned from away-return review with preview/serve UX, rename/usage, DOCX evidence, and a diagrams process question. Gap answer: on port busy, prompt choose between (1) keep/print URL or try next ports vs (2) kill our prior and rebind; always print URL.

- RU7.1 (user): `serve.sh` purpose unclear; directory listing at `http://localhost:8765/` is confusing; Address-already-in-use should fail gracefully (kill prior, free port, or print the URL of the running server) — planned → M4
- RU7.2 (user): Rename skill to `dev-doc`. Invoke once for starter structure + build plan for report/deck/other; continue authoring without the skill; reinvoke only for conversion or other pipeline tasks — planned → M4
- RU7.3 (user): Confirm DOCX conversion was tested and where to inspect the sample (or run the test if missing) — noted: tested; sample at skill `sample/report.docx`; M4 documents path and raises visual bar (RU7.5)
- RU7.4 (user): Question — what process creates the diagrams (curiosity; quality is good) — noted: Fletcher / CeTZ / Chronos in Typst (`diagrams.typ` + `fit-box`); optional brief note in rendering.md via M4
- RU7.5 (user): DOCX export is too thin: table grid lines missing, code lacks line numbers and a code box, figures missing. Need a better conversion (reference.docx / Pandoc/Word styling so structure survives with visible table rules, boxed numbered code, and images) — planned → M4 (RD6, DC16)

## RU8: DOCX polish, preview 404/port, scaffold intake, Pages

status: closed
scope: milestones M4

state: Active, M1–M4 checked. Skill is `dev-doc`. User reviewed rich DOCX, serve.sh, and wants a stronger one-shot feature intake that scaffolds at the user’s chosen location. Applied with no gaps; product → M5.

- RU8.1 (user): DOCX still weak — code looks like a plain table (want a real code box, not table chrome); data-table heading row lacks background/bold; still no diagrams in the Office export — planned → M5
- RU8.2 (user): Preview serve bugs — (a) choice 2 text says kill/rebind 8765 while server actually runs on 8766; (b) UI 404 for assets like `/templates/swatch.png`; also confusion between `./serve.sh` vs `./preview/serve.sh` — planned → M5
- RU8.3 (user): On `dev-doc` invoke, ask once which formats/features are needed, then create the setup at the location the user names, with simple scripts to build and preview all chosen formats — planned → M5 (RD3, DC20)
- RU8.4 (user): Viewing DOCX in Apple Pages on macOS — confirm that is acceptable — noted: Pages OK for viewing; disputed styling → check Word/LibreOffice; not a skill blocker
- RU8.5 (user): Raise the DOCX quality bar — no lame conversion. Revisit export logic (reference.docx, filters, figure/diagram pipeline) and replace weak XML-presence checks with **precise visual/structure asserts** backed by evidence ( regenerated sample + failing checks that catch missing header fill/bold, non-box code, missing diagrams) — planned → M5 (RD6, DC19)

## RU9: DOCX refs, captions, numbering, lists, cross-refs

status: closed
scope: milestones M5

state: Active, M1–M5 checked. User reviewed improved DOCX; remaining gaps are bibliography, caption labels/numbers, section numbering, list numbering fidelity, and cross-references. Applied with no gaps; product → M6. Cross-refs resolve to numbered Figure/Table/section text at export (native Word fields not required).

- RU9.1 (user): DOCX bibliography / references section is missing — planned → M6
- RU9.2 (user): Captions need “Figure” / “Table” labels and numbering so they can be referred to — planned → M6
- RU9.3 (user): Add section / subsection numbering in the DOCX — planned → M6
- RU9.4 (user): Bullet and numbered lists must convert faithfully (numbered Markdown → numbered Word lists) — planned → M6
- RU9.5 (user): Support cross-references in the document (figures/tables/sections) through to DOCX where feasible — planned → M6

## RU10: Objectives met + skill-tree bloat

status: closed
scope: milestones M1–M6; skill-tree bloat / RD3 file-split

state: Active, M1–M6 checked. Agent-review found green verify overclaiming some RDs and a bloated skill tree. Applied: full LaTeX article decision; product corrections → M7 (trim first). Nested M4–M6 boxes left as written (checked-milestone rule).

- RU10.1 (agent-review): Extend `verify.sh` m1 to assert each named M1 unit — planned → M7
- RU10.2 (agent-review): Add Reports/Decks Typst PDF section to `references/browser.md`; assert in m1 — planned → M7
- RU10.3 (agent-review): Add Fletcher/CeTZ/Chronos `fit-box` vector figure to `templates/deck.typ`; assert in m1 — planned → M7
- RU10.4 (agent-review): Assert Beamer export in `verify.sh` m2 — planned → M7
- RU10.5 (agent-review): Fix scaffolded workdir preview asset paths; m5 fails on missing `templates/…` — planned → M7
- RU10.6 (agent-review): Mark nested RU7–RU9 boxes under M4–M6 — noted: leave checked milestones as written (Reviews)
- RU10.7 (agent-review): Drop committed sample binaries/dupes; regenerate via verify; gitignore — planned → M7
- RU10.8 (agent-review): Delete `preview/.serve.pid*`; skill-local ignore — planned → M7
- RU10.9 (agent-review): Retarget rendering/install cites off activity `artifacts/` — planned → M7
- RU10.10 (agent-review): Thin `SKILL.md` DOCX to pointer at `references/docx.md` — planned → M7
- RU10.11 (agent-review): REF cites for core commands + guide-citation assert in m1 — planned → M7
- RU10.12 (agent-review): Strengthen poster/cheat → article LaTeX evidence — planned → M7
- RU10.13 (agent-review): Reuse M2 docx-structure checks inside M3 e2e — planned → M7
- RU10.14 (agent-review): Scaffold serve-preview keeps RD8 port UX — planned → M7
- RU10.15 (agent-review): Traceability paths: `doc-pipeline/` → `dev-doc/` — applied → Traceability RD1
- RU10.16 (agent-review): m6 docx-lists: assert bullet vs decimal numFmt — planned → M7
- RU10.17 (agent-review): One swatch path; drop dupes and unused timing.png — planned → M7
- RU10.18 (agent-review): `./serve.sh` sole entry; preview/serve.sh implementation-only — planned → M7
- RU10.19 (agent-review): Trim Marp autopsy / fat install matrix in side files — planned → M7
- RU10.20 (agent-review): Scaffold cited assets only; verify maintainer-only — planned → M7
- RU10.21 (agent-review): LaTeX export: full article vs fragment — applied → RD7, DC22, `references/latex.md`; planned asserts → M7

## RU11: Purge Marp from skill

status: closed
scope: milestones M7

state: Active, M1–M7 checked. User clarified: no Marp tool mentions in the **skill** only (activity history may keep DC12/REF audit). Applied via M8.

- RU11.1 (user): Purge Marp tool mentions from `.agents/skills/dev-doc/` (`install.md`, `rendering.md`, `refs.bib`) — applied → M8
