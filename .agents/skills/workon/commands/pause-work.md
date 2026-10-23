# `pause-work`

Status: `Planning`, `Approved`, `Active`. `Blocked` is already stopped; say
so. `Complete` is a no-op; use `resume-work`.

Reads: policy/paused-blocked.md, policy/journal.md, policy/reminders.md, policy/update-cadence.md, shapes/journal.md

1. Sync `agent-activity.md` and RD / Design Decisions / Conventions if they
   changed.
2. Set `status` to `Paused` with `prior:` (**Paused vs Blocked**). Put the
   resume context in `# Next Steps`.
3. Append the pause recap (**Journal policy**). Present a short pause
   summary.
4. **Optional-remind** `apply-review`.
