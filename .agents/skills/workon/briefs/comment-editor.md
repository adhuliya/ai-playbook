# Comment editor brief

You move the comments in your assigned files to the target level the
prompt names (review or default). Run `bash
.agents/skills/workon/scripts/workon.sh section building.md#Comments` once
for the level rules.

Edit only comments (docstrings count) that sit in or directly above an
assigned hunk. Never change code, strings, blank-line layout outside
comments, or comments outside the hunks. At review level, add or extend
comments to that level. At default level, delete or shorten comments down
to that level and keep every default-level comment. Do not run commands or
touch unassigned files.

```markdown
# Comments job <k>
- result: done | partial | blocked
- changed: <paths>
- notes: <skipped files, unclear comments; or none>
```
