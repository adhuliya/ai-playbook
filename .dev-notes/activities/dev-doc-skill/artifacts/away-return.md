# Away return — (historical; activity now `dev-doc-skill`)

Gates ran under `user-away` + `auto-continue`. Status was **Active**; M1–M3 checked. Skill path at the time: `.agents/skills/doc-pipeline/` (later renamed `dev-doc`).

## Done

- `approve-plan` → `conventions: ok` → `start-building` → `continue: auto`
- Skill built: router `SKILL.md`, four starters, theme tokens, report HTML `preview/`, conversion refs, `scripts/compile.sh` + `scripts/verify.sh`
- Evidence: `cd .agents/skills/doc-pipeline && ./scripts/verify.sh all` → **VERIFY OK (all)**
- Sample artifacts: `sample/report.pdf`, `deck.pdf`, `poster.pdf`, `cheatsheet.pdf`, `report.docx`, `report.tex`, `poster.tex`

## Check when you return

1. Flip `sample/*.pdf` (report blank-page-free title, deck Touying, poster, cheat mosaic).
2. Optional: `cd preview && ./serve.sh` → open `http://127.0.0.1:8765/`.
3. Skim `SKILL.md` + `references/{browser,rendering,latex,docx,gdocs,install}.md`.
4. Type **`mark-completed`** if satisfied (or open a review if not).

## Assumptions taken (confirm / override)

| Assumption | Choice |
|---|---|
| Skill folder name | `doc-pipeline` (activity slug) |
| Acceptance criteria (`AC*`) | Skipped `add-ac`; Traceability + verify script stand in |
| Deck diagrams in starter | Simplified (table/code/swatch); Fletcher/Chronos left in activity scratch |
| `templates/reference.docx` | Not shipped; Pandoc default DOCX used |
| Vector-diagram unit | Covered by notes + deck `fit-image`/`fit-box` API; full Fletcher sample stays in scratch |
| `mark-completed` | Left for you (gate); not auto-run |

## Not done

- `mark-completed` (needs your keyword)
- Commit / PR (not requested)
