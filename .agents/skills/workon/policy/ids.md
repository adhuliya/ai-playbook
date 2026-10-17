# IDs

Activity entries carry stable IDs. IDs give humans a short, stable name
for an entry and let an agent read exactly that entry without loading the
whole file.

| ID | Entry | Home |
|---|---|---|
| `RD<n>` | Requirement Definition | `requirement-def.md` `## RD<n>: <title>` |
| `DC<nn>` | design decision (two digits) | `design-choices.md` `## DC<nn>: <title>` |
| `CONV<n>` | convention rule (Setup H2 has no ID) | `conventions.md` `## CONV<n>: <title>` |
| `REF<n>` | reference | `references.md` `- REF<n>:` entry |
| `RU<n>`, `RU<n>.<m>` | Review Update: review cycle, point | `reviews.md` |
| `M<n>` | milestone | `activity.md` `# Milestones` |

Assign the next free number. Do not reuse a retired (superseded or removed)
ID, except through `fix-activity` renumbering. `replaces:` names the old
ID. IDs stay out of shipped work and `guide-for-users.md`
(**Engineering while focused**).

## Citing and reading by ID

Recommended, not strict.

- **Cite by ID** in records and replies instead of repeating the title or
  the text: "per RD3", "see DC02". On first mention in a reply, add a few
  words of gloss so the reader need not look it up: "RD3 (CSV column
  order)". Skip the gloss when the context already makes it plain.
- **Read one entry, not the file.** An entry is a `##` block, so print only
  what you need:

  ```bash
  awk '/^## /{p=($2 ~ /^(RD3|RD5):$/)} p' .dev-notes/activities/<slug>/requirement-def.md
  ```

  Use the same call for `DC`, `CONV`, and `RU` entries in their files. For
  `REF<n>` and `M<n>`, which are list items, use `rg -n -A 8 'REF2:'` or
  `rg -n -A 12 'M3:'`.
- Read a whole notes file only to grill, review, or rewrite it as a whole.
