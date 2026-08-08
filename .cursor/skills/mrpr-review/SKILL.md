---
name: mrpr-review
description: >-
  Reviews a git MR/PR or commit by writing a conference-style technical paper
  (markdown + labeled mermaid) to review-details.md. Emphasizes Feature Design
  (end-user observable behavior and layered internal design), Background for
  newcomers, Alternate Designs, Coverage, Evaluation (document-only commands),
  and severity-tagged Comments. Always scouts with a sub-agent, then divides
  work across parallel sub-agents with context budgets from file size and diff
  churn. Use when the user invokes /mrpr-review or asks for an MR/PR/commit
  review paper.
disable-model-invocation: true
---

# MR/PR Review (technical paper)

Produce `review-details.md` in the session CWD / workspace root: a conference-style
technical paper reviewing the chosen git MR/PR or commit. Overwrite on re-run
unless the user names another path.

**Local artifact:** do not `git add` or commit `review-details.md`.

Fill the skeleton in [review-template.md](review-template.md).

## Target resolution

Resolve what to review in this order; **when in doubt, prompt the user**:

1. Explicit arg: PR/MR number or URL, commit SHA, range (`A..B`), or branch
2. Open PR/MR for the current branch (hosting CLI as the session context directs)
3. Unpushed commits on the current branch vs upstream/base (`main`/`master`)
4. Prompt the user

**Diffs:** always from git inside the repo (`git diff`, `git show`, `git log`,
path filters). Prefer hosting CLIs only for metadata when the invoke/session
says which process to use (`gh`, `glab`, etc.). Missing CLI must not block—
fall back to branch/commit range and note limited metadata.

## Paper structure (fixed order)

1. **Abstract** — ≤ ~150 words; what changed, for whom; verdict preview OK
2. **Introduction** — problem/motivation, in/out scope, contribution claim (*this* change)
3. **Background** — newcomer area literacy; how things work **without** the feature
4. **Feature Design** — **spine** (see below)
5. **Alternate Designs** — 1–2 real alternatives with adv/disadv, or “no meaningful fork”
6. **Coverage** — protecting tests, gaps, stale/missing updates, suggested cases
7. **Evaluation** — **document only**: prerequisites, commands, minimal example, expected result, optional negative check (or blocked + closest offline check). Do not run unless the user asks
8. **Comments** — Broad then file-specific (see below)
9. **Conclusion** — Verdict (`Approve` / `Approve with nits` / `Request changes` / `Block`) + 2–4 sentence why + open questions

Tone: precise conference paper. Neutral voice in body; reviewer voice OK in Comments/Conclusion. No Related Work unless truly needed. Prefer diagrams + cited snippets over padding.

### Feature Design (spine)

Subsections (skip empty; do not invent layers the code lacks):

1. **End-user observable behavior** — before → after; non-goals if clear
2. **Conceptual model** — mental model / invariants
3. **Layered internal design** — top-down; labeled mermaid for information flow
4. **Key types & APIs** — new/changed public surfaces and data structures **in full**, each with `path:start-end`
5. **Integration with existing pieces** — only what is needed to understand the flow, cited the same way

Every snippet cites real `path:start-end`. Elide glue with `// ...` (or language equivalent); never truncate the API/type itself.

### Alternate Designs

1–2 competent alternatives (not strawmen). For each: brief sketch, advantages vs current, disadvantages vs current, tied to a concrete tradeoff in *this* change. Do not demand a rewrite unless a Blocker says so. Tiny bugfix with no design fork → one short paragraph saying so.

### Coverage

1. Tests that protect the change (file + name/description + behavior guarded)
2. Gaps (Feature Design behaviors with no test)
3. Stale/missing test updates
4. Suggested left-out cases (prioritized)

Ground in the repo’s real test layout (and guides if present).

### Comments

**A. Broad** — ordered by severity: `Blocker`, `Major`, `Minor`, `Nit`. Title, why it matters, suggested direction.

**B. File-specific** — `path:line` or `path:start-end` + same severity + one-liner (style, security, null check, overflow, API footgun, nit, etc.). Every item must cite a real location.

### Diagrams

- Mermaid only when it clarifies information flow, layering, or before/after paths
- Every diagram has a caption/label (e.g. `Figure 1: …`)
- Prefer sequence/flowchart for runtime; class/ER only when types/relationships are central
- Cite summarized code in/under the caption
- Cap ~3–7 diagrams for a large change; ~0–2 for a small fix; never diagram trivial renames

## Progressive review + sub-agents (required)

Context must not blow up. **Always** start with a Scout sub-agent, then divide work.

### 1. Scout (required, first)

Launch a sub-agent whose only job is the **change map**:

- Inventory via git: commits, `diffstat`, file list, themes
- Rank importance / risk hotspots
- Size work: file size, lines changed, hunk count
- Propose clusters and sub-agent assignments
- Name files the **main agent** should keep for the Feature Design spine

Scout returns structured map only — **no** full paper prose, **no** full diffs.

### 2. Main agent (critical path)

- Keep only highest-importance files/APIs/types for Feature Design
- Own: Abstract, Introduction stitching, Feature Design spine, final Alternate Designs, merged Comments severities, Evaluation polish, Conclusion verdict, writing `review-details.md`
- Resolve specialist conflicts; note tension briefly when needed

### 3. Parallel specialist sub-agents

Fan out after Scout (background when possible), for example:

- **Coverage agent** — tests, gaps, stale updates, suggested cases only
- **Directory-tree agents** — one logical tree/cluster each: design notes, snippets worth citing, `path:line` comments, alternate-design candidates for that cluster
- Other specialists as Scout proposes (e.g. security-focused tree)

Each specialist returns a **structured markdown fragment** aimed at its section/cluster.

### Context budgeting (MUST)

Give each sub-agent **optimal** context for available window:

- Prefer path-filtered `git diff` / `git show` and line-bounded reads over whole-repo dumps
- Pass ranked file list with size and churn (lines changed, hunks)
- Assign only the paths/hunks/symbols that agent needs
- If one assignment still risks overflow, split further (by file group or commit range) and mark deferred detail in Coverage/Comments rather than forcing a full dump
- Specialists: cite `path:line`; include only load-bearing or new API/type snippets; flag `confidence: high|medium|low` on speculative claims

### Specialist → main contract

| Role | Returns |
|------|---------|
| Scout | Change map, rankings, cluster plan, main-agent file list, size/churn hints |
| Coverage | Draft Coverage section fragment |
| Tree/cluster | Design notes for that cluster, cited snippets, Comments items, optional alt-design sketches |
| Main | Assembled `review-details.md` per template |

## Workflow checklist

```
Progress:
- [ ] Resolve target (prompt if doubtful)
- [ ] Scout sub-agent → change map + split + churn sizes
- [ ] Main: read critical-path diffs only
- [ ] Parallel specialists (Coverage + trees) with budgeted context
- [ ] Assemble paper from template; Feature Design is the spine
- [ ] Write review-details.md (CWD/workspace); do not commit
- [ ] Brief user: path to paper + verdict one-liner
```
