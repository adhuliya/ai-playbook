# Reminders

Remind once per phase change.

- On `full`, create, `create-sibling`, and `replan-work`: remind the user to use a
  **strong** model, the most capable reasoning model they can pick (for
  example, a top Claude Opus or GPT high-reasoning tier).
- `approve-plan`: one-time note that planning is done; the user may drop the
  strong model. Do not recommend an execution tier.

**Optional-remind** (once; do not require): `apply-review` when `reviews.md` has an
`open` cycle (at `approve-plan`, `start-building`, `pause-work`,
`resume-work`); `detailed-design` at
`mark-completed` when `spec-design.md`'s Decisions section has grown past a
few entries; `add-ac` at `approve-plan` when any RD has no `AC<n>`; `remove-review-comments` at `mark-completed` when
`review-comments` is `on`; `fix-activity` at `resume-work`, or when the
agent notices drift (activity files edited outside the agent, a pulled or
rebased branch, or cited paths missing). When
`artifacts/guide-for-users.md` is missing at `mark-completed`, the keyword
is `create-guide`. That is required. Do not treat a stale guide as missing.
Remind `requirements-ok` once when `kind` is `full`, `stage` is
`requirements`, and RD looks complete. On `thin` in that stage, follow
**Choose**. A typed `thin` names `start-building`. When the user did not
type `thin`, set `kind` to `full` and follow `commands/make-full.md`.
Then name `requirements-ok`. Do not remind `make-full`.
