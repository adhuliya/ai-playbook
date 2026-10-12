# Requirement words

| Word | Meaning |
|------|---------|
| MUST / REQUIRED / SHALL | Absolute; always do |
| MUST NOT / SHALL NOT | Absolute; never do |
| SHOULD / RECOMMENDED | Strong default; skip only with a valid documented reason |
| SHOULD NOT / NOT RECOMMENDED | Strong avoid; only if necessary |
| MAY / OPTIONAL | Truly optional |

Examples: MUST validate input. SHALL NOT share private user data. SHOULD use plain words. MAY suggest extras when useful.

# Disclose assumptions (MUST)

When answer or work rests on something the user did not say, you MUST name those beliefs. List every **load-bearing** assumption — anything that would change recommendation, implementation, or scope if wrong.

**Grounded (do not list):** explicit user instructions; text read this turn from repo, guide, rule, skill, or tool output; facts that follow directly from that evidence.

**Assumption (MUST list):** anything else treated as true to proceed — guessed intent, unstated preferences, default scope (“only this file”), environment (“they use X”), priorities, naming or API choices not specified, interpretation of ambiguous wording, or “typical” project behavior not verified this session.

**How:** End the user-facing reply with a short **Assumptions** section: bullets, one plain sentence each. Omit only when every decisive step was user-stated or evidenced above. Question-only replies with one obvious reading and no branching MAY omit; if you chose among interpretations or filled gaps, you MUST include it.

Do not bury assumptions in prose; the section is the checklist the user scans at every reply.

# .dev-notes directory

If present, use for context. Do not invent policy. Do not bulk-read.

**Start:** `definition.md`, `vocabulary.md` (if present), `README.md` (if any), `journal.md`.

**Vocabulary (MUST):** If `.dev-notes/vocabulary.md` exists, read it with the startup set. Use its **Term** values (including multi-word phrases) in user-facing prose, docs, and naming; prefer that vocabulary over generic synonyms unless the user overrides.

**As needed:**

| Path | When |
|------|------|
| `vocabulary.md` | Maintained via `build-vocabulary` skill (explicit invoke) |
| `knowledge/` | Domain knowledge trees; navigate via `knowledge` skill |
| `artifacts/` | Stored artifacts (cited from docs) |
| `activities/` | `workon` context |
| `learning/` | `skillup` context; if `learning/skillup.dir.txt` exists, that relative path is the actual learning root |
| `seed-prompt.md` | Recreate-from-scratch DNA (update only via `seed-prompt` skill) |

`journal.md`: append only via `journal` when asked. Guide create/rewrite/audit/delete: `dev-guides` skill only (explicit request).

# Live tree wins

Repo source tree is source of truth. If a guide disagrees on specifics, trust the tree (see "Keep guides fresh" for upkeep duty).

# Read guides (no `dev-guides` skill)

Open guides yourself — never invoke `dev-guides` only to read.

**Trigger (MUST):** Before you modify or add files under project path `P`, read the deepest matching `dev-guide.md` for `P` if one exists. Trivial single-file lookup does not require this.

**Find for path `P`:** `<P>/dev-guide.md`, else walk up (`a/b/c` → `a/b` → `a`), else repo-root `dev-guide.md`. Sparse is normal. Do not auto-open root/siblings. Re-open when the subtree changes and needs its guide.

**Use:** summary, **Notes** (invariants, build/test, gotchas), and **Artifacts** table. Repo-root guide uses the same shape; it does not restate vision (see `definition.md` — link from Notes).

**Other guides:** When Notes or the artifact table names repo path `Q`, open `<Q>/dev-guide.md` if you need that subtree. Otherwise walk up ancestors.

# Keep guides fresh (MUST)

If your change makes a `dev-guide.md` factually wrong — renamed/moved/deleted path in Notes or Artifacts, changed build command, stale table row — you MUST fix it in the same change. For material drift (placement, hierarchy, or what the guide is for), do not rewrite here: note it for the `dev-guides` skill.

# Sub-agents (SHOULD)

For specialized or parallel work, SHOULD launch sub-agents with a self-contained prompt (they never see the parent chat). Keep the parent for orchestration, synthesis, and user talk. MUST NOT spawn agents for a few local tool calls. MUST NOT let parallel sub-agents contend for the same resource.

# Harness-neutral terms

Skills and rules here use these terms. Map each to your harness (Cursor, Claude Code, Codex, …); if a name differs, use the equivalent.

| Term | Meaning | Cursor | Claude Code | Codex |
|---|---|---|---|---|
| launch a sub-agent | Start an isolated agent with a self-contained prompt | `Task` tool | `Agent` tool (formerly `Task`) | `spawn_agent` |
| general-purpose | Default agent type with full tools | `generalPurpose` | `general-purpose` | default agent |
| named sub-agent `<x>` | A defined agent such as `spell-check` | `.cursor/agents/` or `.claude/agents/` | `.claude/agents/` | `.codex/agents/` |
| background | Parent continues without waiting | `run_in_background: true` | `run_in_background: true` | spawn, don't wait |
| foreground | Parent blocks until it returns | `run_in_background: false` | default | spawn, then `wait` |
| resume | Follow-up to the same sub-agent | `resume` | resume by agent ID | `send_input` |
| inherit model | Sub-agent uses the parent's model | `model: inherit` | omit `model` | omit `model` |
| ask the user | Structured question if available, else plain chat | `AskQuestion` | `AskUserQuestion` | ask in chat |
| run / read / search | Shell commands, file reads, code search | `Shell`, `Read`, `Grep`, `Glob` | `Bash`, `Read`, `Grep`, `Glob` | shell (`rg`, `sed -n`, …) |

Fallbacks when the harness lacks a capability: no sub-agents → do the work inline in the same order and still write the same output files; no background → launch in parallel and wait; no resume → launch a fresh sub-agent with the original prompt plus the follow-up.
