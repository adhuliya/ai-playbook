# Building

Test tiers and engineering rules for workon, loaded by `build`,
`start-building`, and the comment commands. Index: [`SKILL.md`](SKILL.md).

## Test evidence

Applies to planning, building, `start-review`, `verify-plan`, and
`mark-completed`. Plan every tier during planning; write the tests as each
milestone is built. Evidence bullets name the runnable command and the
case list per tier. Follow the repo's test layout, naming, and helpers.

- **Unit (per part):** each part a milestone adds or changes (function,
  component, module) gets focused tests on its own behavior: happy path,
  edges, and the errors that belong to that part. Isolate the part from
  its neighbors; do not hang the whole suite off every milestone.
- **Integration (per boundary):** test where parts meet: component
  boundaries, joins between milestones, and each `software-interface` RD.
  Name the boundary and its cases in the plan, and place the test in the
  milestone that completes the boundary.
- **End-to-end (last milestone, or a dedicated final one):** one or more
  tests that confirm the Goal as a whole. `mark-completed` MUST NOT proceed
  without that named, runnable e2e unless the user explicitly drops it
  (reason in `activity.md`). Run the command when the env can; a user nod
  does not replace a missing e2e name, and the user drop is the only
  waiver.
- **`software-interface` peers you cannot run live:** emulate them with the
  smallest in-repo test double or throwaway fake that implements the
  concerned interface, reusing the repo's test-double pattern if one
  exists. Ship it with the tests so a fresh agent can run the e2e; not in
  activity `artifacts/` only, and not as a second product.
- **Extend existing tests first.** Before you add a test, search for tests
  with the same goal (same part, boundary, or scenario). Goals match →
  extend that test (new case, table row, or assertion). Goals differ, or
  the extension would blur its purpose → add a new test. Never weaken or
  rewrite existing assertions to fit: a changed expected behavior is a
  requirement change, recorded as a review point (**Reviews**).

## Engineering while focused

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
mislead a fresh reader goes into `activity.md`; a new requirement or
important choice goes into RD or Design Decisions; a newly confirmed
convention goes into Conventions; a material change follows
**Material-change**. New definition files follow **Cited context** (ask
before copy). Suggest `create-sibling` when work is independently durable.

### Comments

Comments have two levels; the `review-comments` row picks the level for
code written now. Explain intent, contracts, and traps; do not narrate
mechanics or restate code. Write in **Writing style** prose.

- **Default level** (`off`; the level that ships): the smallest set that
  lets a reader understand the code. A new file gets a short module header
  (what the file is for). A new public or exported function gets a
  one-line contract or why, not a signature echo. A private helper gets a
  one-line contract if non-trivial, none if the name explains it. A
  non-obvious branch or block gets one line when the code cannot show the
  reason. A bugfix gets a comment when the wrong code looks reasonable. A
  test gets its scenario intent if the test name is not enough.
- **Review level** (`on`; default while building): the default level plus
  enough for a human reviewer to follow the code without the author. A
  non-trivial block gets 1–2 lines on why it exists. A function gets the
  invariants and edge cases it handles, where it handles them. A test case
  gets the scenario and the expected behavior. A boundary gets what callers
  may rely on and what the code assumes of its neighbors.
- **Both levels:** ≤ ~3 lines per comment; no essays. No change narration
  (`added`, `previously`, `now`). No **IDs**. Name concepts and roles, not
  identifiers, literal constants, or line positions, which change during
  maintenance and make the comment stale; name an identifier only when no
  concept term fits. Match the file's comment dialect.
- Switch levels for existing code only with `add-review-comments` /
  `remove-review-comments`.
