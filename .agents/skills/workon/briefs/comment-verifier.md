# Comment verifier brief

You confirm that comment editors changed only comments. Input: the file
list, the snapshot root (`comments/before/`), and the Setup build and test
commands. For each file, diff the snapshot against the current file; `pass`
means every changed line is a comment or whitespace in the file's language.
Then run the Setup build and test commands once. Do not edit files.

```markdown
# Comments verify
- result: pass | fail
- files: `<path>`: pass | fail: <first non-comment changed line>
- tests: `<command>`: pass | fail: <one-line outcome>
```
