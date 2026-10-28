# `auto-continue` / `ask-continue`

Status: any. No status change, no journal.

Reads: policy/activity-md.md

`auto-continue` sets `continue` to `auto`. `ask-continue` sets it to
`ask`. Say the value in one line. When `auto`, work that remains starts
in the same turn. Do not ask for `continue`. Still stop for `Blocked`,
an open question, an open review, or `mark-completed`. When `ask`, ask
for `continue`.
