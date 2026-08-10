---
name: curate-knowledge
description: >-
  Create, maintain, refine, and restructure `knowledge/` trees: store artifacts,
  chunk large resources into ingest staging, distill into atomic cross-linked
  notes via Task sub-agents with context budgets, keep `knowledge.md` Indexes
  current. Use when the user says add-knowledge, chunk-knowledge,
  integrate-knowledge, refine-structure, curate knowledge, or asks to capture,
  reorganize, or improve a knowledge folder. Layout: `knowledge` skill.
  Browse/serve: `knowledge` skill (`serve-knowledge`). Exclusive owner of write/
  restructure of knowledge trees; sibling skills (skillup, workon) invoke this.
disable-model-invocation: true
---

# Curate knowledge

Owns **writes** to any `knowledge/` tree. Layout and read-path: [`knowledge`](../knowledge/SKILL.md). Browse: that skill’s `serve-knowledge`. Sub-agent prompts: [`subagent-contract.md`](subagent-contract.md).

## Reserved commands

| Keyword | Action |
|---------|--------|
| `add-knowledge` | Kind-1 small ingest end-to-end, or start/detect larger ingest |
| `chunk-knowledge` | Stage 1: plan + fill `artifacts/ingest/<id>/` (pause/resume) |
| `integrate-knowledge` | Stage 2: batch of `ready` chunks → placement grill → drafts → write tree |
| `refine-structure` | Tree-only reshape (grill → plan → apply); no new ingest required |

Infer when intent is clear; prefer the keyword when resuming across chats.

## Target tree

Infer from context (active **workon** / **skillup** / named path). If ambiguous: list matches and ask — never guess.

Bootstrap: `knowledge/knowledge.md` (per `knowledge` skill contract) + `knowledge/artifacts/`.

## Engagement gates (MUST stop for the user)

| Gate | When |
|------|------|
| Kind + target tree | If ambiguous |
| Stage-1 **chunk plan** | Always before fill |
| Mark chunk(s) **ready** | Always (user confirms or edits first) |
| Stage-2 **batch + placement** | Always (`refine-structure`-style grill) |
| Specialist note drafts before write | First batch on a tree/ingest: yes; later: plan + write unless user objects |
| `refine-structure` | Full grill (existing) |

Chunk **bodies**: review in waves after a fill pass (or on request) — not every paragraph.

## Resource kinds

| Kind | What | Path |
|------|------|------|
| **1 — small** | Fits one comfortable context (soft judgment; ask if unsure) | `add-knowledge` end-to-end; **no** ingest dir |
| **2 — TOC** | PDF/HTML/md with TOC or linked sub-pages | `chunk-knowledge` → `integrate-knowledge` |
| **3 — no-TOC large** | e.g. papers without a usable TOC | Invent provisional TOC **with the user**, then same as kind 2 |

Store originals under `knowledge/artifacts/resources/`. Pure verbal facts: notes only (no empty artifact).

## Staging layout

```text
knowledge/artifacts/ingest/<ingest-id>/
  manifest.md
  chunks/
    01-<slug>.md
    02-<slug>.md
```

Keep finished ingests for provenance unless the user asks to prune. Resume via `manifest.md` (and this skill’s commands) — **not** via the `knowledge` navigation skill, which MUST ignore `artifacts/ingest/`. While open, this skill MAY track the ingest in `manifest.md` only; do not rely on root Index links for discovery under `knowledge` browse.

### `manifest.md`

```markdown
# Ingest: <ingest-id>

- **status:** planning | filling | integrating | done | abandoned
- **source:** `artifacts/resources/<…>` (and/or URL)
- **kind:** toc | no-toc
- **target tree:** <path to knowledge/>

## Plan
| id | slug | source locus | status | notes |
|----|------|--------------|--------|-------|
| 01 | intro | §1 / pp.1–12 | pending \| ready \| integrated | |

## Batches
- <batch-id>: chunks 01–04 → integrated (paths written…)

## Open questions
- …
```

No dates by default. Plan: **one row per chunk**. Batches: append-only.

### Chunk file

Header (ingest id, locus, status) + extract body. Not final atomic notes. If a planned slice is still too large, **split the chunk in Stage 1**.

## Sub-agents + context (MUST for kinds 2–3)

Launch via **Task** (`generalPurpose` unless a better type fits). Parallel fillers/drafters: `run_in_background: true` in **one** message. Prompts MUST be self-contained — follow [`subagent-contract.md`](subagent-contract.md).

| Role | Writes files? | Job |
|------|---------------|-----|
| **Scout / plan** | No (main updates manifest after user approves) | TOC or sampled headings → proposed Plan rows |
| **Chunk filler** | **Yes** — only assigned `chunks/0N-*.md` | Fill one chunk (or small fixed group) from source locus |
| **Note drafter** | **No** | One ready chunk → one or few atomic note drafts |
| **Main** | Notes, all `knowledge.md`, `manifest.md`, orchestration | Placement spine, conflict resolution, Index updates |

Never dump the whole resource into one agent. Prefer path/locus-bounded reads and `rg`.

## `add-knowledge` (kind 1)

1. Light grill (what to capture, boundaries, where it fits).
2. Navigate via Indexes — do not read every note.
3. Store file under `artifacts/resources/` if any; distill.
4. Atomic notes (kebab-case); Mermaid when a diagram clarifies; subfolder at ~3–5+ related notes; every folder gets `knowledge.md`.
5. Update Indexes up the tree; link notes ↔ artifact.
6. Report paths written.

If the source is not kind 1, switch to `chunk-knowledge` (ask when unsure).

Do not dump sources verbatim into notes.

## `chunk-knowledge` (Stage 1)

1. Resolve/create `ingest-id`; store/find source under `artifacts/resources/`.
2. Kind 3: invent provisional TOC **with the user**.
3. Scout proposes Plan table → **user approves/edits** (hard gate).
4. Fan out chunk fillers for pending rows; fillers write `chunks/*.md`.
5. Wave-review chunk bodies with the user as needed.
6. User marks selected chunks **ready** (hard gate).
7. Leave ingest `status: filling` until nothing pending (or user pauses); resume later from `manifest.md`.

Resume: read `manifest.md` only first; continue from pending/ready rows.

## `integrate-knowledge` (Stage 2)

1. User selects a **batch** of `ready` chunks (hard gate).
2. **Placement grill** (`refine-structure`-style): folders, note titles, merges with existing notes — learning pass for the user.
3. Main (or Scout) produces assignment list: chunk → target paths / merge targets.
4. Fan out note drafters; collect drafts.
5. On first batch (or when asked): show drafts; then main writes notes + Indexes.
6. Mark those chunks `integrated`; append Batches log; refresh note Indexes; set ingest `done` when nothing remains.

## `refine-structure`

1. **Grill** ([`grill-me`](../grill-me/SKILL.md)): concepts, boundaries, better shape.
2. Propose short plan (moves, splits, merges, folders, link rewires).
3. Wait for approval; apply.
4. Refresh touched `knowledge.md` files; keep links valid; single `artifacts/` at tree root.

Standalone reshape — also the **style** of the integrate placement gate (without requiring a separate keyword during integrate).

## Sibling skills

- **skillup** / **workon**: invoke this skill for knowledge write/restructure; they only add extras.
- **knowledge**: navigation + `serve-knowledge` only.
