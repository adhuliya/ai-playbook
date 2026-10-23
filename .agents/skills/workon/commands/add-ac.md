# `add-ac`

Status: any. No status change. No journal (an RD edit; **Journal policy**
already excludes notes edits).

Reads: policy/requirement-def.md, policy/ids.md, policy/design-document.md

By default, acceptance criteria stay informal: `RD<n>`'s test case set
(`TC<n>` in `spec-design.md`) is its acceptance evidence (**Test evidence**).
`add-ac` makes it explicit for the RDs that lack it, as `AC<n>` (**IDs**:
shares `RD<n>`'s number, not a separate sequence).

1. List every `RD<n>` with no `AC<n>`. None → say so, stop.
2. For each, draft 2-5 short, checkable pass/fail conditions from the RD
   text, its `kind`, and `TC<n>` (planned or built). Grill only the ones
   the repo and RD cannot settle (**Asking**).
3. Append `AC<n>:` as a bullet list under each `RD<n>` entry. Show the
   diff.
4. A material change to the RD's meaning while drafting criteria follows
   **Material-change**; otherwise this is not one.
