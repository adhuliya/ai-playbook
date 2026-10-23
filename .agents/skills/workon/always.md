# Always-on rules

Read once per session, before the first command. These rules hold on every
turn.

## Commands

Follow only the loaded command file and the policies it names; ignore rules
that belong to another command. Run the steps in order. The word "Stop"
ends the command and the turn. Every command needs one focused activity,
except `help`, `import-activity`, `create`, `list`, `query-work`,
`no-query-work`, `teach-off`, `teach-brief`, and `teach-deep`. When the
status is not on the file's `Status:` line,
report the status and stop. `start-review`, `apply-review`, `verify-plan`,
and **draft-check** are four distinct steps; do not treat one as another.

## Stops

- **One focus.** Hold one focused activity in memory (no `.focus` file). A
  switch replaces the focus; announce it. Never silently edit a non-focused
  activity. In a new chat without a named activity, `list` and ask.
- **Keyword gate** holds. A Goal or Scope rewrite, an RD change after
  approval, or new durable work is a **Material-change**
  (`policy/material-change.md`): read it and prompt the choice; do not
  rewrite scope first.
- No dates in `agent-activity.md` or `agent-journal.md` unless asked.
- `agent-activity.md` is the current execution truth; rewrite stale sections.
  Every status or direction change writes the journal (**Journal policy**,
  `policy/journal.md`).
- No product engineering before `start-building` (**Execution gate**,
  `policy/execution-gate.md`). On `full`, `approve-plan` and
  `conventions-ok` come first. Records and replies follow **Writing
  style**; handoff files follow **Portability** (`policy/portability.md`).
- **Guide the user** on every reply that runs a command or meets an unusual
  situation.
- On `full`, delegate through **Background sub-agents**. On `thin`, plan
  and build inline (**Activity kind**). Edit records at **Update
  cadence** checkpoints (`policy/update-cadence.md`), not as micro-edits.
  Never bulk-read the **Catalog**; use `list` and `rg`.
- **Query mode.** `query-work` sets a session flag that blocks every
  mutation until `no-query-work` or session end; its file lists what stays
  allowed. On a blocked request, say query mode is on and ask for
  `no-query-work`.
- **User away.** `user-away` sets a session flag that ends at the user's
  next message (`commands/user-away.md`). While it holds, ask nothing.
- **Teach mode.** `teach-off` / `teach-brief` / `teach-deep` set a session
  flag for how much the agent explains the domain and engineering content
  of the current task (design rationale, implementation concepts,
  tradeoffs) in replies; default `off`. Independent of query mode and user
  away; never adds teaching prose to records. See `commands/teach-mode.md`.
- **Pipeline in flight.** While `artifacts/inflight.md` exists, a pipeline
  of background sub-agents is running (**Inflight pipelines**,
  `policy/inflight.md`). Activity files are frozen except for the parent's
  own steps of that pipeline; skip session start; refuse mutating keywords
  and name the pipeline. Allowed: `help`, `query-work`, `no-query-work`,
  list, details, reads. In a new chat with `inflight.md` present, name the
  pipeline from it and ask whether to wait or abandon; abandon deletes
  `inflight.md`.

## Keyword gate

Natural language is fine for discussion, create, switch, list, and details.
A gated transition needs the exact reserved keyword. When you detect the
intent, do not transition silently; prompt the keyword, for example `If you
want to replan, write \`replan-work\`.` A plain "Resume <slug>" means switch
plus context reload; when the status is `Paused`, `Blocked`, or `Complete`,
prompt `resume-work`.

Exceptions: the agent MAY run the **Consistency check**
(`policy/consistency-check.md`) without a keyword, and `mark-completed`
runs the `delete-tmp-files` flow. Both confirm each item. A `yes` to the
`approve-plan` conventions offer counts as `conventions-ok`.

## Guide the user

Assume the user is new to workon or to this situation. The user should
always know where the activity stands and what to type next.

- After each command or pipeline step, end with at most three lines: what
  just happened, the current state (status, stage, open cycle, pipeline),
  and the next one or two exact keywords or replies.
- On the first use of a concept this session (cycle, fix cycle, stage,
  review comments, inflight pipeline), explain it in one plain sentence.
- On a refused or gated request, say why in one sentence and give the exact
  keyword that unlocks it.
- Map an exceptional situation onto the defined set (a status, a command, a
  cycle kind, or a **Stops** rule) and name the mapping in one sentence:
  "This is source drift; `fix-activity` handles it." Never invent a flow,
  file, status, or keyword. If no mapping fits, stop, describe the
  situation, and ask with **Asking** (two or three defined options).
- Keep guides short. `help` is the full answer for "what now?".

## Asking

Use the harness's structured question tool (**ask the user** in
`.agents/rules/dev-main.md`) for every question: grill, confirm gate, two
plausible readings, choice between paths. With no such tool, list the
options as `a)`, `b)`, `c)` in chat and let the user answer with a letter.

- Give 2–4 options. Put the recommended one first and end its label with
  `(Recommended)`. Add a clause on the consequence when it is not obvious.
  Do not add an "Other" option; the tool offers free text.
- Ask one question per call while grilling. Independent confirm questions
  MAY share one call.
- A yes / no / mods gate has the options `Yes (Recommended)`, `No`, and
  `Modify`; mark the one that fits the case.
- Explore the repo first; ask only what it cannot answer. Ask for a bare
  fact (a name, a path) in plain chat and propose a default.
- Under **User away**, do not ask: take the recommended option, record it
  as an assumption, and ask when the user returns.

## Fewer prompts

Each permission prompt costs the user a click. Plan the tool calls to need
fewer.

- Read independent files in one message. Use one `rg` or `head` call when
  you need lines, not whole files.
- Chain dependent read-only shell steps with `&&` or `;`. Batch the file
  creations of one step in one call. Run the setup, build, and test
  commands of a build or review turn in as few calls as you can.
- Never chain a destructive or state-changing command (`rm`, `git rm`,
  `git commit`, an install) with reads; chain such commands only within one
  confirmed set.
- Prefer common commands (`rg`, `ls`, `head`, `git status`, `git diff`) to
  bespoke scripts, and the edit tools to shell redirection.

## Background sub-agents

The **launch kit** is `policy/launch.md`, `policy/inflight.md`,
`policy/paths.md`, `policy/parent-reads.md`, `policy/critic-pair.md`, and
the file in `pipelines/` for the pipeline you run. Read the kit before you
launch any sub-agent, not before. A command whose steps always launch lists
the kit in its `Reads:`.

On `full`, delegate work by default: give each sub-agent one
self-contained part, keep write paths disjoint, and use files as the
handoff. Work inline for a few tool calls, or when a split would overlap
writes. For full planning, launch explores, then grill, then end the
turn. Judge with the **critic pair**, never with one agent. On `thin`,
do not launch explores or a pipeline unless the user typed that keyword.
