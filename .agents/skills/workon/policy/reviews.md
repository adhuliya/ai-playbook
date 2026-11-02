# Reviews

`<slug>/reviews.md` (H1 `# Reviews`) is the agent-written record of review
cycles, created lazily. The user MAY edit the points of an `open` cycle. It
is not part of the handoff. Shape: `shapes/reviews.md`.

**Cycles and points.** Each review round is one `RU<n>` cycle (Review
Update). There are two kinds only: **regular** (default) and **fix**
(`kind: fix`); do not label cycles by any other source. Each item is a
point `RU<n>.<m> (agent|agent-review|user)` with its outcome. The tag names
who raised it. `(agent-review)` means the `agent-review` command found it.
`(agent)` means a fix cycle. `(user)` means the user. A
cycle MAY mix these tags or hold no points. `status: open | closed`;
at most one regular and one fix cycle are `open` at a time, and a cycle
without the line (legacy) is `closed`.

**Where points go** (regular cycle):

| Source | Open regular cycle exists | None open |
|---|---|---|
| `start-review` | refresh it for user points; launch nothing | open a new one for user points |
| `agent-review` in `Planning` | add `(agent-review)` points; apply only via `apply-review` | new cycle, closed and applied this turn |
| `agent-review` otherwise | add `(agent-review)` points; do not apply | open a new one, then add them; do not apply |
| chat feedback on activity files or built work | follow **Agent notes**; do not open a cycle | same |
| `fix-activity` inline path | new closed cycle (user edits already in the files) | same |

A same-turn apply that would add or uncheck a milestone while the status
is `Complete` does not apply that change. Leave those points `open`.
The cycle that holds them stays `open`. Do not close it this turn.
Prompt `apply-review`.

**Agent notes.** `artifacts/agent-notes.md` is parent scratch for the current work. Sub-agents do not read or write it. Create the file on the first note. Its H1 is `# Agent notes`. The handoff does not include it (**Portability**).

Write `working: <point>` for a passing note the current work still needs, or for an unanswered grill question. Also write it for an important fleeting note that has no home yet in RD, Design Decisions, design, Conventions, or the plan. Promote that note into its home when the home is clear, then remove the line. Do not use this file as a second requirements or design log. Do not record a grill question as a review point. Write `deferred: <point>` for a review or replan point the user did not take. Do not copy an in-place edit into this file. Read the file when you resume the activity.

A chat note does not open a regular cycle. `start-review` opens or refreshes one for user points and launches no critics. `agent-review` runs only when the user types it. Do not offer it. Where its points go is the table above. When a note should be a review point or a replan, suggest the keyword for this status. In flight: `start-review` or `replan-work`. On `Complete`: `start-review` for a bug fix or other minor in-scope point, or `resume-work` / `create-sibling` per **Material-change**. Never suggest `replan-work` on `Complete`. If the user keeps working, append a `deferred` line. Do not apply that note. If the user agrees to add the note to an open regular cycle, append the `user` point. Do not write a `deferred` line for it.

On `thin`, with the same Goal, update the records in place. This includes a requirement, a constraint, or a design note. Say that the note stays on this activity. On full `Planning`, update detail in place when it does not add, drop, or reword an RD. These edits open no cycle.

A Goal or Scope rewrite is a **Material-change**. A material RD change after approval is a **Material-change**. Do not park that note in this file.

`agent-review` opens or joins a regular cycle only when the user types it. `fix-activity` still opens its own cycle when the user types it. A fix cycle does not take these notes. `fix-activity` leaves this file.

Before recording points, `start-review`, `agent-review`, `replan-work`, and a regular `apply-review` read this file. Copy each `deferred` line into that pass, then remove the line. The agent keeps or removes a `working` line as the current work needs. A pass that copies `deferred` lines leaves the `working` lines the agent still needs. Delete the file when no line remains. Leave a `deferred` line when the command stops without recording it.

`start-review` copies each `deferred` line onto the cycle as a `user` point. It does not apply the point. `agent-review` does the same, then adds its own `(agent-review)` points. Outside `Planning` it does not apply. In `Planning`, a `- none` synthesis leaves this file. `replan-work` takes each `deferred` line that still fits the rewrite. `apply-review` copies each `deferred` line onto the open regular cycle before its other points. When the target is the fix cycle, leave this file.

**Fix cycle.** Only `fix-activity` opens one, on its fix-cycle path. It
holds only drift findings (`scope: drift`). Other feedback follows
**Agent notes**. Refresh it by re-running `fix-activity`, never
`start-review`. It never reopens. **Fix first:** while a fix cycle is open,
`apply-review` applies it and the regular cycle waits, though the user MAY
still add points. **Recheck:** after a fix cycle closes, recheck each
`open` point of the regular cycle against the new state. Still valid →
stays `open`. Fixed → `noted: resolved by RU<k>.<m>`. No longer applies →
`noted: obsolete after RU<k>`. A changed `agent` point is rewritten; a
changed `user` point is asked about after the close and stays `open` until
answered.

