# Reviews

`<slug>/reviews.md` (H1 `# Reviews`) is the agent-written record of review
cycles, created lazily. The user MAY edit the points of an `open` cycle. It
is not part of the handoff. Shape: `shapes/reviews.md`.

**Cycles and points.** Each review round is one `RU<n>` cycle (Review
Update). There are two kinds only: **regular** (default) and **fix**
(`kind: fix`); do not label cycles by any other source. Each item is a
point `RU<n>.<m> (agent|user)` with its outcome; the tag names who raised
it. A cycle MAY mix both tags or hold no points. `status: open | closed`;
at most one regular and one fix cycle are `open` at a time, and a cycle
without the line (legacy) is `closed`.

**Where points go** (regular cycle):

| Source | Open regular cycle exists | None open |
|---|---|---|
| `start-review` | refresh it | open a new one |
| chat feedback on activity files or built work | add `user` points; apply only via `apply-review` | new cycle, closed and applied this turn |
| `verify-plan` apply | add `agent` points; apply only via `apply-review` | new cycle, closed and applied this turn |
| `fix-activity` inline path | new closed cycle (user edits already in the files) | same |

**Fix cycle.** Only `fix-activity` opens one, on its fix-cycle path. It
holds only drift findings (`scope: drift`); other feedback
goes to the regular cycle. Refresh it by re-running `fix-activity`, never
`start-review`. It never reopens. **Fix first:** while a fix cycle is open,
`apply-review` applies it and the regular cycle waits, though the user MAY
still add points. **Recheck:** after a fix cycle closes, recheck each
`open` point of the regular cycle against the new state. Still valid →
stays `open`. Fixed → `noted: resolved by RU<k>.<m>`. No longer applies →
`noted: obsolete after RU<k>`. A changed `agent` point is rewritten; a
changed `user` point is asked about after the close and stays `open` until
answered.

**Edit while open.** The user adds, edits, or strikes points in
`reviews.md`, or states them in chat. A `start-review` refresh replaces
only `agent` points that are still `open`; it never touches `user` points.

**Reopen.** The user MAY add points to the last closed regular cycle when
no newer regular cycle exists (an open fix cycle does not block this), by
editing that cycle in `reviews.md` or by naming `RU<n>` in chat. Other chat
feedback follows the table above. The agent sets that cycle `open` again;
`apply-review` closes it and handles only the new `open` points.

**Scope** (`start-review` cycles) is recorded as `scope:`. The default is
the milestones checked after the newest earlier regular cycle with a
milestone `scope:` (none → all checked milestones), plus their joins with
earlier work. The user MAY name milestones (`start-review M2-M3`). In
`Planning`, `scope: plan`. A refresh rewrites `scope:` and `state:`.

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
| `DC<nn>` | Append a new `DC` with `replaces: DC<nn>` and `revised-by: RU<n>.<m>`. |
| `CONV<n>` | Rewrite in place; add `revised-by: RU<n>.<m>`. |
| `activity.md` section or milestone | Edit in place. A regressed milestone is unchecked with `regressed: <evidence>`. |
| Code, tests, docs | Review milestone (below). No IDs in shipped work. |

**Review milestone.** When a cycle needs product work (code, tests, docs),
append the milestone `Apply RU<n>` to `activity.md`; its MECE steps cite
the points. Notes-only edits need no milestone. **Material-change** still
applies: a point that changes Goal or Scope, or a material RD change after
`approve-plan`, needs the prompt.

**Journal.** Each cycle close, and each re-close after a reopen, appends one
`Review` event (**Journal policy**). A status change writes the resume
recap instead, citing `RU<n>`. Opening or refreshing writes no journal.

**Renumber log.** `fix-activity` appends `## Renumber <k>` with the old →
new ID map. Journal entries before it use the old numbers. `RU` IDs and
milestone numbers are never renumbered.
