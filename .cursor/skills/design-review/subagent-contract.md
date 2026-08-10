# Sub-agent contract (design-review)

Read this when launching Task sub-agents. Parent must paste a **self-contained**
prompt; specialists do not see the parent chat.

## Shared rules for every specialist

- Work only the assigned paths / symbols; do not roam the whole repo
- Prefer `git` path filters and line-bounded `Read` over dumping files
- Cite `path:line` or `path:start-end` for every claim that depends on code
- Include API/type snippets **in full** when they are load-bearing; elide glue
- Mark speculative claims with `confidence: high|medium|low`
- Return **only** the structured fragment below — no full paper, no preamble

## Scout return (change)

```markdown
## Change map
- **Target:** …
- **Commits / range:** …
- **Themes:** …

## Files (ranked)
| Rank | Path | Churn (lines +/-) | Hunks | Why it matters |
|------|------|-------------------|-------|----------------|

## Hotspots
- …

## Clusters → specialists
| Cluster | Paths | Suggested agent | Notes |
|---------|-------|-----------------|-------|

## Main-agent spine files
- `path` — reason
```

## Scout return (repo)

```markdown
## Repo map
- **Root:** …
- **Languages / stack:** …
- **Entrypoints:** …
- **Docs anchors:** (README, dev-guide.md, definition.md, …)

## Clusters (ranked)
| Rank | Cluster | Paths / globs | LOC≈ | Files≈ | Criticality | Why |
|------|---------|---------------|------|--------|-------------|-----|

## Vendored / generated / skip
- …

## Clusters → specialists
| Cluster | Paths | Suggested agent | Notes |
|---------|-------|-----------------|-------|

## Main-agent spine files / APIs
- `path` — reason
```

## Coverage specialist return

```markdown
## Coverage fragment
### Tests that protect this surface
| Test | Location | Behavior guarded |
|------|----------|------------------|

### Gaps
- …

### Stale, missing, or weak test areas
- …

### Suggested left-out cases
1. … (priority)

confidence: …
```

## Tree / cluster specialist return

```markdown
## Cluster: [name]
### Design notes
- …

### Cite-worthy snippets
- `path:start-end` — why

### Alternate-design sketches (optional)
- …

### Comments
#### Broad
1. **[Severity] Title** — …

#### File-specific
| Severity | Location | Comment |
|----------|----------|---------|

confidence: …
```

## Entrypoints / cross-cutting return

Same shape as tree/cluster, titled for the concern (`## Entrypoints`, 
`## Security`, etc.).

## Prompt skeleton (copy into Task)

```text
You are a design-review specialist. Mode: [change|repo].
Role: [scout|coverage|tree:NAME|entrypoints|cross-cutting:TOPIC].
Repo root: [abs path]
Target: [PR/SHA/range OR "whole repository"]

Assigned paths only:
- path1
- path2

Size hints: [churn or LOC/file counts from Scout]

Instructions:
- Follow the return schema for your role from the parent skill's
  subagent-contract.md (reproduce the headings exactly).
- Do not write design-review.md.
- Do not review paths outside the assignment unless a cited import forces a
  single bounded peek — then note it.
- Prefer path-filtered git and line-bounded reads.

Return only the structured fragment.
```
