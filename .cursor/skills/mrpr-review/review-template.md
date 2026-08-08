# Review: [short title of the change]

**Target:** [PR/MR #… / commit SHA / range / branch]  
**Repo:** [path or remote]  
**Reviewer artifact:** local `review-details.md` (not for commit)

## Abstract

[≤ ~150 words: what changed, for whom, one-clause verdict preview]

## Introduction

[Problem/motivation for *this* change; scope in/out; contribution claim. No module tutorial.]

## Background

[Newcomer literacy: concepts and modules. Pre-feature behavior — how things work without this change.]

## Feature Design

### End-user observable behavior

[Before → after; non-goals if clear]

### Conceptual model

[Mental model / invariants]

### Layered internal design

[Top-down layers. Insert labeled mermaid figures here as needed.]

Figure N: [caption]. Summarizes `path:start-end`.

```mermaid
%% labeled information-flow / sequence / flowchart
```

### Key types & APIs

[New/changed public APIs and data structures in full. Cite each block.]

```language
// path/to/file.ext:start-end
```

### Integration with existing pieces

[Only existing elements needed to understand the flow; cite `path:start-end`.]

## Alternate Designs

### Alternative A: [name]

[Sketch]

- **Advantages vs current:** …
- **Disadvantages vs current:** …

### Alternative B: [name] (optional)

[Same shape]

<!-- Or: one paragraph — no meaningful design fork for this change. -->

## Coverage

### Tests that protect this change

| Test | Location | Behavior guarded |
|------|----------|------------------|
| … | `path` / name | … |

### Gaps

- …

### Stale or missing test updates

- …

### Suggested left-out cases

1. … (priority)
2. …

## Evaluation

**Prerequisites:** …

**Commands:**

```bash
# copy-pasteable; do not assume the reviewer already ran these
```

**Minimal example input:** …

**Expected observable result:** …

**Optional negative check:** …

<!-- Or: blocked by infra — closest offline check: … -->

## Comments

### Broad comments

1. **[Blocker|Major|Minor|Nit] Title** — why it matters; suggested direction.
2. …

### File-specific comments

| Severity | Location | Comment |
|----------|----------|---------|
| Blocker/Major/Minor/Nit | `path:line` | … |

## Conclusion

**Verdict:** Approve | Approve with nits | Request changes | Block

[2–4 sentences tying Feature Design + Comments, especially Blockers/Majors]

**Open questions:**

- …
