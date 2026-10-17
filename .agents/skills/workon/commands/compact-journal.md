# `compact-journal`

Status: any. Not auto-run from `mark-completed`. If already within budget,
say so and stop.

Reads: policy/journal.md

1. The default budget is ~12 `##` headings; the user may name another
   number.
2. Keep the newest entries verbatim (about half the budget: the last ~7
   when targeting ~12). Prefer recent `Complete`, `Replan`, and review
   events.
3. Merge older entries into a few summary headings a future agent can use:
   shipped outcomes (paths, behavior, decisions, accepted gaps); one line
   per milestone or review cycle (`M2: <outcome>`, `RU3: 4
   applied, 1 rejected`); one line `paused N, resumed N, completed N`. Drop
   plan and status prose that `activity.md` already holds.
4. Show the proposed compacted file. Write in place only after the user
   nods. Git is the archive unless the user asks for an `artifacts/`
   snapshot.
