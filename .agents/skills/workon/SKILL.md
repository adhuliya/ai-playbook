---
name: workon
description: >-
  Manage durable activities under .dev-notes/activities/ (activity record,
  journal, requirements, design decisions, conventions, reviews, user guide).
  Use when the user manages or imports an activity, or issues a workon
  keyword: help, approve-plan, conventions-ok, start-building, pause-work,
  resume-work, mark-completed, replan-work, create-sibling, import-activity,
  start-review, apply-review, verify-plan, update-convention,
  add-review-comments, remove-review-comments, fix-activity, compact-journal,
  create-guide, delete-tmp-files, query-work, no-query-work.
disable-model-invocation: true
---

# workon

workon manages activities. An activity is one unit of work with its own
folder under `.dev-notes/activities/<slug>/`. Its records must let a fresh
agent resume the work months later.

## How it works

An activity moves through `Planning → Approved → Active → Complete`, with
optional `Paused` or `Blocked` stops. The user drives each transition with a
reserved keyword such as `approve-plan`, `start-building`, or
`mark-completed`. The agent plans, builds, and keeps the records current,
but never crosses a gate on its own.

Each folder holds a fixed set of files. `activity.md` is the current truth:
status, goal, scope, design, plan, milestones, next steps. `journal.md` is
the append-only event timeline. `requirement-def.md`, `design-choices.md`,
and `conventions.md` hold numbered entries (`RD<n>`, `DC<nn>`, `CONV<n>`)
that the plan cites by ID. `notes-by-user.md` belongs to the user.
`reviews.md` records review cycles (`RU<n>`). `user-guide.md` is written for
humans when the work ships. `artifacts/` holds cited copies and sub-agent
output. Shapes: `templates.md`.

Work runs in three phases. In planning, the agent grills the user and drafts
the records, and the user reviews them. At the gates, the user approves the
plan and the conventions, then starts the build. In building, the agent runs
milestones through sub-agents, collects test evidence, and reviews the
result. Reviews, plan checks, and drift repair run as pipelines of
background sub-agents that write files; the parent reads only the final
file.

## How to read this skill

`SKILL.md` is the only file the harness loads. Everything else arrives
through one helper, run from the repo root:

```bash
bash .agents/skills/workon/scripts/workon.sh <sub> [args]
```

| Sub-command | Prints or does |
|---|---|
| `load <keyword>` | the command heading plus every section its `Reads:` line names: the whole turn in one call |
| `section <name>...` | a named section (`Reviews`, `templates.md#journal.md`) or a whole file (`planning.md`) |
| `probe <slug>` | the **Session probe**: metadata table, missing notes files and rows (created and filled), legacy markers |
| `snapshot <slug> [--pin]` | the `synced` **snapshot** commit; `--pin` pins `refs/workon/<slug>` and writes the row |
| `base <commit>` | the **`synced` base** of a snapshot and its baseline mode (`ok`, `rewritten`, `none`) |
| `list [--all]` | the activity table (**Catalog** list) |

A turn goes: `probe` once per session before the first activity-file read
or write (`legacy: yes` → `section Repair`); `load <keyword>` for the
command; `section <name>` for a bold name the loaded text uses but does not
contain. Natural language maps to the keyword it means (**Keyword gate**)
or to one of the natural-language headings: `create` (new work), `list`,
`build` (an engineering turn), `feedback` (chat comments on the work). Do
not Read skill files directly; `load` replaces them. Load `editing.md`
before you change a file in this skill directory, never while you run an
activity.

A bold name points at a heading or a bold term. The **Index** says which
file owns each name; a qualified name such as **Reviews** fix first lives in
the file that owns the first word; any other bold name lives in this file.
Apply the named text; do not restate it.

## Index

| File | Names |
|---|---|
| `commands.md` | one heading per keyword, plus `create`, `list`, `build`, `feedback` |
| `lifecycle.md` | Session probe, Execution gate, Material-change, Paused vs Blocked, Reminders, Optional-remind, Journal policy, Update cadence, Consistency check |
| `records.md` | Layout, `activity.md`, snapshot, `synced` base, IDs, Catalog, User guide, Portability |
| `planning.md` | Planning quality bar, Definition bootstrap, Create sequence, Cited context, draft-check, File review |
| `notes-files.md` | Notes files, Repair, Problem header, Isolated setup |
| `review-policy.md` | Reviews, Apply timing |
| `building.md` | Test evidence, Engineering while focused, Comments |
| `subagent-contract.md` | Launch, Prompt shape, Inflight pipelines, Paths and readiness, Parent reads, critic pair, Pipelines |
| `briefs/` | one file per sub-agent role; sub-agents read them, the parent does not |
| `templates.md` | the shape of every record |
| `editing.md` | Editing the workon skill |

## Commands

Follow only the loaded heading and the policies it names; ignore rules that
belong to another command. Run the steps in order. The word "Stop" ends the
command and the turn. Every command needs one focused activity, except
`help`, `import-activity`, `create`, `list`, `query-work`, and
`no-query-work`. When the status is not on the heading's `Status:` line,
report the status and stop. `start-review`, `apply-review`, `verify-plan`,
and **draft-check** are four distinct steps; do not treat one as another.

