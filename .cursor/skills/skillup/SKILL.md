---
name: skillup
description: >-
  Structured learn-by-practice coach for any subject (assembly, data structures
  & algorithms, OS/atomics theory, tools, Morse, Spanish, ...). Sets up a durable
  learning activity under .dev-notes/learning/<slug>/, plans an incremental
  curriculum, runs graded practice sessions with quizzes and agent review
  comments, tracks dated progress and weak/strong points, and builds a browsable
  knowledge/ library. Learning is organized around durable mental models
  (reinforced with stories, diagrams, analogies, and catchphrases) so core
  principles and usage stand out. Use when the user wants to learn/study a topic,
  be quizzed, review learning progress, or issues skillup lifecycle keywords.
disable-model-invocation: true
---

# skillup

Learn-by-practice coach organized around **mental models**. Turns a subject into
a durable, resumable learning journey: incremental curriculum, graded exercises,
dated progress, and a browsable knowledge library. Sibling of the `workon` skill
(same spirit, learning-flavored); records are the deliverable — resumable months
later.

## Mental models (the organizing principle)

A **mental model** is a cognitive framework for how something works — complex
reality compressed into a reusable problem-solving tool. Learning here is built
around forming and reinforcing strong mental models so recall and transfer come
naturally, not by rote.

Every mental model this skill builds MUST answer four questions:

1. **When to use it** — situations that call for it.
2. **What to expect** — what it does / predicts.
3. **What NOT to expect** — its limits; what it is not (defuse misconceptions).
4. **How it relates** — connections to similar models, kept distinctly clear
   (contrast, don't blur).

**Project** each model so it sticks with one or more: a **story**, a **diagram**,
an **analogy**, or a **catchy phrase**. All memory tools (mnemonics included)
serve this one goal — a mental model that is **practical in the long run** —
never decoration.

## Hard constraints (MUST)

- **Mental models are the spine (MUST).** Organize every lesson around a durable
  mental model with its when / what / what-NOT / how-it-relates (see above), so
  core principles and usage stand out and are reinforced.
- **Basics first, always.** Every session reinforces the pinned `# Foundations`
  (the core mental models) and relates new material back to them. No lesson
  floats free of the fundamentals.
- **Memory tools serve the model (MUST).** Project each model with a story,
  diagram, analogy, or catchphrase; mnemonics and other tricks all target one
  goal — a model practical in the long run — never decoration.
- **Surface the essentials (MUST).** For every module/command/feature, capture
  the most common/important concepts, combinations, and commands/args — the
  day-to-day 20% that covers 80% of use — in a dedicated, practiceable
  `knowledge/essentials.md` (see Knowledge library), so the skill is usable in
  daily work, not just study.
- **Learn by practice.** Every session includes graded exercises (not just
  exposition): complete-the-code, complete-the-command, explain-a-concept,
  predict-output, from-scratch. Exposition exists to enable the practice.
- **Evidence-gated mastery.** Never advance a topic's mastery level without
  exercise/quiz evidence. Prose confidence is not evidence.
- **Dated progress.** Journal entries and milestone/quiz completions carry dates
  (this skill overrides the usual no-dates default).
- **Portable core.** `learning.md` + `journal.md` are a self-contained handoff: a
  fresh agent on another machine can assess and continue with no chat memory,
  host paths, or local state. `knowledge/` + `artifacts/` are the durable library.
- **One focused learning activity per chat** (memory only; no focus file).
- **Save the learner's work.** Archive each session (exercises, the learner's
  verbatim answers, grade + comments, mental model + projection offered) so they
  can revisit it.
- **No micro-edits**: update `learning.md` at meaningful checkpoints, not on
  every step. `notes.md` is exempt (free scratch).

## Model reminders

- Planning/replanning (create, `replan-learning`): remind to use a **strong** model.
- Running sessions/quizzes/reviews can use a lighter model; note this once when
  planning is approved. Remind once per phase change.

## Gating policy

- Interact freely in natural language for discussion and study.
- Gated transitions require their exact reserved keyword. When intent for a gated
  action is detected, do not perform it silently; prompt the exact command, e.g.:
  > To start a graded session, write the command `learn-session`.

## Storage and identity

