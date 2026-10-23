# IDs

Activity entries carry stable IDs. IDs give humans a short, stable name
for an entry and let an agent read exactly that entry without loading the
whole file.

| ID | Entry | Home |
|---|---|---|
| `RD<n>` | Requirement Definition | `spec-req-def.md` `## RD<n>: <title>` |
| `DD<n>` | current design statement | `spec-design.md` `### DD<n>: <title>` under `## Decisions` |
| `DC<nn>` | design choice (two digits, append-only) | `spec-design-choice.md` `## DC<nn>: <title>` |
| `CONV<n>` | convention rule (Setup H2 has no ID) | `conventions.md` `## CONV<n>: <title>` |
| `REF<n>` | reference | `references.md` `- REF<n>:` entry |
| `RU<n>`, `RU<n>.<m>` | Review Update: review cycle, point | `reviews.md` |
| `M<n>` | milestone | `agent-activity.md` `# Milestones` |
| `AC<n>` | acceptance criteria for `RD<n>` | `spec-req-def.md`, `AC<n>:` under `## RD<n>` |
| `TC<n>` | test case set for `RD<n>` | `spec-design.md` `## Test Plan`, `TC<n>:` line |

Assign the next free number. Do not reuse a retired (superseded or removed)
ID, except through `fix-activity` renumbering. `replaces:` names the old
ID. IDs stay out of shipped work and `artifacts/guide-for-users.md`
(**Engineering while focused**). `spec-plan-outline.md` and
`artifacts/detailed-design.md` stay readable without IDs (**Writing style**).

`AC<n>` and `TC<n>` are not independently numbered: each always shares its
`RD<n>`'s number, so `RD3` pairs with `AC3` and `TC3`. `AC<n>` exists once
`add-ac` drafts it. A missing `AC<n>` is normal. Renumbering `RD<n>`
(`fix-activity`) renumbers its `AC<n>` and `TC<n>` the same way, in the
same pass. Renumbering also updates every `reads:` line and every `cites:`
line.

A `DD<n>` is the current statement a milestone builds from. Rewrite it in
place. It cites the `DC<nn>` entries it rests on. Those entries keep the
alternatives and why they lost. `DC<nn>` stays the append-only history.

## Citing and reading by ID

Recommended, not strict. `spec-plan-outline.md` and `artifacts/detailed-design.md` are the
exception in **Writing style**.

- **Cite by ID** in records and replies instead of repeating the title or
  the text: "per RD3", "see DD2", "see DC02", "AC3 covers it", "TC3 is green".
  On first mention in a reply, add a few words of gloss so the reader need
  not look it up: "RD3 (CSV column order)". Skip the gloss when the
  context already makes it plain.
- **Read one entry, not the file.** An entry is a `##` block, so print only
  what you need:

  ```bash
  awk '/^## /{p=($2 ~ /^(RD3|RD5):$/)} p' .dev-notes/activities/<slug>/spec-req-def.md
  ```

  Use the same call for `DC`, `CONV`, and `RU` entries in their files. A
  `DD<n>` entry is a `###` block:

  ```bash
  awk '/^### /{p=($2 ~ /^(DD2|DD4):$/)} p' .dev-notes/activities/<slug>/spec-design.md
  ```

  For `REF<n>` and `M<n>`, which are list items, use `rg -n -A 8 'REF2:'` or
  `rg -n -A 12 'M3:'`. For `AC<n>` and `TC<n>`, which are lines or lists
  inside another entry, use `rg -n -A 4 'AC3:'` on `spec-req-def.md` or
  `rg -n -A 2 'TC3:'` on `spec-design.md`. When `AC3:` is absent, stop after the
  `RD3` block.
- Read a whole notes file only to grill, review, or rewrite it as a whole.
