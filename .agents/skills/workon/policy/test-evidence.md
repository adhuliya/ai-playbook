# Test evidence

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
