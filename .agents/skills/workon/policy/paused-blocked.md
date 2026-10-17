# Paused vs Blocked

Both record `prior: <status>` in the `activity.md` `notes` row. Only
`resume-work` leaves either status; it restores `prior:` and clears the
entry. `apply-review` never changes these statuses.

- `Paused`: an intentional stop via `pause-work`. Not allowed from `Blocked`.
- `Blocked`: work cannot continue. The agent MAY set it at a checkpoint when
  work is stuck. Add a one-line blocker to `notes`, details in `activity.md`
  `# Next Steps`, and append a `Blocked` event (**Journal policy**).
