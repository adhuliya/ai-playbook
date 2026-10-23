# `list`

Status: n/a; read-only.

Reads: shapes/list.md

Run one call: `head -n 14 .dev-notes/activities/*/agent-activity.md`. Build the
table from the metadata rows and the H1 title. Skip `Complete` activities
unless the user asks for them (`list --all`). Show the table. For one
activity, follow **Details**.

**Details** (no resume): the full path plus the first ~20 lines of
`agent-activity.md`, then stop.
