# Journal policy

`<slug>/journal.md` is the append-only event timeline. `activity.md` holds
current state and `reviews.md` holds review detail; the journal records
each event that changes direction or status: what happened, why, and
pointers (IDs, paths, commands). A fresh agent reads it to learn how the
activity got here. Shapes: `shapes/journal.md`.

Write one entry per event, in the same turn:

| Event | Written by |
|---|---|
| `Created` | create, `create-sibling` (in the new activity), `import-activity` |
| `Requirements` | `requirements-ok` |
| `Approved` / `Building` | `approve-plan` / `start-building` |
| `Milestone` | checkpoint that checks a milestone |
| `Review` | every `RU<n>` cycle close, whatever the source (`apply-review`, chat feedback, `verify-plan`, `fix-activity` inline) |
| `Replan` | `replan-work` |
| `Blocked` | entering `Blocked` |
| `Pause` / `Resume` | `pause-work` / status change by `resume-work`, or `apply-review` reopening `Complete` (the recap replaces the `Review` event and cites `RU<n>`) |
| `Complete` | `mark-completed` |
| `Renumber` | `fix-activity` renumber |

No other change writes the journal: notes edits, **Consistency check**,
`update-convention`, `conventions-ok`, `start-review` (opening or
refreshing a cycle), `add-review-comments`, `remove-review-comments`,
`create-guide`, `detailed-design`, `delete-tmp-files`, list, details, `help`.

An entry is `## <Event>: <short title> (<from> → <to>)`; omit the arrow when
the status is unchanged. Then at most three bullets: what happened, IDs /
paths / evidence command, and `next:` when not obvious. Point at IDs; do
not copy RD, plans, or review points. No dates unless asked; entry order is
the timeline. A pause or resume recap stays within ~10 lines and omits
empty fields. `Complete` is the one thick entry: a project-work write-up of
what shipped, paths, decisions, and gaps, not a lifecycle novel.

Append at the end. Prior entries are read-only except through
`compact-journal`, the only rewrite.
