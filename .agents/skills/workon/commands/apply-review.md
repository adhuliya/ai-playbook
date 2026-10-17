# `apply-review`

Status: any. No `open` cycle in `reviews.md` → say so; suggest
`start-review`, or adding points to the last closed regular cycle when no
newer regular cycle exists (**Reviews** reopen). Stop.

Reads: policy/reviews.md, policy/apply-timing.md, policy/journal.md, policy/material-change.md, policy/activity-md.md, policy/execution-gate.md

This command applies and closes one cycle, which the user may have edited. The
target is the open fix cycle, else the open regular cycle (**Reviews** fix
first). The keyword is the nod when the points already answer the questions.
**Apply timing**, **Journal policy**, and **Complete stay-on-slug** apply.

1. Read the target cycle. Restate each `open` point with its planned
   outcome, plus remaining work, next action, and any status change. Ask
   only the gaps the points do not settle (one round), then stop; after the
   answers, apply next turn with no new keyword. With no gaps, apply in
   this turn.
2. An `open` point that is a **Material-change** → apply nothing; ask
   `replan-work` or `create-sibling` (`Complete`: `create-sibling` only).
   Stop. The cycle stays `open`; no status change, no journal.
3. Give every `open` point an outcome (**Reviews** outcome). Apply notes
   edits as each point's `where` says (**Reviews** where a change lands).
   Product work → a review milestone `Apply RU<n>`; those points are
   `planned → M<k>`. Set `status: closed`.
4. **Status and journal:** one entry only.
   - `Complete` with a new review milestone: `Complete` → `Planning`.
     Rewrite `# Current Plan` / `# Next Steps` as `resume-work` `Complete`
     step 5, without the grill. Append the resume recap citing `RU<n>`.
     Then the **Execution gate**.
   - Any other case (including `Paused` / `Blocked`, and `Complete` without
     product work): no status change; append the `Review` event.
5. **Fix cycle only:** run the **Reviews**
   recheck on the open regular cycle and show the result. Say that the next
   `fix-activity` runs the deferred housekeeping.
6. Keep `artifacts/review/` or `artifacts/fix/review/` (overwritten on the
   next run of that pipeline). Delete only via `delete-tmp-files`.
