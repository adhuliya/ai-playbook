# skillup templates

## Directory layout

```text
.dev-notes/learning/<slug>/
    learning.md
    journal.md
    notes.md                     # optional; complementary notes
    knowledge/
        index.md                 # home page
        <topic>/dev-guide.md     # subtree index: names + one-line summaries
        <topic>/<concept>.md     # descriptive, greppable note file names
        *.md                     # atomic, cross-linked notes
    artifacts/
        resources/               # books/docs/tools (learner + vetted)
        quizzes/<date>-<topic>.md
        sessions/<date>-<topic>.md
    learning/<child>/            # optional children (max depth 2)
```

## learning.md

Keep the metadata table in the **first ~10 lines** so listing stays greppable.

```markdown
# <Human Title>

| Key | Value |
|---|---|
| status | Planning |
| slug | learn-x86-asm |
| level | beginner |
| notes | |

# Goal

<Target outcome and why it matters now.>

# Foundations

Pinned basic principles. Reinforced every session; new material relates back
here. Near-fixed after planning (major change = `replan-learning`).

| Principle | Note | Last reviewed |
|---|---|---|
| <core principle A> | <one-line essence> | YYYY-MM-DD |
| <core principle B> | <one-line essence> | (unreviewed) |

# Curriculum

Ordered incremental steps. Each names its practice, its evidence, and how it
ties back to the Foundations.

1. [ ] <Step> — practice: <exercise type(s)> — evidence: <quiz/solution/explanation ≥ threshold> — ties to: <foundation>
2. [ ] <Step> — practice: ... — evidence: ... — ties to: ...

# Milestones

MECE learning outcomes with concrete evidence; dated when reached.

1. [ ] <Outcome> — evidence: `<check / quiz ≥ X / working solution>` — reached: <YYYY-MM-DD>

# Mastery

Living weak/strong list and per-topic level (evidence-gated).
Levels: novice → learning → solid → mastered.

| Topic | Level | Evidence | Notes |
|---|---|---|---|
| <topic> | learning | <session/quiz ref + score> | <weak/strong note> |

Strong points: <...>
Weak points: <... (targets for reinforcement)>

# Memory Aids

Adopted stories / mnemonics / analogies for sticky ideas, CLI options, process,
and gotchas.

- <idea> → <mnemonic/story/analogy>

# Next Steps

1. <Safest next learning action>

# References

- resources: see `artifacts/resources/`
- knowledge: `knowledge/index.md`
- <docs, courses, related slugs>
```

## journal.md

Append-only, **dated** entries. Concise; essentials only.

```markdown
# Journal

## YYYY-MM-DD — <session / quiz / review title>

Covered: <topics>. Scores: <ex1 4/5, ex2 3/5>. Weak: <...>. Strong: <...>.
Decisions: <...>. Next: <...>. Transcript: `artifacts/sessions/<date>-<topic>.md`.
```

### pause entry shape

```markdown
## YYYY-MM-DD — Pause: <label>

Progress, current mastery, remaining. Resume Hint: <best next topic/exercise>.
```

### import first entry

```markdown
## YYYY-MM-DD — Imported

Imported `learning.md` + `journal.md` from <origin>. Verified mastery vs claims:
<drift found>. Reconciled into current truth.
```

## notes.md

Optional, complementary scratch (learner + agent). Not part of the portable
handoff. Fold decided items into `learning.md` and prune.

```markdown
# Notes

<Complementary context: open questions, links, snippets, ideas. Light
attribution (learner: / agent:) when it helps.>

## Open questions
- <undecided thing>

## Parking lot
- <idea to revisit>
```

## knowledge/index.md

Home page for browsing. Lay it out intuitively for revision, search, and quick
reference.

```markdown
# <Subject> — Knowledge

Browse map for the whole subject. Start here.

## Foundations
- [<principle A>](foundations/principle-a.md)
- [<principle B>](foundations/principle-b.md)

## Topics
- [<topic 1>](topic-1/index.md)
- [<topic 2>](topic-2.md)

## Resources
- see `../artifacts/resources/`

## How to browse
Run `serve-knowledge` (python3 <skill-dir>/scripts/serve.py <this folder>),
then open the printed URL.
```

## knowledge note (atomic, cross-linked)

```markdown
# <Concept>

<Crisp explanation. Relate to a Foundation.>

Memory aid: <mnemonic/story/analogy, if any>.

Watch out: <common pitfalls>.

See also: [<related note>](../topic/other.md) · [<foundation>](../foundations/x.md)

Source: `../artifacts/resources/<file-or-link>`
```

## knowledge/<topic>/dev-guide.md (subtree index)

One index per non-trivial subtree so the agent finds a note from names +
summaries without reading the notes. List every file with a one-line summary
and link child subtrees.

```markdown
# <Topic> — knowledge index

<One line: what this subtree covers.>

## Notes
| File | Summary |
|---|---|
| [general-purpose-registers.md](general-purpose-registers.md) | RAX/RBX/... roles and calling-convention uses |
| [flags-register.md](flags-register.md) | RFLAGS bits and which instructions set them |

## Subtrees
- [addressing/](addressing/dev-guide.md) — memory addressing modes
```

## artifacts/sessions/<date>-<topic>.md

Full session transcript; keep the learner's answers **verbatim**.

```markdown
# <YYYY-MM-DD> — <Topic> session

## Foundations recall
Q: <...>  A (learner): <verbatim>  — <grade + comment>

## New concept
<what was taught + memory aid offered>

## Exercises
### 1. <type> — <prompt>
Answer (learner): <verbatim>
Grade: <n>/5 — <comment>

### 2. ...

## Review
Weak: <...>  Strong: <...>  Mastery update: <topic → level>  Next: <...>
```

## artifacts/quizzes/<date>-<topic>.md

```markdown
# <YYYY-MM-DD> — <Topic> quiz

Scope: <...>  Result: <total>/<max>

### 1. <prompt>
Answer (learner): <verbatim>
Grade: <n>/5 — <comment>

## Summary
Weak: <...>  Strong: <...>  Mastery update: <...>
```

## List output (agent → user)

```markdown
| status | slug | level | notes |
|---|---|---|---|
| Active | learn-x86-asm | beginner | on step 3 |
| Maintaining | spanish-a2 | intermediate | weekly refresh |
```

## Details output (no resume)

1. Full path to `learning.md`
2. First ~20 lines of that file
3. Stop — user opens the file for the rest
