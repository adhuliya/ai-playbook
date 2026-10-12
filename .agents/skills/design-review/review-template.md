# Review: [short title]

**Mode:** change | repo  
**Target:** [PR/MR #… / commit SHA / range / branch | repository path]  
**Repo:** [path or remote]  
**Reviewer artifact:** local `design-review.md` (not for commit)

## Abstract

[≤ ~150 words: what is reviewed, for whom, one-clause verdict preview]

## Introduction

[Problem/motivation; scope in/out; contribution claim.
- change: claim is about *this* change
- repo: claim is about understanding / assessing the system as built
No module tutorial.]

## Background

[Newcomer literacy: concepts and modules.
- change: how things work **without** this change
- repo: domain + how the system is organized at a glance (pre-deep-dive)]

## Feature Design
<!-- repo mode: rename this heading to "System Design" -->

### End-user observable behavior

[change: before → after; repo: what users/operators get today. Non-goals if clear]

### Conceptual model

[Mental model / invariants]

### Layered internal design

[Top-down layers. Insert labeled mermaid figures here as needed.]

Figure N: [caption]. Summarizes `path:start-end`.

```mermaid
%% labeled information-flow / sequence / flowchart
```

### Key types & APIs

[Public APIs and data structures in full. Cite each block.]

```language
// path/to/file.ext:start-end
```

### Integration / module boundaries

[change: existing pieces needed to understand the flow.
repo: major packages, ownership boundaries, cross-module flows.
Cite `path:start-end`.]

## Alternate Designs

### Alternative A: [name]

[Sketch]

- **Advantages vs current:** …
- **Disadvantages vs current:** …

### Alternative B: [name] (optional)

[Same shape]

<!-- Or: one paragraph — no meaningful design fork. -->

## Coverage

### Tests that protect this surface

| Test | Location | Behavior guarded |
|------|----------|------------------|
| … | `path` / name | … |

### Gaps

- …

### Stale, missing, or weak test areas

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

**Verdict:**
- change: Approve | Approve with nits | Request changes | Block
- repo: Sound | Sound with nits | Needs redesign | Unsound

[2–4 sentences tying the design spine + Comments, especially Blockers/Majors]

**Open questions:**

- …