```text
.dev-notes/learning/<slug>/
    learning.md              # current truth (rewritable)
    journal.md               # append-only, dated history
    notes.md                 # optional complementary notes (learner + agent)
    knowledge/               # durable note library (see Knowledge library)
        index.md             # home page: browse the whole subject
        essentials.md        # daily-use 20%: top concepts/commands/args (drillable)
        <topic>/dev-guide.md # per-subtree structure (when it earns its keep)
        *.md                 # atomic notes, cross-linked
        cheatsheets/*.md     # focused cheatsheets (create-cheatsheet)
    artifacts/
        resources/           # books, docs, tool refs (learner-supplied + vetted)
        quizzes/             # <date>-<topic>.md formal quizzes + answers + grade
        sessions/            # <date>-<topic>.md session transcripts
    scripts/                 # optional per-activity helpers
    learning/<child>/        # optional child sub-journey (max depth 2)
```

- Slug: kebab-case, top-level at `.dev-notes/learning/<slug>/`.
- Child ref: `parent-slug/child-slug` → `.../<parent>/learning/<child>/`. Max depth 2.
- Commit `.dev-notes/learning/` (including useful `knowledge/` and `artifacts/`).
- Ambiguous slug: list matches and ask; never guess.
- The browser is shipped once at the skill level: `scripts/serve.py` (see
  Knowledge library). Per-activity `scripts/` is optional.

## Reserved lifecycle commands

Honor only these exact keywords (ordinary words do not trigger them):

| Keyword | Action |
|---|---|
| `approve-plan` | Mark curriculum approved; ready to learn (no session yet). |
| `learn-session` | Run one graded learning session (the core loop). |
| `quiz-me` | Run a standalone graded quiz and archive it. |
| `review-progress` | Review curriculum + progress + weak spots; grill and update. |
| `note-knowledge` | Note a piece of knowledge into `knowledge/`, or verify it is already noted. |
| `build-knowledge` | Distill a new resource or detail into structured, linked `knowledge/` notes. |
| `create-cheatsheet` | Build a focused cheatsheet (constructs/commands/args/principles + mnemonics) saved in `knowledge/`. |
| `pause-work` | Pause protocol. |
| `resume-work` | Resume protocol. |
| `replan-learning` | Re-open the curriculum on a major change; re-grill scope. |
| `serve-knowledge` | Launch the local browsable knowledge site. |
| `query-work` / `no-query-work` | Enter/exit read-only query mode. |
| `imported-learning` | Adopt a `learning.md` + `journal.md` from elsewhere and orient. |

Natural language initiates create/switch/list/details. Gated transitions
(sessions, quizzes, replans) require their reserved keywords.

## State model

`Planning → Approved → Active → Maintaining`, with optional `Paused`.

- `Active`: actively progressing through the curriculum.
- `Maintaining`: curriculum substantially covered; ongoing reinforcement,
  spaced review, and refresher quizzes. Learning subjects rarely "complete".
- Reopen to `Planning` (via `replan-learning`) for a major curriculum change.

## Create sequence (plan the journey)

(applies to `Planning`; see Planning quality bar for the grill)

1. Remind strong model.
2. **Motivation + level first**: why this subject now, current level, target
   outcome, time budget, how they learn best.
3. **Foundations elicitation**: agree the core mental models (basic principles)
   that will be reinforced throughout (these become the pinned `# Foundations`).
4. **Resources**: propose a vetted resource shortlist (books/courses/docs/tools);
   invite the learner to add any they already have. Record chosen refs in
   `# References`; save files/links under `artifacts/resources/`.
5. Draft an **incremental curriculum**: ordered steps from foundations outward,
   each step tied back to the basics, each with practice + evidence.
6. Self-review, then write `learning.md` + seed `journal.md` and `knowledge/index.md`.
7. File review gate: learner reviews the curriculum.
8. `approve-plan` before the first `learn-session`.

## `learning.md` contract (current truth)

Keep title + metadata table in the first ~10 lines (greppable for listing).

```markdown
# <Human Title>

| Key | Value |
|---|---|
| status | Planning |
| slug | learn-x86-asm |
| level | beginner |
| notes | |

# Goal
...
```

Status tokens (exact): `Planning` | `Approved` | `Active` | `Maintaining` | `Paused`.
Required metadata rows: `status`, `slug`, `level`, `notes`.

