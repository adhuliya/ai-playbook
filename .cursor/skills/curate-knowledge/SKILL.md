---
name: curate-knowledge
description: >-
  Create, maintain, refine, and restructure `knowledge/` trees: store artifacts,
  distill into atomic cross-linked notes, keep `knowledge.md` indexes current so
  humans and agents discover information with minimal reading. Use when the user
  says add-knowledge, refine-structure, curate knowledge, or asks to capture,
  reorganize, or improve a knowledge folder. Layout: follow the `knowledge` skill.
  Browse/serve: `knowledge` skill (`serve-knowledge`). Exclusive owner of write/
  restructure of knowledge trees; sibling skills (skillup, workon) invoke this skill.
disable-model-invocation: true
---

# Curate knowledge

Owns **writes** to any `knowledge/` tree. Layout and read-path: [`knowledge`](../knowledge/SKILL.md). Browse: that skill’s `serve-knowledge`.

## Reserved commands

| Keyword | Action |
|---------|--------|
| `add-knowledge` | Ingest a source and/or facts into the tree (see below). |
| `refine-structure` | Conceptually review and restructure the tree (grill → plan → apply). |

If the user does not use a keyword, **infer** `add-knowledge` vs `refine-structure` from the prompt. Ordinary words do not silently trigger; when intent is clear, proceed (still light-grill first).

## Target tree

Infer from context (active **workon** / **skillup** / named path). If ambiguous: list matches and ask — never guess.

Bootstrap a missing tree: `knowledge/knowledge.md` + empty `knowledge/artifacts/`.

## Always: light grill, then write

Before creating or changing notes, grill **lightly** (enough for shared understanding — placement, atomic splits, links, what not to duplicate). Not a full interrogation. Skip only when the brief is already complete.

## `add-knowledge`

1. Light grill (what to capture, boundaries, where it fits).
2. Navigate existing tree per `knowledge` skill — do not read every note.
3. If there is a file/URL/blob: store under `knowledge/artifacts/` (e.g. `artifacts/resources/`), then distill. Pure verbal facts: notes only (no empty artifact).
4. Prefer **atomic** notes (one concept each, descriptive kebab-case names, cross-links). Complex topics MAY stay one larger note when splitting would hurt. Prefer **Mermaid diagrams** (flowcharts, sequence, class, state, ER, etc.) whenever a visual model clarifies the concept — embed fenced `mermaid` blocks in the note alongside concise prose.
5. Subfolder only when ~3–5+ related notes cluster; every folder gets `knowledge.md`.
6. Update affected `knowledge.md` indexes up to the tree root; link notes ↔ each other and back to the artifact.
7. Report paths written.

Do not dump sources verbatim into notes.

## `refine-structure`

1. **Grill** (use [`grill-me`](../grill-me/SKILL.md)): engage the user on concepts, boundaries, and better shape — more engagement improves their grasp of the topic.
2. Propose a short restructuring plan (moves, splits, merges, new folders, link rewires).
3. Wait for approval; then apply.
4. Refresh all touched `knowledge.md` files; keep links valid; keep a single `artifacts/` at the tree root.

## Sibling skills

- **skillup** / **workon**: invoke this skill for any knowledge write/restructure; they only add extras (e.g. skillup `essentials.md`, cheatsheets).
- **knowledge**: navigation + `serve-knowledge` only.
