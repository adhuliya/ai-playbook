# Index

Read this file only when a bold name in a loaded file has no owner among
the files you have read. A bold name points at a heading or a bold term in
its owner file. Read that file; do not restate it.

**Match rule.** A bold name opens the file with the same name, ignoring case
and reading a hyphen as a space. Every file ends in `.md`; the tables omit
the extension. For example, **Update cadence** opens
`policy/update-cadence.md`, **Milestone** opens `pipelines/milestone.md`, and
**Rules** matches no file name, so look it up below. When both
`policy/<name>.md` and `shapes/<name>.md` exist, open the policy file
unless the sentence says "shape". Then open `shapes/<name>.md`. Only names that differ
from their file name are listed.

## Root

- `always.md`: Commands, Stops, Keyword gate, Guide the user, Asking, Fewer
  prompts, Background sub-agents, launch kit
- `editing.md`: Editing the workon skill. `writing-style.md` and `repair.md`
  have no extra names.

## `policy/`

| File | Other names |
|---|---|
| `activity-md` | `agent-activity.md`, Milestones |
| `conventions` | Rules, Setup, Isolated setup |
| `design-choices` | Design Decisions |
| `engineering` | Engineering while focused |
| `ids` | IDs, Citing and reading by ID |
| `inflight` | Inflight pipelines |
| `journal` | Journal policy |
| `launch` | Prompt shape, Plan packet |
| `material-change` | Complete stay-on-slug, Complete sibling |
| `paths` | Paths and readiness |
| `paused-blocked` | Paused vs Blocked |
| `planning-quality-bar` | draft-check, Project-fit |
| `planning-stages` | File review |
| `references` | Cited context, MCP sources, Refresh |
| `reminders` | Optional-remind, strong model |
| `requirement-def` | RD, Problem header |
| `reviews` | Where points go, Agent notes, Fix cycle, Fix first, Recheck, Where a change lands, Review milestone, Renumber log |

## Other directories

- `commands/`: one file per keyword. Exceptions: **Details** is in `list.md`,
  **Command map** in `help-map.md`, **User away** in `user-away.md`.
  Keyword shares: `SKILL.md` step 3. `grill-me` is `policy/grill.md`.
- `pipelines/`: `verify-plan` (also **Question gate**), `review`, `milestone`,
  `comments`, `drift`.
- `shapes/`: the shape of each record, named for it.
- `briefs/`: one file per sub-agent role. Sub-agents read them; the parent
  does not.
