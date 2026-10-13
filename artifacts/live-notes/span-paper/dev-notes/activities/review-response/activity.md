# Review response (SCP)

| Key | Value |
|---|---|
| status | Active |
| slug | review-response |
| branch | none |
| ticket | none |
| notes | reusable across review rounds; letter-only |

# Goal

Produce short, formal author-response `.tex` files for SCP reviewer remarks, wired into `main.tex` after the appendix so `\cref` works, then removable for separate submission. Reuse this activity for future rounds.

# Scope

Root SCP journal paper only. This activity authors dated response files (e.g. `response_july29.tex`) and the trailing `\input` in `main.tex`. It does **not** edit paper body sections: all claimed paper changes must already exist in the cited commit history; if a reply needs a change not found there, stop and ask. Out of scope: thesis/OOPSLA/defence trees; bulk paper rewriting; long letter-style prose. Done for a round when the response file is brief, comments vs replies are clearly distinguished, locations are lightly pointed via `\cref` where useful, `make` at repo root succeeds, and the PDF trailing pages can be stripped for a standalone reply.

# Background and Special Notes

- Source comments for this round: `reviewer-comments.md`.
- Paper-side fixes already in history (cite, do not re-do):
  - `2ec19cd` — background framing; Apron in related work; lattice-top recall at start of approach via `\cref{sec:background}`
  - `bd314cf` — MFP vs widening qualification (intro, approach, monotonicity, related work); Def. sound-approx domain fix (`\subseteq`)
  - `37d6439` — declarative inference rules beside SV/policy Algorithms 1–3
  - `742f849` — forward-backward proof outline refs from approach/intro
  - `2026057` — SV/policy designer soundness/monotonicity obligation clarity
- Round agreed reply policies (July 2026):
  - **Def. typing:** keep \(\exists\); state soundness holds for a given set of concrete states \(C\); thank reviewer for the catch.
  - **Concern 1:** `sort` (~4.2 KLoC) and `du` (~1.1 KLoC) recursions caused non-termination; widening fixes it; not in paper because termination argument was removed from experiments; politely offer to add if still recommended.
  - **Widening/MFP side note:** minor gap in forward-backward termination argument (not argued there today); offer to add an intuitive argument if reviewer wants.
- Artifacts: optional `artifacts/comments-<round>.md` copies; response `.tex` lives at repo root (not under `artifacts/`).
- `main.tex` already has a commented `\input{review_response.tex}` placeholder after the appendix — replace/extend with dated inputs.

# Current Design

- **Document shape:** unnumbered heading `\section*{Review Response (July 2026)}` (no section number). Not a letter (no Dear Editor / closing).
- **Top matter:** brief thanks + one short summary paragraph of changes (specifics deferred to per-comment replies). Keep overall response small — reviewers may skim.
- **Structure:** subsection per reviewer; for each item `\paragraph{Reviewer.}` (quoted/italic) then `\paragraph{Response.}` (upright, 1–3 sentences + light `\cref`).
- **Include:** `\input{response_july29.tex}` after all appendices in `main.tex` (last pages; comment out when shipping paper alone).
- **Reuse:** one activity; new dated `response_<date>.tex` per round; update/replace `reviewer-comments.md` or archive under `artifacts/`; comment older `\input`s; reset Plan/Next Steps; journal append-only. Material scope change → `replan-work`.

# Current Plan

1. Draft `response_july29.tex` covering Reviewer #1 (footnote recall; Apron) and Reviewer #3 (MFP/widening + FB side note; Def. typing; Concern 1; Concern 2 declarative specs).
2. Wire `\input{response_july29.tex}` at end of `main.tex` (after appendix); retire/comment stale placeholder.
3. Build (`make` at repo root); spot-check `\cref`s and that comments/replies are visually distinct.
4. On later rounds: refresh comments source → new dated response file → swap `\input` → rebuild.

# Milestones

1. [x] `response_july29.tex` exists with unnumbered heading, thanks+summary, R1+R3 items, distinguishable Reviewer/Response paragraphs, brief prose
   - evidence:
     - `test -f response_july29.tex`
     - `rg -n 'Review Response \\(July 2026\\)|\\\\paragraph\{Reviewer|\\\\paragraph\{Response' response_july29.tex`

2. [x] Trailing include in `main.tex` after appendix; PDF builds
   - evidence:
     - `rg -n 'response_july29' main.tex`
     - `make` at repo root (53 pages; response on final pages)

3. [x] Every reply either cites a concrete location/`\cref` from the listed commits or matches an agreed ask-policy above
   - evidence:
     - manual check against `reviewer-comments.md` + commits `2ec19cd bd314cf 37d6439 742f849 2026057`

# Next Steps

1. Skim PDF trailing pages (Review Response); tweak wording if needed.
2. For a later round: refresh `reviewer-comments.md`, add `response_<date>.tex`, swap `\input` in `main.tex`.
3. Comment out the `\input{response_july29.tex}` line before shipping the paper alone.

# References

- `reviewer-comments.md`
- commits: `2026057`, `742f849`, `37d6439`, `bd314cf`, `2ec19cd`
- related activities (orthogonal paper work): `sv-policy-spec`, `sv-policy-obligation-clarity`
- `main.tex` (trailing response `\input` after `\appendix`)
