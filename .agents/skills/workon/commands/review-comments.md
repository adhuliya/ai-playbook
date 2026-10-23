# `add-review-comments` / `remove-review-comments`

Status: `Active`, `Paused`, `Blocked`, `Complete`. No status change, no
journal. Comment-only edits need neither `policy/execution-gate.md`
nor a `Complete` reopen. Levels: **Comments** (`policy/comments.md`).

Reads: policy/comments.md

`add-review-comments` raises comments in the activity diff to review level,
then sets `review-comments: on`. `remove-review-comments` trims them to
default level, then sets `review-comments: off`.

1. Resolve `base-branch` (`agent-activity.md`), else `origin/<base-branch>`.
   Neither exists → say so, suggest fixing the row, stop. Empty activity
   diff → say so; stop.
2. Read the launch kit and `pipelines/comments.md` (**Background
   sub-agents**). Write `inflight.md` (`policy/inflight.md`). Run
   `pipelines/comments.md`. Scope: lines the activity added or changed;
   comments outside that scope stay as they are.
3. The parent Reads only `comments/verify.md`. Restore every `fail` file
   from its snapshot. Tests `fail` → restore every file. Delete
   `inflight.md`.
4. Set the row only if at least one file kept its edits. Report the files
   changed, and the files restored and why. Running the same command again
   is safe.
