# dev-doc skill

| Key | Value |
|---|---|
| status | Complete |
| kind | full |
| stage | design |
| conventions | ok |
| review-comments | on |
| continue | auto |
| slug | dev-doc-skill |
| branch | none |
| base-branch | main |
| ticket | none |
| notes | Shipped `.agents/skills/dev-doc/`. Evidence: `verify.sh all`. |

# Goal

A skill revises a report in Pandoc Markdown through Typst and a deck in Typst + Touying, offers four starter kinds used one at a time, supports page-faithful PDF for reports and decks plus structured HTML browser preview for reports only, allows cites and cross-refs to figures/tables/sections/bibliography, loads skill files only as needed per task, and exports LaTeX, DOCX, and Google Docs as structure only (RD1–RD9).

# Scope

The skill covers revision and four starter kinds. A work starts with one kind and adds others when asked. Browser notes cover Typst PDF (reports and decks) and Markdown→HTML for reports (bind `0.0.0.0`). Decks have no HTML/PNG viewer in the skill. Cross-ref and cite syntax is documented (cite vs label). Skill files are split per task. LaTeX, DOCX, and Google Docs are explicit structure exports. Skill code lives under `.agents/skills/dev-doc/`. Aparajit processor, RTOS, and PX4 work stays out of scope.

# Background and Special Notes

Pandoc + Typst for reports; Typst + Touying for decks (DC01 / DC12). Usage facts in REF1–REF16. Render lessons in `artifacts/rendering-pitfalls.md` (mirrored in skill `references/rendering.md`). Default tokens in `artifacts/styling.md` / skill `templates/theme/`. LaTeX full standalone article (DC22). Google Docs via DOCX upload (REF5).

# Current Design

See `spec-design.md`.

# Current Plan

Maintenance: skill at `.agents/skills/dev-doc/`. Reopen with `resume-work` for in-scope fixes.

# Milestones

- [x] M1: Core router, starters, browser, RD9 polish, install — evidence: `cd .agents/skills/dev-doc && ./scripts/verify.sh m1`
- [x] M2: LaTeX / DOCX / GDocs conversion files — `./scripts/verify.sh m2`
- [x] M3: Sample PDF + structured DOCX e2e — `./scripts/verify.sh m3`
- [x] M4: Rename `dev-doc`, serve UX, rich DOCX — `./scripts/verify.sh m4`
- [x] M5: Precise DOCX, serve assets, feature-intake scaffold — `./scripts/verify.sh m5`
- [x] M6: Scholarly DOCX (bib, captions, sections, lists, xrefs) — `./scripts/verify.sh m6`
- [x] M7: Trim skill tree + harness/scaffold/docs gaps — `./scripts/verify.sh all`
- [x] M8: Purge Marp mentions from skill — `rg -i marp .agents/skills/dev-doc` (empty); `./scripts/verify.sh all`

# Next Steps

1. `resume-work` for any in-scope fix (or `create-sibling` for major new work).
2. Fastest check: `cd .agents/skills/dev-doc && ./scripts/verify.sh all`.
3. Safest first edit targets: `references/*.md` (task notes), then `scripts/scaffold.sh` / `templates/` — avoid churning `SKILL.md` router unless intake changes.
4. Human guide: `artifacts/guide-for-users.md`.
