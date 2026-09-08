# workon templates

## Directory layout

```text
.dev-notes/activities/
    activities.md           # high-level catalog (heading + short para)
    <slug>/
        activity.md
        journal.md
        notes.md                # SRD + design decisions + user notes
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

<Short summary of notes.md Software Requirement Definition. SRD is authoritative.>

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

## activities.md

`.dev-notes/activities/activities.md`. Create lazily. Append-only for new
activities; never bulk-read — `rg '^## <slug>:'`. No tables.

```markdown
# Activities

High-level catalog. Details live in each activity folder.

## marshal: Marshal playbook sync gaps

Harden playbook/target sync for machine registry, ignores, syncmap, and nested-git guide handling.

## parent-slug/child-slug: Child title

One-liner high-level purpose. Update only if the Goal changes.
```

On create/derive/import, append (do not Read the whole file):

```bash
printf '\n## %s: %s\n\n%s\n' "$slug" "$title" "$para" >> .dev-notes/activities/activities.md
```

## notes.md

Required. Exact headings in this order. SRD is the activity definition (agent
keeps it current for review before `approve-plan`). Software Design Decisions
is the source other skills use for design docs. **User Notes** is user-owned —
do not overwrite.

```markdown
# Notes

## Software Requirement Definition

### <title>
- kind: end-user-interface | internal-behavior | external-interface
- <description>

## Software Design Decisions

### <decision title>
- chosen: <what>
- why: <compelling reason>
- alternatives:
  - <alt>: <why not>
- replaces: <old decision title>

## User Notes

<User free-form information for this activity.>
```

`kind` is exactly one of `end-user-interface`, `internal-behavior`,
`external-interface` (contracts with other software — API/ABI/link/protocol).

On a superseding design choice, set `replaces:` to the old `###` title and leave
the old entry unchanged. Omit `replaces:` on a first decision.

Create at activity birth (empty sections are fine until grill fills SRD).
If an older activity has unstructured `notes.md`, add the three headings and
move leftover body under **User Notes**.

## List output (agent → user)

Present a markdown table, one row per activity (from first ~10 lines of each
`activity.md`), e.g.:

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
