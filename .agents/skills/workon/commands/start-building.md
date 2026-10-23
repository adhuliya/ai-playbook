# `start-building`

Status: `Approved`. Also `Planning` when `kind` is `thin`.
`Planning` and `full`: require `approve-plan` first.

Reads: policy/activity-kind.md, policy/engineering.md, policy/comments.md, policy/test-evidence.md, policy/journal.md, policy/reminders.md

1. When `kind` is `full`, this needs `conventions: ok`. If `pending`,
   prompt `conventions-ok` and stop. When `kind` is `thin`, `pending`
   does not block.
2. On `full`, **Optional-remind** `apply-review`.
3. Set `status` to `Active`. Append a `Building` event. Begin
   engineering. On `thin`, build inline (**Activity kind**).
