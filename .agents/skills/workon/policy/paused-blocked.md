# Paused vs Blocked

Both record `prior: <status>` in the `agent-activity.md` `notes` row,
beside any text already there. Only `resume-work` leaves either status.
It restores that token and removes the token only. A blocker line is
removed with it. Other notes text stays.

If `prior:` is missing, or it is `Paused` or `Blocked`, ask which of
`Planning`, `Approved`, or `Active` to restore. Do not append the resume
recap until the user names one.

`apply-review` never changes these statuses. After it closes a cycle
while the status is `Paused` or `Blocked`, prompt `resume-work`.

- `Paused`: an intentional stop via `pause-work`. Not allowed from `Blocked`.
- `Blocked`: work cannot continue. The agent MAY set it at a checkpoint when
  work is stuck. Add a one-line blocker to `notes`, details in `agent-activity.md`
  `# Next Steps`, and append a `Blocked` event (**Journal policy**). Quote
  the blocker, then prompt `resume-work`.
