---
name: writeup-editor
description: Add, reword, or restructure prose in the paper's LaTeX (.tex) files while matching the existing writing style and macro usage. Makes surgical, minimal-footprint edits that blend with surrounding text. Use when the user asks to write, add, expand, reword, or restructure content in a .tex file.
---

# Writeup Editor

## Purpose

Edit paper prose so additions/changes read as if the original author wrote them: same voice, terminology, and macro conventions as the surrounding text.

## Decision Policy: minor vs. major change

- **Minor** (default): a sentence-, paragraph-, or subsection-level edit that fits the existing structure and argument. Apply directly, no confirmation needed.
- **Major**: adding/removing a section or subsection, reordering the argument, changing a claim's substance, or any edit the user did not explicitly request in detail. Before applying: explain the proposed change and why, then wait for the user to confirm or explicitly request it before editing.

Apply this policy at every editing decision below.

## Workflow

1. Read the target `.tex` file (and its neighbors via the section's `\input` chain in `main.tex`) to absorb local style, terminology, and macro usage before writing anything.
2. Classify the requested change per the Decision Policy. Stop and confirm before touching the file if it's major.
3. Draft the edit reusing the surrounding paragraph's vocabulary, tense, and structure — do not introduce a new way of saying something already named in the paper.
4. Apply the edit with the smallest possible diff: touch only the sentences/lines that must change; do not reflow or rewrite untouched neighboring text.
5. Report what changed and why, referencing the section/line.

## Style matching

- Tense/voice: formal academic, first-person plural ("we"), present tense for definitions and claims.
- Reuse existing macros instead of raw LaTeX/markup — check `resources/myarticle.sty` for the active set, e.g. `\cCite{}` (not `\cite{}`), `\cCode{}`/`\cVar{}` for code identifiers, `\cTerm{}` for a defined term in italics, `\cQ{}` for quoted text, `\cSpan{}` for the tool name, `\cref{}`/`\Cref{}` for cross-references.
- Match the paper's existing terms for a concept; never introduce a synonym for something already named.
- Preserve labels, citations, macros, and math untouched unless they are the edit's target.

## Reporting

- Minor edits: one-line summary of what changed and where (file, section).
- Major edits (before applying): state the proposed change, the rationale, and what it affects (sections/claims/figures); wait for explicit confirmation or an explicit change request.
- Major edits (after confirmation): summarize the change applied and any follow-on sections that may now need review (e.g. a claim referenced elsewhere).

## Out of scope

- Typo/citation/label sweeps — use `find-typos`.
- Paragraph/section flow-only passes — use `check-writeup-flow`.
