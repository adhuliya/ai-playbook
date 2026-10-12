---
name: skillup
description: >-
  Structured learn-by-practice coach for any subject (assembly, data structures
  & algorithms, OS/atomics theory, tools, Morse, Spanish, ...). Sets up a durable
  learning activity under the learning root (default .dev-notes/learning/<slug>/;
  override with .dev-notes/learning/skillup.dir.txt), plans an incremental
  curriculum, runs graded practice sessions with quizzes and agent review
  comments, tracks dated progress and weak/strong points, and builds a browsable
  knowledge/ library. Optionally binds a Project Lab (in-repo, submodule, or
  path) so lessons navigate a real codebase via learning-relevant dev-guide.md
  files, with locate/trace/patch exercises and oracle checks. Learning is
  organized around durable mental models (reinforced with stories, diagrams,
  analogies, and catchphrases) so core principles and usage stand out. Use when
  the user wants to learn/study a topic, be quizzed, review learning progress,
  learn against a project tree, or issues skillup lifecycle keywords.
disable-model-invocation: true
---

# skillup

Learn-by-practice coach organized around **mental models**. Turns a subject into
a durable, resumable learning journey: incremental curriculum, graded exercises,
dated progress, and a browsable knowledge library. MAY bind a **Project Lab**
(real codebase) for locate/trace/patch practice, using learning-relevant
`dev-guide.md` files for navigation and `knowledge/` for durable learning notes.
Sibling of the `workon` skill (same spirit, learning-flavored); records are the
deliverable — resumable months later.

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
  predict-output, from-scratch; with a Project Lab also locate-and-explain,
  trace-path, patch-and-verify. Exposition exists to enable the practice.
- **Evidence-gated mastery.** Never advance a topic's mastery level without
  exercise/quiz evidence. Prose confidence is not evidence.
- **Dated progress.** Journal entries and milestone/quiz completions carry dates
  (this skill overrides the usual no-dates default).
- **Portable core.** `learning.md` + `journal.md` are a self-contained handoff: a
  fresh agent on another machine can assess and continue with no chat memory,
  host paths, or local state. The `knowledge/` tree is the durable library (see
  [`knowledge`](../knowledge/SKILL.md)).
- **One focused learning activity per chat** (memory only; no focus file).
- **Save the learner's work.** Archive each session (exercises, the learner's
  verbatim answers, grade + comments, mental model + projection offered) so they
  can revisit it.
- **Answer worksheets (MUST).** Before collecting graded answers in
  `learn-session` or `quiz-me`, write a pre-filled prompt worksheet (see
  **Answer worksheets** below). Do not ask the learner to invent a blank file or
  paste long answers only in chat.
- **No micro-edits**: update `learning.md` at meaningful checkpoints, not on
  every step. `notes.md` is exempt (free scratch).
- **Project Lab is optional.** Only when the learner names a repo/path (or
  attaches one later). Non-code subjects stay unchanged.
- **Lab records stay in the notes home.** Never auto-create the learning root
  inside a third-party lab tree. Mode `in-repo` means exercises use that project
  as lab root/cwd only.
- **Guides for relevant subtrees only (MUST).** When a Project Lab is bound,
  `dev-guide.md` files SHALL exist only for **learning-relevant** paths (see
  `# Project Lab` `relevant-paths`), created/audited via [`dev-guides`](../dev-guides/SKILL.md).
  Do not guide the whole upstream tree.
- **Read/navigate by default; writes opt-in.** Prefer locate/explain/trace.
  `patch-and-verify` uses a lesson branch (user or agent may create); agent
  MUST ask once per session before creating/switching branches unless the
  learner already delegated branch handling.
- **No surprise git submodule add.** Mode `submodule`: ask the user for the
  location; record it; multiple learnings MAY share one lab path. Do not run
  `git submodule add` unless the learner asks.

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

**Learning root (MUST resolve first).** Default: `.dev-notes/learning/`. If
`.dev-notes/learning/skillup.dir.txt` exists, that file names the actual learning
root. Resolve it before listing, creating, or opening any learning activity:

