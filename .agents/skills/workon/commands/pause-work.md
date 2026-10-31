# `pause-work`

Status: `Planning`, `Approved`, `Active`. Already `Paused`: say so and
prompt `resume-work`. `Blocked`: quote the blocker and prompt
`resume-work`. `Complete` is a no-op; prompt `resume-work`. A pipeline
in flight does not block this command.

Reads: policy/paused-blocked.md, policy/journal.md, policy/reminders.md, policy/update-cadence.md, policy/inflight.md, shapes/journal.md

1. When `artifacts/inflight.md` exists, do not sync records. Otherwise
   sync `agent-activity.md` and RD / Design Decisions / Conventions if
   they changed.
2. Set `status` to `Paused` with `prior:` beside any existing notes text
   (**Paused vs Blocked**). Record where the agent stopped and what
   remains. Put both in the pause recap and in `# Next Steps` item 1.
   Do not add a new recap label. Keep item 1 short. Do not write a
   transcript. Keep the rest of the list, including `In progress:` when
   a pipeline is in flight. Add a resume block after that item: `kind`,
   `stage`, `conventions`, and one next keyword. When
   `artifacts/inflight.md` already exists, keep the file. Do not delete
   it. Add where the agent stopped and what remains to its `notes:` line.
   Read `shapes/layout.md` before that edit.
   An open grill branch is `open question:` in every stage. When the
   pause is a grill, read `policy/grill.md`. Do not create
   `artifacts/inflight.md`. Write each unanswered grill question as
   `working: <question>` in `artifacts/agent-notes.md`. Write each other
   open question that is not already there the same way. Create the file
   with H1 `# Agent notes` when it is missing. Do not create another
   scratch file.
   Do not name `requirements-ok`, `approve-plan`, or
   `start-building` while a branch is open. An unfinished requirement is
   `unfinished requirement:` plus the missing point, for any kind. Do
   not name `start-building` while one remains. While a pipeline is in
   flight, the next keyword is `resume-work`. Otherwise, when no branch
   is open and nothing is unfinished, name one keyword.
   `stage: requirements` and `kind: thin`: follow **Choose**. A typed
   `thin` names `start-building`. When the user did not type `thin`, set
   `kind` to `full`, follow `commands/make-full.md`, and name
   `requirements-ok`. Do not name `make-full`.
   `stage: requirements` and `kind: full`, with no open branch, when RD
   looks complete, names `requirements-ok`. Full `Planning` in
   `stage: design` names `approve-plan`. `Active` names `continue`, or
   `continue: auto` when that row is `auto`. `Approved` with
   `conventions: pending` names `conventions-ok`. `Approved` with
   `conventions: ok` names `start-building`. Thin `Planning` in
   `stage: design` with nothing unfinished names `start-building`.
3. Append the pause recap (**Journal policy**). Do not copy
   `artifacts/inflight.md` into the journal. The arrow uses the real
   from status. While a pipeline is in flight, `done` lists work already
   checked, `next` is `resume-work`, and `watch` names the pipeline, the
   unit, and the final path. Sub-agents may still write. Present a short
   pause summary. Prompt `resume-work`. While a pipeline is in flight,
   also say they can wait in this chat, or ask to abandon.
4. **Optional-remind** `apply-review` only when no pipeline is in flight.
   It is not the way out of `Paused`.