Required sections (order):

1. `# Goal` — target outcome and why.
2. `# Foundations` — the pinned **core mental models**, each with a `last
   reviewed` date. Reinforced every session; the spine everything relates back to.
3. `# Curriculum` — ordered incremental steps; each names the mental model it
   builds, its practice, the evidence that proves it, and how it connects to the
   foundations.
4. `# Milestones` — MECE learning outcomes with evidence (a quiz score, a working
   solution, an explanation graded ≥ threshold); dated when reached.
5. `# Mastery` — living weak/strong list and per-topic mastery
   (`novice` / `learning` / `solid` / `mastered`), advanced only by evidence.
6. `# Mental Models` — the running catalog of models built. Each entry states
   when to use / what to expect / what NOT to expect / how it relates to similar
   models, plus its projection (story / diagram / analogy / catchphrase) and any
   mnemonics. This is where memory tools live, in service of the models.
7. `# Next Steps` — the safest next learning action.
8. `# References` — resources, related slugs, `knowledge/index.md` link.

- `# Foundations` is near-fixed after planning (a major change → `replan-learning`).
- Template: [`templates.md`](templates.md)

## The learning session (`learn-session`)

The core loop. **Time-boxed to ~20 minutes** (a focused block). In exceptional
cases it MAY run up to 30 minutes; never longer. Break the curriculum into
session-sized chunks: scope each step so its recall + concept + graded practice
comfortably fit the 20-minute box. If a topic is too big, split it across
sessions (part 1/2/...) rather than overrunning. When the box is nearly spent,
wind down — grade, record, and stop — even if the concept is unfinished; carry
the remainder to the next session's `# Next Steps`.

Fixed shape (rough budget within the box):

1. **Foundations recall** (~3 min) — resurface the stalest foundation(s) with a
   quick recall or micro-quiz; update their `last reviewed` date. Reinforce basics.
2. **Build the mental model** (~6 min) — teach the next curriculum step by
   forming its mental model: state when to use it, what to expect, what NOT to
   expect, and how it relates to (and differs from) similar models. Relate it
   back to the foundations. Project it with a story / diagram / analogy /
   catchphrase (MUST); add mnemonics for CLI options, process, and gotchas — all
   in service of the model.
3. **Graded practice** (~8 min) — pose mixed exercises (complete-the-code,
   complete-the-command, explain-a-concept, predict-output, from-scratch). Pick
   types that fit the topic. Learner answers; do not reveal answers first.
4. **Grade + review** (~3 min) — score each exercise 0–5 with a short comment;
   call out a weak point and a strong point; update `# Mastery` (evidence-gated).
