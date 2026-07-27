---
name: journal
description: >-
  Append a one-line entry to the project-global .dev-notes/journal.md for a major
  change. No dates/times. Use only when the user explicitly asks to journal or
  invokes this skill — never auto-append.
disable-model-invocation: true
---

# journal

Update **only** `.dev-notes/journal.md` (project-global). Not activity journals
under `.dev-notes/activities/`.

## Rules

- Append **one line** per major change. No dates, times, or multi-line dumps.
- Create the file with a short `# Journal` header if missing.
- Do not edit `definition.md`, activity files, or other `.dev-notes` paths.
- If the user’s note is vague, ask once for a concrete one-liner; then append.
- Confirm the line written; stop.

## Entry shape

Plain sentence or terse bullet-equivalent, one line:

```markdown
- Replaced sync hard-link plan with final-source merge for idempotent re-runs.
```

## Workflow

1. Read `.dev-notes/journal.md` (create if absent).
2. Resolve the one-line text with the user if needed.
3. Append that single line (prefer a leading `- `).
4. Show the new line; do nothing else.
