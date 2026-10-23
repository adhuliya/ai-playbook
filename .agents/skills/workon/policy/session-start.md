# Session start

Run once per activity per session, before the first read or write of its
files. Skip it under query mode, while a pipeline is in flight, and for
`help`. It touches only `.dev-notes/activities/<slug>/`.

Run one read-only shell call:

```bash
d=.dev-notes/activities/<slug>
act="$d/agent-activity.md"; [ -f "$act" ] || act="$d/activity.md"
rd="$d/spec-req-def.md"; [ -f "$rd" ] || rd="$d/requirement-def.md"
des="$d/spec-design.md"; [ -f "$des" ] || des="$d/design.md"
ls -A "$d"; ls -A "$d/artifacts" 2>/dev/null || true
for f in activity.md journal.md plan-outline.md requirement-def.md design.md design-choices.md guide-for-users.md; do
  [ -f "$d/$f" ] && echo "legacy $f"
done
[ -f "$act" ] && head -n 14 "$act" || echo "missing-activity"
rg -n '^\| synced \||^[0-9]+\. (\[.\]|removed:)|^## R[0-9]+:|\b(UR|SR|RRD)[0-9]+\b' "$d" --glob '*.md' --glob '!artifacts/**' || true
[ -f "$act" ] && rg -n '^# References' "$act" || true
[ -f "$rd" ] && rg --files-without-match '^## Problem:' "$rd" || true
[ -f "$des" ] && rg -n '^- DC[0-9]|^### DD[0-9]' "$des" || true
[ -f "$act" ] && rg -n '^- (\[[ xX]\] )?M[0-9]+:|^[[:space:]]*- reads:' "$act" || true
```

The `head` output is the metadata table, so the first read of the activity
record is often unnecessary. If any legacy marker below is present, read
`repair.md` and finish it before the gap fixes. Then fix gaps in one
batched step (**Fewer prompts**):

- **Missing notes file:** create it with its H1 only. `spec-req-def.md`:
  `# Requirement Definition`. `spec-design-choice.md`: `# Design Decisions`.
  `conventions.md`: `# Conventions` plus the empty `## Setup, build, test and
  install notes`. `notes-by-user.md`: `# Notes by User`. `references.md`:
  `# References`. Missing `spec-design.md` is a legacy marker (below), not a
  plain gap; do not create it here. When `kind` is `thin` and
  `spec-design.md` is missing, create the H1 only; do not run the legacy
  design migration.
- **Missing row:** add its default. `kind`: `full` (tell the user once).
  `conventions`: `pending` when `kind` is `thin`; otherwise `ok` when the
  status is `Active`, `Paused`, `Blocked`, or `Complete`, else `pending`.
  `review-comments`: `off` when `Complete`, else `on`. `base-branch`: `main`
  (tell the user once). `stage`: `design`. A missing `status`, `slug`,
  `branch`, `ticket`, or `notes` row has no default; ask for it.

**Legacy markers.** Read `repair.md` and follow it before anything else when
any of these shows:

- a file named `notes.md`, `user-notes.md`, `requirements.md`, or
  `user-guide.md`, or `artifacts/self-review.md` or `artifacts/self-review/`;
- a legacy line from the shell (`legacy activity.md`, `journal.md`,
  `plan-outline.md`, `requirement-def.md`, `design.md`,
  `design-choices.md`, or root `guide-for-users.md`);
- `spec-design.md` missing while `spec-req-def.md` exists, and `kind` is
  not `thin` (pre-design-document layout);
- a line from the `rg` hits: a `# References` heading in the activity
  record (not in `references.md`), a `synced` row, a
  numbered milestone, an `R<n>` heading, or a `UR`, `SR`, or `RRD` ID;
- `spec-req-def.md` listed as having no `## Problem:` heading;
- `spec-plan-outline.md` missing while `stage` is `design` and the status is not
  `Complete`;
- `spec-design.md` has a `^- DC` line and no `^### DD` line;
- `stage` is `design`, and a milestone line is not `TBD (design stage)` or
  `removed`, and no `reads:` line appears before the next milestone or `#`
  heading.

With no marker, go on.
