# workon templates

## Directory layout

```text
.dev-notes/activities/<slug>/
    activity.md
    journal.md
    artifacts/              # optional; create when first needed
    activities/<child>/     # optional children
```

## activity.md

Keep the metadata table in the **first ~10 lines** (title + table) so listing stays greppable.

```markdown
# <Human Title>

| Key | Value |
|---|---|
| status | Planning |
| slug | my-activity |
| branch | none |
| ticket | none |
| notes | |

# Goal

<Concise desired outcome.>

# Background and Special Notes

<Context plus durable global notes that must not be buried in the journal.>

<Artifacts plan: what will live under artifacts/ vs pointers elsewhere.>

# Current Design

<Latest agreed design only.>

# Current Plan

<Approach currently believed correct. Rewrite as understanding evolves.>

# Milestones

MECE outcomes. Each embeds concrete evidence (one or more commands/checks).
Up to ~10 short lines per milestone.

1. [ ] <Outcome A>
   - evidence:
     - `<command or check>`
     - `<optional second command>`

2. [ ] <Outcome B>
   - evidence:
     - `<command or check>`

# Next Steps

1. <Immediate task>
2. <Immediate task>

# References

- <docs, specs, commits, issues, related slugs, …>
```

## journal.md

Append-only. No dates. Free prose under a short heading. Keep entries short
(token economy — essentials only; no dumps or full restatement of `activity.md`).

```markdown
# Journal

## <Short session title>

<What was done, decisions, discoveries, obstacles, open questions, next actions.>

## <Another session title>

...
```

### pause-work entry shape (guidance)

```markdown
## Pause: <short label>

<Work completed, discoveries, decisions, remaining work, unresolved issues.>

Resume Hint: <best place to continue.>
```

### derive first entry

Provenance only — the new `activity.md` must stand alone without reading the source.

```markdown
## Derived from <source-slug>

Derived from `<slug>`: <reason>. New `activity.md` rewritten to be
self-contained; do not require the source on resume.
```

## List output (agent → user)

Present a markdown table, one row per activity (from first ~10 lines), e.g.:

```markdown
| status | slug | branch | notes |
|---|---|---|---|
| Active | add-export-endpoint | feature/add-export-endpoint | waiting on API review |
| Paused | parent/child | none | blocked on fixture data |
```

## Details output (no resume)

1. Full path to `activity.md`
2. First ~20 lines of that file
3. Stop — user opens the file for the rest
