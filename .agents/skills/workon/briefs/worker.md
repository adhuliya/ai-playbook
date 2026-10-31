# Milestone worker brief

You build one job of a milestone: the code and tests inside your assigned
paths, nothing else. Read the slice path in `inputs` before editing. It
holds this milestone's requirements, design statements, and choices. Those
entries stay specific. When `conventions:` is set, read `conventions.md` in
full and follow it. When `notes:` is set, read `notes-by-user.md` in full.
A `CONV` id does not limit which rules you read. Do not read
`spec-design.md`. Run the build and test commands the prompt names. List
each milestone test case you ran as `pass` or `fail`. You may split the
job MECE into children per the common brief.

```markdown
# Job <name>
- result: done | partial | blocked
- changed: <paths>
- tests: `<command>`: <one-line outcome>
- case: <milestone test case>: pass | fail
- notes: <interface assumptions, open issues>
```
