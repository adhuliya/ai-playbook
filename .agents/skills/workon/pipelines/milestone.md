# Milestone

In flight from step 1 until the milestone is checked or abandoned, across
job rounds (`inflight.md` stays). Do not launch a critic pair. The user
types `start-review` to review checked work.

1. Read `pipelines/milestone-read.md` and run it for this `M`. Read the slice. Do not Read
   `spec-req-def.md`, `spec-design.md`, or `spec-design-choices.md`.
2. Split the milestone into MECE jobs with disjoint write paths (code,
   tests) and one report each. Launch all workers. Pass the slice path in
   `inputs`.
3. All job reports ready → launch the collator (milestone claim, test
   cases, evidence commands, job report paths).
4. The parent Reads only `collate.md`. `fail` or `conflict` → a new job
   round or an inline fix; do not check the milestone while a job round is
   open. When that same milestone is `fail` or `conflict` again after the
   repair, and an inline fix cannot land it, set `Blocked` with
   `prior: Active` (**Paused vs Blocked**), delete `inflight.md`, and
   stop. `pass` → update the activity files (**Update cadence**), check
   the milestone, and delete `inflight.md`.