1. Read the file. Use the first non-empty line; ignore the rest.
2. Strip surrounding whitespace and at most one trailing `/`.
3. The line MUST be a relative path (no leading `/`, no `~`). Resolve it against
   the directory that contains the file (`.dev-notes/learning/`). Example:
   `../../learning` (trailing slash optional) → repo-root `learning/`.
4. Normalize `..`. The result MUST stay inside the repository (the directory that
   contains `.dev-notes/`). If it would escape, stop and ask.
5. That directory is the **learning root**. Do not mix slugs from
   `.dev-notes/learning/` with the redirected root. `skillup.dir.txt` is a
   pointer, not an activity; the learner places it — do not create it unasked.
6. If the file exists but the line is empty or absolute, or the resolved
   directory is missing when listing/resuming, stop and tell the learner — do not
   silently fall back to the default. Create the resolved directory when creating
   a new activity if it is missing.

```text
<learning-root>/<slug>/
    learning.md              # current truth (rewritable)
    journal.md               # append-only, dated history
    notes.md                 # optional complementary notes (learner + agent)
    knowledge/               # durable note library (see Knowledge library)
        knowledge.md           # root index (per `knowledge` skill)
        essentials.md          # skillup: daily-use 20% (drillable)
        lab-maps/              # optional; Project Lab breadcrumbs
        <topic>/               # optional subtrees; each folder has knowledge.md
        *.md                   # atomic notes, cross-linked
        cheatsheets/*.md
        artifacts/             # sole raw-file store for this tree
            resources/         # books, docs, tool refs
            quizzes/           # <date>-<topic>.md (+ <date>-<topic>-worksheet.md)
            sessions/          # <date>-<topic>.md (+ <date>-<topic>-worksheet.md)
    scripts/                 # optional per-activity helpers
    learning/<child>/        # optional child sub-journey (max depth 2)
```

- Slug: kebab-case, top-level at `<learning-root>/<slug>/`.
- Child ref: `parent-slug/child-slug` → `.../<parent>/learning/<child>/`. Max depth 2.
- Commit the learning root (including useful `knowledge/`) and
  `.dev-notes/learning/skillup.dir.txt` when present. Do not assume a huge lab
  checkout under the notes home is committed — learner owns submodule / ignore
  choices.
- Ambiguous slug: list matches and ask; never guess.
- Browse knowledge via the [`knowledge`](../knowledge/SKILL.md) skill
  (`serve-knowledge`), passing the resolved learning root. Per-activity
  `scripts/` is optional.

## Reserved lifecycle commands

Honor only these exact keywords (ordinary words do not trigger them):

| Keyword | Action |
|---|---|
| `approve-plan` | Mark curriculum approved; ready to learn (no session yet). |
| `learn-session` | Run one graded learning session (the core loop). |
| `quiz-me` | Run a standalone graded quiz and archive it. |
| `review-progress` | Review curriculum + progress + weak spots; grill and update. |
| `create-cheatsheet` | Build a focused cheatsheet (constructs/commands/args/principles + mnemonics) saved in `knowledge/`. |
| `pause-work` | Pause protocol. |
| `resume-work` | Resume protocol. |
| `replan-learning` | Re-open the curriculum on a major change; re-grill scope. |
| `query-work` / `no-query-work` | Enter/exit read-only query mode. |
| `imported-learning` | Adopt a `learning.md` + `journal.md` from elsewhere and orient. |

Natural language initiates create/switch/list/details and Project Lab
attach/change/detach. Gated transitions (sessions, quizzes, replans) require
their reserved keywords. No separate lab keywords — lab spine acceptance is via
`approve-plan` (planning-time) or journal + `guide-spine: accepted` at first lab
session after a mid-journey attach.

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
   `# References`; save files/links under `knowledge/artifacts/resources/`.