## Stops

These rules hold on every turn.

- **One focus.** Hold one focused activity in memory (no `.focus` file). A
  switch replaces the focus; announce it. Never silently edit a non-focused
  activity. In a new chat without a named activity, `list` and ask.
- **Keyword gate** holds. A Goal or Scope rewrite, an RD change after
  approval, or new durable work is a **Material-change**: load it and
  prompt the choice; do not rewrite scope first.
- No dates in `activity.md` or `journal.md` unless asked.
- `activity.md` is the current execution truth; rewrite stale sections.
  Every status or direction change writes the journal (**Journal policy**).
- No product engineering before `approve-plan`, `conventions-ok`, and
  `start-building` (**Execution gate**). Records and replies follow
  **Writing style**; handoff files follow **Portability**.
- **Guide the user** on every reply that runs a command or meets an unusual
  situation.
- Delegate through **Background sub-agents**. Edit records at
  **Update cadence** checkpoints, not as micro-edits. Never bulk-read the
  **Catalog**; use `list` and `rg`.
- **Query mode.** `query-work` sets a session flag that blocks every
  mutation until `no-query-work` or session end; its heading lists what
  stays allowed. On a blocked request, say query mode is on and ask for
  `no-query-work`.
- **Pipeline in flight.** While `artifacts/inflight.md` exists, a pipeline
  of background sub-agents is running (**Inflight pipelines**). Activity
  files are frozen except for the parent's own steps of that pipeline;
  skip the session probe; refuse mutating keywords and name the pipeline.
  Allowed: `help`, `query-work`, `no-query-work`, list, details, reads. In
  a new chat with `inflight.md` present, name the pipeline from it and ask
  whether to wait or abandon; abandon deletes `inflight.md`.

## Keyword gate

Natural language is fine for discussion, create, switch, list, and details.
A gated transition needs the exact reserved keyword. When you detect the
intent, do not transition silently; prompt the keyword, for example `If you
want to replan, write \`replan-work\`.` A plain "Resume <slug>" means switch
plus context reload; when the status is `Paused`, `Blocked`, or `Complete`,
prompt `resume-work`.

Exceptions: the agent MAY run the **Consistency check** without a keyword,
and `mark-completed` runs the `delete-tmp-files` flow. Both confirm each
item. A `yes` to the `approve-plan` conventions offer counts as
`conventions-ok`.

## Guide the user

Assume the user may be new to workon or to this situation. The user should
always know where the activity stands and what to type next.

- After each command or pipeline step, end with at most three lines: what
  just happened, the current state (status, open cycle, pipeline), and the
  next one or two exact keywords or replies.
- On the first use of a concept this session (cycle, fix cycle, `synced`,
  review comments, inflight pipeline), explain it in one plain sentence,
  once.
- On a refused or gated request, say why in one sentence and give the exact
  keyword that unlocks it.
- Map an exceptional situation onto the defined set (a status, a command, a
  cycle kind, or a **Stops** rule) and name the mapping in one sentence:
  "This is source drift; `fix-activity` handles it." Never invent a new
  flow, file, status, or keyword. If no mapping fits, stop, describe the
  situation, and offer two or three defined options with a recommendation.
- When a request has two plausible readings, ask one short question with a
  recommended answer instead of guessing.
- Keep guides short. `help` stays the full answer for "what now?".

## Writing style

Follow ASD-STE100 about 70% of the way: readable, not mechanical.
Be terse and spend few tokens.
This style applies to all agent text: replies, code
comments, `user-guide.md`, user docs the activity writes, these skill
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
- Do not apply the strict STE approved-word dictionary.
- Write in a clear, readable style using simple, well-formed sentences and
  cohesive paragraphs that flow naturally and make the content easy 
  for the user to understand. 

**Records** (activity files, journal recaps, `reviews.md`, sub-agent
reports): bullets and fragments. Drop articles when the line stays
unambiguous. Pattern: `[thing] [action] [reason].` Shapes: `templates.md`.

**Prose** (replies, code comments, `user-guide.md`, user docs, skill
instructions, grill questions, confirm gates): full sentences with
articles. One instruction per sentence, in the imperative. Instructions ≤
20 words; descriptions ≤ 25 words. Group sentences into short paragraphs of
one idea each; lead with the topic sentence, then order known before new so
the sentences chain. Use a list or table for enumerations and lookups. When
a record fragment would scramble an order, a constraint, or a confirm, use
prose.

## Background sub-agents

Load `subagent-contract.md` before you launch any sub-agent; it owns
launch, depth, waits, and parent reads, and each role's instructions live in
`briefs/`, read by the sub-agent itself. Delegate work by default: give each
sub-agent one self-contained part, keep write paths disjoint, and use files
as the handoff. Work inline for a few tool calls, or when a split would
overlap writes. For planning, launch explores, then grill, then end the
turn. Judge with the **critic pair**, never with one agent.
