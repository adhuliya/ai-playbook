# SV/Policy designer-obligation clarity

| Key | Value |
|---|---|
| status | Active |
| slug | sv-policy-obligation-clarity |
| branch | none |
| ticket | none |
| notes | surgical prose only |

# Goal

Make it unmistakable in the root paper’s SV and policy sections which named items the analysis designer must prove (soundness vs monotonicity, kept distinct) and which are framework definitions / non-obligations—aligned with what `sv_policy_proofs.tex` actually discharges.

# Scope

Root SCP journal paper only. Clarify obligation vs non-obligation in `sv.tex` and `policy.tex` so the distinction stands out in those sections themselves. Complementary: one short opener sentence in `sv_policy_proofs.tex`. Out of scope: proof-body rewrites; algorithm bodies; `theta.tex`; commented-out `properties.tex`; intro/overview/framework soundness sections unless a cross-ref breaks; thesis/OOPSLA copies. Edits must be minimal and surgical. Done when a reader can tell at a glance the four designer obligations vs non-obligations, wording matches appendix proof targets, and `make` at repo root succeeds.

# Background and Special Notes

- Related completed activity: `sv-policy-spec` (declarative specs beside algos)—orthogonal; do not reopen unless needed.
- Appendix opener already states sample \(\cAbsSim{}\) / \(\cPolicy{}\) satisfy `eq:sv.sound`, `eq:sv.monotone`, `eq:policy.sound`, `eq:policy.monotone`—not `eq:soundASRjImplied`.
- Classification agreed in grill:

  | Item | Role |
  |---|---|
  | `eq:soundASRjImplied` (Local Soundness) | Motivation / concrete reading; **not** designer proof obligation |
  | `def:restricted.view` | Framework **definition** (allowed view shape); **not** prove-by-designer |
  | `eq:sv.sound` (uses \(\Theta\)) | Designer **soundness** obligation for SV |
  | `eq:sv.monotone` | Designer **monotonicity** obligation for SV |
  | `eq:policy.sound` | Designer **soundness** obligation for policy |
  | `eq:policy.monotone` | Designer **monotonicity** obligation for policy |

- Keep soundness vs monotonicity as **separate** obligations for both SV and policy.
- Artifacts: none required; evidence is PDF/`make`. Optional notes may go under this activity’s `artifacts/` if useful later.

# Current Design

- **Callout templates** (paper voice, `\emph{…}` for stress, no new envs/boxes):
  - *It is the analysis designer’s \emph{soundness} obligation to prove … (`\cref{eq:…}`).*
  - *It is the analysis designer’s \emph{monotonicity} obligation to prove … (`\cref{eq:…}`).*
  - *This is \emph{not} a designer proof obligation; …*
- Place after each relevant property/definition; add a short summary bullet list at end of SV obligation stretch and again in policy section.
- **`eq:sv.sound`:** drop “side effect” / awkward “iff”; present as the named SV soundness obligation (for generators producing restricted, locally sound views). Math unchanged.
- **Local Soundness:** keep property; remove designer-obligation sentence; add bridge that compositional target is `eq:sv.sound`.
- **`def:restricted.view`:** keep as definition; add non-obligation + “allowed shape” clarification.
- **`policy.tex`:** parallel callouts + summary; surgically normalize uneven obligation prose only; leave output-meaning bullets and algos untouched.
- **`sv_policy_proofs.tex`:** one opener sentence that the four cited eqs are the designer obligations demonstrated; no body edits.
- Invariants: no algorithm line-body edits; no math/label renames unless required for clarity of prose only; minimal diffs.

# Current Plan

1. Edit `sv.tex`: Local Soundness → non-obligation + bridge; restricted def → non-obligation/shape; `eq:sv.sound` reframe + soundness obligation callout; monotonicity → separate monotonicity obligation callout; short SV summary list.
2. Edit `policy.tex`: parallel soundness/monotonicity callouts + summary; normalize uneven sentences only.
3. Edit `sv_policy_proofs.tex` opener only.
4. `make` at repo root; skim PDF for callouts and summaries.
5. Self-check: four obligations named; Local Soundness + restricted def marked non-obligation; no competing obligation on `eq:soundASRjImplied`.

# Milestones

1. [x] SV section obligation clarity
   - evidence:
     - `sv.tex` has callouts for `eq:sv.sound` / `eq:sv.monotone`; non-obligation lines for Local Soundness and `def:restricted.view`; no “side effect”/iff framing on `eq:sv.sound`
     - `make` at repo root succeeds

2. [x] Policy section obligation clarity
   - evidence:
     - `policy.tex` has parallel soundness/monotonicity callouts + summary
     - `make` at repo root succeeds

3. [x] Complementary proofs opener + consistency check
   - evidence:
     - `sv_policy_proofs.tex` opener names the four eqs as designer obligations demonstrated
     - greppable alignment: appendix cites `eq:sv.sound` not `eq:soundASRjImplied` for sample SV soundness
     - `make` at repo root succeeds; PDF skim confirms summaries stand out

# Next Steps

1. Skim the SV/policy stretches in `main.pdf` for callout readability.
2. If satisfied, run `complete-work`; else request targeted wording tweaks.
3. Optional: `find-typos` pass on the touched paragraphs.

# References

- `sv.tex` — Local Soundness, restricted view, `eq:sv.sound`, `eq:sv.monotone`
- `policy.tex` — `eq:policy.sound`, `eq:policy.monotone`
- `sv_policy_proofs.tex` — `\label{sec:svpolicyproofs}` opener ~ll.320–323
- `theta.tex` — `\Theta` / `def:theta` (read-only for this activity)
- related: `sv-policy-spec` (Complete)
- grill decisions: Q1–Q9 confirmed in planning session
