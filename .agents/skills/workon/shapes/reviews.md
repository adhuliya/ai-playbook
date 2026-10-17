# reviews.md

Policy: **Reviews**. `status:` is required on every new cycle. `scope:`
applies to `start-review` and fix cycles; other cycles MAY omit it. `kind:
fix` appears only on fix cycles. A cycle with no points holds `- none`;
after an automated pass with no findings, `- none (agent)`; after env
`blocked`, `- none (env blocked)`.

```markdown
# Reviews

## RU1: <short topic>

status: closed
scope: milestones M1–M2 | plan

state: <status, current milestone. Changes since the previous RU cycle:
IDs added/changed, work built. 1–2 short paragraphs; deltas only.>

- RU1.1 (agent): <point> — applied → RD2 (revised), DC04 (replaces DC03)
- RU1.2 (user): <point> — rejected: <why>
- RU1.3 (agent): <point> — noted: <why no action>
- RU1.4 (user): <point> — planned → M3

## RU3: <short drift topic>

kind: fix
status: open
scope: drift

state: <drift summary from `fix/drift.md`>

- RU3.1 (agent): <drift finding> — open
- RU3.2 (user): <user edit> — open
```

Renumber log (`fix-activity`):

```markdown
## Renumber 1
- RD4 → RD3, DC07 → DC05
```
