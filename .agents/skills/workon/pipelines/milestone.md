# Milestone

In flight from step 1 until the milestone is checked or abandoned, across
job rounds and the critic pair (`inflight.md` stays).

1. Split the milestone into MECE jobs with disjoint write paths (code,
   tests) and one report each. Launch all workers.
2. All job reports ready → launch the collator (milestone claim, test
   cases, evidence commands, job report paths).
3. The parent Reads only `collate.md`. `fail` or `conflict` → a new job
   round or an inline fix; do not check the milestone while a job round is
   open. `pass` → step 4 if it applies; then update the activity files
   (**Update cadence**), check the milestone, and delete `inflight.md`.
4. **Evaluate** when the parent must judge quality, not only record a pass:
   real design latitude, the last milestone, or the user asked. Launch the
   critic pair (`pipeline: milestone`) with the milestone claim, RD and
   design slices, `collate.md`, and the changed paths (MAY Read). The
   parent Reads both critic files and reconciles. Fix `must` defects in a
   job round; record the rest.
