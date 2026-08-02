# Dev-guide template

Copy into `<project-path>/dev-guide.md` (or repo-root `dev-guide.md`). Keep the
guide short — easy for humans to skim and edit. No dates. No Parent/Children
blocks (hierarchy is discovered by walking paths; see the skill cookbook).

## Required shape

Every guide uses **exactly these parts**, in this order:

1. **Title** — `# <P> -- Dev-Guide` where `<P>` is the repo-relative path this
   file documents (`repository root` for `dev-guide.md` at the repo root).
2. **Summary** — one or two lines under the title (plain prose, not a heading).
3. **`## Notes`** — free-form. Put invariants, build/test/run commands,
   gotchas, conventions, and pointers to other guides or dirs here. Use bullets
   or short paragraphs; keep it scannable.
4. **`## Artifacts`** — markdown table: **Name** | **Description**.
   List only what matters for this folder (key files, subdirs, entrypoints). One
   line per row. Use repo-rooted paths in **Name** when the artifact is a path
   (`span/pkg/spir`). Omit rows whose role is obvious from the name alone.

Delete a section only when it would be empty **and** adds no signal; otherwise
leave a single `- (none yet)` under Notes or one table row explaining that.

Do **not** add other top-level sections unless the user explicitly asked when
invoking the skill. Do **not** restate guide meta-policy — that lives in
`dev-main.mdc`. Do **not** duplicate `.dev-notes/definition.md` (vision/scope).

## Example (folder guide)

```markdown
# span/pkg/spir -- Dev-Guide

SPIR wire format and Go types shared by the analyzer and tooling.

## Notes

- Regenerate protobufs from repo root: `make gen` (do not hand-edit `*.pb.go`).
- Parent module overview: see `span/dev-guide.md`.

## Artifacts

| Name | Description |
|------|-------------|
| `spir.proto` | Canonical SPIR schema |
| `spir.pb.go` | Generated Go types |
| `encode.go` | Load/save helpers used by `span` |
```

## Example (repo-root guide)

```markdown
# repository root -- Dev-Guide

Go/C monorepo: slang frontend, span analyzer, shared SPIR IR.

## Notes

- Prefer root `Makefile` targets; run `make help` for the current list.
- Project vision and terms: `.dev-notes/definition.md`.

## Artifacts

| Name | Description |
|------|-------------|
| `Makefile` | Top-level build and test entry |
| `slang/` | C++ Clang/LLVM SPIR frontend |
| `span/` | Go analyzer module |
| `dev-guide.md` | This index; subtree guides live in `<path>/dev-guide.md` |
```

### Agent conventions

- Prefer updating **Notes** and **artifact rows** over growing the summary.
- When another directory has its own guide, mention it in Notes or add a
  table row; the reader opens `<path>/dev-guide.md` from the path in **Name**.
- The live tree wins over this file; fix stale one-liners when you touch code.
