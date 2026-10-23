# Activity kind

`kind` in `agent-activity.md` is `thin` or `full`. Both kinds use the same
files (**Layout**). Kind changes how deep the grill goes and which gates
block implementation. It does not change where a record lives.

## Choose

Default `thin` when the request has one outcome and a clear done
condition. The agent judges. The user may say `thin` or `full` at create.

A request for requirements first sets `kind: full` and
`stage: requirements`.

Stop when the agent cannot choose safely. Ask with **Asking**. Offer
`full` (recommended) and `thin`. Unsafe means two real designs, an unclear
done condition, or several milestones. Do not start the full grill until
the user picks `full`.

When the user says `thin` anyway, name the risk in one sentence, then
run `thin`. On an existing activity, an unsafe scope offers `make-full`
(recommended) or staying `thin`. Stop until the user picks. Do not
prompt `make-full` while the status is `Complete`; reopen to `Planning`
first. A reply of `thin` continues the command that asked.

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
to checks the user named. One milestone is enough for one outcome.

`approve-plan` does not run on a thin activity. Prompt `make-full` or
`start-building`. `requirements-ok` does not run on a thin activity.
Prompt `make-full`. `conventions-ok` may be typed and does not change
kind. Do not prompt for it. `conventions` stays `pending` and does not
block.

Status stays `Planning` until `start-building`. No product engineering
before that keyword. When the create message already contains
`start-building`, run this pass and then that command in one turn.

Show `spec-plan-outline.md` and the Goal, then prompt `start-building`.
The user may correct the files first. A later chat note that adds a
requirement, a constraint, or a design note on the same Goal updates
the records in place. Say that it stays on this activity. Name
`make-full` only when they ask for a stricter plan, or the scope is
unsafe.

After `start-building`, build inline. Do not launch explores or the
milestone, review, or plan pipelines unless the user typed that keyword.
`start-review`, `verify-plan`, and `fix-activity` still run when typed.

## Full

Run the **Planning quality bar** and **Planning stages**. The **Execution
gate** requires `approve-plan`, `conventions-ok`, and `start-building`.
Build through the **Milestone** pipeline.

## `make-full`

Same slug. Set `kind: full` and `status: Planning`. Deepen the existing
records up to the **Planning quality bar**. Grill only open branches. Do
not re-ask a settled fact. Do not discard code already written. Pause
product engineering until `approve-plan`, `conventions-ok`, and
`start-building`.
