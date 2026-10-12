# Building

Test tiers and engineering rules for workon.
Read this file before product engineering or a comment command.
Index: [`SKILL.md`](SKILL.md).

## Test evidence

Planning, building, `start-review`, `verify-plan`, `mark-completed`.

Three tiers. Plan each tier during planning. Write tests as each milestone is
built.

- **Unit (per part):** each part a milestone adds or changes (function,
  component, module) gets focused tests on its own behavior. Cases: happy
  path, edges, and errors that belong to that part. Isolate the part from
  its neighbors. Do not hang the whole suite off every milestone.
- **Integration (per boundary):** test where parts meet: component
  boundaries, joins between milestones, and each `software-interface` RD.
  Name the boundary and its cases in the plan. Place the test in the
  milestone that completes the boundary.
- **Last milestone** (or a dedicated final one): one or more **end-to-end**
  tests that confirm the Goal as a whole. `mark-completed` MUST NOT proceed
  without that named, runnable e2e unless the user explicitly drops it (reason
  in `activity.md`). Run the command when the env can; a user nod does not
  replace a missing e2e name. User drop is the only waiver.
- **`software-interface` peers you cannot run live:** emulate. Smallest
  in-repo test double / throwaway fake that implements the concerned
  interface. Reuse the repo's test-double pattern if one exists. Ship it
  with the tests so a fresh agent can run e2e. Not activity `artifacts/`
  only. Not a second product.
- **Extend existing tests first:** before you add a test, search for tests
  with the same goal (same part, boundary, or scenario).
  - Goals match → extend that test (new case, table row, or assertion).
  - Goals differ, or the extension would blur its purpose → add a new test.
  - Do not weaken or rewrite existing assertions to fit. A changed expected
    behavior is a requirement change; record it as a review point
    (**Reviews**).
- **Layout:** follow the repo's test layout, naming, and helpers.
- Evidence bullets name the runnable command and the case list per tier.

## Engineering while focused

Only after the **Execution gate**, outside **Stops** blocks.

- Checkpoints only (**Update cadence**).
- Honor `conventions.md` rules (precedence: **Notes files**). Use Setup
  commands for build/test.
- **Coding style:** where `conventions.md` rules are silent, the repo's
  guidelines apply.
  - Match the surrounding code: naming, idiom, error handling, structure,
    and file layout.
  - Keep the diff minimal and in scope. Do not refactor or reformat code the
    milestone does not touch; suggest it separately.
  - Reuse existing helpers, utilities, and patterns before you write new
    ones.
  - Prefer the standard library and existing dependencies. A new dependency
    is a Design Decision.
- Planning vocabulary stays out of shipped work: no **IDs**, milestone
  numbers, or the activity slug in code, comments, or identifiers. Such
  labels mean nothing outside the activity files.
- **Comments:** two levels. The `review-comments` row picks the level for
  code written now. Explain intent, contracts, and traps; do not narrate
  mechanics or restate code. Write in **Writing style** prose.
  - **Default level** (`off`; the level that ships): the smallest set that
    lets a reader understand the code.
    - New file: short module header (what this file is for).
    - New public/exported function: one-line contract/why, not a signature
      echo.
    - Private helper: one-line contract if non-trivial; skip if the name is
      the explanation.
    - Non-obvious branch or block: one line when the code cannot show the
      reason.
    - Bugfix: comment when the wrong code looks reasonable.
    - Test: scenario intent if the test name is not enough.
  - **Review level** (`on`; default while building): the default level plus
    enough for a human reviewer to follow the code without the author.
    - Non-trivial block: 1–2 lines on why it exists.
    - Function: the invariants and edge cases it handles, where it handles
      them.
    - Test case: the scenario and the expected behavior.
    - Boundary: what callers may rely on; what the code assumes of its
      neighbors.
  - Both levels: ≤ ~3 lines per comment; no essays. No change narration
    (`added`, `previously`, `now`). No **IDs**.
  - Name concepts and roles, not identifiers, literal constants, or line
    positions. Names and values change during maintenance and make the
    comment stale. Name an identifier only when no concept term fits.
  - Match the file's comment dialect.
  - Switch levels for existing code only with `add-review-comments` /
    `remove-review-comments`.
- New definition files → **Cited context** (ask before copy).
- Missing invariant that would mislead a fresh reader → update `activity.md`.
  New requirement or important choice → RD / Design Decisions. New confirmed
  convention → Conventions. Material change → **Material-change**.
- Suggest `create-sibling` when work is independently durable.
- Apply **Test evidence** while building.
