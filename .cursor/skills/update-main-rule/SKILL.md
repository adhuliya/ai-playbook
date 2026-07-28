---
name: update-main-rule
description: >-
  Create or refresh the shared alwaysApply dev-main.mdc so agents can navigate
  .dev-notes and read dev-guides without invoking the dev-guides skill.
  Project-agnostic. Use when the user asks to update the main/dev-main rule or
  after .dev-notes layout changes.
disable-model-invocation: true
---

# update-main-rule

Maintain **shared** `.cursor/rules/dev-main.mdc` (playbook source; hard-linked
into targets). Content must stay **project-agnostic** — no repo names, stack, or
paths outside the fixed `.dev-notes` scheme. Project detail belongs in
`.dev-notes/` (and READMEs), not in this rule.

If a top-level `<project>.cursor/rules/dev-main.mdc` overlay exists, warn that it
wins on sync clash; still update the shared rule unless the user asks to edit
the overlay instead.

If an old `.cursor/rules/main.mdc` exists, remove it after writing `dev-main.mdc`
(or replace via rename) so targets do not keep a stale duplicate.

## Target file

```text
.cursor/rules/dev-main.mdc
```

## Required behavior in the rule

1. **Define** requirement words (MUST / SHOULD / MAY table) as global agent
   vocabulary.
2. **Map** the fixed `.dev-notes` layout (read files; do not invent policy):
   - `definition.md` — project definition
   - `journal.md` — global major-change one-liners (append via `journal` skill only)
   - `knowledge/` — project knowledge (`knowledge/dev-notes.md`)
   - `artifacts/` — project artifacts (`artifacts/dev-notes.md`)
   - `activities/` — `workon` activities
   - `dev-guides/` — hierarchical guides
3. **Read** guides using deepest-path discovery; escalate via Related only.
4. **Do not** invoke `dev-guides` for reading — only for create/rewrite/audit/delete
   when explicitly requested.
5. Prefer live tree over stale guide one-liners; factual one-liner fixes OK inline.
6. **Trigger (MUST):** read the deepest matching guide before modifying/adding
   files under a path it covers.
7. **Keep guides fresh (MUST):** fix any one-liner a change makes factually
   wrong (renamed/moved/deleted path, changed build/test command, stale role
   line) in the same change; note material drift for the `dev-guides` skill.

## Canonical template

Write (or replace) `dev-main.mdc` with this shape. Tweak only if the `.dev-notes`
contract changed and the user agreed:

```markdown
---
description: Navigate .dev-notes; read dev-guides (project-agnostic).
alwaysApply: true
---

# Requirement words

Use the following vocabulary:

| Word | Meaning |
|------|---------|
| MUST / REQUIRED / SHALL | Absolute; always do |
| MUST NOT / SHALL NOT | Absolute; never do |
| SHOULD / RECOMMENDED | Strong default; skip only with a valid documented reason |
| SHOULD NOT / NOT RECOMMENDED | Strong avoid; only if necessary |
| MAY / OPTIONAL | Truly optional |

Examples: MUST validate input. SHALL NOT share private user data. SHOULD use plain words. MAY suggest extras when useful.

# .dev-notes directory

If present, use for context. Do not invent policy. Do not bulk-read.

**Start:** `definition.md`, `README.md` (if any), `journal.md`.

**As needed:**

| Path | When |
|------|------|
| `knowledge/` | Notes/reference |
| `artifacts/` | Stored artifacts |
| `activities/` | `workon` context |
| `dev-guides/` | Path-specific orientation (below) |

`journal.md`: append only via `journal` when asked. Guide create/rewrite/audit/delete:
`dev-guides` skill only (explicit request).

# Live tree wins

Repo source tree is source of truth. If a guide disagrees on specifics, trust the
tree (see "Keep guides fresh" below for your upkeep duty).

# Read guides (no `dev-guides` skill)

Open guides yourself — never invoke `dev-guides` only to read.

**Trigger (MUST):** Before you modify or add files under a project path `P`, read
the deepest matching `dev-guide.md` for `P` if one exists. Read-only exploration
or a trivial single-file lookup does not require this.

**Find for path `P`:** `.dev-notes/dev-guides/<P>/dev-guide.md`, else walk up
(`a/b/c` → `a/b` → `a`), else root `dev-guides/dev-guide.md`. Sparse is normal
(intermediate folders may have no guide). Do not auto-open root/siblings. Re-open
when the subtree changes and needs its guide.

**Use:** Purpose, Invariants/Gotchas, Layout, Key entry points, Build/test/run.
Root = thin structural index (paths → roles, pipeline, build entrypoint); it does
not restate vision (see `definition.md`). No Parent/Children blocks.

**Related:** Repo-rooted paths only. For `Q`, open `dev-guides/<Q>/dev-guide.md`
if present. Escalate only via Related or clear cross-folder need.

# Keep guides fresh (MUST)

If your change makes a `dev-guide.md` factually wrong — a renamed/moved/deleted
path it lists, a changed build/test command, a stale role line — you MUST fix
that one-liner in the same change. For material drift (Purpose, Invariants,
placement, hierarchy, Related), do not rewrite here: note it for the `dev-guides`
skill.
```

## Workflow

1. Confirm any layout change with the user if diverging from the template.
2. Write `.cursor/rules/dev-main.mdc` from the canonical template (or agreed delta).
3. Keep the rule short; no project examples (`pkg/…`, product names, etc.).
4. Show a summary of what changed; stop.
