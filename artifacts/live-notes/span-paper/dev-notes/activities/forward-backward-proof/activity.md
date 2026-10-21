# Forward-backward proof (soundness, monotonicity, termination)

| Key | Value |
|---|---|
| status | Planning |
| slug | forward-backward-proof |
| branch | none |
| ticket | none |
| notes | draft appendix written unattended; awaiting user review |
| conventions | pending |
| review-comments | on |
| base-branch | main |
| synced | none |

# Goal

Rigorous, simple proof that forward-backward SPAN (forward analyses paired with strong liveness) is sound, monotone and terminating, against a well-defined purged collecting semantics. Worked pair: points-to + strong liveness; CP/intervals via a checklist.

# Scope

Appendix section `fbproof.tex` (`sec:fb-proof`), hooked in `main.tex` after Proofs; pointer in `proof.tex`. Intraprocedural; roots `assume`/`use`; no faults. Supersedes the two-stage sketch (`sec:fb-proof-outline`).

# Background and Special Notes

- See `requirement-def.md`, `design-choices.md`, `artifacts/span-facts-excerpt.md` (REF1).
- Dead assignment = view `x=T` via inserted `x=x` nodes (old `filter(x)` retired).

# Current Design

Baseline: purged collecting semantics (dynamic strong liveness). Proof device: static `b`-restricted runs, one forward induction (step lemma), dynamic purge as corollary. Per-variable top `T_x` keeps monotonicity.

# Plan

1. Draft `fbproof.tex` (done, builds clean, 0 undefined refs).
2. User review; revise lemmas/assumptions.

# Next Steps

User reviews appendix; decide flagged assumptions (design-choices.md DC6-DC9).
