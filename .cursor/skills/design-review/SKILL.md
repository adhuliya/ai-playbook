---
name: design-review
description: >-
  Writes a conference-style design review paper (markdown + labeled mermaid)
  to design-review.md for either a git change (MR/PR/commit/range) or a
  complete repository. Feature/System Design is the spine; also covers
  Background, Alternate Designs, Coverage, Evaluation (document-only), and
  severity-tagged Comments. Always scouts with a Task sub-agent, then fans out
  parallel specialists with context budgets (diff churn for changes; LOC/file
  count for repos). Use when the user invokes /design-review or asks for a
  design review of a PR, commit, MR, or whole codebase/repository.
disable-model-invocation: true
---

# Design review (technical paper)

Produce `design-review.md` in the session CWD / workspace root: a conference-style
technical paper. Overwrite on re-run unless the user names another path.

**Local artifact:** do not `git add` or commit `design-review.md`.

Fill the skeleton in [review-template.md](review-template.md). Sub-agent return
shapes and prompt skeletons: [subagent-contract.md](subagent-contract.md).

## Modes

| Mode | Target | Design spine title |
|------|--------|--------------------|
| **change** | MR/PR, commit, range, or branch tip vs base | Feature Design |
| **repo** | Whole repository (workspace or explicit path) | System Design |

Resolve mode in this order; **when in doubt, prompt the user**:

1. Explicit: `repo` / “whole codebase” / “full repository” / review path that is a repo root → **repo**
2. Explicit change target: PR/MR number or URL, SHA, range (`A..B`), branch → **change**
3. Ambiguous invoke → prompt (offer change vs repo)

### Change target resolution

1. Explicit arg: PR/MR number or URL, commit SHA, range, or branch
2. Open PR/MR for the current branch (hosting CLI as the session context directs)
3. Unpushed commits on the current branch vs upstream/base (`main`/`master`)
4. Prompt the user

**Diffs:** always from git inside the repo (`git diff`, `git show`, `git log`,
path filters). Prefer hosting CLIs only for metadata (`gh`, `glab`, etc.).
Missing CLI must not block—fall back to branch/commit range and note limited
metadata.

### Repo target resolution

1. Explicit path if given (must be a git repo root or contain one)
2. Else session workspace / CWD git root
3. Prompt if multiple roots or unclear

Do **not** dump the whole tree into one context. Scout + specialists are
mandatory for anything beyond a tiny toy repo (< ~15 source files MAY skip
parallel tree agents, but Scout is still required).

## Paper structure (fixed order)

1. **Abstract** — ≤ ~150 words; what is reviewed, for whom; verdict preview OK
2. **Introduction** — problem/motivation, in/out scope, contribution claim
3. **Background** — newcomer literacy for the area
4. **Feature Design** (*change*) or **System Design** (*repo*) — **spine**
5. **Alternate Designs** — 1–2 real alternatives with adv/disadv, or “no meaningful fork”
6. **Coverage** — tests/gaps/stale/suggested
7. **Evaluation** — **document only**: prerequisites, commands, minimal example, expected result, optional negative check (or blocked + closest offline check). Do not run unless the user asks
8. **Comments** — Broad then file-specific
9. **Conclusion** — Verdict + 2–4 sentence why + open questions

Tone: precise conference paper. Neutral voice in body; reviewer voice OK in
Comments/Conclusion. No Related Work unless truly needed. Prefer diagrams +
cited snippets over padding.

### Design spine (Feature / System)

Subsections (skip empty; do not invent layers the code lacks):

1. **End-user observable behavior** — *change:* before → after; *repo:* what users/operators get today. Non-goals if clear
2. **Conceptual model** — mental model / invariants
3. **Layered internal design** — top-down; labeled mermaid for information flow
4. **Key types & APIs** — public surfaces and data structures **in full**, each with `path:start-end`
5. **Integration / module boundaries** — *change:* how the change hooks into existing pieces; *repo:* major packages, ownership boundaries, cross-module flows. Cite `path:start-end`

Every snippet cites real `path:start-end`. Elide glue with `// ...` (or language
equivalent); never truncate the API/type itself.

### Alternate Designs

1–2 competent alternatives (not strawmen). For each: brief sketch, advantages vs
current, disadvantages vs current, tied to a concrete tradeoff. Do not demand a
rewrite unless a Blocker says so. Tiny bugfix / trivial repo with no fork → one
short paragraph saying so.

### Coverage

1. Tests that protect the reviewed surface (file + name/description + behavior)
2. Gaps (spine behaviors with no test)
3. Stale/missing test updates (*change*) or weak/missing suite areas (*repo*)
4. Suggested left-out cases (prioritized)

