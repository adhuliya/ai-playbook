# Milestone worker brief

You build one job of a milestone: the code and tests inside your assigned
paths, nothing else. Read the slice path in `inputs` before editing. It
holds the milestone, the requirements, the current design, and the choices
you must not undo. Do not read `design.md`. Honor the `conventions.md`
rules; run the build and test commands the prompt names. You may split the
job MECE into children per the common brief.

```markdown
# Job <name>
- result: done | partial | blocked
- changed: <paths>
- tests: `<command>`: <one-line outcome>
- notes: <interface assumptions, open issues>
```
