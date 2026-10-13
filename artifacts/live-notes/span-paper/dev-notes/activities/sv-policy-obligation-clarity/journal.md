# Journal

## Planning: obligation clarity grill

Created activity from project-fit + recommended scope. Grilled Q1–Q9: designer SV soundness = `eq:sv.sound` (Θ); Local Soundness kept but not an obligation; restricted view = framework definition; parallel soundness/monotonicity callouts in SV and policy; surgical diffs; proofs opener only; no files outside those three. Plan drafted for file review.

## Approved and started building

Plan approved. Status → Active. Beginning surgical edits in `sv.tex`, then `policy.tex`, then proofs opener.

## Edits applied; milestones checked

Surgical callouts/summaries in `sv.tex` and `policy.tex`; proofs opener sentence added. `make` succeeded (52-page `main.pdf`). All three milestones checked. Await user PDF skim / `complete-work` or wording tweaks.

## Build verify (`fix-latex-errors`)

Forced `make` rebuild: exit 0, `main.pdf` 52 pages. No `!` / LaTeX Error / undefined citation or reference hits in `main.log` for the touched obligation labels.

## Review polish

Dropped mid-policy soundness-obligation repeat in `policy.tex` (outputs subsection) for SV-like lighter touch. Left Local Soundness “must/always” framing as-is.

## Committed (tex only)

`2026057` — `[sv][policy] Clarify designer soundness/monotonicity obligations` (`sv.tex`, `policy.tex`, `sv_policy_proofs.tex`). `.dev-notes/` left untracked by request.
