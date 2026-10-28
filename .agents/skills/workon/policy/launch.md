# Launch

Use a general-purpose sub-agent and inherit the model unless the user named
one. From the chat parent, launch in the background and do not wait or
poll. Launch independent sub-agents together (one message where the harness
allows), then do work that does not need them, or end the turn. Stay at
depth 1: a worker may split its job into foreground children, but children
never launch agents (`briefs/common.md`). Name each job, and once give `tail -f` for `artifacts/sub-agents-log.txt`.
Truncate that file in place on the first launch only. Append `Parent: started <role>
— <job>`, and `Parent: stopped <role> — <result>` when
it returns.

**Prompt shape.** Every prompt has these parts, in this order:

```text
Read `.agents/skills/workon/briefs/common.md`, then
`.agents/skills/workon/briefs/<role>.md`, and follow both.
role: <role>   side: positive | negative   pipeline: verify-plan | review   focus: <list>
assigned file: <path>   slice dir: <path>
log: .dev-notes/activities/<slug>/artifacts/sub-agents-log.txt
conventions: <path to conventions.md>
inputs: <paths the brief may read>
<pasted slices, only when the pipeline step names them>
```

`side`, `pipeline` (`verify-plan` or `review` only), and `focus` apply to
critics. `side` and `pipeline` also apply to synthesizers. Omit them
otherwise. Pass the `conventions.md` path to
every agent except explores that do not need it.

**Plan packet.** The critics and the synthesizer of `verify-plan` and review
read one packet file, not pasted text. Before it launches the critics, the
parent writes the packet once per pipeline run and lists its path in
`inputs`. The packet holds the `agent-activity.md` sections Goal, Scope, Current
Plan, Milestones, and Next Steps, then the full RD (with the
Problem header), the full Design Decisions, and the full `spec-design.md`
(**Design document**). The `DD` blocks are the current statements. The
choice history stays in `spec-design-choices.md`. Build it in one shell call,
so the text never passes through your context:

```bash
s=.dev-notes/activities/<slug>; mkdir -p "$s/artifacts/<dir>"; { awk '/^# /{p=/^# (Goal|Scope|Current Plan|Milestones|Next Steps)/} p' "$s/agent-activity.md"; cat "$s/spec-req-def.md" "$s/spec-design-choices.md" "$s/spec-design.md"; } > "$s/artifacts/<dir>packet.md"
```

`<dir>` is the pipeline directory with its slash (`verify-plan/`, `review/`,
`fix/review/`); a re-run overwrites the file. The env agent, test agents,
and explores get only the slices they need, pasted. Milestone workers
get `artifacts/bg/M<n>/slice.md` from **Milestone read**, not a paste.

On a re-run, the agent deletes stale files in its slice directory and
overwrites its assigned files; nothing else is wiped. Keep pipeline files
after use; delete them only through `delete-tmp-files`.
