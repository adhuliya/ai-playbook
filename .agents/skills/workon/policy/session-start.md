# Session start

Run once per activity per session, before the first read or write of its
files. Skip it under query mode, while a pipeline is in flight, and for
`help`. It touches only `.dev-notes/activities/<slug>/`.

Run one read-only shell call:

```bash
d=.dev-notes/activities/<slug>; ls -A "$d" "$d/artifacts"; head -n 14 "$d/activity.md"; rg -n '^# References|^\| synced \||^[0-9]+\. (\[.\]|removed:)|^## R[0-9]+:|\b(UR|SR|RRD)[0-9]+\b' "$d" --glob '*.md' --glob '!artifacts/**'; rg --files-without-match '^## Problem:' "$d/requirement-def.md"; [ -f "$d/design.md" ] && rg -n '^- DC[0-9]|^### DD[0-9]' "$d/design.md"; rg -n '^- (\[[ xX]\] )?M[0-9]+:|^[[:space:]]*- reads:' "$d/activity.md"
```

The `head` output is the metadata table, so the first read of `activity.md`
is often unnecessary. Then fix gaps in one batched step (**Fewer prompts**):

- **Missing notes file:** create it with its H1 only. `requirement-def.md`:
  `# Requirement Definition`. `design-choices.md`: `# Design Decisions`.
  `conventions.md`: `# Conventions` plus the empty `## Setup, build, test and
  install notes`. `notes-by-user.md`: `# Notes by User`. `references.md`:
  `# References`. Missing `design.md` is a legacy marker (below), not a
  plain gap; do not create it here.
- **Missing row:** add its default. `conventions`: `ok` when the status is
  `Active`, `Paused`, `Blocked`, or `Complete`, else `pending`.
  `review-comments`: `off` when `Complete`, else `on`. `base-branch`: `main`
  (tell the user once). `stage`: `design`. A missing `status`, `slug`,
  `branch`, `ticket`, or `notes` row has no default; ask for it.

**Legacy markers.** Read `repair.md` and follow it before anything else when
any of these shows:

- a file named `notes.md`, `user-notes.md`, `requirements.md`, or
  `user-guide.md`, or `artifacts/self-review.md` or `artifacts/self-review/`;
- `design.md` missing while `requirement-def.md` exists (pre-design-document
  layout);
- a line from the `rg` hits: a `# References` heading, a `synced` row, a
  numbered milestone, an `R<n>` heading, or a `UR`, `SR`, or `RRD` ID;
- `requirement-def.md` listed as having no `## Problem:` heading;
- `plan-outline.md` missing while `stage` is `design` and the status is not
  `Complete`;
- `design.md` has a `^- DC` line and no `^### DD` line;
- `stage` is `design`, and a milestone line is not `TBD (design stage)` or
  `removed`, and no `reads:` line appears before the next milestone or `#`
  heading.

With no marker, go on.
