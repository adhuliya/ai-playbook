# `conventions.md`

H1: `# Conventions`. Target ≤ ~500 words; rewrite in place. Commands stay
exact; when over budget, trim rules before commands.

It has two H2 kinds. `## CONV<n>: <short title>` entries are binding
**rules**: a living list, not a decision log. `## Setup, build, test and
install notes` holds the commands, cwd, and toolchain for this activity.
Each fact lives in one place: do not duplicate into `activity.md`, do not
duplicate rules into Setup, and do not put commands only in rules or
constraints only in Setup.

For this activity, the rules take precedence over project and repo
conventions, style guides, and agent rules (`AGENTS.md`, `.agents/rules/`,
tool-specific rule files) where they conflict. Workon **Stops**, safety,
and git safety still win. Where the rules are silent, repo rules apply.

**Rules** have 2–5 bullets each and use `replaces: CONV<n>` only when
splitting or renaming. Seed them from observed repo and activity facts; no
taste-only rules, and no forced conventions interview in Planning. Write
them without a keyword while `conventions: pending` (planning grill,
`conventions-ok`), and for rules the agent observes and the user confirms.
Once `conventions: ok`, an explicit user add or rewrite needs
`update-convention`; on detected intent, prompt it. Rewrite in place when a
newly confirmed rule contradicts or tightens an entry, and never tighter
than the user stated. To drop a rule, mark it `superseded` on request; do
not delete (except a `fix-activity` prune).

**Setup** is always a best-effort draft that the user corrects. It is the
env-agent bootstrap: the env agent reads it and never writes it.

**Isolated setup:** for quick tests and activity env setup, do not install
into or change the system unless the user asks. Use path-redirect sandboxes
(e.g. `bwrap` bind mounts on Linux), local prefixes, virtual envs, or
`PATH`-style overrides to test a package or library without disturbing the
system. Record the method in Setup.

User sign-off of rules and Setup is `conventions-ok` (**Execution gate**).