5. **Record** — append a **dated** `journal.md` entry (concise: covered,
   scores, weak/strong, next). Save the full transcript (exercises, the
   learner's verbatim answers, grades + comments, projections/mnemonics) to
   `artifacts/sessions/<date>-<topic>.md`. Capture the mental model (with its
   when/what/not/relate and projection) in `# Mental Models` and as a
   `knowledge/` note linked from `index.md`. If the step introduced a heavily-used
   construct/command/arg combo, add it to `knowledge/essentials.md`.

Grading rubric (0–5): 0 no attempt · 1 major gaps · 2 partial · 3 correct with
help · 4 correct, minor slips · 5 fluent and correct. Advance mastery only on
repeated ≥4 evidence.

## `quiz-me`

Standalone graded quiz (broader than one session).

1. Ask scope (topic(s) / whole curriculum / weak spots / `essentials.md` drill)
   and length.
2. Pose questions; collect answers without revealing solutions first.
3. Grade with the rubric; comment on each; summarize weak/strong.
4. Save quiz + answers + grades to `artifacts/quizzes/<date>-<topic>.md`.
5. Update `# Mastery` (evidence-gated) and append a dated journal line.

## `review-progress`

Reconcile the learning plan against reality; grill on weak spots.

1. Read `learning.md`, recent `journal.md`, `notes.md`, and recent
   `artifacts/sessions|quizzes` to gather evidence.
2. Surface: covered vs planned, mastery vs evidence, stale foundations, recurring
   weak points, drift between plan and actual progress.
3. **Grill** the learner on weak areas (use `grill-me` for a deeper drill);
   ask them to explain or re-solve where mastery is claimed but thin.
4. Update `# Curriculum` (reorder/insert reinforcement), `# Mastery`,
   `# Foundations` review dates, and `# Next Steps`. Sharpen the mental model for
   sticky weak spots — clarify what-it-is-not and how-it-relates, and add a
   stronger projection (story/diagram/analogy/catchphrase).
5. If the change is a major scope/curriculum shift, route to `replan-learning`.
6. Append a dated journal entry with the review outcome.

## Knowledge library (`knowledge/`)

Durable, browsable note store. Not part of the portable handoff, but the
long-term value of the journey.

**Findable without reading everything (MUST).** Structure `knowledge/` so the
agent can locate a piece of information from paths and guide files alone — never
by reading every note. Achieve this pragmatically:

- **Descriptive, greppable file names**: name a note after its concept
  (`knowledge/registers/general-purpose-registers.md`), not `note1.md`. The name
  plus its folder should reveal the content. Prefer kebab-case topic names.
- **`dev-guide.md` as the index at each level**: every `knowledge/` subtree that
  holds more than a couple of notes gets a `dev-guide.md` that lists its files
  with a one-line summary each and points to child subtrees (per the repo
  `dev-main` guide rules). A reader walks guides top-down to the right file
  without opening the notes themselves.
- **Structure by usefulness**: add folders + guides only where they earn their
  keep; keep flatter, atomic, Zettelkasten-style notes elsewhere.
- **Atomic notes, heavily cross-linked** with relative markdown links so ideas
  connect. Prefer many small linked notes over few large ones.
- **`index.md` is the home page**: an intuitive, browsable map of the whole
  subject — foundations, topics, resources, and entry points for revision and
  search. Keep it current as notes are added.
- **Break big artifacts down**: when a book/spec/course is a chosen resource,
  progressively distill it into crisp `knowledge/` notes (do not dump the source
  verbatim); link notes back to the source under `artifacts/resources/`.
- **`essentials.md` is the daily-use index (MUST)**: maintain
  `knowledge/essentials.md` listing, per module/command/feature, the most
  common/frequent/important concepts, combinations, features, and commands/args
  — the practical 20% for day-to-day work. Keep it compact, tabular, and
  practiceable (it is a drill target for `quiz-me`), cross-linked to fuller
  notes, and grow it whenever a new heavily-used construct is learned. Link it
  from `index.md`.
- Both learner and agent may edit knowledge notes freely.

### `note-knowledge`

Capture a piece of knowledge into `knowledge/`, or verify it is already noted.

1. Identify the piece of knowledge (from the learner's request, the current
   session, or a distilled resource).
2. **Locate first, using structure not full reads**: consult `index.md` and the
   relevant `dev-guide.md` files and file names to find where it belongs or
   whether it already exists. Do not scan every note.
3. If already noted: verify it is correct and findable; report the path. Improve
   the name/guide entry/cross-links if it was hard to locate.
4. If missing: create an atomic note at a descriptive path, cross-link it to
   related notes and the relevant `# Foundations` model, and capture its mental
   model (when/what/not/relate) with a projection and "watch out" note.
5. **Update the index chain**: add/refresh the note's row in its subtree
   `dev-guide.md` (one-line summary) and, if it is a new entry point, in
   `index.md`. Create a subtree `dev-guide.md` if the folder now needs one.
6. Keep it lean; if the knowledge is a decided item sitting in `notes.md`, fold
   it in and prune the scratch copy.

### `build-knowledge`

Distill a whole resource (a book chapter, doc, course section, spec, article,
tool man page) or a larger detail the learner supplies into structured,
cross-linked `knowledge/` notes. This is the bulk-ingest sibling of
`note-knowledge` (which handles a single piece).

1. **Take the input**: the resource or detail the user names. If it lives under
   `artifacts/resources/`, read it there; otherwise ingest what the user pasted
   or pointed to, and save a copy/link under `artifacts/resources/` for provenance.
2. **Outline before writing**: propose a small set of atomic note topics and the
   subtree/folder they belong in, tying each back to a `# Foundations` principle.
   Confirm placement fits the existing structure (walk `index.md` + `dev-guide.md`,
   do not read every note).
3. **Distill, don't dump**: write crisp atomic notes (not verbatim copies), each
   at a descriptive, greppable path, framing each as a mental model
   (when/what/not/relate) with a projection and "watch out" notes. Cross-link
   related notes and back to the source under `artifacts/resources/`.
4. **Update the index chain**: add/refresh rows in each affected subtree
   `dev-guide.md`, create subtree guides where a folder now warrants one, and add
   new entry points to `index.md`. The new notes MUST be findable via names +
   guides without reading them. Add any heavily-used constructs/commands/args to
   `knowledge/essentials.md`.
5. **Reconcile with the curriculum**: if the material maps to curriculum steps or
   foundations, note the linkage; suggest a `learn-session` or `quiz-me` to
   practice it (do not silently expand scope).
6. Append a dated `journal.md` line noting what was built and from which source.

### `create-cheatsheet`

Build a focused cheatsheet for the content the user describes, saved in
`knowledge/` for later reference through the server.

1. **Scope it**: confirm the focus (topic/tool/language subset) and the intended
   use (quick recall, exam prep, daily reference). Keep it tight — a cheatsheet
   overviews the essentials, not everything.
2. **Curate the essentials**: the most important constructs, commands, arguments/
   flags, and principles for that focus. Pull from `knowledge/` and chosen
   resources; prefer what recurs and what the learner is weak on (`# Mastery`).
3. **Make it graspable fast (MUST)**: project items with stories, diagrams,
   analogies, catchphrases, and mnemonics, plus tiny examples and "watch out"
   callouts, so the sheet builds a working mental model quickly. Ground each
   grouping in the relevant `# Foundations` mental model. Use compact tables and
   short groupings, not prose.
4. **Save under `knowledge/`** at a descriptive path
   (`knowledge/cheatsheets/<focus>.md`), so `serve-knowledge` renders it. Add it
   to the `cheatsheets/` `dev-guide.md` and link it from `index.md`.
5. Cross-link the cheatsheet to the fuller notes it summarizes; keep it lean and
   refresh it as understanding grows. Append a dated journal line.
6. Add any new mental models/projections to `learning.md` `# Mental Models`.

### `serve-knowledge` (browse in a web browser)

Launch the shipped local server. Point it at the **learning root** for a global
index across all activities, or at one activity's `knowledge/` folder:

```bash
# Global: home page lists every activity (title/status/level) with quick links
python3 <skill-dir>/scripts/serve.py .dev-notes/learning

# Single activity (legacy): serve just this activity's knowledge/
python3 <skill-dir>/scripts/serve.py .dev-notes/learning/<slug>/knowledge
```

It auto-detects the mode: a learning root (containing `<slug>/learning.md`)
shows the generated global index linking each activity's knowledge index,
`essentials.md`, and cheatsheets; a single `knowledge/` folder serves `index.md`.
Renders `.md` → HTML (relative links, fenced code, Mermaid); zero dependencies.
See [`scripts/serve.py`](scripts/serve.py). Tell the learner the URL; stop with
Ctrl-C. Prefer global mode so all ongoing learning is reachable from one page.

## `journal.md` contract (history)

- Append-only, **dated** entries (this skill wants dates), concise.
- One short heading per session/quiz/review; skip noise.
- Record: what was covered, scores, weak/strong points, decisions, next action.

## `notes.md` contract (complementary, optional)

- Free-form scratch for learner + agent (open questions, links, half-ideas).
- Not load-bearing for handoff; fold decided items into `learning.md` and prune.
- Free to edit; exempt from checkpoint cadence.

## Artifacts

- `resources/` — chosen books/docs/tools (learner-supplied + agent-vetted);
  large sources distilled into `knowledge/`, not read wholesale each time.
- `sessions/<date>-<topic>.md` — full session transcript incl. verbatim answers.
- `quizzes/<date>-<topic>.md` — quiz, answers, grades, comments.
- Keep the learner's answers verbatim so they can revisit and self-assess later.

## Portability

`learning.md` + `journal.md` are the whole handoff; assume a fresh agent, new
machine, no chat memory. `knowledge/`, `artifacts/`, and `notes.md` enrich but
must not be required to resume.

- Self-contained truth; repo-relative paths; verifiable evidence (a new session
  can re-run the check or re-pose the exercise).
- `# Next Steps` names the safest next learning action for a newcomer.

## Update cadence

- Update `learning.md` at checkpoints: after a session/quiz/review, on a
  mastery change, on curriculum change, before pausing.
- Append one dated journal entry per session/quiz/review.
- `notes.md` is free scratch (exempt). Sync durable items into `learning.md`.
- Always sync before `pause-work` or handing off.

## List / details output

- **List** learning activities: default show `Active` / `Maintaining` / `Paused`
  (exclude nothing by status unless asked); recurse into `learning/`; build a
  table from the first ~10 lines (title/slug/status/level). Prefer `rg`.
- **Details** (no resume): show full path + first ~20 lines of `learning.md`, stop.

## Planning quality bar

(applies to create and `replan-learning`)

- **Motivation + level first**: why now, current level, target, time budget,
  learning style.
- **Foundations rule (MUST)**: agree the core mental models up front; they anchor
  the whole curriculum and are reinforced every session.
- **Mental-model rule (MUST)**: frame each curriculum step as a mental model with
  when-to-use / what-to-expect / what-NOT-to-expect / how-it-relates, projected by
  a story, diagram, analogy, or catchphrase.
- **Incremental rule**: curriculum is ordered small steps, each with practice and
  concrete evidence, each tied back to the foundations.
- Grill vague input: scope in/out, prerequisites, target depth, evidence of done.
- Use `grill-me` when attached or when a fuller design grill is wanted.
- Define resources and what goes to `artifacts/resources/` vs distilled into
  `knowledge/`.
- Plan the projection strategy: which stories/diagrams/analogies/catchphrases
  will make each mental model stick; mnemonics serve the models, not vice versa.
- Self-review curriculum for gaps, missing evidence, and missing basics ties.

Required first prompt (motivation, or equivalent):
> Before the plan: why learn this now, what's your current level, target outcome,
> and time budget — and how do you learn best?

Required foundations prompt (or equivalent):
> What are the core mental models (basic principles) of this subject we should
> pin as Foundations and reinforce every session — and for each, when to use it,
> what to expect, what it is not, and how it relates to nearby ideas?

## `replan-learning`

Use on a major curriculum/scope change (minor edits do not need it).

1. Remind strong model.
2. Re-run the Planning quality bar: motivation/level, foundations, curriculum.
3. Rewrite `# Curriculum` and affected sections; preserve mastery/progress history.
4. If status is not `Planning`, reopen to `Planning` and journal the reason (dated).
5. File review + `approve-plan` before the next session.

## `approve-plan`

1. Validate the curriculum is written and reviewed.
2. Set `status` to `Approved`.
3. Append a dated journal entry (curriculum approved).
4. Note planning is done (learner may switch to a lighter model for sessions).
5. Ask the learner to run `learn-session` to begin.

## `pause-work` / `resume-work`

- `pause-work`: sync `learning.md`, set `status` `Paused`, append a dated journal
  entry with a Resume Hint (best next topic/exercise), present a short summary.
- `resume-work`: read `learning.md` only, then recent `journal.md`. Output a
  concise resume summary (goal, foundations status, mastery, last covered,
  weak spots, next action). If `Paused`/`Active`, wait for confirmation before a
  session. Remind strong model if next is planning/replan.

## `imported-learning`

Adopt a `learning.md` + `journal.md` brought from elsewhere.

1. Locate the pair (ask if ambiguous); treat files as sole truth.
2. Read `learning.md` fully, then recent `journal.md`.
3. Verify progress: re-pose a sample of milestone evidence exercises/quizzes;
   note drift between claimed mastery and demonstrated mastery.
4. Orientation summary: goal, foundations, claimed vs verified mastery, covered
   vs remaining, gaps, safest next action.
5. Place files under `.dev-notes/learning/<slug>/`, reconcile drift, set
   `status` to `Planning` (or `Approved` if approved now). Append a dated import
   journal entry. Do not run a session until `approve-plan`.

## `query-work` / `no-query-work`

- `query-work`: read-only mode; answer questions, make no file/state changes.
  Lasts until `no-query-work` or session end.
- `no-query-work`: exit; changes allowed again.

## Token economy

- Keep `learning.md` and `journal.md` lean; they load on resume.
- Distill big resources into `knowledge/`; link, don't dump.
- Prefer concise bullets; delete stale prose when rewriting `learning.md`.
