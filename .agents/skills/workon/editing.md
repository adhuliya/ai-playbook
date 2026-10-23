# Editing the workon skill

Read this before you change any file in this directory. It is for editors
of the skill; do not read it while you run an activity.

## Loading model

`SKILL.md` is the only file the harness loads. It stays a short intro plus
the reading guide. The Index of bold names lives in `index.md`, which the
agent reads only when a bold name has no owner among the files it read.
Every other rule lives in a small file that the agent reads on demand with
the Read tool, so a rule the agent could miss on an ordinary turn belongs in
a file that the relevant command's `Reads:` line names, or in `always.md`. There is no loader script; do not add one.

Each file holds one concept, so a read costs only what the turn needs. Put
a new rule in the file that owns its concept; start a new file when a
concept has no home. Keep `SKILL.md`, `always.md`, `writing-style.md`,
and `policy/session-start.md` near their current size: together they load
on every session (about 5.0k tokens in `o200k_base`).

Each file in `commands/` starts with `# \`keyword\``, a `Status:` paragraph,
and one `Reads:` line of paths relative to this folder, separated by
commas. List the policy, shape, and pipeline files the command needs
before its first step, and no others. A file that only a later step needs
(a shape, the launch kit, a pipeline) is named by that step, which says to
read it just before the step; do not put it on `Reads:`. A command whose
first steps may stop or run inline never lists the launch kit.

A check of one or two sentences may stay inline in a command when a new file
would be the only reason; `approve-plan` and `mark-completed`
keep the e2e completion rule for that reason.

## Where a change goes

| Change | File |
|---|---|
| Keyword steps, natural-language entry points | `commands/<keyword>.md` |
| The `help all` command map | `commands/help-map.md` |
| Rules that hold every turn: stops, keyword gate, guiding, asking, fewer prompts | `always.md` |
| A new bold name, or a moved one | `index.md` |
| Status changes, gates, reminders, journal, update cadence, consistency check, session start | `policy/` (one file per concept) |
| Activity folder, `agent-activity.md`, IDs, catalog, guide for users, portability, references, plan outline | `policy/` |
| Create, derive, replan, planning stages, cited context, activity kind | `policy/` (`activity-kind.md` for thin vs full) |
| Review cycles and apply timing | `policy/reviews.md`, `policy/apply-timing.md` |
| Test tiers, engineering, comment levels | `policy/test-evidence.md`, `policy/engineering.md`, `policy/comments.md` |
| Launch, prompt shape, inflight scratch, paths, parent reads | `policy/launch.md`, `inflight.md`, `paths.md`, `parent-reads.md` |
| Pipeline steps | `pipelines/<name>.md` |
| What one sub-agent role does, its rules, its output shape | `briefs/<role>.md` (`common.md` for all roles) |
| Record shapes | `shapes/<record>.md` |
| Old layouts and their fixes | `repair.md`, plus the marker scan in `policy/session-start.md` |

Two places must agree: the marker scan in `policy/session-start.md` and the
fixes in `repair.md`. Change both together.

## Moving and naming

When you move a policy, update the Index in `index.md` and every
`Reads:` line that names the file. Name a file for its main bold name, so
the match rule in `index.md` finds it; list a name there only when it
differs from the file name. Keep a bold name on one line so a search
finds it. A bold name in the kernel is a trigger, not a restatement: it
tells the agent when to read that file.

Keep every pipeline step, path row, ready marker, critic kind, weight, and
output-shape field; sub-agents read them from the briefs, so a missing
field is a behavior change. The parent never pastes brief text, so a rule
the parent needs stays in `policy/` or `pipelines/` and a rule a sub-agent
needs stays in its brief.

## Wording

Follow `writing-style.md`. A shorter sentence that drops a constraint is a
behavior change; keep the old sentence when a cut would make the order or
the condition unclear.

## Before you finish

Check every path on every `Reads:` line exists. Search for old paths and
names (`scripts/`, `templates.md`, `commands.md`, `lifecycle.md`,
`synced`, `user-guide`). Old record names (`activity.md`, `journal.md`,
`plan-outline.md`, `requirement-def.md`, `design.md`, `design-choices.md`, and a root
`guide-for-users.md`) may appear only as legacy markers in `repair.md`,
`policy/session-start.md`, and this list. Check that each bold name resolves through the
Index in `index.md`. Check that `help all` still prints the command map.
Run the session-start command from `policy/session-start.md` against a
sample activity. Measure `SKILL.md`, `always.md`, and the touched files with
the `o200k_base` tokenizer when you add more than a few lines.
