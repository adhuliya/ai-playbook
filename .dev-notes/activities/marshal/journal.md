# Journal

## Planning grill

Created `marshal` after project-fit + scope grill. Locked: hostname machines/ registry + aliases; hard-link repair (identical re-link, conflict prompt, `--force` playbook wins); `--yes` vs `--force`; ignoresync hierarchy with `!`; `--machine` syncmap-only (not default); `.cursor/` one-way / notes+guides bidirectional; target git-tracked warn-and-skip; docs + `smoke-test-sync-marshal.sh`. Awaiting plan review → `approve-plan` → `start-building`.

## Approved + start-building

Plan approved; status → Active. Beginning implementation (sync rewrite, ignoresync, `--machine`, marshal smoke, docs).

## Implementation checkpoint

Shipped sync rewrite + `ignoresync.txt` + `machines/` + `--machine` syncmap + docs. Both smoke tests green. Next: fill real machine project paths / syncmap; then `complete-work` when ready.

## Complete

Status → Complete. Smokes green; docs match. Operator still fills real machine paths/syncmap as needed. Resume Hint: bugs or scheme tweaks → `resume-work` (reopen Planning; material change → `replan-work` / derive).

## Resume — nested git / submodule guides

Reopened Complete → Planning. User request: do not auto-sync `dev-guide.md` under nested `.git` trees; prompt to opt in; associate nested dir with known (or new) project; save path mapping; sync guides via associated project hub. Drafted plan + open decisions in `activity.md`. Awaiting grill answers and plan approval.

## Planning decisions locked

User: `--ignore-submodules` or else prompt (not `--yes`); no nested map — infer project from `machines/<id>/projects.txt` path match; `project-modules.txt` (`proj:/abs/submodule`) for same-project assumption; check `.git` only when handling `dev-guide.md`; many paths per project OK; new keys via existing `projects.txt` flow. Updated `activity.md`.

## Implementation

Shipped nested guide handling in `sync-playbook.sh`, `tests/smoke-test-sync-submodule-guides.sh` (7 cases), README/dev-guide/definition updates. All three sync smokes green.

## Complete (nested guides extension)

Status → Complete. Nested submodule guide sync + submodule smoke + docs; prior marshal behaviors unchanged. Resume Hint: `resume-work` on `marshal` for fixes; `replan-work` if scope grows materially.

## Fix — git-tracked hard-link noise

Re-sync warned on every git-tracked path even when target inode already matched playbook (`same_file`). Fixed via `playbook_src_for_managed_rel` + silent `EXISTING` when linked; marshal smoke extended. All three sync smokes green.

## Reopen — submodule .git file as git root

Reopened Complete → Planning. User: submodule checkouts use `.git` file not directory; sync must treat file or folder `.git` as git root (`projects.txt`, target-cwd, path repair). Nested guide code already uses `-e`; three `-d` checks are wrong. Plan + iloop smoke extension in `activity.md`. Awaiting `approve-plan`.

## Build — submodule .git file

Plan approved; `start-building`. iloop: extend submodule smoke (`.git` file), fix three `-d` checks → `dir_has_git`, verify all sync smokes.

## Build — submodule .git file (done)

Shipped `dir_has_git` for `projects.txt`, path repair, target-cwd; submodule smoke cases 8–9. All sync smokes green.

## Complete — marshal (submodule .git file)

Status → Complete. Submodule `.git` file roots + smoke cases 8–9; full marshal sync surface unchanged. Resume Hint: `resume-work` on `marshal` for sync bugs; `replan-work` if scope grows materially.
