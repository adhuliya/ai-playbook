# workon templates

## Directory layout

```text
.dev-notes/activities/
    activities.md
    <slug>/
        activity.md
        journal.md
        notes.md
        artifacts/              # optional; copies flat; verify-plan/ and bg/ reserved
```

No child activity directories. Siblings are top-level slugs.

**`artifacts/`:** whole copies as `<basename>` at the root; excerpts as
`<stem>-excerpt.md` (header = source path + what was kept). Reserved
subdirs (ephemeral, never git-add): `verify-plan/` (`critic-a.md`,
`critic-b.md`, `synthesis.md`) and `bg/`.

## activity.md

Metadata table in the **first ~10 lines** (title + table) so listing stays greppable.

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

<Short summary of notes.md Requirement Definition. ARD is authoritative.>

# Scope

<One or two paragraphs: whole activity scope and how it fits the project.
Set after initial grilling; near-fixed. Major in-flight change = `replan-work`.>

# Background and Special Notes

<Context plus durable global notes.>

# Current Design

<Latest agreed design only. After `mark-completed`, shipped handoff.>

# Current Plan

<Approach currently believed correct. On Complete-reopen: legacy verify, then
delta steps starting at the new requirement.>

# Milestones

MECE outcomes. Each embeds concrete evidence. Keep checked items on reopen;
append new; mark removed work `superseded`.

1. [ ] <Outcome A>
   - evidence:
     - `<command or check>`

2. [ ] <Outcome B>
   - evidence:
     - `<command or check>`

# Next Steps

1. <Immediate task>
2. <Immediate task>

# References

- <docs, specs, commits, issues, related slugs, …>
- `path/to/input` — context-only | copied (`artifacts/<name>`) | excerpt (`artifacts/<stem>-excerpt.md`)
  Learned: <1–3 sentences>
- `derived-from: <parent-slug>` — siblings only; non-load-bearing
```

## journal.md

This activity's `<slug>/journal.md` only. Write on `pause-work`, `resume-work`,
and `mark-completed`. Append at end. Read-only except `compact-journal`.
No dates unless asked. Recap cap ~8–12 lines.

Until the first `pause-work` / `resume-work` / `mark-completed`:

```markdown
# Journal
```

### Pause / resume recap (~8–12 lines)

```markdown
## Pause (Active → Paused)

- why: <one line>
- done: <1–3 bullets>
- next: <single start step>
- watch: <one blocker or risk>
```

```markdown
## Resume (Paused → Active)

- done: <1–3 bullets>
- next: <single start step>
```

```markdown
## Resume (Complete → Planning)

- why: <the understood issue>
- delta: <what the new work is>
- next: <start step of new implementation>
- watch: <legacy verify, or omit>
```

### `mark-completed` entry

Heading names the **work slice** and carries the transition tick
(`(<from> → Complete)`). Body is shipped outcomes, paths, decisions,
lessons, accepted gaps — no separate tick line.

```markdown
## <Short work title> (Active → Complete)

<Shipped outcomes, technical decisions, discoveries, accepted gaps.
Repo paths and evidence pointers.>
```

### Sibling provenance (not journal)

In derived `activity.md` `# References`: `derived-from: <slug>`.
Parent gets no sibling pointer. Sibling journal starts as `# Journal` only.

## activities.md

Create lazily. Append-only for new activities. Never bulk-read — `rg '^## <slug>:'`.

```markdown
# Activities

High-level catalog. Details live in each activity folder.

## marshal: Marshal playbook sync gaps

Harden playbook/target sync for machine registry, ignores, syncmap, and nested-git guide handling.
```

On create / derive / import (do not Read the whole file):

```bash
printf '\n## %s: %s\n\n%s\n' "$slug" "$title" "$para" >> .dev-notes/activities/activities.md
```

## notes.md

Exact headings, this order.

```markdown
# Notes

## Requirement Definition

### <title>
- kind: end-user-interface | software-interface | internal-behavior
- <description>

## Design Decisions

### <decision title>
- level: design-choice | major-implementation-detail | implementation-detail
- chosen: <what>
- why: <compelling reason>
- alternatives:
  - <alt>: <why not>
- replaces: <old decision title>

## Conventions

### <short title>
- <2–5 bullets: the rule>

## User Notes

<User free-form information for this activity.>
```

`kind` is exactly one of `end-user-interface` (humans), `software-interface`
(contract other software must honor: in-repo modules/libraries, API, ABI, FFI,
protocol; old notes may still say `external-interface`), or
`internal-behavior`. `level` is exactly one of `design-choice`
(affects user interface or a software-facing contract; feeds a future design document),
`major-implementation-detail` (internal but individually mentioned in that
document — costly to not know, or reversal ripples across components), or
`implementation-detail` (internal; summarized when that document is written).
Keep each decision entry under ~200 words as a hard max; prefer a few short
bullets. Omit `replaces:` on a first decision.

Conventions are binding and living: 2–5 short bullets per named rule. They
take precedence over project/repo conventions and rules for this activity
(workon hard constraints, safety, and git safety still win). Rewrite in place
when the user asks or a newly confirmed rule contradicts or tightens that
entry. Mark `superseded` to drop; do not delete. Write only user-stated or
confirmed rules. `replaces:` only when splitting or renaming.

Agent-written sections use the **Prose density** bar in `SKILL.md` (not User Notes).

## List output (agent → user)

```markdown
| title | status | slug | branch | notes |
|---|---|---|---|---|
| Add export endpoint | Active | add-export-endpoint | feature/add-export-endpoint | waiting on API review |
```

`ticket` is omitted on purpose (token economy); include it if the user asks.

## Details output (no resume)

1. Full path to `activity.md`
2. First ~20 lines of that file
3. Stop
