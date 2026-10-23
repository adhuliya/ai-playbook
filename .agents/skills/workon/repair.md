# Repair

Run this only when **Session start** found a legacy marker. Fix every
marker in one pass, with batched calls (**Fewer prompts**). Do not edit
the journal, except the filename-token rename below. Afterwards tell the
user, in three lines or fewer, what changed.

**Record filenames.** Do this before the other fixes. `git mv` when the
file is tracked. If the new path already exists, do not overwrite; tell
the user.

| Old name | New name |
|---|---|
| `activity.md` | `agent-activity.md` |
| `journal.md` | `agent-journal.md` |
| `plan-outline.md` | `spec-plan-outline.md` |
| `requirement-def.md` | `spec-req-def.md` |
| `design.md` | `spec-design.md` |
| `design-choices.md` | `spec-design-choice.md` |
| `guide-for-users.md` (activity root) | `artifacts/guide-for-users.md` |

Replace those filename tokens in markdown under the slug, including the
journal and `artifacts/`. Longest token first. Do not change
`detailed-design.md` or a name that is already new. Do not rewrite
sentences, regenerate sections, or renumber. When `kind` is missing, add
`kind | full`. That row is the only new text.

**Current-layout renames and moves:**

- `user-guide.md`: rename to `artifacts/guide-for-users.md` (`git mv` if tracked).
- Numbered milestones: in `# Milestones`, rewrite `<n>. [ ] <text>` as
  `- [ ] M<n>: <text>` and `<n>. removed: <why>` as `- M<n>: removed: <why>`.
  Keep the checked state. Update milestone citations in `agent-activity.md` and
  `reviews.md` (`milestone 3` → `M3`). Leave old `artifacts/bg/milestone-<n>/`
  and `artifacts/review/milestone-<n>.md` for `delete-tmp-files`.
- `# References` in `agent-activity.md`: move each bullet to `references.md` in the
  **References** shape and number any bullet without a `REF<n>`. Remove the
  section from `agent-activity.md`. Keep `derived-from:` as the last entry.
- `synced` row: delete it. When `refs/workon/<slug>` exists, remove it with
  `git update-ref -d refs/workon/<slug>`.
- `spec-plan-outline.md` missing, `stage: design`, and the status is not
  `Complete`: draft it from `# Current Plan` and `# Milestones` (**Plan
  summary**). Show it once with the next **File review**.
- `spec-design.md` missing (**Design document**): skip this when `kind`
  is `thin` (session start creates the H1 only). Otherwise create it with the `# Design`
  H1. Migrate the body
  of `agent-activity.md`'s `# Current Design` section into its Current Design
  section. Synthesize Decisions as `### DD<n>:` blocks from
  `spec-design-choice.md` by level, each with `- cites:` set to the `DC` it
  comes from. Add an empty Test Plan (`TBD` lines per RD) and an empty
  Traceability section (`TBD` rows from RD). Then
  replace `# Current Design` in `agent-activity.md` with the one-line pointer
  `See \`spec-design.md\`.`. Show the new `spec-design.md` once.

**Older layouts:**

- Legacy `notes.md`: map each old `##` to the file whose H1 matches
  (Requirement Definition, Design Decisions, Conventions); the rest goes to
  `notes-by-user.md`. Promote `###` to `##`. Add an empty `## Setup, build,
  test and install notes` if missing. Delete `notes.md`.
- Legacy `user-notes.md`: rename to `notes-by-user.md` (`git mv` if
  tracked) and change the H1 `# User Notes` to `# Notes by User`. Keep the
  body.
- Legacy `requirements.md`: rename to `spec-req-def.md` (`git mv` if
  tracked). Keep the body.
- `spec-req-def.md` without a **Problem header**: draft one from
  `# Scope`, `# Goal`, and `.dev-notes/definition.md`. Show it once and ask
  the user to confirm or correct it.
- Entries or References bullets without **IDs**: number them in file
  order; rewrite title-based `replaces:` to IDs.
- Legacy IDs: rename `R<n>` → `RD<n>` (same number). Merge `UR<n>`,
  `SR<n>`, and `RRD<n>` cycles into one `RU<n>` sequence in file order.
  Update every reference in the scope files. Append the map as a
  **Renumber log**.
- Legacy `artifacts/self-review.md` and `artifacts/self-review/` are old
  review records. Do not apply them; `delete-tmp-files` lists them
  (default delete).

**Milestone reads and DD.** Run when `spec-design.md` Decisions has a `- DC`
bullet and no `### DD` heading, or when `stage` is `design` and a real
milestone (not `TBD (design stage)`, not `removed`) has no `reads:` line.
Skip the `reads:` fill while `stage` is `requirements`.

1. In Decisions, replace each `- DC<nn>` bullet with the next `### DD<n>:
   <title>` in file order, a `- cites: DC<nn>` bullet, and the old line as
   the body. A summary bullet with no `DC` id becomes a `DD` with no
   `cites:` line. Leave a `TBD` Decisions section as `TBD`.
2. For each real design-stage milestone that lacks `reads:`, set the line
   from Traceability: every `RD` whose row has a case tagged with that `M`
   (`planned for`, `done by`, or `implemented by`). Do not add `DD` ids.
   When no row matches, write `reads: none`.
3. Tell the user which milestones have `reads:` and no `DD`.

Do not renumber in this pass. `fix-activity` step 7 renumbers.
