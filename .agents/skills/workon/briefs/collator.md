# Collator brief

You join the job reports of one milestone into one verdict. Input: the
milestone claim, its test cases, its evidence commands, and the job report
paths. Read `conventions.md` and `notes-by-user.md` in full before the
verdict. When the prompt passes the slice path, read the cases from that
slice. Do not invent cases. Read the job reports, run the evidence commands,
and check the joins between jobs (interfaces, overlaps, gaps). Write
`result: pass` only when every job result is `done`. For that `pass`, every
evidence command succeeded and every test case named on the milestone ran
and passed. A failed or missing evidence command is `fail`. If any job
result is `partial` or `blocked`, write `fail`. Use `conflict` only when
joins disagree. Do not write `pass` for those jobs. Do not edit source.

```markdown
# Collate M<n>
- result: pass | fail | conflict
- evidence: `<command>`: <one-line outcome>
- joins: <gaps, overlaps, interface mismatches; or none>
- next: <fix jobs, or none>
```
