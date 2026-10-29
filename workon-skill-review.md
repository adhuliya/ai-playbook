# workon skill review

Handoff for a later session. The skill lives in `.agents/skills/workon/`.
Edits from this review are **uncommitted** on `main`. Do not commit unless
asked.

Date of the review: 2026-10-29.

## How to resume

1. Read this file, then `.agents/skills/workon/editing.md` and
   `writing-style.md`, before any further edit.
2. Read the **Questions** section. Apply only the answers that are filled
   in. Leave a question alone when its Answer line is still blank.
3. Do not reopen an item under **Applied** or **Rejected** unless an
   Answer overturns it.
4. Finish the checks under **Still to verify**.
5. A shorter sentence that drops a constraint is a behavior change. Keep
   pipeline steps, path rows, ready markers, critic kinds, weights, and
   output-shape fields. Do not add a loader script, a new status, or a
   new keyword.

## What the user asked for

1. Use sub-agents on the whole skill. Look for rough phase transitions,
   usability, ambiguous spec, and safe token cuts.
2. The user should always know where the activity is and what to type next.
3. Split the review by focus. A synthesizer collates. The main agent
   checks before editing.
4. Grill before a change when a real decision remains.
5. `pause-work` must work while a pipeline is in flight
   (`artifacts/inflight.md` exists), and `resume-work` must be safe.

Requirement 5 is implemented. See **Pause and resume, as implemented**.

## How the review was run

Four read-only reviewers each read the whole skill, with one lens:

| Lens | What they owned |
|---|---|
| Phase transitions | Status path, next keyword, “you are here” |
| Pause and inflight | Requirement 5, plus other pause/resume bugs |
| Ambiguity | Two files that can make an agent do two different things |
| Usability and tokens | Next-keyword friction, and cuts that keep every constraint |

A synthesizer merged them. The main agent checked the gate-skip and the
pause refusal in the files, then edited. Six behavior forks were not
edited. They are the questions below.

## Questions

Fill the Answer line. Recommended option is marked.

### Q1. Where does a Planning chat note land?

Asked in chat. The user said they will answer later. No answer recorded.

Today, `commands/feedback.md` updates a Planning note in place only when
it “only adds detail”. The reviews table sends every chat note to `user`
points. `policy/activity-kind.md` updates a thin same-Goal note in place
when it adds a requirement, a constraint, or a design note. That sentence
was not edited.

- **a (recommended).** Thin, same Goal, including a new requirement,
  constraint, or design note: update in place, open no cycle. Full
  Planning: update in place only for detail that does not add, drop, or
  reword an `RD`. Anything else follows the reviews table. A Goal or
  Scope rewrite still stops for **Material-change**.
- **b.** Every Planning note updates in place and opens no cycle.
- **c.** Every chat note goes through the reviews table, including thin
  Planning notes on the same Goal.

Hold until answered: `commands/feedback.md`, the “where points go” rows
in `policy/reviews.md`, the file-review sentence in
`policy/planning-stages.md`, and the thin chat-note sentence in
`policy/activity-kind.md`.

Answer: a. A regular cycle opens only when the user types `start-review`. A thin same-Goal note, including a new requirement, constraint, or design note, updates the records in place. Full `Planning` updates detail in place only when it does not add, drop, or reword an RD. Anything else is suggested as `start-review` or `replan-work`. If the user keeps working, that point is a `deferred:` line in `artifacts/agent-notes.md`. The same file holds `working:` lines that help finish the current work. `start-review`, `replan-work`, `verify-plan`, and a regular `apply-review` pick up `deferred:` lines and remove them. The agent keeps or removes a `working:` line as the current work needs. `verify-plan` and `fix-activity` still open their own cycles when the user types them. A Goal or Scope rewrite still stops for **Material-change**.

### Q2. On comments abandon, restore `comments/before/`?

An in-flight `add-review-comments` or `remove-review-comments` run copies
files to `comments/before/<path>` so a `fail` can restore them. Abandon
today only deletes `inflight.md`. Editors may already have changed
comments. A later re-run snapshots that half-applied tree. Milestone
code has no snapshot. Do not invent a rollback for it.