**Edit while open.** The user adds, edits, or strikes points in
`reviews.md`. A point stated in chat follows **Agent notes**. A `start-review`
refresh records user points and does not replace `(agent-review)` points.
`agent-review` replaces `open` `(agent-review)` points only. Neither
command changes a `user` point.

**Reopen.** The user MAY add points to the last closed regular cycle when
no newer regular cycle exists (an open fix cycle does not block this), by
editing that cycle in `reviews.md` or by naming `RU<n>` in chat. Other chat
feedback follows the table above. The agent sets that cycle `open` again;
`apply-review` closes it and handles only the new `open` points.

**Scope** (`start-review`) is recorded as `scope:`. The default is
the milestones checked after the newest earlier regular cycle with a
milestone `scope:` (none → all checked milestones), plus their joins with
earlier work. The user MAY name milestones (`start-review M2-M3`). In
`Planning`, `scope: plan`. A refresh rewrites `state:`. It rewrites
`scope:` only when the cycle has no `(agent-review)` point. This scope is
the user's review. It does not launch critics.

**Scope** (`agent-review`). Keep a milestone `scope:` that `start-review`
already wrote. Do not widen it unless the user names a wider depth. Add
joins only when the `start-review` scope rules already include them. When
`agent-review` opens the cycle and no milestone scope is set yet, set a new
scope. The depth menu in `commands/agent-review.md` sets that scope before
launch. Record the kept scope or the new scope on the cycle. Each milestone
in scope is checked against the requirements and the design it implements.
A re-run replaces `open` `(agent-review)` points only. In `Planning`,
`scope: plan` is the whole plan, and the pass reviews the chosen depth.
With no open regular cycle, accepted points are applied after all / some /
none. An open cycle waits for `apply-review`.

**State note.** Each cycle opens with status, milestone, and what changed
since `RU<n-1>` (IDs added or changed, work built), in one or two short
paragraphs of deltas only; earlier cycles hold the rest.

**Authority and outcomes.** The user approves every cycle in principle. A
point MAY change a requirement, a design decision, a convention, or the
implementation. Each point ends with an outcome: `applied → <IDs>` |
`planned → M<k>` | `rejected: <why>` | `noted: <why no action>` |
`open`. Name every changed ID. Product work is `planned` until its
milestone is checked; the check is the proof. A cycle with no actionable
points is valid: close it with each point `noted`, or with `- none`.

**Where a change lands** (the target's own edit rule holds):

| Target | Edit |
|---|---|
| `RD<n>` | Rewrite in place; add `revised-by: RU<n>.<m>`. |
| `DD<n>` | Rewrite in place. When the choice changes, append a new `DC` and point `cites:` at it. |
| `DC<nn>` | Append a new `DC` with `replaces: DC<nn>` and `revised-by: RU<n>.<m>`. |
| `CONV<n>` | Rewrite in place; add `revised-by: RU<n>.<m>`. |
| `agent-activity.md` section or milestone | Edit an unchecked milestone in place. Leave a checked milestone as written. A replaced aspect gets `Superseded by: M<k> — <aspect>`. |
| Code, tests, docs | Append a review milestone (below). No IDs in shipped work. |

**Review milestone.** A cycle that needs code, tests, docs, or a correction
to work a checked milestone already finished appends one milestone,
`Apply RU<n>`. Do not rewrite a checked milestone, and do not uncheck it.
An unchecked milestone may be adjusted. A notes-only cycle appends no
milestone. The appended milestone keeps the history of earlier milestones
intact.

Its paragraph says what the correction does and which parts of the
project tree it touches. Its `reads:` line lists the `RD` and `DD` the
product work implements, and its steps cite the points. Its test cases
are the completion check (**Test evidence**). A point that adds a test case adds it to the matching `TC<n>`
in `spec-design.md`'s Test Plan and Traceability, tagged
`(planned for M<n>)` (**Design document**, **IDs**).

When the point revises an `RD` or a `DC` that a checked milestone already
implemented, leave that milestone. Rewrite the `RD` in place, or append the
new `DC`, as the rows above say. The appended milestone brings the product
in line with the revision. When the new milestone replaces an aspect, add
`Superseded by: M<k> — <aspect>` on the checked milestone. The field names
the aspect and the milestone that replaces it.

When the e2e milestone is already checked, still append the new milestone
after it. The new milestone runs that e2e command before it can be checked,
unless the user says not to. Record that waiver on the new milestone. Do
not edit the checked e2e milestone.

**Material-change** still applies: a point that changes Goal or Scope, or a
material RD change after `approve-plan`, needs the prompt. Apply the other
open points. Leave that point `open`. When `replan-work`, a stay-on-slug
reopen, or `create-sibling` has covered it, the next `apply-review` marks it
`noted: covered` or `applied → <IDs>`.

**Journal.** Each cycle close, and each re-close after a reopen, appends one
`Review` event (**Journal policy**). A status change writes the resume
recap instead, citing `RU<n>`. Opening or refreshing writes no journal.

**Renumber log.** `fix-activity` appends `## Renumber <k>` with the old →
new ID map. Journal entries before it use the old numbers. `RU` IDs and
milestone numbers are never renumbered.
