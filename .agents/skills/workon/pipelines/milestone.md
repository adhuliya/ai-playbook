# Milestone

In flight from step 1 until the milestone is checked or abandoned, across
job rounds (`inflight.md` stays). Do not launch a critic pair. A passing
test checks the milestone. Critics wait for `agent-review` or a
fix-cycle review. `start-review` records the user's points and launches
nothing.

1. Read `pipelines/milestone-read.md` and run it for this `M`. Read the slice. Do not Read
   `spec-req-def.md`, `spec-design.md`, or `spec-design-choices.md`.
2. Split the milestone into MECE jobs with disjoint write paths (code,
   tests) and one report each. The milestone paragraph names the areas.
   Choose the concrete write paths in this split. Do not copy that file
   list onto the milestone. Launch all workers. Give each a `name`.
   Pass the slice path in `inputs`. Set `conventions:` to `conventions.md`
   and `notes:` to `notes-by-user.md` (**Launch**).
3. All job reports ready → launch the collator (milestone claim, test
   cases, evidence commands, job report paths). Pass `conventions.md` and
   `notes-by-user.md`. Give it its own `name`.
4. If `status` is `Paused`, prompt `resume-work` and stop (**Inflight
   pipelines**). The parent Reads only `collate.md`. On the first `fail` or
   `conflict`, fix inline when the repair is a few tool calls, or when a
   split would overlap writes. Launch a new job round when the repair is a
   fresh slice of work. Do not check the milestone while a job round is
   open. When that same milestone is `fail` or `conflict` again after the
   repair, and an inline fix cannot land it, set `Blocked` with
   `prior: Active` (**Paused vs Blocked**), delete `inflight.md`, and
   stop. `pass` means this milestone's test cases passed. Update the
   activity files (**Update cadence**), check the milestone, and delete
   `inflight.md`. The next milestone may then start (**Continue mode**).
