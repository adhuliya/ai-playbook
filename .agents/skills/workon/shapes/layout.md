# Directory layout

```text
.dev-notes/activities/
    activities.md
    <slug>/
        agent-activity.md
        spec-plan-outline.md         # design stage on; not in the handoff
        spec-design.md
        agent-journal.md
        spec-req-def.md
        spec-design-choices.md
        conventions.md
        references.md
        notes-by-user.md
        reviews.md              # lazy
        artifacts/              # copies flat; reserved names below
            agent-notes.md      # parent scratch
            guide-for-users.md  # create-guide only
            detailed-design.md  # detailed-design only
```

A whole copy sits at the artifacts root as `<basename>`; an excerpt is
`<stem>-excerpt.md` with a header that names the source and what was kept.
The reserved directories are `verify-plan/`, `bg/`, `review/`, `comments/`,
and `fix/`, and the reserved files are `inflight.md`, `sub-agents-log.txt`,
`guide-for-users.md`, `detailed-design.md`, and `agent-notes.md`; never use a reserved name
for a cited copy. File
roles: **Paths and readiness**. `inflight.md` is parent scratch
(**Inflight pipelines**):

```markdown
# Inflight

- pipeline: agent-review | fix-cycle review | verify-plan | comments | drift | milestone
- unit: RU<n> | M<n> | <command>
- launched: <steps launched so far>
- final: <path of the final file>
- notes: <short working notes; on pause, where the agent stopped and what remains>
```