- **a (recommended).** On abandon of a comments pipeline, restore every
  snapshotted file, the same way `commands/review-comments.md` restores
  on `fail`. Do not set the `review-comments` row. Warn that a
  still-running editor may write again.
- **b.** Leave the working tree. Delete `inflight.md` and only warn.

Hold until answered: the abandon paragraph in `policy/inflight.md`. The
rest of pause/resume is already written and does not restore snapshots.

Answer: a. On abandon of a comments pipeline, restore every `comments/before/<path>` file. Do not set `review-comments`. Warn that a still-running editor may write again.

### Q3. What does Stop mean when a command says the next message resumes it?

`always.md` says the word Stop ends the command and the turn.
`apply-review`, `start-review`, `mark-completed`, and `fix-activity` say
a later `yes`, `defer`, `scan`, `inline`, or `stop` resumes that command
with no new keyword. Those words are not reserved keywords.

- **a (recommended).** Stop always ends the turn. It ends the command
  unless that command says the next message resumes it. Keep every
  resumption sentence.
- **b.** Stop always ends the command. Those files must name a reserved
  keyword for the next turn.

Hold until answered: the Stop sentence in `always.md`. The inflight
exception in that file is already edited. Do not rewrite it while
changing the Stop sentence.

Answer: a. Stop ends the turn. It ends the command unless that command says the next message resumes it. The resumption sentences stay.

### Q4. What counts as major drift?

`commands/fix-activity.md` introduces major drift as “new repo,
restructured tree, drastic early changes”. The terms line says major
drift is whatever `drift.md` marks `major: yes`. `briefs/drift-scanner.md`
sets `major: yes` when scope is `all` and any milestone is checked, and
also on real damage (failed setup or test, many missing paths, layout
change, missing `base-branch`). A clean `all` scan can still force the
fix-cycle gate.

- **a (recommended).** Major means damage only: missing `base-branch`,
  failed Setup or test, many missing paths, or a layout change. A clean
  `all` scan with checked milestones is not major.
- **b.** Keep “`all` plus any checked milestone” as `major: yes`.

Hold until answered: the major triggers in `briefs/drift-scanner.md`,
and the fix-activity definition and route. The turn-order wording in
`commands/fix-activity.md` was already edited. Do not change what
`major: yes` means until this is answered.

Answer: a. Major drift is damage only: missing `base-branch`, a failed Setup or test, many missing paths, or a layout change. A clean `all` scan is not major. Resync asks whether the user is aware of manual changes. A finding that changes an RD, a DD, a DC, a CONV rule, Setup, a Current Design invariant, or a Background fact is plan-impacting and takes the fix-cycle path so the activity files match the repo.

### Q5. Do `superseded` milestones get the same exemptions as `removed`?

Replan, `make-full`, and a Complete reopen mark removed work
`superseded`. A `fix-activity` prune uses `M<n>: removed: <why>`, which
is the only tombstone in `shapes/activity.md`. The outline drops
`removed` and does not mention `superseded`. The consistency check
excuses `removed` from a missing `reads:` line and does not excuse
`superseded`.

- **a (recommended).** Same outline drop and same `reads:` exemption for
  both. `removed` stays the prune stub. `superseded` stays the
  scope-drop marker.
- **b.** Only `removed` drops out of the outline and skips `reads:`.

Hold until answered: `policy/plan-outline.md`, and the `reads:`
exemption in `policy/consistency-check.md` and `policy/activity-md.md`.
Do not change the words `removed` and `superseded` elsewhere.

Answer: a. A `removed` milestone and a `superseded` milestone both drop out of the plan outline and both skip `reads:`. `removed` stays the prune stub. `superseded` stays the scope-drop marker.

### Q6. When must a thin plan name the end-to-end command, or an explicit drop?

Thin planning says do not invent test tiers, and keep the test plan to
checks the user named. `policy/test-evidence.md` says plan every tier,
and the last milestone needs a named runnable end-to-end command unless
the user drops it in `agent-activity.md`. `mark-completed` enforces that
name and has no thin exception. `approve-plan` checks it for full.

- **a (recommended).** Require the name, or an explicit drop, while the
  thin plan is written. Still do not invent unit or integration cases.
