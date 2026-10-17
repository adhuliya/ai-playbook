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
<pasted slices, only when the pipeline step names them>
```

`side` and `pipeline` apply to critics and synthesizers. Pass the
`conventions.md` path to every agent except explores that do not need it.

**Plan packet.** The critics and the synthesizer of `verify-plan` and review
read one packet file, not pasted text. Before it launches the critics, the
parent writes the packet once per pipeline run and lists its path in
`inputs`. The packet holds the `activity.md` sections Goal, Scope, Current
Design, Current Plan, Milestones, and Next Steps, then the full RD (with the
Problem header) and the full Design Decisions. Build it in one shell call,
so the text never passes through your context:

```bash
s=.dev-notes/activities/<slug>; mkdir -p "$s/artifacts/<dir>"; { awk '/^# /{p=/^# (Goal|Scope|Current Design|Current Plan|Milestones|Next Steps)/} p' "$s/activity.md"; cat "$s/requirement-def.md" "$s/design-choices.md"; } > "$s/artifacts/<dir>packet.md"
```

`<dir>` is the pipeline directory with its slash (`verify-plan/`, `review/`,
`fix/review/`); a re-run overwrites the file. Other roles (workers, the env
agent, test agents, explores, milestone critics) get only the slices they
need, pasted.

On a re-run, the agent deletes stale files in its slice directory and
overwrites its assigned files; nothing else is wiped. Keep pipeline files
after use; delete them only through `delete-tmp-files`.
