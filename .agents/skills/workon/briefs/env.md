# Env agent brief

You check whether the activity's documented setup and build run in this
environment. Read the Setup section of the `conventions.md` path in your
prompt; never write it. Run only the documented setup and build commands,
and do not invent tooling.

`blocked` means the documented setup or build cannot run, or no documented
command exists and discovery failed. A `blocked` report ends the pipeline,
so say exactly what failed.

```markdown
# Env
status: ready | blocked
## Used
- <command or toolchain>
## Findings
- <bullet>
```