5. **Project Lab (only if a repo/path is mentioned)**: run the Project Lab bind
   grill (binding kind, location, remote/clone recipe, seed `relevant-paths`).
   Do not prompt for a lab on non-code subjects. Mid-journey attach is allowed
   later in natural language (no new keyword).
6. Draft an **incremental curriculum**: ordered steps from foundations outward,
   each step tied back to the basics, each with practice + evidence. Lab steps
   stay within `relevant-paths` (grow the list when a later step needs a new
   subtree).
7. Self-review, then write `learning.md` + seed `journal.md` and `knowledge/knowledge.md`.
8. If a Project Lab is bound: invoke [`dev-guides`](../dev-guides/SKILL.md) for
   the learning-relevant sparse guide set before treating the lab spine as ready
   (see Project Lab — guide spine).
9. File review gate: learner reviews the curriculum (and `# Project Lab` if any).
10. `approve-plan` before the first `learn-session`.

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
   foundations. Lab steps MAY cite `relevant-paths` symbols/files and a tour.
4. `# Milestones` — MECE learning outcomes with evidence (a quiz score, a working
   solution, an explanation graded ≥ threshold); dated when reached.
5. `# Mastery` — living weak/strong list and per-topic mastery
   (`novice` / `learning` / `solid` / `mastered`), advanced only by evidence.
6. `# Mental Models` — the running catalog of models built. Each entry states
   when to use / what to expect / what NOT to expect / how it relates to similar
   models, plus its projection (story / diagram / analogy / catchphrase) and any
   mnemonics. This is where memory tools live, in service of the models.
7. `# Next Steps` — the safest next learning action.
8. `# References` — resources, related slugs, `knowledge/knowledge.md` link.

Optional section (when a codebase lab is bound; place **after `# Goal`**):

- `# Project Lab` — binding kind, portable clone recipe, `relevant-paths`,
  lesson-branch convention, guide-spine status. Absolute machine paths stay in
  `notes.md` only. See Project Lab.

`# Foundations` is near-fixed after planning (a major change → `replan-learning`).
Template: [`templates.md`](templates.md)

## Project Lab (optional codebase teaching)

Bind a real project tree so lessons can navigate files/symbols, use
learning-relevant `dev-guide.md` files for orientation, and optionally patch on
a lesson branch with an oracle check. Durable learning notes stay under this
activity's `knowledge/`; guides live **in the lab repo** (owned by
[`dev-guides`](../dev-guides/SKILL.md)).

### When to bind

- **At create:** only if the learner mentions a repo/path; do not interrupt
  non-code journeys.
- **Later:** attach or change a lab in natural language (no new keyword). Full
  `replan-learning` only if goals/foundations change because of the lab.
- **Shared labs:** multiple learning slugs MAY record the same lab location.

### Binding kinds (`binding` field)

| Kind | Meaning |
|---|---|
| `in-repo` | Exercises use the project as lab root/cwd. Skillup records stay in the **notes home**; do not auto-write the learning root into the lab. |
| `submodule` | Lab is (or will be) a **git submodule of the notes-home** repo at a **user-chosen** path. Ask for the location; do not surprise-`git submodule add`. Record relative path + remote URL. |
| `path` | **External checkout** (not necessarily a submodule of notes-home). Record portable clone recipe; keep absolute path in `notes.md` only. |

### `# Project Lab` (portable) vs `notes.md` (local)

In `learning.md` record:

- `binding`: `in-repo` | `submodule` | `path`
- `remote` / clone recipe and default ref (when applicable)
- `lab-path-rel`: notes-home-relative path when `binding` is `submodule`;
  otherwise `(n/a)` (resolve checkout via `notes.md` absolute path)
- `relevant-paths`: learning-relevant subtrees (seed at bind; **grow with curriculum**)
- `branch-prefix`: suggested lesson-branch prefix (default `skillup/<slug>/`)
- `guide-spine`: `pending` | `accepted` (and what was accepted: which guides)
- links to lab-map notes under `knowledge/` once they exist

