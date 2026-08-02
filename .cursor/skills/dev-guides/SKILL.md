---
name: dev-guides
description: >-
  Create and maintain hierarchical dev-guide files at <P>/dev-guide.md in the
  target repo. Use when creating the initial guide set, adding or updating folder
  guides, auditing guides after project changes, or when the user explicitly
  requests a dev guide.
disable-model-invocation: true
---

# Dev guides

Hierarchical orientation guides for humans and agents.

This skill owns the **guide format**, **storage scheme**, and **maintenance workflow**.
It does **not** define the project's structure or conventions.

Run this skill only from the **target git repo root** (the project being documented).
Day-to-day **reading** is governed by `dev-main.mdc` (deepest applicable guide,
then walk up ancestors). Use this skill only to **create, update, or audit** guides.

---

## Storage scheme

| Guide | Path in target repo |
|--------|----------------------|
| Repository root | `dev-guide.md` |
| Project folder `<path>` | `<path>/dev-guide.md` |

Rules:

- Guides are **sparse** — one `dev-guide.md` per chosen directory; children inherit
  by walking up to the nearest ancestor guide.
- Discover hierarchy from the filesystem; never store Parent/Children links.
- Never place guides under `.dev-notes/dev-guides/` (obsolete).
- A guide may live under `.dev-notes/<subpath>/dev-guide.md` when that subtree is
  the documented folder (synced via the normal `.dev-notes/` domain, not the hub
  `dev-guides/` tree).
- Never put dates inside guides.
- Existing `README.md` files are outside the scope of this skill (only repair
  broken links if they referenced old guide locations).

**Hub (ai-playbook only, via sync):** for guides outside `.dev-notes/`, sync mirrors
to `artifacts/live-notes/<project>/dev-notes/dev-guides/<path>/dev-guide.md`.

---

## Decision policy

Treat the live project tree as the source of truth for project structure.
Existing guides may be stale.

Use the live project tree to answer factual questions such as:

- directory layout
- APIs
- build targets
- file locations

Never invent project policy.
When uncertain, stop and use the `grill-me` skill
(one question at a time, with a recommended answer).

### Policy questions include:

- whether a directory deserves a guide
- guide placement when ancestors are skipped
- changing the *core* required section set (the title + summary + Notes +
  Artifacts block — not extra bullets inside Notes)
- line-budget exceptions
- renaming, deleting, or merging guides
- changing what a guide is for (summary / scope of the folder)

Material guide changes always require grilling.

### Material changes include:

- guide placement and hierarchy
- more than one line edits in Notes
- the core required section set (not free-form edits inside Notes)
- scope of the summary (what the folder is “for”)

Pure factual corrections do **not** require grilling, for example:

- artifact table row updates
- path renames in Notes or table **Name** cells
- build command updates in Notes
- correcting stale one-liners

---

## Audience and size

Guides help developers and agents understand the project tree.

Guide budget:

- Typical guide: soft ~40 lines, hard ~80 lines
- Repo-root guide: same template; keep the artifact table to top-level paths only

Prefer short table rows and bullet Notes over prose.

---

## Placement rules

Create guides only for genuine work-entry directories with meaningful structure
or non-obvious invariants.

Normally skip:

- leaf-only directories
- empty or reserved packages
- generated output
- gitignored caches
- build directories

---

## Anti-bloat

Always enforce:

- No tutorials or API reference dumps
- Artifacts is selective, not a directory listing; the live tree is
  authoritative for the full layout
- No documenting generated or gitignored content unless Notes must warn about it
- No duplicated vision/style/scope (that is `definition.md`)
- No restating guide meta-policy — it lives in `dev-main.mdc`
- No dates
- No Parent/Children navigation
- Avoid repeating ancestor guides — point to them in Notes or a table row instead

---

## Activities

### 1. Initial guide set

Seed guides for a repo that has no guides yet (or a full rebuild). Follow the
Decision policy throughout.

1. Explore the live project tree (top-level layout, build entrypoint, work-entry
   directories).
2. Propose which directories deserve guides (Placement rules). Grill until there
   is shared agreement — including ancestor skips and root vs folder split.
3. Create the root guide at `dev-guide.md` first from `template.md` (summary +
   top-level artifacts; link `.dev-notes/definition.md` in Notes, do not
   duplicate it).
4. Create each agreed folder guide at `<path>/dev-guide.md` from `template.md`.
5. Keep within line budgets; no dates.
6. Stop when the sparse tree matches the agreed placement — do not document
   every directory.

### 2. Create, update or audit folder guide(s)

- Follow the Decision policy.
- Create or update the guide as per the live project tree.
- Create or update as per `template.md` format.
- Update only affected guides.
- Prefer the smallest sufficient edit.
- Keep guides within line budgets.
- Remove Duplication.
- Add, remove, rename, or move guides when project structure changes.

Update ancestor guides only when their artifact rows or Notes are obviously stale.

---

## Workflow checklist

```
Progress:

- [ ] 1. Follow the Decision policy (grill material forks)
- [ ] 2. Explore the live project tree
- [ ] 3. Agree placement (initial set) or target path (single guide)
- [ ] 4. Create or update guide(s) from template.md (title, summary, Notes,
        Artifacts)
- [ ] 5. Keep artifact table selective; no meta-policy restated
- [ ] 6. Vision stays in definition.md (link from Notes if needed)
- [ ] 7. Fix obviously stale ancestor guides
- [ ] 8. Keep within line budget
```
