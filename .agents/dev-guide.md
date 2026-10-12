# .agents -- Dev-Guide

Agent rules and skills shared by Cursor, Codex, and Claude Code. Installed by
ai-playbook sync; edit them in the playbook, not in a target repo.

## Notes

- **Always-on rules (MUST):** at the start of every session, read and follow
  every `.agents/rules/*.md`. They apply to all work in this repo.
- **Skills:** each `.agents/skills/<name>/SKILL.md` starts with `name` and
  `description` frontmatter. When a task matches a description, or the user
  names a skill (e.g. "iloop", "workon"), read that `SKILL.md` and follow it.
  Cursor and Codex list these natively; other agents read them on demand.
- Paths inside a skill (templates, `scripts/`) resolve from that skill's folder.
- Subagents: `.claude/agents/*.md` (Claude Code, Cursor) and
  `.codex/agents/*.toml` (Codex). Cursor-only extras (hooks) live in `.cursor/`.

## Artifacts

| Name | Description |
|------|-------------|
| `.agents/rules/` | Always-on rules (plain markdown) |
| `.agents/skills/` | On-demand skills (Agent Skills format) |