**MUST NOT** put machine-absolute paths in `learning.md`. Resolve on resume; stash
the working absolute path in `notes.md`.

### Relevant paths + `dev-guides`

- Seed a minimal `relevant-paths` list from the learning goal (e.g. LLVM backend
  paths, not all of LLVM).
- Grow the list when a curriculum step needs a new subtree; before the heavy lab
  task for that subtree, create/audit its guide via `dev-guides`.
- `dev-guide.md` SHALL be required **only** for project subtrees relevant to this
  learning activity (plus a repo-root guide only if needed for orientation).
- **Division of labor (MUST):**
  - **Guides** (`dev-guides`): sparse orientation — layout, invariants, build
    entrypoints, selective artifacts. No tutorials / API dumps (skill anti-bloat).
  - **`knowledge/`**: mental models, thin lab-map breadcrumbs (path/symbol →
    concept), session-grown only (see Knowledge library). Cite guide paths and
    source symbols; do not mirror the tree.

### Guide spine gate

- **Hard gate once per lab:** before the first heavy lab exercise after bind (or
  when Planning includes a lab, as part of `approve-plan`), the guide spine for
  current `relevant-paths` must be created/audited and marked `guide-spine:
  accepted` (journal the acceptance).
- **Later sessions:** soft-check factual staleness (paths/commands); fix small
  factual drift per `dev-guides` rules. Material hierarchy/placement changes
  still go through `dev-guides` + grill — skillup MUST NOT silently redesign guides.
- If spine is not ready: refuse `locate-and-explain` / `trace-path` /
  `patch-and-verify`; prompt invoking `dev-guides` / finishing placement. Other
  non-lab session work may continue.

### Lab exercise types

Add to the practice menu when a Project Lab is bound:

| Type | Role |
|---|---|
| `locate-and-explain` | Open named files/symbols (via guides + tour); answer guided questions. |
| `trace-path` | Follow call/data flow across a small hop count. |
| `patch-and-verify` | Opt-in write on a lesson branch; verify with an oracle. |

**Soft cap (MUST):** at most **one** heavy lab task (`trace-path` *or*
`patch-and-verify`) per ~20-minute `learn-session`, plus light foundations recall.

**Navigation default:** sessions follow the deepest applicable `dev-guide.md`, then
the step's tour (ordered file:symbol list). Free `rg`/wide search only when stuck
or on `review-progress`, or when the learner asks to widen one hop.

### Lesson branches (writes)

- Suggest `skillup/<slug>/<step-or-topic>` (or the recorded `branch-prefix`).
- Always record the **actual** branch name in the session artifact and `# Next Steps`.
- User or agent MAY create branches and save progress there.
- Agent MUST ask once per session before `checkout -b` / branch switch unless the
  learner already said the agent can handle branches this session.
- Prefer not leaving the learner's primary checkout dirty as the lesson vehicle.

### Oracles (`patch-and-verify`)

Every write exercise declares:

- **Success criterion** (plain language) — always.
- **Oracle:** `agent-review` | `diff-hint` | `test/build` — use the strongest
  practical option.
- **Runner:** `agent` | `learner` | `either` — default **learner** for heavy
  builds; agent for tiny/safe checks.

If `test/build` will not fit the time box, **downgrade** to `agent-review` and
record “build verification pending” rather than inventing a green check. Grade
with the usual 0–5 rubric; archive diff summary + oracle output in the session
artifact.

### Resume when the lab is missing

- Non-lab learning (recall, quiz, knowledge review) continues from `learning.md`
  + `knowledge/`.
- For lab work: **rebind** path, **reclone** from recorded remote, or **detach**
  the lab — never invent a path. Update `notes.md` / `# Project Lab` accordingly.

### Detach / change lab

