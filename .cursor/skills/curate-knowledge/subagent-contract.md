# Sub-agent contract (curate-knowledge)

Parent must paste a **self-contained** Task prompt; specialists do not see the parent chat. Return **only** the structured fragment for the role — no preamble.

## Shared rules

- Stay inside the assigned source locus and/or chunk paths; do not roam the whole resource or tree
- Prefer bounded `Read` / `rg` over dumping large files
- Do not write final notes or `knowledge.md` (fillers write **only** assigned `chunks/*.md`)
- Mark speculative claims with `confidence: high|medium|low`
- If the assignment still overflows context, stop and report a **split recommendation** instead of skimming

## Scout / plan return

```markdown
## Ingest plan proposal
- **source:** …
- **kind:** toc | no-toc
- **notes on structure:** …

## Proposed Plan rows
| id | slug | source locus | why this split | size hint |
|----|------|--------------|----------------|-----------|

## Open questions for user
- …
```

## Chunk filler

**May write** only the assigned file(s) under `knowledge/artifacts/ingest/<id>/chunks/`.

```markdown
## Chunk fill result
- **wrote:** `chunks/0N-<slug>.md` (list all)
- **locus covered:** …
- **key terms:** …
- **split needed:** no | yes — <recommendation>
- **confidence:** high|medium|low
```

Chunk file shape:

```markdown
# Chunk 0N — <slug>

- **ingest:** <ingest-id>
- **locus:** …
- **status:** pending

## Extract
…

## Key terms
- …
```

## Note drafter return (no file writes)

One ready chunk → one or few atomic notes.

```markdown
## Note drafts
### Draft: <proposed-filename.md>
- **proposed path:** `knowledge/…/<file>.md`
- **title:** …
- **merge with existing:** none | `path` — reason
- **body:** …
- **see also:** …
- **source cite:** `artifacts/resources/…` and/or `artifacts/ingest/<id>/chunks/0N-….md`
- **mermaid:** none | fenced block if it clarifies
- **confidence:** high|medium|low
```

## Placement helper return (optional; main may do this)

After the user’s placement grill, if a Task maps the batch:

```markdown
## Placement map
| Chunk | Target path(s) / merges | Notes |
|-------|-------------------------|-------|

## Index rows to add
| Folder knowledge.md | Name | Description | Link |
|---------------------|------|-------------|------|
```
