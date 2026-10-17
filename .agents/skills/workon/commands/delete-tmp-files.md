# `delete-tmp-files`

Status: any. Also run by `mark-completed`. No status change, no journal.

1. List the temporaries of this activity. For each: path, why it looks
   temporary, default.
   - Reserved dirs default to **delete** when their work is done, else
     **keep**: `review/` and `verify-plan/` when no regular cycle is
     `open`; `fix/` when no fix cycle is `open`; `comments/` when no
     comment pipeline is in flight; `bg/M<n>/` when `M<n>` is
     checked.
   - `inflight.md`: never listed; **Inflight pipelines** (`policy/inflight.md`) manages it.
   - Legacy leftovers, default **delete**: `self-review/` and
     `self-review.md`; `bg/milestone-<n>/` and `review/milestone-<n>*`; the
     old snapshot ref `refs/workon/<slug>` when `git for-each-ref
     refs/workon` lists it (delete with `git update-ref -d`).
   - Untracked or gitignored leftovers (scratch dirs, sample outputs,
     dumped test artifacts, isolated-setup envs): default **delete**.
   - Uncertain items: default **keep**.
   - Never list activity files (`activity.md`, `journal.md`, notes files,
     `references.md`, `plan-outline.md`, `reviews.md`, `guide-for-users.md`),
     `.agents/`, `.cursor/`, shipped
     source, real tests, docs, or scripts. List other tracked files only if
     the user points at them.
2. Ask yes / no / mods (**Asking**). Delete only the confirmed set, in one
   call. Confirmed tracked paths allow `git rm`; no other `git rm`.
3. Show what was deleted.
