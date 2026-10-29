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
   (**Paused vs Blocked**). Keep the current `# Next Steps` list,
   including `In progress:` when a pipeline is in flight. Prepend a
   resume block: `kind`, `stage`, `conventions`, and one next keyword.
   An open grill branch is `open question:` plus that question, in every
   stage. Do not name `requirements-ok`, `approve-plan`, or
   `start-building` while a branch is open. An unfinished requirement is
   `unfinished requirement:` plus the missing point, for any kind. Do
   not name `start-building` while one remains. While a pipeline is in
   flight, the next keyword is `resume-work`. Otherwise, when no branch
   is open and nothing is unfinished, name one keyword.
   `stage: requirements` and `kind: thin` names `make-full`.
   `stage: requirements` and `kind: full`, with no open branch, when RD
   looks complete, names `requirements-ok`. Full `Planning` in
   `stage: design` names `approve-plan`. `Active` names `continue`, or
   `continue: auto` when that row is `auto`. `Approved` with
   `conventions: pending` names `conventions-ok`. `Approved` with
   `conventions: ok` names `start-building`. Thin `Planning` in
   `stage: design` with nothing unfinished names `start-building`.
3. Append the pause recap (**Journal policy**). The arrow uses the real
   from status. While a pipeline is in flight, `done` lists work already
   checked, `next` is `resume-work`, and `watch` names the pipeline, the
   unit, and the final path. Sub-agents may still write. Present a short
   pause summary. Prompt `resume-work`. While a pipeline is in flight,
   also say they can wait in this chat, or ask to abandon.
4. **Optional-remind** `apply-review` only when no pipeline is in flight.
   It is not the way out of `Paused`.
