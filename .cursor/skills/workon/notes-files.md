# Notes files

Authoring rules for RD, Design Decisions, Conventions, and user notes.
Shapes: [`templates.md`](templates.md).

`requirement-def.md`, `design-choices.md`, `conventions.md`, `notes-by-user.md`.
Required at birth.

**Repair** (legacy content only). Run this only when the **Session probe**
says the activity is legacy. The probe already created missing files and
filled missing rows.

- Legacy `notes.md`: map each old `##` to the file whose H1 matches
  (Requirement Definition, Design Decisions, Conventions); the rest goes to
  `notes-by-user.md`. Promote `###` to `##`. Add an empty
  `## Setup, build, test and install notes` if missing. Delete `notes.md`.
- Legacy `user-notes.md`: rename to `notes-by-user.md` (`git mv` if tracked);
  change H1 `# User Notes` to `# Notes by User`. Keep the body.
- Legacy `requirements.md`: rename to `requirement-def.md` (`git mv` if
  tracked). Keep the body.
- `requirement-def.md` without a **Problem header**: draft one from
  `# Scope`, `# Goal`, and `.dev-notes/definition.md`. Show it once and ask
  the user to confirm or correct it.
- Entries or References bullets without **IDs**: number them in file order;
  rewrite title-based `replaces:` to IDs.
- Legacy review and requirement IDs: rename `R<n>` → `RD<n>` (same number).
  Merge `UR<n>`, `SR<n>`, and `RRD<n>` cycles into one `RU<n>` sequence in
  file order.
  Update every reference in the scope files. Append the map as a **Renumber
  log**. Do not edit the journal.
- Legacy `artifacts/self-review.md` and `artifacts/self-review/`: old review
  records. Do not apply them. `delete-tmp-files` lists them (default
  delete).

Agent **best-effort drafts** all except `notes-by-user.md` (repo + this
activity; user reviews and corrects). Bullets wherever possible. What
sub-agents may read or receive: contract **Every agent**.

### `requirement-def.md` (RD)

**RD** (Requirement Definition) means the `RD<n>` entries in this file, one
entry or all. H1: `# Requirement Definition`. Parent-only.

**Problem header** (always present, first H2, no ID):
`## Problem: <problem title>`. The body is one short paragraph under
~100 words. It states the problem this activity solves and how it fits the
project in `.dev-notes/definition.md`. Write it from the project-fit and
intake answers. Do not list requirements here; RD entries hold them.
Keep it crisp: one problem, its impact, and the project link. Rewrite in
place when the problem understanding changes. A change to the problem
itself is **Material-change**.

Entries follow the header: `## RD<n>: <title>`. Keep them current as
grilling reveals requirements; user challenges them before `approve-plan`.
`kind` is exactly one of:

- `end-user-interface`: humans (UI, CLI output, docs the user reads).
- `software-interface`: contract other software must honor (in-repo
  modules/libraries, API / ABI / FFI / protocol / link). Prefer this name;
  old `external-interface` is the same kind (do not rewrite solely to rename).
- `internal-behavior`: no contract outside this component.

Drop or reword when the user challenges. A review point that changes an entry
adds `revised-by:` (**Reviews**; same for `DC` and `CONV`). Material RD change after approval: apply
**Material-change**.

### `design-choices.md`

H1: `# Design Decisions`. Entries: `## DC<nn>: <title>`. Parent-only.
Append-only (except `fix-activity`). Append when a real choice is made. Do not
delete or rewrite history. Supersede with a new entry and `replaces: DC<nn>`.
Skip micro-choices recoverable from code. ~200 words hard max. `level` is
exactly one of:

- `design-choice`: UI or software-facing contract (same coverage as RD
  `end-user-interface` / `software-interface`). Feeds a future design document.
- `major-implementation-detail`: internal, but individually mentioned in that
  document. Test: costly if unknown, or reversal ripples across components.
- `implementation-detail`: internal; summarized (not copied) in that document.

Unsure between adjacent levels → higher; user may downgrade.

### `conventions.md`

H1: `# Conventions`. Target **≤ ~500 words**; rewrite in place. Commands stay
exact — if over budget, trim rules before commands.

Two H2 kinds: `## CONV<n>: <short title>` binding **rules** (living list, not a
decision log); `## Setup, build, test and install notes` (commands, cwd,
toolchain for **this** activity). Single source; do not duplicate into
`activity.md`. Do not duplicate rules into Setup. Do not put commands only in
rules, or constraints only in Setup.

For this activity, **rules** take precedence over project/repo conventions,
style guides, and Cursor rules where they conflict. Workon **Stops**, safety,
and git safety still win. Where rules are silent, repo rules apply.

**Rules:** 2–5 bullets each. `replaces: CONV<n>` only when splitting or
renaming. Seed from observed repo/activity facts. No taste-only rules. Write
without a keyword while `conventions: pending` (planning grill,
`conventions-ok`), and for rules the agent observes and the user confirms.
Once `conventions: ok`, an explicit user add or rewrite needs
`update-convention`; on detected intent, prompt it. Rewrite in place when a
newly confirmed rule contradicts or tightens an entry. No tighter than the
user stated. Drop: mark `superseded` on request — do not delete (except
`fix-activity` prune). No forced conventions interview in Planning.

**Setup:** always best-effort draft; user corrects. It is the env-agent
bootstrap; the env agent reads it and never writes it.

**Isolated setup:** for quick tests and activity env setup, do not install
into or change the system unless the user asks. Use path-redirect sandboxes
(e.g. `bwrap` bind mounts on Linux), local prefixes, virtual envs, or
`PATH`-style overrides. They test a package or library without disturbing the
system. Record the method in Setup.

User sign-off of rules + Setup is `conventions-ok` (**Execution gate**).

### `notes-by-user.md`

H1: `# Notes by User`. User-owned. Aim **≤ ~500 words**; if over budget, warn
once; the user trims. Read for intake; promote load-bearing bits into RD,
Design Decisions, or Conventions. The agent never edits it, except a short
`agent:` line when asked.
