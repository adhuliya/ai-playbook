# Review policy

Read this file before a review command.
Also read it before you record chat feedback on activity files or built work.
Index: [`SKILL.md`](SKILL.md).

## Reviews

`<slug>/reviews.md`, H1 `# Reviews`. Create lazily. Agent-written record;
the user MAY edit points of an `open` cycle. Shape: `templates.md`. Not part
of the handoff.

- **Cycle:** each review round is one `RU<n>` cycle (Review Update). Two
  kinds only: **regular** (default) and **fix** (`kind: fix`). Do not label
  cycles by any other source.
- **Point:** each item is `RU<n>.<m> (agent|user)` with its outcome. The tag
  names who raised it. A cycle MAY mix both, or hold no points.
- **Open / closed:** `status: open | closed`. At most one regular and one
  fix cycle are `open` at a time. Cycles without the line (legacy) are
  `closed`.
- **Where points go** (regular cycle):

  | Source | Open regular cycle exists | None open |
  |---|---|---|
  | `start-review` | refresh it | open a new one |
  | chat feedback on activity files or built work | add `user` points; apply only via `apply-review` | new cycle, closed and applied this turn |
  | `verify-plan` apply | add `agent` points; apply only via `apply-review` | new cycle, closed and applied this turn |
  | `fix-activity` inline path | new closed cycle (user edits already in the files) | same |

- **Fix cycle:** opened only by `fix-activity` on the fix-cycle path.
  Holds only drift findings; `scope: drift <synced>..HEAD`. Other feedback
  goes to the regular cycle. Refresh by re-running `fix-activity`, never
  `start-review`. Never reopens.
- **Fix first:** while a fix cycle is open, `apply-review` applies it, not
  the regular cycle. The regular cycle waits; the user MAY still add points.
- **Recheck:** after a fix cycle closes, recheck each `open` point of the
  regular cycle against the new state. Still valid → stays `open`. Fixed
  → `noted: resolved by RU<k>.<m>`. No longer applies → `noted: obsolete
  after RU<k>`. Changed `agent` point → rewrite it. Changed `user` point →
  ask after the close; it stays `open` until answered.
- **Edit while open:** the user adds, edits, or strikes points in
  `reviews.md`, or states them in chat. A `start-review` refresh replaces
  only `agent` points that are still `open`. It never touches `user`
  points.
- **Reopen:** the user MAY add points to the last closed regular cycle when
  no newer regular cycle exists (an open fix cycle does not block this).
  The user does it by editing that cycle in `reviews.md`, or by naming
  `RU<n>` in chat. Other chat feedback follows the table above.
  The agent sets that cycle `open` again. `apply-review` closes it and
  handles only the new `open` points.
- **Scope** (`start-review` cycles): records `scope:`. Default: milestones
  checked after the newest earlier regular cycle with a milestone `scope:`
  (none → all checked milestones), plus their joins with earlier work. The
  user MAY name milestones (`start-review 2-3`). In `Planning`: `scope:
  plan`. Refresh rewrites `scope:` and `state:`.
- **Authority:** the user approves every cycle in principle. A point MAY
  change a requirement, a design decision, a convention, or the
  implementation.
- **Where a change lands** (the target's own edit rule holds):

  | Target | Edit |
  |---|---|
  | `RD<n>` | Rewrite in place; add `revised-by: RU<n>.<m>`. |
  | `DC<nn>` | Append a new `DC` with `replaces: DC<nn>` and `revised-by: RU<n>.<m>`. |
  | `CONV<n>` | Rewrite in place; add `revised-by: RU<n>.<m>`. |
  | `activity.md` section or milestone | Edit in place. A regressed milestone is unchecked with `regressed: <evidence>`. |
  | Code, tests, docs | Review milestone (below). No IDs in shipped work. |

- **Material-change** still applies: a point that changes Goal or Scope, or a
  material RD change after `approve-plan`, needs the prompt.
- **State note:** open each cycle with status, milestone, and what changed
  since `RU<n-1>` (IDs added or changed, work built). One or two short
  paragraphs; deltas only. Earlier cycles hold the rest.
- Outcome: `applied → <IDs>` | `planned → milestone <k>` | `rejected:
  <why>` | `noted: <why no action>` | `open`. Name every changed ID.
  Product work is `planned` until its milestone is checked; the check is the
  proof. A cycle with no actionable points is valid: close it with each
  point `noted`, or with `- none`.
- **Review milestone:** if a cycle needs product work (code, tests, docs),
  append milestone `Apply RU<n>` to `activity.md`. Its MECE steps cite the
  points. Notes-only edits need no milestone.
- **Journal:** each cycle close (and each re-close after a reopen) appends
  one `Review` event (**Journal policy**). A status change writes the
  resume recap instead (cites `RU<n>`). Opening or refreshing writes no
  journal.
- **Renumber log:** `fix-activity` appends `## Renumber <k>` with the
  old → new ID map. Journal entries before it use the old numbers. `RU`
  IDs and milestone numbers are never renumbered.

## Apply timing

| Pipeline | Apply when |
|---|---|
| `verify-plan` | After the contract question gate. Never in the same turn as the first Read of `synthesis.md`. All / some / none. |
| `apply-review` | Target: the open fix cycle, else the open regular cycle. Restate its `open` points. Ask **only** gaps the points do not settle (one round), then stop; apply next turn after the answers, no new keyword. If no gaps, apply in this turn. Product work becomes a review milestone. |
| `start-review` | Never applies. Opens or refreshes the cycle only. |
| chat feedback | Open regular cycle → `user` points, applied by `apply-review`. None open → apply this turn (**Reviews** where points go). |

Planning order: `start-review` → `apply-review` (if the user wants the
points applied) → `verify-plan` → `approve-plan`. None of the middle steps
is required. After `Active`: `start-review` / `apply-review` only.
