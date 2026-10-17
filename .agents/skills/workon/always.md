# Always-on rules

Read once per session, before the first command. These rules hold on every
turn.

## Commands

Follow only the loaded command file and the policies it names; ignore rules
that belong to another command. Run the steps in order. The word "Stop"
ends the command and the turn. Every command needs one focused activity,
except `help`, `import-activity`, `create`, `list`, `query-work`, and
`no-query-work`. When the status is not on the file's `Status:` line,
report the status and stop. `start-review`, `apply-review`, `verify-plan`,
and **draft-check** are four distinct steps; do not treat one as another.

## Stops

- **One focus.** Hold one focused activity in memory (no `.focus` file). A
  switch replaces the focus; announce it. Never silently edit a non-focused
  activity. In a new chat without a named activity, `list` and ask.
- **Keyword gate** holds. A Goal or Scope rewrite, an RD change after
  approval, or new durable work is a **Material-change**: read it and
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
  mutation until `no-query-work` or session end; its file lists what stays
  allowed. On a blocked request, say query mode is on and ask for
  `no-query-work`.
- **User away.** `user-away` sets a session flag that ends at the user's
  next message (`commands/user-away.md`). While it holds, ask nothing.
- **Pipeline in flight.** While `artifacts/inflight.md` exists, a pipeline
  of background sub-agents is running (**Inflight pipelines**). Activity
  files are frozen except for the parent's own steps of that pipeline; skip
  session start; refuse mutating keywords and name the pipeline. Allowed:
  `help`, `query-work`, `no-query-work`, list, details, reads. In a new chat
  with `inflight.md` present, name the pipeline from it and ask whether to
  wait or abandon; abandon deletes `inflight.md`.

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
  just happened, the current state (status, stage, open cycle, pipeline),
  and the next one or two exact keywords or replies.
- On the first use of a concept this session (cycle, fix cycle, stage,
  review comments, inflight pipeline), explain it in one plain sentence,
  once.
- On a refused or gated request, say why in one sentence and give the exact
  keyword that unlocks it.
- Map an exceptional situation onto the defined set (a status, a command, a
  cycle kind, or a **Stops** rule) and name the mapping in one sentence:
  "This is source drift; `fix-activity` handles it." Never invent a new
  flow, file, status, or keyword. If no mapping fits, stop, describe the
  situation, and ask with **Asking**: two or three defined options, the
  recommended one first.
- Keep guides short. `help` stays the full answer for "what now?".

## Asking

Use the harness's structured question tool (**ask the user** in
`.agents/rules/dev-main.md`) for every question: grill, confirm gate, two
plausible readings, choice between paths.

- Give 2–4 options. Put the recommended one first and end its label with
  `(Recommended)`. Add a clause on the consequence when it is not obvious.
  The tool already offers free text; do not add an "Other" option.
- Ask one question per call while grilling. Independent confirm questions
  MAY share one call.
- A yes / no / mods gate has the options `Yes (Recommended)`, `No`, and
  `Modify`, with the recommended one chosen to fit the case.
- Explore the repo first; ask only what it cannot answer. Ask for a bare
  fact (a name, a path) in plain chat and propose a default.
- With no such tool, list the options as `a)`, `b)`, `c)` in chat, mark the
  recommended one, and let the user answer with a letter.
- Under **User away**, do not ask: take the recommended option, record it
  as an assumption, and ask when the user returns.

## Fewer prompts

Each permission prompt costs the user a click. Plan the tool calls to need
fewer.

- Read independent files in one message. Use one `rg` or `head` call when
  you need lines, not whole files.
- Chain dependent read-only shell steps in one command with `&&` or `;`.
  Batch the file creations of one step in one call.
- Never chain a destructive or state-changing command (`rm`, `git rm`,
  `git commit`, an install) with reads. Chain such commands only within one
  confirmed set.
- Prefer common commands (`rg`, `ls`, `head`, `git status`, `git diff`) to
  bespoke scripts, and the edit tools to shell redirection.
- Before a build or review turn, list the setup, build, and test commands
  you need and run them in as few calls as you can.

## Background sub-agents

Read `policy/launch.md` and its kit (`policy/inflight.md`,
`policy/paths.md`, `policy/parent-reads.md`, `policy/critic-pair.md`, and
the file in `pipelines/`) before you launch any sub-agent. Delegate work by
default: give each sub-agent one self-contained part, keep write paths
disjoint, and use files as the handoff. Work inline for a few tool calls,
or when a split would overlap writes. For planning, launch explores, then
grill, then end the turn. Judge with the **critic pair**, never with one
agent.
