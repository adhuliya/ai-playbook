# Comments
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
