# workon templates

## Directory layout

```text
.dev-notes/activities/<slug>/
    activity.md
    journal.md
    notes.md                # optional; complementary user/agent notes
    knowledge/              # optional; see `knowledge` skill
    activities/<child>/     # optional children
```

**`knowledge/`:** see [`knowledge`](../knowledge/SKILL.md) skill (optional; lazy-create).

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

# Scope

<One or two human-readable paragraphs: the whole activity scope and how it fits
the project. Set after initial grilling; near-fixed afterward. Major change =
`replan-work`.>

# Background and Special Notes

<Context plus durable global notes. Lifecycle and resume hints live here or in
`# Next Steps`, not in `journal.md`.>

<Knowledge plan: what lives under `knowledge/` (and `knowledge/artifacts/`) vs pointers elsewhere.>

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

Written **only** on `complete-work`: append **one** entry at the **end** of the
file after `status` → `Complete`. Prior entries are **read-only**. No dates.

**Content:** project/engineering work only (what shipped, paths, behavior,
decisions, tradeoffs, lessons, accepted gaps). **Not** activity status or
lifecycle (no approvals, pauses, reopens, resume hints — use `activity.md` and
`notes.md`).

Until the first `complete-work`, the file is only:

```markdown
# Journal
```

### `complete-work` entry shape

Heading names the **work slice** (not the command or status).

```markdown
## <Short work title>

<Shipped outcomes, technical decisions, discoveries, accepted gaps. Repo paths
and evidence pointers; no status narration.>
```

### derive provenance (not journal)

Put in derived `activity.md` `# References`:

`derived-from: <slug>` — non-load-bearing; journal stays scaffold until first
`complete-work` on the derived activity.

## knowledge.md (inside `knowledge/`)

Per [`knowledge`](../knowledge/SKILL.md) skill. Not a substitute for `activity.md` handoff truth.

## notes.md

Optional, complementary. Free-form scratch for user + agent notes that are not
current truth (`activity.md`) or completed work log (`journal.md`). Not part of the
portable handoff. Keep lean; fold decided items into `activity.md` and prune.

```markdown
# Notes

<Complementary context: user notes, agent working notes, open questions, links,
snippets, ideas, reminders. Light attribution (user: / agent:) when it helps.>

## Open questions

- <thing still undecided>

## Ideas / parking lot

- <half-formed idea to revisit>
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
