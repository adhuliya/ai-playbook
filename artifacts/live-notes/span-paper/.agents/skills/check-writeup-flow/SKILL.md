---
name: check-writeup-flow
description: Analyze a given LaTeX .tex file for logical writeup flow across sentences, paragraphs, and section progression. Pays special attention to section-opening and section-closing paragraphs, and applies high-confidence flow-focused edits in place. Use when the user asks to improve argument flow, paragraph coherence, section transitions, or overall writeup structure.
disable-model-invocation: true
---

# Check Writeup Flow

## User Intent (verbatim)

analyse the given tex file for proper writeup flow. Check that the sequence of sentences correctly form a logical paragraph and the sequence of paragraph makeup a logical flow. Pay special attention to the first and the last paragraphs of a section such that the flow is properly started and ended with a reasonable conclusion. Neglect minor typo errors and focus on the larger idea and its flow.

## Purpose

Review one user-specified `.tex` file and improve high-level writing flow by editing in place:

- Sentence-to-sentence continuity inside each paragraph.
- Paragraph-to-paragraph progression inside each section.
- Section openings that clearly set context and intent.
- Section closings that land on a clear takeaway or transition.

Ignore minor typos, punctuation-only nits, and micro style tweaks unless they block logical flow.

## Workflow

1. Identify the target `.tex` file from the user's request. If none is provided, ask for one.
2. Read the file in full, preserving LaTeX commands and technical meaning.
3. Split the review by section (`\section`, `\subsection`, `\subsubsection`):
   - Evaluate the first paragraph: does it set up purpose, scope, and direction?
   - Evaluate body paragraphs: does each paragraph follow naturally from the previous one?
   - Evaluate the last paragraph: does it conclude, synthesize, or bridge to next content?
4. For each weak-flow area, prefer local rewrites over full-section rewrites:
   - Add or revise transition sentences.
   - Reorder closely related sentences when needed.
   - Tighten topic sentences and concluding sentences.
5. Apply high-confidence edits directly to the `.tex` file.
6. Summarize what was changed and why, emphasizing flow improvements.

## Flow Review Heuristics

Use these checks while editing:

- Paragraph unity: one main idea per paragraph with clear internal progression.
- Topic sentence quality: opening sentence announces the paragraph's role.
- Bridge quality: next paragraph starts where the prior one naturally ends.
- Section framing: first paragraph introduces the section's question or objective.
- Section closure: last paragraph states implications, conclusion, or handoff.
- Redundancy control: remove repeated claims that stall progression.
- Reader orientation: avoid abrupt jumps in terminology, scope, or abstraction level.

## Editing Rules

- Preserve equations, citations, labels, commands, and technical claims unless flow requires minimal wording changes around them.
- Do not perform typo sweeps, grammar polishing passes, or citation/label audits here.
- Prioritize changes that improve argument order, transitions, and coherence.
- Keep edits concise and high-confidence; avoid speculative rewrites.
- If a section is structurally broken and cannot be safely fixed with local edits, report it clearly instead of inventing content.

## Output Format

If edits were applied:

```markdown
Applied flow-focused edits to [filename].

Sections improved:
- [Section heading]: [what was wrong] -> [what was improved]
- [Section heading]: [what was wrong] -> [what was improved]

Key flow fixes:
- Improved section opener in [section] to establish objective.
- Added/revised paragraph transitions in [section].
- Strengthened section closer in [section] to deliver a clear conclusion or bridge.

Residual concerns:
- [List any places needing author input, or write "None in this pass."]
```

If no edits were needed, say the file already has strong logical flow and mention any residual risk (for example, domain-level argument gaps that require author intent).

## Limitations

- Does not optimize for stylistic preference.
- Does not run compilation checks unless explicitly requested.
