---
name: knowledge
description: >-
  Navigate any `knowledge/` tree under `.dev-notes/` (repo, activity, learning,
  etc.): each folder has `knowledge.md` (intro and index), one `knowledge/artifacts/`
  at the tree root, atomic cross-linked markdown notes. Serve a browsable HTML
  view via `serve-knowledge`. Use when locating domain knowledge, exploring
  `.dev-notes/**/knowledge/`, following links between notes and artifacts, or
  when the user asks to browse/serve knowledge. For creating or restructuring
  notes, use `curate-knowledge`; sibling skills add their own extras on top.
---

# Knowledge (navigation)

## Tree shape

```text
knowledge/
    knowledge.md       # required in every folder, including this root
    artifacts/         # only raw-file store for this tree (here only, not in subfolders)
    <subdir>/
        knowledge.md
        ...
```

- Atomic `.md` notes: one concern each; link out instead of duplicating; indexes and notes cross-link each other and paths under `artifacts/`.

## Where trees live

| Parent | Path |
|--------|------|
| Repo | `.dev-notes/knowledge/` |
| Activity | `.dev-notes/activities/<slug>/knowledge/` |
| Learning | `.dev-notes/learning/<slug>/knowledge/` |

`workon`, `skillup`, and other skills that use `knowledge/` MUST follow this skill for layout and navigation; they document only their add-ons (e.g. skillup `essentials.md`, lab-maps). Writes/restructures: [`curate-knowledge`](../curate-knowledge/SKILL.md).

## Navigate (MUST)

1. Start at that tree's `knowledge/knowledge.md`.
2. Descend via each folder's `knowledge.md`; use paths, index entries, and links — not full-tree reads.
3. Raw files: only `knowledge/artifacts/`; avoid opening these as they may be large text blobs. Use `rg` on these files if required to extract more information.

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
