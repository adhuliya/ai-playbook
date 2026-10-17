# `mark-completed`

Status: `Active`.

Reads: policy/journal.md, policy/portability.md, policy/reminders.md, policy/activity-md.md, commands/delete-tmp-files.md, shapes/journal.md

0. An `open` review cycle (regular or fix) → ask the user to run
   `apply-review` or to say `defer`. Stop. On `defer` (next turn), mark
   each open point `noted: deferred`, set `status: closed`, append a
   `Review` event, then continue at step 1.
1. The milestones are complete, or the user dropped them with a reason in
   `activity.md`. The last milestone names a runnable e2e command, or the
   user dropped it in `activity.md`; a user nod does not replace a missing
   e2e name. Run that command when the environment can.
2. Rewrite `activity.md` as a maintenance handoff:
   - **Current Design:** shipped behavior, touched paths, must-not-break
     invariants.
   - **Milestones:** checked or dropped, with evidence commands or artifact
     pointers.
   - **Next Steps:** the minor-fix runway (small follow-ups, fastest checks,
     safest first edit targets).
3. Set `status` to `Complete`. The handoff follows **Portability**. Leave
   `plan-outline.md` as the plan overview; rewrite it only if the plan
   changed.
4. Append the `Complete` journal entry (**Journal policy**).
   **Optional-remind** `create-guide` and `remove-review-comments`.
5. **Cleanup:** run the `delete-tmp-files` flow.
6. Later fixes: `resume-work` (`Complete` path), then the **Execution gate**,
   then `mark-completed` again.
