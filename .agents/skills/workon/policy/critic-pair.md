# Collect vs evaluate

Use one agent to collect facts: outcomes, paths, pass or fail, and joins.
A milestone `pass` checks it. That pass is the test result, not a critique.

Critics do not run until the user types a command that names them. The
commands are `agent-review`, and the fix-cycle review inside
`fix-activity` after the user chooses `review`. In `Planning`,
`agent-review` runs the plan pass (`pipelines/verify-plan.md`). Otherwise
it runs the milestone pass (`pipelines/review.md`). Always launch both
sides. The pipeline step assigns each focus. Do not launch a critic pair
on a milestone, on `start-review`, on `apply-review`, or on any other turn.

`briefs/critic.md` is the critic brief. The synthesizer reconciles.
