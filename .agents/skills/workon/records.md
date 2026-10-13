# Records

Rules for the activity folder and its files. Commands load the sections
they need through `Reads:`. Index: [`SKILL.md`](SKILL.md).

## Layout

Tree and artifact names: `templates.md#Directory layout`. Slugs are
kebab-case and top-level only; siblings sit side by side. On an ambiguous
slug, list the matches and ask.

Commit `.dev-notes/activities/`, including useful `artifacts/` copies and
the reserved `verify-plan/`, `review/`, `comments/`, `fix/`, and `bg/`
records, but not `inflight.md` (scratch). The agent does not `git add` or
commit unless asked. Huge generated trees stay out of the repo. A
gitignored `.dev-notes/` is valid; the `synced` snapshot still covers it.

Status tokens (exact): `Planning` | `Approved` | `Active` | `Paused` |
`Blocked` | `Complete`. Preferred lifecycle: `Planning → Approved → Active →
Complete`, with optional `Paused` / `Blocked`. Never `Complete` → `Active`.

## `activity.md`

Title plus metadata table in the first ~10 lines. Template:
`templates.md#activity.md`. Required rows: `status`, `conventions`,
`review-comments`, `slug`, `branch`, `base-branch`, `synced`, `ticket`,
`notes`. `ticket` and `branch` may be `none`; `notes` may be empty.

`branch` is a hint; do not auto-create or check out branches. `base-branch`
is the parent branch the activity diffs against (default `main`); the
activity diff is `git diff $(git merge-base HEAD <base-branch>)` plus new
untracked files. `conventions` is `pending` or `ok` (**Execution gate**).
`review-comments` is `on` (default at create) or `off` (**Comments**
levels).

`synced` is the drift baseline for `fix-activity`: a **snapshot** commit
taken when the activity files were last in line with the repo, or `none`.
`snapshot <slug> --pin` takes it: the commit captures `HEAD`, uncommitted
tracked changes, and the activity folder (also when `.dev-notes/` is
gitignored) without touching the working tree or the real index, pins it
as `refs/workon/<slug>` so git does not garbage-collect it, and writes the
row. On the first pin in a session, tell the user in one sentence that the
ref is local, never pushed, and only marks the drift baseline. Because the
snapshot covers uncommitted agent work, that work is not mistaken for
drift. Measure drift as `git diff <synced> <now>`, where `<now>` is a fresh
unpinned `snapshot <slug>`; a plain `git diff <synced>` misses gitignored
activity files. `base <commit>` prints the **`synced` base** (the
snapshot's first parent when its subject starts with `workon synced` or it
is a legacy stash with two parents; otherwise the commit itself) and the
baseline mode: `ok` when that base is an ancestor of `HEAD`, `rewritten`
when it is not, `none` when the commit is unknown.

Only these write `synced`: create and `create-sibling` (first snapshot);
`import-activity` (`none`); every other agent write to an activity file
(**Update cadence** checkpoints, `update-convention`, `conventions-ok`,
**Consistency check** fixes); `fix-activity` step 9; and `apply-review` when
it closes a fix cycle. Agent writes skip the refresh while a fix cycle is
`open`, or when the mode is `rewritten` (then remind `fix-activity`).

Required sections, in order: Goal, Scope, Background and Special Notes,
Current Design, Current Plan, Milestones, Next Steps, References.

- **Goal** summarizes RD. On conflict, RD wins; refresh Goal and Scope at
  the next checkpoint.
- **Scope:** one or two paragraphs after the first grill, then near-fixed.
  A major in-flight change is a **Material-change**.
- **Current Design:** the execution handoff (invariants, boundaries,
  evidence signals). Chosen-vs-alternatives live only in Design Decisions.
- **Milestones:** MECE outcomes with **Test evidence**. On reopen, keep
  checked items, append new ones, and mark removed work `superseded`; do
  not delete. Milestone numbers are stable: a `fix-activity` prune replaces
  a milestone body with a one-line `<n>. removed: <why>` stub. Review
  milestones: **Reviews**.
- **References:** one `REF<n>` bullet per cited planning file
  (**Cited context**).

## IDs

Activity entries carry stable IDs. Cross-references use the ID, not the
title.

| ID | Entry | Home |
|---|---|---|
| `RD<n>` | Requirement Definition | `requirement-def.md` `## RD<n>: <title>` |
| `DC<nn>` | design decision (two digits) | `design-choices.md` `## DC<nn>: <title>` |
| `CONV<n>` | convention rule (Setup H2 has no ID) | `conventions.md` `## CONV<n>: <title>` |
| `REF<n>` | reference | `activity.md` `# References` bullet |
| `RU<n>`, `RU<n>.<m>` | Review Update: review cycle, point | `reviews.md` |

Assign the next free number. Do not reuse a retired (superseded or removed)
ID, except through `fix-activity` renumbering. `replaces:` names the old
ID. IDs stay out of shipped work and `user-guide.md`
(**Engineering while focused**).

## Catalog

`.dev-notes/activities/activities.md` lists every activity by slug. Create
it lazily (`# Activities`). Append new entries at the end; do not rewrite or
reorder the file unless asked. An entry is `## <slug>: Short title` plus one
high-level paragraph with no **IDs** and no milestone numbers. It is not a
substitute for `activity.md`. Shape: `templates.md#activities.md`.

On create, derive, or import, append without reading the catalog:

```bash
printf '\n## %s: %s\n\n%s\n' "$slug" "$title" "$para" >> .dev-notes/activities/activities.md
```

When the Goal changes (`replan-work`, `apply-review` if the Goal text
changes, or equivalent), edit that one heading via `rg`. Skip catalog
updates for any other change.

```bash
rg -n -A 8 '^## <slug>:' .dev-notes/activities/activities.md
rg '^## ' .dev-notes/activities/activities.md
```

**List:** `list` prints the table (shape: `templates.md#List output`) for
all statuses except `Complete`; `list --all` includes `Complete`, which you
show only when asked. **Details** (no resume): the full path plus the first
~20 lines of `activity.md`, then stop.

## User guide

`<slug>/user-guide.md` is written only by `create-guide`, which rewrites it
in place on re-run. The audience is a human user, not an agent. It explains
what the activity delivered and how to use it, test it, and explain it to
others, in **Writing style** prose with no **IDs**. Shape:
`templates.md#user-guide.md`.

## Portability

The handoff is `activity.md` + `journal.md` + `requirement-def.md` +
`design-choices.md` + `conventions.md` + `notes-by-user.md`. `reviews.md`,
and `user-guide.md` are extra; the handoff must not depend on them.

- Inline load-bearing facts. No "as discussed".
- Use repo-relative paths, commands, and commit / PR / ticket IDs. No host
  paths in Goal, Scope, or Plan (a source path in References is fine for
  untracked files).
- Milestone evidence must be commands a new session can run.
- `# Next Steps` names the safest first action.
- Prefer rediscovering fine-grained progress from the repo, tests, and
  evidence.

Resume loads the handoff files, so keep them lean: delete stale prose when
you rewrite `activity.md`. Do not load `activities.md` on resume.
