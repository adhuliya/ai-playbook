# `requirement-def.md` (RD)

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