Natural language. Update `# Project Lab` + journal. If foundations/goal shift,
route to `replan-learning`. Clearing `guide-spine: accepted` is required when
`relevant-paths` change materially (re-accept after guide create/audit).

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
   complete-the-command, explain-a-concept, predict-output, from-scratch; with a
   Project Lab also `locate-and-explain`, `trace-path`, `patch-and-verify`). Pick
   types that fit the topic. **At most one** heavy lab task per session.
   **Before collecting answers:** create
   `knowledge/artifacts/sessions/<date>-<topic>-worksheet.md` with every prompt
   and stable item IDs (`1.A`, `3.2`, …) plus empty **Your answer:** blocks (see
   **Answer worksheets**). Tell the learner the path; they fill the worksheet and
   reply when done — do not reveal solutions first. For code edits, also point at
   files under `practice/` when applicable. For lab types: navigate via
   learning-relevant `dev-guide.md` + step tour; enforce guide-spine gate; for
   patches use lesson branch + oracle (see Project Lab).
4. **Grade + review** (~3 min) — score each worksheet item 0–5 with a short comment;
   call out a weak point and a strong point; update `# Mastery` (evidence-gated).
5. **Record** — append a **dated** `journal.md` entry (concise: covered,
   scores, weak/strong, next). Save the graded transcript to
   `knowledge/artifacts/sessions/<date>-<topic>.md` (link the worksheet path;
   copy or quote verbatim answers from the filled worksheet). Capture the mental
   model in `# Mental Models`. For the durable `knowledge/` note + index updates,
   [`curate-knowledge`](../curate-knowledge/SKILL.md) (`add-knowledge`). Grow thin
   lab-map notes when new entry points were taught. If the step introduced a
   heavily-used construct/command/arg combo, add it to `knowledge/essentials.md`.
   Fix only factual guide staleness touched this session; do not dump tutorials
   into `dev-guide.md`.

Grading rubric (0–5): 0 no attempt · 1 major gaps · 2 partial · 3 correct with
help · 4 correct, minor slips · 5 fluent and correct. Advance mastery only on
repeated ≥4 evidence.

## `quiz-me`

Standalone graded quiz (broader than one session).

1. Ask scope (topic(s) / whole curriculum / weak spots / `essentials.md` drill)
   and length.
2. Create `knowledge/artifacts/quizzes/<date>-<topic>-worksheet.md` with prompts
   and **Your answer:** blocks (see **Answer worksheets**); tell the learner the
   path. Collect answers from the filled worksheet — do not reveal solutions first.
3. Grade with the rubric; comment on each; summarize weak/strong.
4. Save quiz + grades to `knowledge/artifacts/quizzes/<date>-<topic>.md` (link the
   worksheet; quote verbatim answers from it).
5. Update `# Mastery` (evidence-gated) and append a dated journal line.

## `review-progress`

Reconcile the learning plan against reality; grill on weak spots.

1. Read `learning.md`, recent `journal.md`, `notes.md`, and recent
   `knowledge/artifacts/sessions` or `knowledge/artifacts/quizzes` to gather evidence.
2. Surface: covered vs planned, mastery vs evidence, stale foundations, recurring
   weak points, drift between plan and actual progress; if Project Lab: path
   resolve, `relevant-paths` vs curriculum, guide factual drift.
3. **Grill** the learner on weak areas (use `grill-me` for a deeper drill);
   ask them to explain or re-solve where mastery is claimed but thin.
4. Update `# Curriculum` (reorder/insert reinforcement), `# Mastery`,
   `# Foundations` review dates, and `# Next Steps`. Sharpen the mental model for
   sticky weak spots — clarify what-it-is-not and how-it-relates, and add a
   stronger projection (story/diagram/analogy/catchphrase). For lab drift, invoke
   `dev-guides` audit on affected `relevant-paths` and refresh thin lab-map notes.
5. If the change is a major scope/curriculum shift, route to `replan-learning`.
6. Append a dated journal entry with the review outcome.

## Knowledge library (`knowledge/`)

