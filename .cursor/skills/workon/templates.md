# workon templates

## Directory layout

```text
.dev-notes/activities/
    activities.md           # high-level catalog (one-liner per activity)
    <slug>/
        activity.md
        journal.md
        notes.md                # requirement definition + design decisions + user notes
        artifacts/              # optional; flat snapshots/excerpts
        activities/<child>/     # optional children
```

**`artifacts/`:** `.dev-notes/activities/<slug>/artifacts/` — flat; whole copies and `<stem>-excerpt.md` files the user chose.

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

<Short summary of notes.md Requirement Definition. SRD is authoritative.>

# Scope

<One or two human-readable paragraphs: the whole activity scope and how it fits
the project. Set after initial grilling; near-fixed afterward. Major change =
`replan-work`.>

# Background and Special Notes

<Context plus durable global notes. Lifecycle and resume hints live here or in
`# Next Steps`, not in `journal.md`.>

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
- `path/to/input` — context-only | copied (`artifacts/<name>`) | excerpt (`artifacts/<stem>-excerpt.md`)
  Learned: <1–3 sentences of what this file contributed to define/design/plan>
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

## activities.md

`.dev-notes/activities/activities.md`. Create lazily. Append-only for new
activities; never bulk-read — `rg '^## <slug>:'`. No tables. One-liner per
activity.

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

Required. Exact headings in this order. **SRD** (`## Requirement Definition`) is
the activity definition (keep current for review before `approve-plan`).
**Design Decisions** is the decision log. **User Notes** is user-owned — do not
overwrite.

```markdown
# Notes

## Requirement Definition

### <title>
- kind: end-user-interface | internal-behavior | external-interface
- <description>

## Design Decisions

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
move leftover body under **User Notes**. Rename `## Software Requirement
Definition` / `## Software Design Decisions` in place if those old headings
remain.

## artifacts/

`.dev-notes/activities/<slug>/artifacts/` — flat, lazy. Whole copy:
`<basename>`. Portion: `<stem>-excerpt.md` (header = source path + what was
kept; then the pieces).

## List output (agent → user)

Present a markdown table, one row per activity (from first ~10 lines of each
`activity.md`), e.g.:

```markdown
| title | status | slug | branch | notes |
|---|---|---|---|---|
| Add export endpoint | Active | add-export-endpoint | feature/add-export-endpoint | waiting on API review |
| Child title | Paused | parent/child | none | blocked on fixture data |
```

## Details output (no resume)

1. Full path to `activity.md`
2. First ~20 lines of that file
3. Stop — user opens the file for the rest