- **b.** Leave the requirement at `mark-completed` only. Full still
  checks at `approve-plan`.

Hold until answered: do not add an end-to-end gate to thin planning,
`policy/activity-kind.md`, or `policy/test-evidence.md`. The existing
`approve-plan` and `mark-completed` sentences stay.

Answer: a. While a thin plan is written, name the runnable e2e command, or record the user's drop in `agent-activity.md`. Do not invent unit or integration cases. The `approve-plan` and `mark-completed` sentences stay.

### Q7. How should a test that cannot run be recorded?

Not edited, except the collator half below.

Milestone workers report `done | partial | blocked`. The collator reports
`pass | fail | conflict`. The milestone pipeline only branches on `fail`
and `conflict`. **Applied:** `briefs/collator.md` now says a job
`partial` or `blocked` is collator `fail`, and `conflict` is only for
joins that disagree. The milestone is not checked.

Review tests report `pass | fail | blocked`. The review report line is
`M<n>: pass | fail | skipped`. A `blocked` test file still counts as
ready, so critics can launch. Nothing maps `blocked` onto the report.

- **a (recommended).** Store `blocked` on the report line. Do not treat
  it as passed or skipped. This adds a result token. `editing.md` says
  to keep output-shape fields, so this is a real behavior change.
- **b.** Map test `blocked` to report `fail`. No new token. It looks
  like a product defect.
- **c.** Map test `blocked` to report `skipped`. No new token. A skipped
  milestone can be dropped from the review.

Hold until answered: `briefs/test.md`, `briefs/synthesizer.md`, and the
report line those files define. Leave the collator mapping as it is
unless this answer says to undo it.

Answer: a. The review report line is `M<n>: pass | fail | blocked | skipped`. A test `blocked` stays `blocked`. The collator mapping is unchanged.

## Pause and resume, as implemented

This is requirement 5. Home of the procedure: `policy/inflight.md`.
`always.md` only has the every-turn exception.

`pause-work` from `Planning`, `Approved`, or `Active` sets `Paused` with
`prior:` even when `artifacts/inflight.md` exists. It does not delete or
rewrite `inflight.md`. It does not kill sub-agents. They may keep writing
their assigned outputs. They still must not write activity files or
`inflight.md`.

While inflight, pause writes only status, `prior:`, the resume block, and
one Pause journal recap. `# Next Steps` keeps `In progress: <pipeline>
<unit>`. The resume block’s next keyword is `resume-work`. Pause does not
sync RD, Design Decisions, Conventions, or `spec-design.md`, and it does
not remind `apply-review`. Outside inflight, the old sync remains.

While `Paused`, a sub-agent return does not finish the unit. It does not
check a milestone, record points, enter the question gate, or delete
`inflight.md`. The user is prompted `resume-work`. Each parent end step
says the same thing. `Blocked` still cannot start a pause.

`resume-work` still waits for an explicit confirm. On `Blocked`, the
confirm is that the blocker is resolved. Then it restores `prior:` and
appends the Resume recap.

Finish the open unit only when **this chat** has a completion notice for
**this launch’s** final file (`policy/paths.md`: Ready is a completion
notice, or a ready marker on disk). A ready marker alone is not enough.
A previous run can leave one, and a new chat has no notice. On a safe
finish, run only the existing parent end step. Do not relaunch. Follow
**Continue mode** only when the status is `Active` and `inflight.md` is
gone.

With no notice, or in a new chat, do not read the final file and do not
follow Continue mode. Waiting works only in the chat that launched the
pipeline. If the user abandons, name the re-run keyword and do not launch
it in that turn. `auto` does not start work on that turn.

Abandon still deletes `inflight.md`, leaves status unchanged (so `Paused`
stays until `resume-work`), leaves an unchecked milestone unchecked, and
does not roll back product code. It refreshes `# Next Steps` to the
re-run keyword. An open review cycle stays open. Abandon does not
unpause. On a comments abandon, every `comments/before/<path>` file is restored. `review-comments` stays unchanged.

Re-run keywords: `verify-plan`; `start-review`; `fix-activity`; the
comment command named in `unit:`; an unchecked `M<n>` names `continue`.

