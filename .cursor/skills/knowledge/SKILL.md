---
name: knowledge
description: >-
  Navigate any `knowledge/` tree under `.dev-notes/` (repo, activity, learning,
  etc.): each folder has `knowledge.md` (heading, fluid body, trailing Index
  table), one `knowledge/artifacts/` at the tree root, atomic cross-linked
  markdown notes. Serve a browsable HTML view via `serve-knowledge`. Use when
  locating domain knowledge, exploring `.dev-notes/**/knowledge/`, following
  links between notes and artifacts, or when the user asks to browse/serve
  knowledge. For creating or restructuring notes, use `curate-knowledge`;
  sibling skills add their own extras on top.
---

# Knowledge (navigation)

## Tree shape

```text
knowledge/
    knowledge.md       # required in every folder
    note.md            # atomic notes
    <subdir>/
        knowledge.md
        ...
    artifacts/         # sole raw/store root (here only, not in subfolders)
        resources/     # original files / URL dumps (safe to link; avoid bulk-read)
```

- Atomic `.md` notes: one concern each; link out instead of duplicating.
- Indexes and notes cross-link each other and paths under `artifacts/resources/` (and other non-ingest artifact stores sibling skills define).

### `artifacts/ingest/` — out of scope (MUST)

Do **not** read, search, Index-link, or otherwise treat `knowledge/artifacts/ingest/` as part of navigation. That subtree is owned exclusively by [`curate-knowledge`](../curate-knowledge/SKILL.md). If an Index row points there, ignore it for browse/answer paths and use notes + `resources/` instead.

## `knowledge.md` contract (MUST)

Every folder’s `knowledge.md` uses this shape:

```markdown
# <Folder title>

<Fluid body: short intro and any sections that help humans/agents
 (notes, child folders, see-alsos). No fixed subsection names here —
 sibling skills MAY add conventional sections inside this body.>

## Index

| Name | Description | Link |
|------|-------------|------|
| <term or label> | One-line what it is / when to open it | [label](relative/path) |
```

Rules:

1. **`## Index` is always last** (even if only a few rows, or one “none yet” row).
2. Rows MAY point at notes, child `knowledge.md` folders, `artifacts/resources/` (or other non-ingest artifact paths), or terms (term → note).
3. Do **not** inline large artifact contents — links + one-liners only.
4. Do **not** put `artifacts/ingest/` links in Indexes for navigation; resume/staging is `curate-knowledge`’s concern.

## Where trees live

| Parent | Path |
|--------|------|
| Repo | `.dev-notes/knowledge/` |
| Activity | `.dev-notes/activities/<slug>/knowledge/` |
| Learning | `.dev-notes/learning/<slug>/knowledge/` |

`workon`, `skillup`, and other skills that use `knowledge/` MUST follow this skill for layout and navigation; they document only their add-ons (e.g. skillup `essentials.md`, lab-maps). Writes/restructures: [`curate-knowledge`](../curate-knowledge/SKILL.md).

## Navigate (MUST)

1. Start at that tree's `knowledge/knowledge.md`.
2. Descend via each folder's `knowledge.md` (body + Index) — not full-tree reads.
3. Raw files under `knowledge/artifacts/`: prefer `resources/` and skill-specific stores; avoid opening large blobs whole — use `rg` for a slice when needed. **Skip `artifacts/ingest/` entirely.**

Do not read every note to answer a narrow question.

## `serve-knowledge`

When the user asks to serve/browse knowledge, run the local server and tell them the URL (Ctrl-C to stop):

```bash
# One knowledge tree (home = knowledge.md)
python3 .cursor/skills/knowledge/scripts/serve.py path/to/knowledge

# Learning root: global index of all learning activities
python3 .cursor/skills/knowledge/scripts/serve.py .dev-notes/learning
```

Stdlib only. Auto-detects learning-root vs single `knowledge/` folder. See [`scripts/serve.py`](scripts/serve.py).
