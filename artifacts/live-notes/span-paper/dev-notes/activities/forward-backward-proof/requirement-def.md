# Requirements

## Problem: forward-backward proof

No rigorous proof that forward-backward SPAN (forward analysis + strong liveness) is sound, monotone, terminating; existing appendix is a rough two-stage sketch.

- RD1 (must): well-defined purged collecting semantics as baseline, analysis-independent.
- RD2 (must): soundness of forward facts w.r.t. RD1; liveness soundness as corollary.
- RD3 (must): monotonicity of composite flow function incl. dead-view case.
- RD4 (must): termination/MFP; soundness for any solution (widening).
- RD5 (should): worked on points-to; checklist for CP/intervals; example from slides.
- RD6 (must): intuitive, simple; copy used facts into artifacts; explicit assumptions.