Durable note store. **Layout / navigate / serve:** [`knowledge`](../knowledge/SKILL.md) (MUST). **Create / maintain / restructure:** [`curate-knowledge`](../curate-knowledge/SKILL.md) exclusively (`add-knowledge`, `refine-structure`). When the learner needs knowledge written or reorganized, invoke that skill; do not reinvent its workflows here.

**Skillup add-ons (on top):**

- **`essentials.md` (MUST):** daily-use 20% — common concepts, commands/args; compact, tabular, drillable (`quiz-me`); cross-link to fuller notes; link from root `knowledge/knowledge.md`. After `curate-knowledge` adds heavily-used constructs, update `essentials.md`.
- Notes that capture mental models: prefer when/what/not/relate + projection + "watch out"; link to `# Foundations`.
- **Lab maps (when Project Lab bound):** thin orientation notes (entry points, key files, “start here” tours) that link path/symbol → concept and cite lab `dev-guide.md` paths. Grow **only** from what sessions cover (and essentials) — no proactive full-tree catalog; the live repo + guides are authoritative for layout.
- After bulk ingest via `add-knowledge`: reconcile with curriculum; suggest `learn-session` / `quiz-me` when useful (do not silently expand scope).
- **Do not** put tutorials into lab `dev-guide.md` files; invoke [`dev-guides`](../dev-guides/SKILL.md) only to create/audit orientation guides for `relevant-paths`.

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
   (`knowledge/cheatsheets/<focus>.md`). Link it from
   `knowledge/cheatsheets/knowledge.md` and root `knowledge/knowledge.md`.
5. Cross-link the cheatsheet to the fuller notes it summarizes; keep it lean and
   refresh it as understanding grows. Append a dated journal line.
6. Add any new mental models/projections to `learning.md` `# Mental Models`.

Browse via [`knowledge`](../knowledge/SKILL.md) `serve-knowledge` (prefer the
resolved learning root for a global index across activities).

## `journal.md` contract (history)

- Append-only, **dated** entries (this skill wants dates), concise.
- One short heading per session/quiz/review; skip noise.
- Record: what was covered, scores, weak/strong points, decisions, next action.

## `notes.md` contract (complementary, optional)

- Free-form scratch for learner + agent (open questions, links, half-ideas).
- Not load-bearing for handoff; fold decided items into `learning.md` and prune.
- Free to edit; exempt from checkpoint cadence.

## Artifacts (`knowledge/artifacts/`)

- `resources/` — chosen books/docs/tools (learner-supplied + agent-vetted);
  large sources distilled into `knowledge/`, not read wholesale each time.
- `sessions/<date>-<topic>-worksheet.md` — session prompts + learner answers
  (filled before grade; canonical verbatim source).
- `sessions/<date>-<topic>.md` — graded session transcript (links worksheet;
  grades, comments, mental model, lab metadata).
- `quizzes/<date>-<topic>-worksheet.md` — quiz prompts + learner answers.
- `quizzes/<date>-<topic>.md` — graded quiz (links worksheet).
- Keep the learner's answers verbatim so they can revisit and self-assess later.

## Answer worksheets

Pre-written markdown files for graded `learn-session` and `quiz-me` work. The agent
writes prompts; the learner fills **Your answer:** blocks.

**Paths (MUST):**

| Kind | Worksheet | Graded artifact |
|------|-----------|-----------------|
| Session | `knowledge/artifacts/sessions/<YYYY-MM-DD>-<topic>-worksheet.md` | `…/<YYYY-MM-DD>-<topic>.md` |
| Quiz | `knowledge/artifacts/quizzes/<YYYY-MM-DD>-<topic>-worksheet.md` | `…/<YYYY-MM-DD>-<topic>.md` |

**Workflow (MUST):**

1. After teaching the mental model (session) or scoping the quiz, write the
   worksheet with stable item IDs matching the grade table.
2. Tell the learner the repo-relative path; they edit the file and reply when done.
3. Grade from the filled worksheet; record scores in the graded artifact.
4. Do **not** ask for a blank file the learner invents, and do **not** rely on
   chat-only answers for multi-item graded work.

