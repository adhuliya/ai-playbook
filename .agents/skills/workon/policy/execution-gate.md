# Execution gate

`kind` is `thin` or `full` (**Activity kind**). No product engineering
before `start-building`.

On `thin`, `approve-plan` and `conventions-ok` are not required.
`conventions: pending` does not block. `start-building` runs from
`Planning`.

On `full`, no product engineering until `approve-plan`, `conventions-ok`,
and then `start-building`. `conventions-ok` may come before or after
`approve-plan`. It is one-time: once `conventions: ok`, it stays `ok`
through edits, `replan-work`, and reopens. Only `import-activity` resets
it. After a Complete stay-on-slug reopen to `Planning`, `approve-plan`
and `start-building` run again.

`make-full` sets `kind: full` and `status: Planning`. The full gate then
applies again, including when `start-building` already ran.