Also landed with this design:

- Pause and resume use one next-keyword rule. An open question blocks
  `requirements-ok`, `approve-plan`, and `start-building` in every stage.
  An unfinished requirement is repeated for any kind and blocks
  `start-building`. `requirements-ok` only when `stage` is `requirements`,
  no branch is open, and RD looks complete. `Active` with `continue: auto`
  writes `continue: auto` in the pause block.
- The journal resume shape has both `Paused → <prior>` and
  `Blocked → <prior>`. A Complete reopen `next:` is the exit keyword.
- A missing `prior:` on thin offers `Planning` or `Active` only. Full
  still offers `Planning`, `Approved`, or `Active`.
- `help` does not start work when `continue` is `auto`. The in-flight
  help row offers `pause-work`, wait, or abandon.

## Applied

These are in the working tree. The finding ids are from the review
(A phase, B pause, C consistency, D usability).

### Gates and the next keyword

- **A F1, C F2.** `commands/start-building.md` no longer sets `Active`
  from full `Planning`. Requirements plus thin prompts `make-full` and
  does not flip `kind`. Requirements plus full prompts `requirements-ok`.
  Full and not `Approved` prompts `approve-plan`. Full and
  `conventions: pending` prompts `conventions-ok`. Only then `Active`.
  Thin design still goes `Planning` → `Active`, and `pending` does not
  block. `policy/execution-gate.md` matches that. `commands/help-map.md`
  says full `Planning` is refused.
- **C F3.** `policy/planning-stages.md` no longer says to silently set
  `kind: full` on a thin `stage: requirements` record. Prompt
  `make-full`. The requirements help row says the same. This was a
  fork. It was applied because a silent flip skipped the requirements
  half of the quality bar, and `requirements-ok` already refused thin.
  Overturn by answering in Q1’s neighborhood only if you want the silent
  flip back. Say so under Overturn below.
- **A F3.** `commands/conventions-ok.md` branches the closing prompt.
  Requirements plus thin → `make-full`. Requirements plus full →
  `requirements-ok`. Full design `Planning` → `approve-plan`.
  `Approved`, or thin design `Planning` → `start-building`.
- **A F6, D F6.** `commands/verify-plan.md` does not launch during
  `stage: requirements` (thin → `make-full`, full → `requirements-ok`).
  Design stage still ends at `apply-review` or `approve-plan`. The
  restated pipeline prose was cut. The first-Read delete ban stayed.
- **A F2, D F1.** `help intro` names `start-building` on the full path,
  after `approve-plan` and `yes` when conventions are offered.
  Requirements first is `make-full` when thin, else `requirements-ok`.
- **A F4, D F4.** `commands/import-activity.md` keeps an imported
  `stage: requirements`. It does not flip `kind`. After the write it
  prompts `resume-work`, `make-full`, `requirements-ok`, `approve-plan`,
  or `start-building`. It no longer says only “wait for the Execution
  gate”. `policy/planning-stages.md` matches the import stage rule.
- **A F5.** A Complete reopen leads `# Next Steps` with the exit keyword
  (`policy/activity-md.md`, `commands/resume-work.md`,
  `commands/apply-review.md`, `shapes/journal.md`). `apply-review` points
  at resume-work Complete step 6, not only “Execution gate”.
- **C F7, narrowed.** A same-turn apply that would add or uncheck a
  milestone while `Complete` leaves those points `open`, keeps that
  cycle `open`, and prompts `apply-review`. `commands/fix-activity.md`
  step 6 does not put those points in the closed cycle. Other confirmed
  items can still close their own cycle.
- **A F7.** `commands/create-sibling.md` announces the sibling’s status
  and keyword before switching back to the parent for `replan-work`.
- **A F8.** `commands/make-full.md`: already `full` says so and stops,
  including on `Complete`. Thin `Complete` prompts `resume-work` and
  does not upgrade yet. After that reopen, `resume-work` prompts
  `make-full` instead of `start-building`.
- **A F9.** The Active help row no longer starts work on the help turn
  when `continue` is `auto`. `commands/continue-mode.md` agrees, and
  also refuses to auto-start while `inflight.md` exists.
