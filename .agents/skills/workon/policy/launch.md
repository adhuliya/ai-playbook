# Launch

Use a general-purpose sub-agent and inherit the model unless the user named
one. From the chat parent, launch in the background and do not wait or
poll. Launch independent sub-agents together (one message where the harness
allows), then do work that does not need them, or end the turn. Stay at
depth 1: a worker may split its job into foreground children, but children
never launch agents (`briefs/common.md`).

**Prompt shape.** Every prompt has these parts, in this order:

```text
Read `.agents/skills/workon/briefs/common.md`, then
`.agents/skills/workon/briefs/<role>.md`, and follow both.
role: <role>   side: positive | negative   pipeline: verify-plan | review | milestone
assigned file: <path>   slice dir: <path>
conventions: <path to conventions.md>
inputs: <paths the brief may read>
<pasted slices: plan packet, or the slices the pipeline step names>
```

`side` and `pipeline` apply to critics and synthesizers. Pass the
`conventions.md` path to every agent except explores that do not need it.

**Plan packet** (pasted by the parent): Goal, Scope, Current Design,
Current Plan, Milestones, Next Steps, the Problem header, full RD, full
Design Decisions, and the `conventions.md` path. Workers, the env agent,
test agents, and explores get only the slices they need.

On a re-run, the agent deletes stale files in its slice directory and
overwrites its assigned files; nothing else is wiped. Keep pipeline files
after use; delete them only through `delete-tmp-files`.
