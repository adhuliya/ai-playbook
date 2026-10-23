# `pause-work`

Status: `Planning`, `Approved`, `Active`. Already `Paused`: say so and
prompt `resume-work`. `Blocked`: quote the blocker and prompt
`resume-work`. `Complete` is a no-op; prompt `resume-work`. While
`artifacts/inflight.md` exists, stop. The user may wait, or ask to
abandon. Do not set `Paused`.

Reads: policy/paused-blocked.md, policy/journal.md, policy/reminders.md, policy/update-cadence.md, shapes/journal.md

1. Sync `agent-activity.md` and RD / Design Decisions / Conventions if they
   changed.
2. Set `status` to `Paused` with `prior:` beside any existing notes text
   (**Paused vs Blocked**). Keep the current `# Next Steps` list. Prepend
   a resume block: `kind`, `stage`, `conventions`, and one next keyword.
   An open grill branch is `open question:` plus that question. Do not
   name `requirements-ok` while a branch is open. An unfinished
   requirement is `unfinished requirement:` plus the missing point. Do
   not name `start-building` while one remains. `stage: requirements`
   with no open branch names `requirements-ok`. Full `Planning` in
   `stage: design` names `approve-plan`. `Active` names `continue`.
   `Approved` with `conventions: pending` names `conventions-ok`.
   `Approved` with `conventions: ok` names `start-building`. Thin
   `Planning` with nothing unfinished names `start-building`.
3. Append the pause recap (**Journal policy**). The arrow uses the real
   from status. Present a short pause summary. Prompt `resume-work`.
4. **Optional-remind** `apply-review`. It is not the way out of `Paused`.
