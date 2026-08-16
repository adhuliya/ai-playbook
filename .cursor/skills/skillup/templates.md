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
        lab-maps/                # optional; Project Lab breadcrumbs
        <topic>/knowledge.md   # optional subtree indexes
        <topic>/<concept>.md
        cheatsheets/<focus>.md
        artifacts/
            resources/
            quizzes/<date>-<topic>.md
            quizzes/<date>-<topic>-worksheet.md
            sessions/<date>-<topic>.md
            sessions/<date>-<topic>-worksheet.md
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

# Project Lab

Optional. Only when learning against a codebase. Place after Goal. Absolute
machine paths go in `notes.md`, not here.

| Key | Value |
|---|---|
| binding | in-repo \| submodule \| path |
| remote | <clone URL or (none)> |
| default-ref | <branch/tag/commit or (default)> |
| lab-path-rel | <notes-home-relative path when binding=submodule; else (n/a)> |
| branch-prefix | skillup/<slug>/ |
| guide-spine | pending \| accepted |
| relevant-paths | `<path1>`, `<path2>`, … (seed; grow with curriculum) |

Notes: <clone recipe; shared-with other slugs; guide acceptance summary>.
Lab maps: `knowledge/<…>` (session-grown). Local absolute path: see `notes.md`.

# Foundations

Pinned core mental models. Reinforced every session; new material relates back
here. Near-fixed after planning (major change = `replan-learning`).

| Mental model | Essence (when / what / not / relates) | Last reviewed |
|---|---|---|
| <core model A> | <one-line: when to use, what to expect, what it is not, nearby> | YYYY-MM-DD |
| <core model B> | <one-line essence> | (unreviewed) |

# Curriculum

Ordered incremental steps. Each names the mental model it builds, its practice,
its evidence, and how it ties back to the Foundations. Lab steps MAY add a short
tour (file:symbol list) inside `relevant-paths`.

1. [ ] <Step> — model: <mental model> — practice: <exercise type(s)> — evidence: <quiz/solution/explanation ≥ threshold> — ties to: <foundation>
2. [ ] <Step> — model: ... — practice: locate-and-explain \| trace-path \| patch-and-verify — tour: `<file>:<symbol>`, … — evidence: ... — ties to: ...

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
- project lab: see `# Project Lab` (guides live in the lab repo as `dev-guide.md`)
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

## Project Lab (local only)

- absolute-path: </abs/path/to/checkout>
- last-resolved: <YYYY-MM-DD or unknown>
```

## knowledge/knowledge.md

Root index for the tree (per [`knowledge`](../knowledge/SKILL.md) skill): heading,
fluid body (skillup sections below are conventional, not required by `knowledge`),
trailing `## Index` (Name | Description | Link).

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

## Lab maps
- [<lab map>](lab-maps/overview.md) — entry points / tours (only if Project Lab)

## Cheatsheets
- [<focus>](cheatsheets/focus.md)

## How to browse
Run `serve-knowledge` ([`knowledge`](../knowledge/SKILL.md) skill), then open the printed URL.

## Index

| Name | Description | Link |
|------|-------------|------|
| essentials | Daily-use 20% | [essentials.md](essentials.md) |
| Foundations | Core principles | [foundations/](foundations/knowledge.md) |
| resources | Source materials | [artifacts/resources/](artifacts/resources/) |
```

## knowledge/lab-maps (optional, Project Lab)

Thin breadcrumbs only — path/symbol → concept; cite lab `dev-guide.md`. Grow from
sessions; do not mirror the tree.

```markdown
# Lab map — <focus>

Learning-relevant orientation. Guides in the lab repo are authoritative for layout.

| Path / symbol | Why it matters | → note | Lab guide |
|---|---|---|---|
| `lib/Foo.cpp` / `Foo::bar` | <one line> | [concept](../topic/x.md) | `lib/dev-guide.md` |

Tours:
1. <file:symbol> → <file:symbol> — <what to notice>
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

Per-folder index per [`knowledge`](../knowledge/SKILL.md): fluid body + trailing Index.

```markdown
# <Topic>

<One line: what this subtree covers.>

## Notes
Brief pointers (optional prose); durable discovery is the Index below.

## Index

| Name | Description | Link |
|------|-------------|------|
| general-purpose-registers | RAX/RBX/... roles and calling-convention uses | [general-purpose-registers.md](general-purpose-registers.md) |
| flags-register | RFLAGS bits and which instructions set them | [flags-register.md](flags-register.md) |
| addressing | Memory addressing modes | [addressing/knowledge.md](addressing/knowledge.md) |
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

## knowledge/artifacts/sessions/<date>-<topic>-worksheet.md

Pre-written prompts for `learn-session` graded practice (and foundations recall
when included). Learner fills **Your answer:** blocks; agent grades from this file.

```markdown
# Worksheet — <Topic>

| Key | Value |
|---|---|
| activity | cmake-cpp |
| type | learn-session |
| date | YYYY-MM-DD |
| curriculum step | <n> — <short title> |
| status | open \| filled |
| graded artifact | [sessions/<date>-<topic>.md](<date>-<topic>.md) |

**Instructions:** Fill each **Your answer:** block below. Save the file, then tell
the agent you are done. Do not peek at graded artifacts until after submit.

---

## 1. Foundations recall

### 1.A — <short label>

<prompt text>

**Your answer:**



### 1.B — <short label>

<prompt text>

**Your answer:**



---

## 3. Graded practice

### 3.1 — <exercise type> — <short label>

<prompt text>

**Your answer:**



### 3.2 — complete-the-code

<prompt + starter fence if any>

**Your answer:**



---

## Hands-on (optional)

If this step edits code under `practice/<step-slug>/`, note paths here:

- Code: `practice/<step-slug>/…`
- Build oracle: <command or (conceptual only)>
```

Same shape for quizzes at `knowledge/artifacts/quizzes/<date>-<topic>-worksheet.md`
(`type: quiz-me`; omit curriculum step).

## knowledge/artifacts/sessions/<date>-<topic>.md

Full session transcript; keep the learner's answers **verbatim** (source:
linked worksheet).

```markdown
# <YYYY-MM-DD> — <Topic> session

**Worksheet:** [sessions/<date>-<topic>-worksheet.md](<date>-<topic>-worksheet.md)

## Foundations recall
Q: <...>  A (learner): <verbatim>  — <grade + comment>

## New concept
<mental model built (when/what/not/relate) + projection offered>

## Exercises
### 1. <type> — <prompt>
Answer (learner): <verbatim>
Grade: <n>/5 — <comment>

### 2. patch-and-verify — <intent>
Branch: <actual-branch-name>
Oracle: agent-review \| diff-hint \| test/build
Runner: agent \| learner \| either
Success criterion: <plain language>
Diff summary: <files touched / key hunks>
Oracle result: <output or agent-review notes; or build verification pending>
Answer (learner): <verbatim notes / what they changed and why>
Grade: <n>/5 — <comment>

## Review
Weak: <...>  Strong: <...>  Mastery update: <topic → level>  Next: <...>
Lab: paths/symbols opened: <...>; guides touched: <...>; guide factual fixes: <none|list>
```

## knowledge/artifacts/quizzes/<date>-<topic>.md

```markdown
# <YYYY-MM-DD> — <Topic> quiz

**Worksheet:** [quizzes/<date>-<topic>-worksheet.md](<date>-<topic>-worksheet.md)

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
