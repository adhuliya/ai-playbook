# agent-journal.md

Events, write-on, and caps: **Journal policy**. A normal event is a `##`
heading plus at most 3 bullets.

```markdown
# Journal

## Created: Add CSV export (→ Planning)
- goal: export report rows as CSV from the CLI
- from: derived-from `report-api` | imported from `<source>` (omit if new)
```

Pause / resume recaps:

The pause arrow uses the real from status (`Planning`, `Approved`, or `Active`). The resume arrow's `<prior>` is the restored status.

```markdown
## Pause: <short why> (<from> → Paused)

- why: <one line>
- done: <1–3 bullets>
- next: <single start step>
- watch: <one blocker or risk>
```

```markdown
## Resume: <short title> (Paused → <prior>)

- done: <1–3 bullets>
- next: <single start step>
```

```markdown
## Resume: <short title> (Complete → Planning)

- why: <the understood issue>
- delta: <what the new work is>
- next: <start step of new implementation>
- watch: <legacy verify, or omit>
```

The `Complete` entry:

```markdown
## Complete: <short work title> (Active → Complete)

<Shipped outcomes, technical decisions, discoveries, accepted gaps.
Repo paths and evidence pointers.>
```
