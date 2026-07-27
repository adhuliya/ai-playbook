---
name: dev-guides
description: >-
  Create and maintain hierarchical dev-guide files under .dev-notes/dev-guides/.
  Use when creating the initial guide set, adding or updating folder guides,
  auditing guides after project changes, or when the user explicitly requests a
  dev guide. Invoke only when explicitly requested by the user or another rule.
disable-model-invocation: true
---

# Dev guides

Hierarchical orientation guides for humans and agents.

This skill owns the **guide format**, **storage scheme**, and **maintenance workflow**.
It does **not** define the project's structure or conventions.

Day-to-day **reading** is governed by `dev-main.mdc`
(deepest applicable guide, escalating through Related when necessary).
Use this skill only to **create, update, or audit** guides.

---

# Storage scheme

| Guide | Path |
|--------|------|
| Repository root | `.dev-notes/dev-guides/dev-guide.md` |
| Project folder `<path>` | `.dev-notes/dev-guides/<path>/dev-guide.md` |

Rules:

- Mirror the project tree under `.dev-notes/dev-guides/`, but guides are sparse.
- Directories without a guide inherit from the nearest ancestor guide.
- Discover hierarchy from the filesystem; never store Parent/Children links.
- Never place guides inside the source tree.
- Never put dates inside guides.
- Existing `README.md` files are outside the scope of this skill (only repair
  broken links if they referenced old guide locations).

---

# Decision policy

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

Policy questions include:

- whether a directory deserves a guide
- guide placement when ancestors are skipped
- Related entries
- adding or removing template sections
- line-budget exceptions
- renaming, deleting, or merging guides
- changing a guide's purpose or invariants

Material guide changes always require grilling.

Material changes include:

- Purpose
- Invariants
- Guide placement
- Related entries
- Guide hierarchy decisions
- Template structure

Pure factual corrections do **not** require grilling, for example:

- layout or role descriptions
- path renames
- build command updates
- correcting stale file lists

---

# Audience and size

Audience:

- new developers
- new agent sessions

Guide budget:

- Folder guides: soft 60–80 lines, hard 100 lines
- Root guide: thin index only

Prefer concise role lines over prose.

---

# Placement rules

Create guides only for genuine work-entry directories with meaningful structure
or non-obvious invariants.

Normally skip:

- leaf-only directories
- empty or reserved packages
- generated output
- gitignored caches
- build directories

---

# Guide template

Default required sections (see `template.md`)

1. Purpose
2. Layout
3. Build / test / run
4. Invariants
5. Related (optional)

Optional sections:

- Key entry points
- Common tasks

Never include Parent/Children navigation.

---

# Related

Use Related only when another project directory has a clear dependency that is
useful for navigation.

Example:

```markdown
## Related

- `pkg/core` — shared contract
- `test/integration` — integration corpus
```

Rules:

- Use project paths only.
- Never reference `.dev-notes/dev-guides/...`.
- Related exists for navigation, not strictly for documentation.
- Omit the section when no clear dependency exists.
- Avoid weak "see also" links.

---

# Anti-bloat

Always enforce:

- No tutorials
- No API reference dumps
- No large file listings
- No documenting generated or gitignored content
- No duplicated vision/style/scope documents
- No dates
- No Parent/Children navigation
- Avoid repeating information already covered by ancestor guides
- Common tasks may include concrete build/test commands

---

# Hierarchy discovery (cookbook)

For guide creation and audits only.

```bash
# Deepest guide for project path P
P=pkg/core
while [ -n "$P" ]; do
  f=".dev-notes/dev-guides/$P/dev-guide.md"
  [ -f "$f" ] && { echo "$f"; break; }
  case "$P" in
    */*) P=${P%/*} ;;
    *) P= ;;
  esac
done
[ -z "${f:-}" ] || [ ! -f "$f" ] && \
  [ -f .dev-notes/dev-guides/dev-guide.md ] && \
  echo .dev-notes/dev-guides/dev-guide.md

# Immediate child guides
G=pkg
if [ -z "$G" ]; then
  find .dev-notes/dev-guides -mindepth 2 -maxdepth 2 -name dev-guide.md | sort
else
  find ".dev-notes/dev-guides/$G" -mindepth 2 -maxdepth 2 -name dev-guide.md | sort
fi
```

---

# Activities

## 1. Initial guide set

Seed `.dev-notes/dev-guides/` for a repo that has no guides yet (or a full
rebuild). Follow the Decision policy throughout.

1. Explore the live project tree (top-level layout, build entrypoint, work-entry
   directories).
2. Propose which directories deserve guides (Placement rules). Grill until there
   is shared agreement — including ancestor skips and root vs folder split.
3. Create the root guide at `.dev-notes/dev-guides/dev-guide.md` first (thin
   index only):
   - top-level path → role table
   - high-level pipeline (if any)
   - top-level build entrypoint (`Makefile` / `make help`, or project equivalent)
   - Related only for clear top-level navigation
4. Create each agreed folder guide at
   `.dev-notes/dev-guides/<path>/dev-guide.md` from `template.md`.
5. Wire Related only for clear dependencies; keep within line budgets;
   no Parent/Children links; no dates.
6. Stop when the sparse tree matches the agreed placement — do not document
   every directory.

Project detail belongs in folder guides, not the root index.

---

## 2. Create or modify a folder guide

Follow the Decision policy.

Explore the live project tree.

Create or update from `template.md`:

```
.dev-notes/dev-guides/<path>/dev-guide.md
```

Update Related only when dependencies are clear.

Update ancestor role lines only when obviously stale.

---

## 3. Audit guides

Repository-wide verification.

1. Use git history as a soft staleness signal.
2. Compare each guide against the live project tree.
3. Add, remove, rename, or move guides when project structure changed.
4. Remove duplication.
5. Keep guides within line budgets.
6. Follow the Decision policy whenever material changes are needed.

---

## 4. Post-feature update

Maintenance triggered by code changes.
Targeted maintenance after a feature or API change.

Update only affected guides.

Prefer the smallest sufficient edit.

Follow the Decision policy for material changes.

---

## 5. Hybrid maintenance

Outside this skill, agents may update clearly factual information during a code
change, such as:

- renamed paths
- role-line corrections
- updated commands

Anything involving guide placement, purpose, invariants, hierarchy, or Related
requires this skill and the Decision policy.

---

# Workflow checklist

```
Progress:

- [ ] 1. Follow the Decision policy (grill material forks)
- [ ] 2. Explore the live project tree
- [ ] 3. Agree placement (initial set) or target path (single guide)
- [ ] 4. Create or update guide(s) from template.md
- [ ] 5. Add Related only for clear dependencies
- [ ] 6. Fix obviously stale ancestor role lines
- [ ] 7. Keep within line budget
```
