# `mark-completed`

Status: `Active`.

Reads: policy/journal.md, policy/portability.md, policy/reminders.md, policy/activity-md.md, policy/design-document.md, commands/delete-tmp-files.md, shapes/journal.md

0. An `open` review cycle (regular or fix) → ask the user to run
   `apply-review` or to say `defer`. Stop. On `defer` (next turn), mark
   each open point `noted: deferred`, set `status: closed`, append a
   `Review` event, then continue at step 1.
1. The milestones are complete, or the user dropped them with a reason in
   `agent-activity.md`. The last milestone names a runnable e2e command, or the
   user dropped it in `agent-activity.md`; a user nod does not replace a missing
   e2e name. Run that command when the environment can.
2. Rewrite `spec-design.md`'s Current Design section as a maintenance handoff:
   shipped behavior, touched paths, must-not-break invariants. Flip every
   remaining `(planned for M<n>)` tag in Traceability to `(done by M<n>)`
   (or the activity's chosen term) for a checked milestone, and fill its
   Paths. Rewrite
   `agent-activity.md` as a maintenance handoff:
   - **Milestones:** checked or dropped, with evidence commands or artifact
     pointers.
   - **Next Steps:** the minor-fix runway (small follow-ups, fastest checks,
     safest first edit targets).
3. Set `status` to `Complete`. The handoff follows **Portability**. Leave
   `spec-plan-outline.md` as the plan overview; rewrite it only if the plan
   changed.
4. Append the `Complete` journal entry (**Journal policy**).
   **Optional-remind** `create-guide`, `remove-review-comments`, and
   `detailed-design` (when `spec-design.md`'s Decisions section has grown past
   a few entries).
5. **Cleanup:** run the `delete-tmp-files` flow.
6. Later fixes: `resume-work` (`Complete` path), then the **Execution gate** (`policy/execution-gate.md`),
   then `mark-completed` again.
