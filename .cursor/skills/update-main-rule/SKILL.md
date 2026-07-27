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

1. **Map** the fixed `.dev-notes` layout (read files; do not invent policy):
   - `definition.md` — project definition
   - `journal.md` — global major-change one-liners (append via `journal` skill only)
   - `knowledge/` — project knowledge (`knowledge/dev-notes.md`)
   - `artifacts/` — project artifacts (`artifacts/dev-notes.md`)
   - `activities/` — `workon` activities
   - `dev-guides/` — hierarchical guides
2. **Read** guides using deepest-path discovery; escalate via Related only.
3. **Do not** invoke `dev-guides` for reading — only for create/rewrite/audit/delete
   when explicitly requested.
4. Prefer live tree over stale guide one-liners; factual one-liner fixes OK inline.

## Canonical template

Write (or replace) `dev-main.mdc` with this shape. Tweak only if the `.dev-notes`
contract changed and the user agreed:

```markdown
---
description: Navigate .dev-notes; read dev-guides (project-agnostic).
alwaysApply: true
---

# .dev-notes

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
tree; fix clearly stale factual one-liners in the same change. Material guide
rewrites: `dev-guides` skill.

# Read guides (no `dev-guides` skill)

Open guides yourself when needed — never invoke `dev-guides` only to read.

**Find for path `P`:** `.dev-notes/dev-guides/<P>/dev-guide.md`, else walk up
(`a/b/c` → `a/b` → `a`), else root `dev-guides/dev-guide.md`. Sparse is normal.
Do not auto-open root/siblings. Re-open when the subtree changes and needs its guide.

**Use:** Purpose, Layout, Build/test/run, Invariants, Key entry points, Common
tasks. Root = thin index; detail in deeper guides. No Parent/Children blocks.

**Related:** Repo paths only. For `Q`, open `dev-guides/<Q>/dev-guide.md` if
present. Escalate only via Related or clear cross-folder need.
```

## Workflow

1. Confirm any layout change with the user if diverging from the template.
2. Write `.cursor/rules/dev-main.mdc` from the canonical template (or agreed delta).
3. Remove stale `.cursor/rules/main.mdc` if present.
4. Keep the rule short; no project examples (`pkg/…`, product names, etc.).
5. Show a one-line summary of what changed; stop.
