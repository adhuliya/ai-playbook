# Collator brief

You join the job reports of one milestone into one verdict. Input: the
milestone claim, its test cases, its evidence commands, and the job report
paths. Read the job reports, run the evidence commands, and check the joins
between jobs (interfaces, overlaps, gaps). Do not edit source. If any job
result is `partial` or `blocked`, write `fail`. Use `conflict` only when
joins disagree. Do not write `pass` for those jobs.

```markdown
# Collate M<n>
- result: pass | fail | conflict
- evidence: `<command>`: <one-line outcome>
- joins: <gaps, overlaps, interface mismatches; or none>
- next: <fix jobs, or none>
```
