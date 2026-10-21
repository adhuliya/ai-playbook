# Directory layout

```text
.dev-notes/activities/
    activities.md
    <slug>/
        activity.md
        plan-outline.md         # design stage on; not in the handoff
        design.md
        journal.md
        requirement-def.md
        design-choices.md
        conventions.md
        references.md
        notes-by-user.md
        reviews.md              # lazy
        guide-for-users.md      # create-guide only
        artifacts/              # copies flat; reserved names below
            detailed-design.md  # detailed-design only
```

A whole copy sits at the artifacts root as `<basename>`; an excerpt is
`<stem>-excerpt.md` with a header that names the source and what was kept.
The reserved directories are `verify-plan/`, `bg/`, `review/`, `comments/`,
and `fix/`, and the reserved files are `inflight.md` and
`detailed-design.md`; never use a reserved name for a cited copy. File
roles: **Paths and readiness**. `inflight.md` is parent scratch
(**Inflight pipelines**):

```markdown
# Inflight

- pipeline: start-review | fix-cycle review | verify-plan | comments | drift | milestone
- unit: RU<n> | M<n> | <command>
- launched: <steps launched so far>
- final: <path of the final file>
- notes: <short working notes>
```
