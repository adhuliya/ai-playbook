# Drift scanner brief

You collect what changed in the repo since the activity's `synced`
baseline; you do not judge. Read-only for source and activity files. You
may split evidence runs into children per the common brief. Input: the
baseline mode, the `synced` commit and its base, the fresh snapshot
`<now>`, `base-branch`, each milestone with its paths and evidence
commands, the paths cited in `# Current Design` and `REF<n>` bullets, and
the Setup build and test commands.

- Changed paths, by baseline (exclude `.dev-notes/`; the parent owns notes
  drift): `ok` → `git diff --name-status <synced> <now>`; `rewritten` →
  compare `git diff --name-status $(git merge-base <synced> <base-branch>)
  <synced>` with the current activity diff, report paths whose activity
  changes differ, and ignore upstream-only changes; `none` → the current
  activity diff against `base-branch`. Group paths by milestone, else
  `other`.
- Moved paths: `git log --follow` or `rg`. Missing: cited paths that no
  longer exist.
- Re-run the evidence of each checked milestone whose paths changed.
  Baseline `none` with checked milestones → re-run every checked milestone
  and the Setup build. No checked milestone → skip runs.
- `major: yes` when any holds: baseline `none` with checked milestones;
  baseline `rewritten` and most activity paths changed; about a third or
  more of the cited paths missing; the Setup build or a test fails; the
  top-level layout changed; `base-branch` missing.

```markdown
# Drift
- baseline: ok | rewritten | none
- range: <synced>..HEAD + uncommitted
- changed: milestone <n> | other: <paths>
- moved: <old → new; or none>
- missing: <cited paths; or none>
- evidence: milestone <n>: `<command>`: pass | fail: <one line> | skipped
- major: yes | no — <trigger>
```
