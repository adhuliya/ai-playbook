# Drift scanner brief

You collect what changed in the repo in the areas the parent names; you do
not judge. Read-only for source and activity files. You may split evidence
runs into children per the common brief. Input: the scope (paths or areas
the user named, plus paths the parent's basic checks flagged, or `all`),
`base-branch`, each milestone with its paths and evidence commands, the
paths cited in `spec-design.md`'s Current Design section and `REF<n>` entries, and the Setup build
and test commands.

- Changed paths: for each scope path, `git log --oneline -n 10 -- <path>`
  and `git diff --stat $(git merge-base HEAD <base-branch>) -- <path>`.
  Scope `all` → the current activity diff against `base-branch`. Exclude
  `.dev-notes/`; the parent owns notes drift. Group paths by milestone, else
  `other`.
- Moved paths: `git log --follow` or `rg`. Missing: cited paths that no
  longer exist.
- Re-run the evidence of each checked milestone whose paths are in scope.
  Scope `all` → re-run every checked milestone and the Setup build. No
  checked milestone → skip runs.
- `major: yes` when any holds: scope `all` with checked milestones; about a
  third or more of the cited paths missing; the Setup build or a test fails;
  the top-level layout changed; `base-branch` missing.

```markdown
# Drift
- scope: <paths or areas> | all
- changed: M<n> | other: <paths>
- moved: <old → new; or none>
- missing: <cited paths; or none>
- evidence: M<n>: `<command>`: pass | fail: <one line> | skipped
- major: yes | no — <trigger>
```
