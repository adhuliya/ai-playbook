# skillup templates

## Directory layout

```text
.dev-notes/learning/<slug>/
    learning.md
    journal.md
    notes.md                     # optional; complementary notes
    knowledge/                 # see `knowledge` skill + skillup Knowledge library
        knowledge.md           # root index
        essentials.md            # skillup: daily-use 20%
        <topic>/knowledge.md   # optional subtree indexes
        <topic>/<concept>.md
        cheatsheets/<focus>.md
        artifacts/
            resources/
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

Pinned core mental models. Reinforced every session; new material relates back
here. Near-fixed after planning (major change = `replan-learning`).

| Mental model | Essence (when / what / not / relates) | Last reviewed |
|---|---|---|
| <core model A> | <one-line: when to use, what to expect, what it is not, nearby> | YYYY-MM-DD |
| <core model B> | <one-line essence> | (unreviewed) |

# Curriculum

Ordered incremental steps. Each names the mental model it builds, its practice,
its evidence, and how it ties back to the Foundations.

1. [ ] <Step> — model: <mental model> — practice: <exercise type(s)> — evidence: <quiz/solution/explanation ≥ threshold> — ties to: <foundation>
2. [ ] <Step> — model: ... — practice: ... — evidence: ... — ties to: ...

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

# Mental Models

The catalog of models built. Each states when to use / what to expect / what
NOT to expect / how it relates, plus its projection and any mnemonics. Memory
tools live here in service of the models.

## <Model name>
- When to use: <situations that call for it>
- Expect: <what it predicts / does>
- Not: <its limits; what it is not>
- Relates to: <nearby models, and how to keep it distinct>
- Projection: <story / diagram (mermaid) / analogy / catchphrase>
- Mnemonics: <optional, serving the model>

# Next Steps

1. <Safest next learning action>

# References

- resources: see `knowledge/artifacts/resources/`
- knowledge: `knowledge/knowledge.md`
- <docs, courses, related slugs>
```

## journal.md

Append-only, **dated** entries. Concise; essentials only.

```markdown
# Journal

## YYYY-MM-DD — <session / quiz / review title>

Covered: <topics>. Scores: <ex1 4/5, ex2 3/5>. Weak: <...>. Strong: <...>.
Decisions: <...>. Next: <...>. Transcript: `knowledge/artifacts/sessions/<date>-<topic>.md`.
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

## knowledge/knowledge.md

Root index for the tree (per [`knowledge`](../knowledge/SKILL.md) skill). Lay it out
intuitively for revision, search, and quick reference.

```markdown
# <Subject> — Knowledge

Browse map for the whole subject. Start here.

## Foundations
- [<principle A>](foundations/principle-a.md)
- [<principle B>](foundations/principle-b.md)

## Topics
- [<topic 1>](topic-1/knowledge.md)
- [<topic 2>](topic-2.md)

## Daily use
- [essentials](essentials.md) — the practical 20% for day-to-day work

## Cheatsheets
- [<focus>](cheatsheets/focus.md)

## Resources
- see `artifacts/resources/`

## How to browse
Run `serve-knowledge` ([`knowledge`](../knowledge/SKILL.md) skill), then open the printed URL.
```

## knowledge/essentials.md (daily-use index)

The practical 20%: per module/command/feature, the most common/important
concepts, combinations, and commands/args. Compact and drillable (a `quiz-me`
target). Grow it as heavily-used constructs are learned.

```markdown
# <Subject> — Essentials

Day-to-day quick reference. The 20% that covers 80% of use.

## <Module / command / feature>
| Item | Common use / combo | Watch out | → note |
|---|---|---|---|
| `<cmd/construct + args>` | <the frequent pattern> | <pitfall> | [details](topic/x.md) |

## <Another module>
| Item | Common use / combo | Watch out | → note |
|---|---|---|---|
| `<...>` | <...> | <...> | [details](...) |
```

## knowledge note (atomic, cross-linked)

```markdown
# <Concept>

<Crisp explanation as a mental model. Relate to a Foundation.>

- When to use: <situations>
- Expect: <what it does / predicts>
- Not: <limits; what it is not>
- Relates to: <nearby concepts, kept distinct>

Projection: <story / diagram / analogy / catchphrase that makes it stick>.

Watch out: <common pitfalls>.

See also: [<related note>](../topic/other.md) · [<foundation>](../foundations/x.md)

Source: `artifacts/resources/<file-or-link>`
```

## knowledge/<topic>/knowledge.md (subtree index)

Per-folder index: list notes with one-line summaries and link child subtrees.

```markdown
# <Topic> — knowledge index

<One line: what this subtree covers.>

## Notes
| File | Summary |
|---|---|
| [general-purpose-registers.md](general-purpose-registers.md) | RAX/RBX/... roles and calling-convention uses |
| [flags-register.md](flags-register.md) | RFLAGS bits and which instructions set them |

## Subtrees
- [addressing/](addressing/knowledge.md) — memory addressing modes
```

## knowledge/cheatsheets/<focus>.md (cheatsheet)

Focused overview built by `create-cheatsheet`. Compact tables + mnemonics, not
prose. Must be graspable fast; ground groupings in a Foundation.

```markdown
# <Focus> cheatsheet

Focus: <what this covers>. Foundation: <the principle it rests on>.

## Constructs / commands
| Item | Does what | Watch out | Mnemonic |
|---|---|---|---|
| `<cmd/construct>` | <one line> | <pitfall> | <memory aid> |

## Key arguments / flags
| Flag | Meaning | Mnemonic |
|---|---|---|
| `-x` | <one line> | <aid> |

## Principles to remember
- <principle> — <mnemonic/analogy>

## Quick example
\`\`\`text
<tiny worked example>
\`\`\`

See also: [<fuller note>](../topic/concept.md)
```

## knowledge/artifacts/sessions/<date>-<topic>.md

Full session transcript; keep the learner's answers **verbatim**.

```markdown
# <YYYY-MM-DD> — <Topic> session

## Foundations recall
Q: <...>  A (learner): <verbatim>  — <grade + comment>

## New concept
<mental model built (when/what/not/relate) + projection offered>

## Exercises
### 1. <type> — <prompt>
Answer (learner): <verbatim>
Grade: <n>/5 — <comment>

### 2. ...

## Review
Weak: <...>  Strong: <...>  Mastery update: <topic → level>  Next: <...>
```

## knowledge/artifacts/quizzes/<date>-<topic>.md

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
