# `start-building`

Status: `Approved` or `Planning`. These steps name a keyword and stop
until the gates below pass. Only then do they set `Active`.

Reads: policy/activity-kind.md, policy/engineering.md, policy/comments.md, policy/test-evidence.md, policy/journal.md, policy/reminders.md

1. When `stage` is `requirements` and `kind` is `thin`, prompt
   `make-full` and stop. Do not set `kind`. When `stage` is
   `requirements` and `kind` is `full`, prompt `requirements-ok` and
   stop.
2. When `kind` is `full` and `status` is not `Approved`, prompt
   `approve-plan` and stop. When `kind` is `full` and `conventions` is
   `pending`, prompt `conventions-ok` and stop. When `kind` is `thin`,
   `pending` does not block.
3. On `full`, **Optional-remind** `apply-review`.
4. Set `status` to `Active`. Append a `Building` event. Begin
   engineering. On `thin`, build inline (**Activity kind**).
5. This turn begins the work. On a later turn, work still left follows
   **Continue mode**. When the milestones and the end-to-end check are
   done, prompt `mark-completed`.
