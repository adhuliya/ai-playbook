# Editing the workon skill

Read this before you change any file in this directory. It is for editors
of the skill; do not load it while you run an activity.

## Loading model

`SKILL.md` is the kernel: the harness loads it on every turn, so it holds
only rules that are true on every turn (How it works, How to read, Stops,
Keyword gate, Guide the user, Writing style). Every other rule reaches the
agent through `scripts/workon.sh`: `load <keyword>` prints a command
heading plus the sections its `Reads:` line names, and `section <name>`
prints one section. A rule the agent could miss on an ordinary turn
therefore belongs either in the kernel or in a section that the relevant
command's `Reads:` line names. Keep the kernel near its current size.

In `commands.md`, the `Reads:` line is one line, placed after the status
paragraph. Items are separated by `;` and are a file (`planning.md`), a
section in a named file (`templates.md#journal.md`), or a bare section
name resolved by search order (`lifecycle.md`, `records.md`,
`review-policy.md`, `planning.md`, `building.md`, `notes-files.md`,
`subagent-contract.md`, `templates.md`, `commands.md`, `SKILL.md`). A bare
name matches the first heading whose text starts with it, at any level, so
qualify a name that exists in two files. A check of one or two sentences
may stay inline in a command when loading a whole section would be the
only reason; `approve-plan` and `mark-completed` keep the e2e completion
rule for that reason.

## Where a change goes

| Change | File |
|---|---|
| Keyword steps, natural-language entry points, the command map (`help`) | `commands.md` |
| Status changes, gates, reminders, journal, update cadence, consistency check, session probe prose | `lifecycle.md` |
| Activity folder, `activity.md`, `synced` semantics, IDs, catalog, user guide, portability | `records.md` |
| Create, derive, replan, cited context | `planning.md` |
| RD, design decisions, conventions, legacy repair | `notes-files.md` |
| Review cycles and apply timing | `review-policy.md` |
| Test tiers, engineering, comment levels | `building.md` |
| Launch, prompt shape, inflight scratch, paths, parent reads, pipeline steps | `subagent-contract.md` |
| What one sub-agent role does, its rules, its output shape | `briefs/<role>.md` (`common.md` for all roles) |
| Record shapes | `templates.md` |
| Probe checks, snapshot and base mechanics, list, section extraction | `scripts/workon.sh` |

Two places must agree with the script: the **Session probe** prose
describes what `probe` checks and fixes, and **`activity.md`** describes
what `snapshot` and `base` do. Change the script and the prose together.

## Moving and naming

When you move a policy, add its names to the **Index**, then run `bash
.agents/skills/workon/scripts/workon.sh section "<name>"` for each bold
name you touched and confirm it resolves. Keep a bold name on one line so a
search finds it. A bold name in the kernel is a trigger, not a restatement:
it tells the agent when to load that section.

Keep every pipeline step, path row, ready marker, critic kind, weight, and
output-shape field; sub-agents read them from the briefs, so a missing
field is a behavior change. The parent never pastes brief text, so a rule
the parent needs stays in the contract and a rule a sub-agent needs stays
in its brief.

## Wording

Follow **Writing style** in `SKILL.md`. A shorter sentence that drops a
constraint is a behavior change; keep the old sentence when a cut would
make the order or the condition unclear.

## Before you finish

Run `load` for every heading in `commands.md` and confirm each `Reads:`
item resolves. Search for the old path or heading name you changed. Check
that `help all` still prints the command map from the `help` heading, and
that the `probe`, `snapshot`, `base`, and `list` sub-commands still run
against a sample activity. Measure `SKILL.md` when you add more than a few
lines.