Ground in the repo’s real test layout (and guides if present).

### Comments

**A. Broad** — ordered by severity: `Blocker`, `Major`, `Minor`, `Nit`. Title,
why it matters, suggested direction.

**B. File-specific** — `path:line` or `path:start-end` + same severity +
one-liner. Every item must cite a real location.

### Verdicts

| Mode | Allowed verdicts |
|------|------------------|
| **change** | `Approve` / `Approve with nits` / `Request changes` / `Block` |
| **repo** | `Sound` / `Sound with nits` / `Needs redesign` / `Unsound` |

### Diagrams

- Mermaid only when it clarifies information flow, layering, or before/after paths
- Every diagram has a caption/label (e.g. `Figure 1: …`)
- Prefer sequence/flowchart for runtime; class/ER only when types/relationships are central
- Cite summarized code in/under the caption
- Cap ~3–7 diagrams for a large target; ~0–2 for a small fix/tiny repo; never diagram trivial renames

## Progressive review + sub-agents (required)

Context must not blow up. **Always** Scout first, then divide work.

Launch sub-agents via the **Task** tool (`subagent_type: generalPurpose` unless
a more specific type clearly fits). Parallel specialists: set
`run_in_background: true` and launch them in **one** message (multiple Task
calls). Each Task prompt MUST be self-contained — specialists do not see the
parent chat. Follow [subagent-contract.md](subagent-contract.md).

### 1. Scout (required, first)

Only job: produce the **map** (no paper prose, no full diffs/file dumps).

**Change scout:** commits, `diffstat`, file list, themes; rank importance/risk;
size by file size, lines changed, hunk count; propose clusters + assignments;
name files the **main agent** keeps for the Feature Design spine.

**Repo scout:** top-level layout; README / `dev-guide.md` / `.dev-notes/definition.md`
(if present); languages and entrypoints; module/package clusters; rank by
criticality (user-facing, core libs, glue, generated/vendored); size by LOC and
file count per cluster; propose specialist assignments; name spine files/APIs for
the main agent’s System Design.

### 2. Main agent (critical path)

- Keep only highest-importance files/APIs/types for the design spine
- Own: Abstract, Introduction stitching, Background synthesis, design spine,
  final Alternate Designs, merged Comments severities, Evaluation polish,
  Conclusion verdict, writing `design-review.md`
- Resolve specialist conflicts; note tension briefly when needed

### 3. Parallel specialist sub-agents

Fan out after Scout, for example:

| Specialist | Job |
|------------|-----|
| **Coverage** | Tests, gaps, stale/weak areas, suggested cases only |
| **Tree/cluster** | One logical tree each: design notes, cite-worthy snippets, Comments, optional alt-design sketches |
| **Entrypoints** (*repo*, optional) | CLI/API/UI/bootstrap surfaces and how they reach core |
| **Cross-cutting** (optional) | Security, concurrency, data durability — only if Scout flags a hotspot |

Each returns a **structured markdown fragment** per the contract — not a full paper.

### Context budgeting (MUST)

Give each sub-agent **optimal** context for the available window:

- Prefer path-filtered `git diff` / `git show` (*change*) or bounded reads of
  ranked paths (*repo*); never whole-repo dumps
- Pass ranked file list with size hints (churn *or* LOC/file count)
- Assign only the paths/hunks/symbols that agent needs
- If one assignment still risks overflow, split further and mark deferred detail
  in Coverage/Comments rather than forcing a full dump
- Specialists: cite `path:line`; include only load-bearing or public API/type
  snippets; flag `confidence: high|medium|low` on speculative claims

### Specialist → main contract

| Role | Returns |
|------|---------|
| Scout | Map, rankings, cluster plan, main-agent file list, size hints |
| Coverage | Draft Coverage section fragment |
| Tree/cluster | Design notes, cited snippets, Comments items, optional alt-design sketches |
| Entrypoints / cross-cutting | Focused fragment + Comments |
| Main | Assembled `design-review.md` per template |

## Workflow checklist

```
Progress:
- [ ] Resolve mode (change | repo); prompt if doubtful
- [ ] Resolve target (change: PR/SHA/range; repo: path/root)
- [ ] Scout Task → map + split + size hints
- [ ] Main: read critical-path files/diffs only
- [ ] Parallel specialist Tasks with budgeted, self-contained prompts
- [ ] Assemble paper from template; design spine is Feature/System Design
- [ ] Write design-review.md (CWD/workspace); do not commit
- [ ] Brief user: path to paper + verdict one-liner
```
