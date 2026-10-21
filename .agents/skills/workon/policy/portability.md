# Portability

The handoff is `activity.md` + `journal.md` + `requirement-def.md` +
`design-choices.md` + `design.md` + `conventions.md` + `references.md` +
`notes-by-user.md`. `plan-outline.md`, `reviews.md`, `guide-for-users.md`,
and `artifacts/detailed-design.md` are extra; the handoff must not depend
on them.

- Inline load-bearing facts. No "as discussed".
- Use repo-relative paths, commands, and commit / PR / ticket IDs. No host
  paths in Goal, Scope, or Plan (a source path in `references.md` is fine
  for untracked files).
- Milestone evidence must be commands a new session can run.
- `# Next Steps` names the safest first action.
- Prefer rediscovering fine-grained progress from the repo, tests, and
  evidence.

Resume loads the handoff files, so keep them lean: delete stale prose when
you rewrite `activity.md`. Do not load `activities.md` on resume.
