---
name: review-technical-writeup
description: >-
  Critically reviews a technical writeup (.tex, .md, .txt) for a formal
  submission: overall flow, argument structure, and idea presentation. Asks
  the user for clarity whenever intent or meaning is ambiguous instead of
  guessing. Delegates low-level spelling/grammar checks to the spell-check
  subagent and uses judgement on whether to apply non-obvious suggested
  fixes. Use when the user asks to review a writeup, paper, report, or
  submission draft for flow, clarity, or readiness, or invokes
  /review-technical-writeup.
disable-model-invocation: true
---

# Review Technical Writeup

Review a `.tex`, `.md`, or `.txt` writeup as a critical, high-standards
reviewer for a formal submission (paper, report, proposal). Focus on
**substance and flow**, not typos.

## Scope

- **In scope**: structure, argument flow, idea progression, clarity of
  claims, motivation, consistency of terminology, whether each section
  earns its place, whether conclusions follow from what was presented,
  missing context a reader would need.
- **Out of scope (delegate)**: spelling, grammar, punctuation, repeated
  words — hand these to the `spell-check` subagent (see below).

## Workflow

1. **Read the whole document first.** Do not comment section-by-section
   without having seen the ending — flow issues (e.g., a concept used
   before it's introduced, a promise in the intro never resolved) only
   show up against the full arc.

2. **Map the argument.** Identify: the core claim/contribution, the
   intended reader, and the through-line connecting sections. If this
   isn't clear from the text, that's already a finding.

3. **When in doubt, ask the user — don't guess.** If a passage is
   ambiguous, a claim's intent is unclear, a section's purpose isn't
   obvious, or you can't tell whether an omission is deliberate, use
   `AskQuestion` (or ask conversationally if the ambiguity doesn't fit
   discrete options) rather than assuming. Quote the exact passage you're
   asking about. Do not silently "fix" meaning you're unsure of.

4. **Run the spell-check subagent** on the file(s) for low-level issues:
   - Launch the `spell-check` subagent type via `Task`, pointing it at the
     specific file path(s).
   - It returns a table of proposed fixes with file/line references.

5. **Triage the subagent's suggestions:**
   - **Obvious** (clear typo, duplicated word, wrong homophone with no
     ambiguity) → apply directly.
   - **Non-obvious** (could change meaning, touches a term-of-art, a
     proper noun, notation, or a deliberate stylistic choice) → use your
     judgement first; if still unsure, surface it to the user rather than
     applying blindly. Never let the subagent's fix silently alter
     technical meaning.

6. **Deliver the review** as a structured report (do not edit the file
   yourself unless the user asks you to apply fixes):

   ```markdown
   ## Overall assessment
   [1-2 sentences: is this ready, close, or needs rework]

   ## Flow & structure
   - [Section-by-section or thematic notes on ordering, transitions, pacing]

   ## Ideas & argument
   - [Gaps in reasoning, unsupported claims, missing motivation, scope creep]

   ## Open questions for the author
   - [Anything you asked the user about, plus their answers if resolved]

   ## Low-level fixes (from spell-check)
   - Applied: [list, with file:line]
   - Flagged for your review: [non-obvious ones, with reasoning why you didn't auto-apply]
   ```

7. Only apply edits to the source file if the user confirms they want
   fixes applied, or for the "Applied" low-level fixes in step 6 if the
   user has pre-approved auto-applying obvious fixes.

## Notes

- A writeup can be spelling-perfect and still fail as a submission if the
  ideas don't flow — treat structural/argument issues as higher priority
  than the spell-check pass.
- If the document is very long, it's fine to read it in chunks, but form
  your flow judgement only after the full read.