**Hands-on code:** pair the worksheet with `practice/<step-slug>/` when the step
includes `complete-the-code` or `from-scratch` builds; prose answers stay in the
worksheet.

Template: [`templates.md`](templates.md) — `*-worksheet.md`.

## Portability

`learning.md` + `journal.md` are the whole handoff; assume a fresh agent, new
machine, no chat memory. `knowledge/` and `notes.md` enrich but
must not be required to resume.

- Self-contained truth; repo-relative paths; verifiable evidence (a new session
  can re-run the check or re-pose the exercise).
- `# Next Steps` names the safest next learning action for a newcomer.
- Project Lab: portable `# Project Lab` (kind, remote/clone recipe,
  `relevant-paths`, branch prefix, guide-spine status). Absolute lab paths live
  only in `notes.md`; on resume re-resolve (ask / existing checkout) or
  rebind/reclone/detach — never invent a path.

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
- **Project Lab (when applicable)**: choose binding kind; ask submodule/path
  location (user-chosen; sharable); seed `relevant-paths`; plan guide spine via
  `dev-guides`; keep absolute paths out of `learning.md`.
- Grill vague input: scope in/out, prerequisites, target depth, evidence of done.
- Use `grill-me` when attached or when a fuller design grill is wanted.
- Define resources and what goes to `knowledge/artifacts/resources/` vs distilled into
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

Required Project Lab prompt when a repo/path is in play (or equivalent):
> Project Lab: binding `in-repo` | `submodule` | `path`? Where is (or will) the
> checkout live? Remote/clone ref? Which subtrees are in-scope for this learning
> (`relevant-paths`)?

## `replan-learning`

Use on a major curriculum/scope change (minor edits do not need it).

1. Remind strong model.
2. Re-run the Planning quality bar: motivation/level, foundations, curriculum.
3. Rewrite `# Curriculum` and affected sections; preserve mastery/progress history.
4. If status is not `Planning`, reopen to `Planning` and journal the reason (dated).
5. File review + `approve-plan` before the next session.

## `approve-plan`

1. Validate the curriculum is written and reviewed.
2. If `# Project Lab` is present: confirm binding fields + seeded `relevant-paths`;
   ensure the guide spine for those paths is created/audited via `dev-guides` (or
   explicitly deferred with `guide-spine: pending` and `# Next Steps` pointing at
   guide work). When the spine is ready, set `guide-spine: accepted` and journal it.
   Planning-time acceptance of the lab spine is part of this keyword — no separate
   lab keyword.
3. Set `status` to `Approved`.
4. Append a dated journal entry (curriculum approved; lab spine note if any).
5. Note planning is done (learner may switch to a lighter model for sessions).
6. Ask the learner to run `learn-session` to begin (or finish guides first if
   `guide-spine: pending`).

## `pause-work` / `resume-work`

- `pause-work`: sync `learning.md`, set `status` `Paused`, append a dated journal
  entry with a Resume Hint (best next topic/exercise), present a short summary.
- `resume-work`: read `learning.md` only, then recent `journal.md`. Output a
  concise resume summary (goal, foundations status, mastery, last covered,
  weak spots, next action; if Project Lab: binding, whether local path resolves,
  guide-spine status). If the lab path is missing, offer rebind/reclone/detach
  and continue non-lab work until resolved. If `Paused`/`Active`, wait for
  confirmation before a session. Remind strong model if next is planning/replan.

## `imported-learning`

Adopt a `learning.md` + `journal.md` brought from elsewhere.

1. Locate the pair (ask if ambiguous); treat files as sole truth.
2. Read `learning.md` fully, then recent `journal.md`.
3. Verify progress: re-pose a sample of milestone evidence exercises/quizzes;
   note drift between claimed mastery and demonstrated mastery.
4. Orientation summary: goal, foundations, claimed vs verified mastery, covered
   vs remaining, gaps, safest next action.
5. Place files under `<learning-root>/<slug>/`, reconcile drift, set
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
