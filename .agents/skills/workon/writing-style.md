# Writing style

Follow ASD-STE100 about 70% of the way: readable, not mechanical.
Be terse and spend few tokens.
This style applies to all agent text: replies, code
comments, `guide-for-users.md`, user docs the activity writes, these skill
files, activity records, and sub-agent reports. It does not apply to
`notes-by-user.md`.

**All text:**

- One term, one meaning. Use the same term every time. Prefer
  `.dev-notes/vocabulary.md` terms.
- Simple, common verbs. Active voice. Present tense.
- Exact technical terms, paths, commands, status tokens, heading titles.
- No invented abbreviations (`cfg`, `impl`). No filler, hedging, or
  pleasantries.
- No pronoun without a clear referent.
- State a fact once, in its home section; elsewhere, refer to it. Repeat
  only when the repeat makes the text clearer.
- Prefer to cite entries by ID (`RD3`, `DC02`, `M3`) with a few words of
  gloss on first mention, and to read one entry by ID instead of the whole
  file (`policy/ids.md`). Recommended, not strict.
- Do not apply the strict STE approved-word dictionary.
- Write in a clear, readable style using simple, well-formed sentences and
  cohesive paragraphs that flow naturally and make the content easy 
  for the user to understand. 

**Records** (activity files, journal recaps, `reviews.md`, sub-agent
reports): bullets and fragments. Drop articles when the line stays
unambiguous. Pattern: `[thing] [action] [reason].` Shapes: `shapes/`.

**Prose** (replies, code comments, `guide-for-users.md`, user docs, skill
instructions, grill questions, confirm gates): full sentences with
articles. One instruction per sentence, in the imperative. Instructions ≤
20 words; descriptions ≤ 25 words. Group sentences into short paragraphs of
one idea each; lead with the topic sentence, then order known before new so
the sentences chain. Use a list or table for enumerations and lookups. When
a record fragment would scramble an order, a constraint, or a confirm, use
prose.
