# Execution gate

No product engineering until `approve-plan`, `conventions-ok`, and then
`start-building`. `conventions-ok` may come before or after `approve-plan`.
It is one-time: once `conventions: ok`, it stays `ok` for the life of the
activity through edits, `replan-work`, and reopens. Only `import-activity`
resets it, because the repo may differ. After a Complete stay-on-slug reopen
to `Planning`, `approve-plan` and `start-building` run again.