- **A F10, B F4.** The pause block writes `continue: auto` instead of
  leaving the next keyword blank.
- **A F11.** `commands/mark-completed.md`: `# Next Steps` item 1 is
  `resume-work`, then the minor-fix runway. This turn, a missing
  `artifacts/guide-for-users.md` makes the keyword `create-guide`.
  Otherwise the status is `Complete` and `resume-work` is the way back.
  The Complete help row matches. No stale-guide check was added.
- **D F5.** `help <command>` uses the shared file named in `SKILL.md`
  step 3. `grill-me` is `policy/grill.md`. `index.md` says so.
- **D F10.** `commands/fix-activity.md` turn order names `scan` /
  `inline` / `stop` and `review` / `inline` / `stop` up front. The two
  gates were not merged.

### Consistency that did not need a product fork

- **C F9.** `pipelines/review.md` step 2 on env `blocked` does not launch
  tests or critics. The parent goes to the record step, which writes
  `- none (env blocked)` and deletes `inflight.md`, unless status is
  `Paused`.
- **C F10, collator half only.** See Q7. Worker `partial` or `blocked`
  becomes collator `fail`.
- **C F11.** `commands/list.md` and `policy/session-start.md` use
  `head -n 15`, so the `notes` row (`prior:`, blocker) is in the
  preview. The shape’s `notes` row is line 15 when the blank line after
  the title is present. `policy/activity-md.md` and `shapes/activity.md`
  no longer say the table is ~10 lines.
- **C F12.** `index.md`: when both `policy/<name>.md` and
  `shapes/<name>.md` exist, open the policy unless the sentence says
  “shape”. There is no `**Plan summary**` bold name in the skill. Do
  not add one.
- **D F8.** `policy/engineering.md` cites **Rules**. The precedence
  paragraph now sits under that bold name in `policy/conventions.md`.
  `shapes/notes-files.md` points precedence at **Rules**.
  `conventions.md` was not added to `start-building` Reads.
- **D F2, D F3.** `policy/activity-kind.md` no longer repeats “show the
  outline and prompt `start-building`” or the make-full keyword list.
  Those live in `policy/create-sequence.md` step 4 and
  `commands/make-full.md`. “Status stays `Planning` until
  `start-building`” stayed. “Keep code already written” stayed.

### Token cuts that landed

Only cuts inside files this pass already had to edit:

- `commands/verify-plan.md` no longer restates the pipeline. It keeps
  delete timing, the first-Read ban, and “record per Reviews”.
- `policy/activity-kind.md` dropped the duplicated thin prompt and the
  duplicated make-full grill sentence.

Not cut, on purpose: end-to-end sentences, the pause/resume keyword
lists, the execution-gate convention reset, the thin grill skip, the
quality-bar prompts, the session-start/repair pair, critic fields,
pipeline steps, and the activity-file ban lists.

## Rejected for this pass

Do not redo these unless the user asks.

- The narrower start-building fix that only checked full `Planning`.
  The applied guard also covers requirements stage and `conventions:
  pending`.
- “Apply nothing this turn” for every Complete review. Other points
  still follow `apply-review` step 2. Only the milestone add/uncheck
  stays open.
- Adding `blocked` as a collator or report token without Q7. The
  collator mapping onto existing `fail` did land.
- A `**Plan summary**` index entry. That bold name is not in the skill.
- `commands/create.md` Reads trim (about seven policies the grill does
  not need yet). Token-only. `create.md` was not otherwise edited.
- Deleting `writing-style.md` lines 28–30 (the vague “clear, readable
  style” sentence). Token-only. That file was not otherwise edited.
- Dropping the extra confirm inside `resume-work`. Step 3 still
  requires it. On `Blocked`, the user confirms the blocker is resolved.
- Reopening transitions the reviewers marked as already smooth: thin
  create → `start-building`; `requirements-ok` sets design and prompts
  `approve-plan`; `approve-plan` refuses the requirements stage; thin
  skips `Approved`; Complete reopen goes to `Planning`, never `Active`;
  no critic pair on a milestone; `verify-plan` inflight delete timing;
  `AC`/`TC` share the `RD` number; `reads:` is `RD` and `DD`.

