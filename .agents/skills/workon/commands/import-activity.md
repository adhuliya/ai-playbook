# `import-activity`

Status: n/a (new session). The user brings `agent-activity.md` and `agent-journal.md`,
plus notes files, `spec-design.md`, `references.md`, `spec-plan-outline.md`,
`reviews.md`, `artifacts/guide-for-users.md`, and `artifacts/` if present (or older
names from the **Repair** table, such as `activity.md`, `notes.md`, or
`user-guide.md`, or no `spec-design.md` at all). There
is no prior chat context.

Reads: repair.md, policy/catalog.md, policy/journal.md, policy/execution-gate.md, policy/references.md, policy/plan-outline.md

1. Locate the files; ask when the path or slug is ambiguous. Do not assume
   this repo's tree.
2. Read the activity record fully under `agent-activity.md` or legacy
   `activity.md`, plus RD / Design Decisions / Conventions / `spec-design.md`
   or legacy `design.md` if present, and the journal only if it has entries. Treat the imported
   `status` as not executable here.
3. Verify progress against this repo with evidence commands. Note drift.
4. Orient the user: RD, Scope, design, conventions, claimed vs verified,
   remaining work, safest next action from `# Next Steps`.
5. Place the files under `.dev-notes/activities/<slug>/` and run
   **Repair** (migrates or creates `spec-design.md` if missing). Reconcile
   drift into `agent-activity.md`, `spec-design.md`, RD, and Conventions. Set
   `status` to `Planning` and `conventions: pending`, unless imported as
   `Complete` (keep both), and `stage: design`. Keep `kind` when present.
   When `kind` is missing, set `full`. Clear `prior:` and any
   blocker from `notes`. Keep `review-comments` (session-start default if
   missing). Ask
   the user to confirm `base-branch` for this repo. Open review cycles stay
   `open`; report them. Append a **Catalog** entry if no heading exists.
   Append a `Created` event: source and drift found.
6. Wait for the **Execution gate**. If `Complete` and new work is wanted:
   `resume-work`.
