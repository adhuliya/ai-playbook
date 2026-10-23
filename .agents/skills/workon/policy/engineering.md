# Engineering while focused

Only after the **Execution gate**, and outside **Stops** blocks. Update
records at checkpoints only (**Update cadence**). Apply **Test evidence**
while building.

Honor the `conventions.md` rules (precedence: **Notes files**) and use the
Setup commands for build and test. Where the rules are silent, the repo's
guidelines apply: match the surrounding code (naming, idiom, error
handling, structure, file layout); keep the diff minimal and in scope, and
suggest refactors or reformatting of untouched code separately; reuse
existing helpers, utilities, and patterns before you write new ones;
prefer the standard library and existing dependencies, since a new
dependency is a Design Decision.

Planning vocabulary stays out of shipped work: no **IDs**, milestone
numbers, or the activity slug in code, comments, or identifiers. Such
labels mean nothing outside the activity files.

While building, keep the records honest. A missing invariant that would
mislead a fresh reader goes into `spec-design.md` (**Design document**); a new
requirement or important choice goes into RD or Design Decisions (and
`spec-design.md`'s synthesis); a newly confirmed convention goes into
Conventions; a material change follows **Material-change**. New definition files follow **Cited context** (ask
before copy). Suggest `create-sibling` when work is independently durable.