## Overturn

Applied choices a later session should undo only if you say so. Leave
blank to keep them.

- Thin `stage: requirements` prompts `make-full` and does not flip
  `kind`. Overturn:

- `create-sibling` announces the sibling, then switches to the parent
  for `replan-work`. Overturn:

- `make-full` on thin `Complete` prompts `resume-work`, and that reopen
  then prompts `make-full`. Overturn:

- On `mark-completed`, a missing guide makes this turn’s keyword
  `create-guide`. Otherwise `resume-work` is the way back, and it is
  item 1 of `# Next Steps`. Overturn:

- Worker `partial` or `blocked` is collator `fail`. Overturn:

## Files touched

All under `.agents/skills/workon/`. 40 files, uncommitted.

`always.md`, `index.md`, `briefs/collator.md`,
`commands/apply-review.md`, `commands/continue-mode.md`,
`commands/conventions-ok.md`, `commands/create-sibling.md`,
`commands/fix-activity.md`, `commands/help.md`, `commands/help-map.md`,
`commands/import-activity.md`, `commands/list.md`, `commands/make-full.md`,
`commands/mark-completed.md`, `commands/pause-work.md`,
`commands/resume-work.md`, `commands/review-comments.md`,
`commands/start-building.md`, `commands/start-review.md`,
`commands/verify-plan.md`, `pipelines/comments.md`, `pipelines/drift.md`,
`pipelines/milestone.md`, `pipelines/review.md`, `pipelines/verify-plan.md`,
`policy/activity-kind.md`, `policy/activity-md.md`, `policy/conventions.md`,
`policy/engineering.md`, `policy/execution-gate.md`, `policy/inflight.md`,
`policy/journal.md`, `policy/paused-blocked.md`, `policy/planning-stages.md`,
`policy/reviews.md`, `policy/session-start.md`, `policy/update-cadence.md`,
`shapes/activity.md`, `shapes/journal.md`, `shapes/notes-files.md`.

Not edited, and named on purpose: `SKILL.md`, `writing-style.md`,
`repair.md`, `commands/create.md`, `commands/build.md`, `commands/feedback.md`,
`briefs/drift-scanner.md`, `briefs/synthesizer.md`, `briefs/test.md`,
`policy/plan-outline.md`, `policy/consistency-check.md`,
`policy/test-evidence.md`.

## Still to verify

`editing.md` asks for these before the edit is finished.

- Done: every `Reads:` path under the skill resolves to a file.
- Done: a shape-shaped activity file has `notes` on line 15, so
  `head -n 15` includes `prior:`. `head -n 14` does not.
- Done: the session-start script was run on a sample activity. `notes`
  is line 15. No legacy marker fired. This repo still has no live
  `.dev-notes/activities/*/agent-activity.md`.
- Done: `o200k_base` token count of `SKILL.md` + `always.md` +
  `writing-style.md` + `policy/session-start.md` is 5192. The budget is
  about 5.0k. The extra lines are constraints added in this review.
- Done: legacy names from `editing.md` appear only in `repair.md`,
  `policy/session-start.md`, `commands/import-activity.md`, and the
  list in `editing.md`.
- Done: **Project-fit** is indexed on `planning-quality-bar`. The local
  labels legacy verify and delta steps are not bold. `journal`,
  `layout`, `reviews`, and `plan-outline` still open the policy file.
- `help all` still prints `commands/help-map.md`. The map text changed.
  The command still points at that file.

## Constraints the next editor must keep

From `editing.md` and `writing-style.md`, plus this review:

- `SKILL.md` stays a short intro plus the reading guide.
- One concept per file. A bold name is a trigger to read, not a copy of
  the rule.
- The parent never pastes brief text. A parent rule stays in `policy/`
  or `pipelines/`. A sub-agent rule stays in its brief.
- Sub-agents do not read or write `inflight.md`.
- Do not treat a ready marker on disk as this launch’s completion notice.
- Do not check a milestone, record review points, or delete `inflight.md`
  while status is `Paused`.
- A comments abandon restores every `comments/before/<path>` file and does not set `review-comments`.
