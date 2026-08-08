---
name: build-vocabulary
description: >-
  Creates and maintains `.dev-notes/vocabulary.md`, a two-column glossary of
  project terms and phrases so agents speak in domain-specific language. Use
  when the user asks to build, refresh, or update vocabulary, domain language,
  a term glossary, or invokes build-vocabulary.
disable-model-invocation: true
---

# build-vocabulary

Maintain **`.dev-notes/vocabulary.md`** in the **target git repo** (project root).
Day-to-day **reading and use** is governed by `dev-main.mdc`; this skill only
**creates and updates** the file.

## Split from `definition.md`

| File | Owns |
|------|------|
| `.dev-notes/definition.md` | Vision, scope, stable repo-infrastructure terms |
| `.dev-notes/vocabulary.md` | Domain speech: concepts, phrases, module/user language mined from the project |

Do not copy playbook-only infra terms from `definition.md` unless they are also
how people talk about the **product/domain** in this repo. Link mentally to
`definition.md`; do not duplicate its table.

## File format

Create or keep this shape (no section headers, no extra columns):

```markdown
# Vocabulary

| Term | Description |
|------|-------------|
| Example term or phrase | What it means. Also called: …. Not: …. |
```

- **Term:** canonical wording (may be a **phrase**, not only one word).
- **Description:** one cell for everything: meaning, synonyms (“also called”),
  and confusions (“not …”). Keep rows scannable; prefer short sentences.
- Sort rows **alphabetically** by Term (case-insensitive) after edits.
- Do not add dates, source columns, or HTML comments unless the user asks.

## Using the vocabulary (all agent work)

When the file exists, agents MUST read it per `dev-main.mdc` and **think in
that vocabulary**: choose **Term** values over generic synonyms in user-facing
prose, docs, comments, and new names unless the user overrides.

## Modes

| Mode | When |
|------|------|
| **From scratch** | No file, empty table, or user says rebuild / start over |
| **Refresh** | File already has rows; user asks to update or sync with recent changes |

Ask once if unclear which mode the user wants.

## From scratch (extensive read)

1. Read `.dev-notes/definition.md` (terms only as domain speech, not infra dump).
2. Read repo-root `dev-guide.md`; for each major subtree you investigate, read the
   **deepest** `dev-guide.md` on the ancestor chain (do not bulk-read every nested
   guide unless terms point there).
3. Skim `.dev-notes/knowledge/` if present (headings and term-heavy passages).
4. Honor **user-named paths** as the only roots when given.
5. Pull terms from code signals: package/dir names, public APIs, READMEs, prominent
   comments — not every internal symbol.
6. Stop when new terms taper off; avoid listing one-off identifiers.
7. Before the first write, ask: **anything else to include?** (one short question).
8. Write the full table.

Do **not** scan `artifacts/live-notes/` unless the user asks.

## Refresh (incremental)

1. Read the current `vocabulary.md`.
2. Find **recent deltas**:
   - Commits after the last commit that touched `vocabulary.md`, or
   - if unknown, the last **~10** commits on the current branch, plus
   - **uncommitted** diff.
3. Restrict reads to changed paths plus guides/notes those paths imply; do not
   re-walk the whole tree.
4. Add rows for new terms; update rows when evidence changed.

### Merge rules

- Match rows by **Term** with **case-insensitive** comparison (trim outer whitespace).
- You **may** edit any **Description** (or **Term** if renamed in the project) when
  you have a **good reason** from repo evidence; state that reason briefly in chat
  when you change non-empty text.
- Do not delete a row unless the concept is gone from the project and nothing
  replaces it, or the user confirms removal.
- Prefer updating empty descriptions over adding duplicate terms.

## After writing

Show a short summary: rows added, updated, removed (if any), and paths inspected.
Offer a second pass only if the user wants more coverage.

## Hard constraints

- Update **only** `.dev-notes/vocabulary.md` unless the user explicitly asks for
  rule or guide changes.
- Do not edit `definition.md`, `journal.md`, or activity files as part of this skill.
- Do not invoke `dev-guides` solely to read guides; open guides directly.
