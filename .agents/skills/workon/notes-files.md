# Notes files

Authoring rules for `requirement-def.md`, `design-choices.md`,
`conventions.md`, and `notes-by-user.md`. All four exist from birth.
Shapes: [`templates.md`](templates.md).

The agent drafts all but `notes-by-user.md` best-effort from the repo and
this activity; the user reviews and corrects. Use bullets wherever
possible. What sub-agents may read or receive: `briefs/common.md`.

## Repair

Run this only when the **Session probe** says the activity is legacy. The
probe has already created missing files and filled missing rows.

- Legacy `notes.md`: map each old `##` to the file whose H1 matches
  (Requirement Definition, Design Decisions, Conventions); the rest goes to
  `notes-by-user.md`. Promote `###` to `##`. Add an empty `## Setup, build,
  test and install notes` if missing. Delete `notes.md`.
- Legacy `user-notes.md`: rename to `notes-by-user.md` (`git mv` if
  tracked) and change the H1 `# User Notes` to `# Notes by User`. Keep the
  body.
- Legacy `requirements.md`: rename to `requirement-def.md` (`git mv` if
  tracked). Keep the body.
- `requirement-def.md` without a **Problem header**: draft one from
  `# Scope`, `# Goal`, and `.dev-notes/definition.md`. Show it once and ask
  the user to confirm or correct it.
- Entries or References bullets without **IDs**: number them in file
  order; rewrite title-based `replaces:` to IDs.
- Legacy IDs: rename `R<n>` → `RD<n>` (same number). Merge `UR<n>`,
  `SR<n>`, and `RRD<n>` cycles into one `RU<n>` sequence in file order.
  Update every reference in the scope files. Append the map as a
  **Renumber log**. Do not edit the journal.
- Legacy `artifacts/self-review.md` and `artifacts/self-review/` are old
  review records. Do not apply them; `delete-tmp-files` lists them
  (default delete).

## `requirement-def.md` (RD)

**RD** (Requirement Definition) means the `RD<n>` entries in this file, one
or all. H1: `# Requirement Definition`. Parent-only.

The **Problem header** is always present as the first H2, with no ID:
`## Problem: <problem title>`. Its body is one short paragraph under ~100
words that states the problem this activity solves and how it fits the
project in `.dev-notes/definition.md`. Write it from the project-fit and
intake answers: one problem, its impact, and the project link. Do not list
requirements here; RD entries hold them. Rewrite it in place when the
problem understanding changes; a change to the problem itself is a
**Material-change**.

Entries follow the header as `## RD<n>: <title>`. Keep them current as
grilling reveals requirements; the user challenges them before
`approve-plan`, and you drop or reword on challenge. `kind` is exactly one
of:

- `end-user-interface`: humans (UI, CLI output, docs the user reads).
- `software-interface`: a contract other software must honor (in-repo
  modules or libraries, API / ABI / FFI / protocol / link). Prefer this
  name; the old `external-interface` is the same kind, and do not rewrite
  solely to rename.
- `internal-behavior`: no contract outside this component.

A review point that changes an entry adds `revised-by:` (**Reviews**; the
same for `DC` and `CONV`). A material RD change after approval follows
**Material-change**.

## `design-choices.md`

H1: `# Design Decisions`. Entries: `## DC<nn>: <title>`. Parent-only and
append-only (except `fix-activity`): append when a real choice is made,
never delete or rewrite history, and supersede with a new entry that says
`replaces: DC<nn>`. Skip micro-choices recoverable from code. Hard max ~200
words per entry. `level` is exactly one of:

- `design-choice`: a UI or software-facing contract (same coverage as RD
  `end-user-interface` / `software-interface`). Feeds a future design
  document.
- `major-implementation-detail`: internal, but individually mentioned in
  that document. Test: costly if unknown, or reversal ripples across
  components.
- `implementation-detail`: internal; summarized (not copied) in that
  document.

When unsure between adjacent levels, pick the higher; the user may
downgrade.

## `conventions.md`

H1: `# Conventions`. Target ≤ ~500 words; rewrite in place. Commands stay
exact; when over budget, trim rules before commands.

It has two H2 kinds. `## CONV<n>: <short title>` entries are binding
**rules**: a living list, not a decision log. `## Setup, build, test and
install notes` holds the commands, cwd, and toolchain for this activity.
Each fact lives in one place: do not duplicate into `activity.md`, do not
duplicate rules into Setup, and do not put commands only in rules or
constraints only in Setup.

For this activity, the rules take precedence over project and repo
conventions, style guides, and agent rules (`AGENTS.md`, `.agents/rules/`,
tool-specific rule files) where they conflict. Workon **Stops**, safety,
and git safety still win. Where the rules are silent, repo rules apply.

**Rules** have 2–5 bullets each and use `replaces: CONV<n>` only when
splitting or renaming. Seed them from observed repo and activity facts; no
taste-only rules, and no forced conventions interview in Planning. Write
them without a keyword while `conventions: pending` (planning grill,
`conventions-ok`), and for rules the agent observes and the user confirms.
Once `conventions: ok`, an explicit user add or rewrite needs
`update-convention`; on detected intent, prompt it. Rewrite in place when a
newly confirmed rule contradicts or tightens an entry, and never tighter
than the user stated. To drop a rule, mark it `superseded` on request; do
not delete (except a `fix-activity` prune).

**Setup** is always a best-effort draft that the user corrects. It is the
env-agent bootstrap: the env agent reads it and never writes it.

**Isolated setup:** for quick tests and activity env setup, do not install
into or change the system unless the user asks. Use path-redirect sandboxes
(e.g. `bwrap` bind mounts on Linux), local prefixes, virtual envs, or
`PATH`-style overrides to test a package or library without disturbing the
system. Record the method in Setup.

User sign-off of rules and Setup is `conventions-ok` (**Execution gate**).

## `notes-by-user.md`

H1: `# Notes by User`. User-owned; aim for ≤ ~500 words, and when over
budget warn once and let the user trim. Read it for intake and promote
load-bearing bits into RD, Design Decisions, or Conventions. The agent
never edits it, except for a short `agent:` line when asked.
