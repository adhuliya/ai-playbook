# Activity kind

`kind` in `agent-activity.md` is `thin` or `full`. Both kinds use the same
files (**Layout**). Kind changes how deep the grill goes and which gates
block implementation. It does not change where a record lives.

## Choose

The agent sets `kind`. Do not ask the user to pick `thin` or `full`.
Do not tell the user to remember `make-full`. A clear single outcome
with a clear done condition stays `thin`.

Unsafe means two real designs, an unclear done condition, or several
milestones. An unsafe request sets `kind` to `full`. Grill the open
branches. Do not stop to offer `full` or `thin`.

A request for requirements first sets `kind: full` and
`stage: requirements`.

When the user types `thin` or `full`, honor it. A typed `thin` stays
`thin`. On an existing thin activity whose scope becomes unsafe, upgrade
in place the way `make-full` does. Do this only when the user did not
type `thin`. Follow `commands/make-full.md`. Do not ask the user to type
that keyword.

`create-sibling` defaults to the parent's kind unless the user says
otherwise.

## Thin

Write the same files as a full activity, except lazy `reviews.md`,
`artifacts/guide-for-users.md`, and `artifacts/detailed-design.md`. Write
them in one pass from the request. Keep each record short and real. Ask
only a branch you cannot resolve. Skip the project-fit prompt, the intake
prompt, and the rest of the grill. Skip the strong-model reminder.

Do not invent entries to fill a template. Write an RD for each stated
requirement. Write a `DC` only when a choice was made. Keep the test plan
to checks the user named. The e2e name follows **Test evidence**. One
milestone is enough for one outcome.

`approve-plan` does not run on a thin activity. Follow **Choose**. Prompt
`start-building` when `kind` stays `thin`. `requirements-ok` does not run
on a thin activity. Follow **Choose**.
`conventions-ok` may be typed and does not change
kind. Do not prompt for it. `conventions` stays `pending` and does not
block.

Status stays `Planning` until `start-building`. No product engineering
before that keyword. A later chat note follows **Agent notes**. Follow
**Choose**. The agent upgrades in place and does not ask for the keyword.
A typed `thin` stays `thin`.

After `start-building`, build inline. Do not launch explores or the
milestone, review, or plan pipelines unless the user typed that keyword.
`start-review`, `agent-review`, and `fix-activity` still run when typed.

## Full

Run the **Planning quality bar** and **Planning stages**. The **Execution
gate** requires `approve-plan`, `conventions-ok`, and `start-building`.
Build through the **Milestone** pipeline.

## `make-full`

Same slug, in place. Follow `commands/make-full.md` for the row changes,
the grill, and the next keyword. Keep code already written.
