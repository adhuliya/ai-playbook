---
name: seed-prompt
description: >-
  Create or refresh .dev-notes/seed-prompt.md as a single self-contained file an
  agent can paste elsewhere to recreate the project with no other context. Use when
  the user asks to update the seed prompt, rebuild DNA, recreate-from-scratch
  instructions, or invokes seed-prompt.
disable-model-invocation: true
---

# seed-prompt

## Core invariant: single-file independence

The **body** of `.dev-notes/seed-prompt.md` is the entire handoff. A user may
copy **only that file** into a new agent session and leave the original project
behind. The receiving agent has **no** other files, links, or repo access.

- **Storage** (where the project keeps the seed): `.dev-notes/seed-prompt.md`.
  Create `.dev-notes/` if missing when you write it.
- **Consumption** (how it is used): paste the full file contents as the user’s
  prompt. Nothing else is required—not `.dev-notes/`, not dev-guides, not git
  history.

While authoring, you MAY read the live repo and optional `.dev-notes/` / dev-guides.
**None of that may be required reading for the rebuilder**—distill anything
rebuild-critical **into the seed text**.

Run from the **target git repo root**. Do not edit playbook hub copies unless you
are inside the ai-playbook repo’s own `.dev-notes/`.

---

## When to run

- User explicitly asks to create, update, or refresh the seed prompt.
- Major architecture or bootstrap path changed and the user wants rebuild docs synced.
- **Do not** auto-update on every small commit.

---

## Inputs (read before writing)

Use the **live repo tree** as the primary source. Other inputs are **optional**
— read only if the path exists; never fail or stall because `.dev-notes/` or
`dev-guide.md` files are missing.

| Source | Use |
|--------|-----|
| Live repo tree | Layout, entrypoints, actual commands (always) |
| `README.md` | User-facing setup if present and accurate |
| Build files (`Makefile`, `go.mod`, `CMakeLists.txt`, …) | Commands and constraints |
| `.cursor/` / overlays | Agent assets contract if present |
| `.dev-notes/definition.md` | Source material only — **must be inlined** into seed, not referenced |
| `dev-guide.md` (any path) | Hints only — **must be inlined**, not referenced |

Never invent policy. If rebuild scope is unclear, ask once (recommended default:
“minimal bootstrappable skeleton” vs “full feature parity”).

---

## Output rules

1. **Single deliverable:** write or update `.dev-notes/seed-prompt.md` only (create
   `.dev-notes/` if needed). Do not create other files unless the user explicitly
   asked as part of this task.
2. **Format:** Follow [template.md](template.md). Fill every section; delete a
   section only if truly N/A and say so in one line under it.
3. **Self-contained (REQUIRED):** The seed file alone must be sufficient. The
   rebuilder MUST NOT need to open any path, URL, or sibling document from the
   old project.
4. **Concise but complete:** Target roughly **80–200 lines**; hard stop ~300.
   Prefer trees and bullet contracts over prose. If a rule is essential, **embed it**;
   do not point at where it lives today.
5. **No dates** in the seed file.
6. Source docs (`definition.md`, dev-guides, README) are inputs to **you** while
   writing—not dependencies for the reader of the seed.

### Forbidden inside the seed file body

The receiving agent only sees this file. The seed body MUST NOT:

- Say “see `.dev-notes/…`”, “read `definition.md`”, “open the dev-guide”, or
  “refer to the repo”.
- Use relative links or paths as **substitutes** for missing content (paths in
  the **layout tree** or bootstrap deliverables are fine).
- Assume the rebuilder has sync, git remote, or playbook access unless the seed
  defines that setup from zero.
- End with “ask the user for the rest” for core behavior—inline the contract.

Allowed: repo-rooted paths **as names of files the rebuilder will create**;
verbatim command lines; short inlined excerpts of critical config or rule text
when size allows; “omit X unless user asks” in **Out of scope**.

---

## Authoring guidelines (well-defined seed)

### Goal clarity

- Open with **one sentence** stating what “recreated” means (playbook vs app vs paper).
- State **in scope** and **out of scope** for the *seed agent* separately from the
  product’s long-term scope.

### Layout

- ASCII tree to **depth that matters** (top level + key subtrees).
- Each path line: **role**, not a file listing.
- Mark generated/gitignored dirs as such.
- Include `.dev-notes/` and `<path>/dev-guide.md` **only if** the live project
  uses them; otherwise state that dev-notes and/or guides are out of scope for
  the rebuild (or are a later optional step).

### Behavior contract

Capture **testable** rules the rebuilder must implement:

- CLI / API surface (flags, subcommands, env vars).
- Idempotency, failure modes, conflict handling.
- Invariants (e.g. “single sync entrypoint”, “proto is source of truth”).
- Integration between major components (pipeline one-liner + data format).

Avoid vague “handle errors appropriately”. Say what to print, skip, or exit.

### Build / test / run

- Commands copy-pasted from the live tree (or `make help` output).
- Name **one** primary dev build and **one** primary test entry.
- Note filesystem assumptions (hard links, same volume, docker, etc.) if real.

### Bootstrap order

- Numbered steps: **order matters**.
- Each step: deliverable (e.g. “`scripts/foo.sh` exists and passes `--help`”).
- Last step should align with **Verification**.

### Verification

- Concrete checks: shell commands + expected files or exit code 0.
- For libraries/apps: smallest command that proves the core path works.

### Agent assets

- If the project uses Cursor rules/skills/hooks, specify **which dirs sync or
  copy** and overlay precedence — same level of precision as product behavior.

### Anti-patterns

- Tutorials, narrative history, or journal entries.
- Pointers to the source repo instead of inlined contract.
- Pinning every dependency version without reason.
- Promising CI, packaging, or features the live repo does not have.
- Splitting instructions across “also read file X” outside this seed.

---

## Workflow

```
Progress:
- [ ] 1. Confirm rebuild scope with user if ambiguous
- [ ] 2. Read inputs (live tree first; optional .dev-notes / dev-guides if present)
- [ ] 3. Draft or update `.dev-notes/seed-prompt.md` from template.md
- [ ] 4. Self-review: cold-start agent checklist (below)
- [ ] 5. Show summary of what changed; stop (no other files unless creating `.dev-notes/`)
```

### Independence test (REQUIRED before finish)

Imagine the seed copied to `/tmp/seed-prompt.md` with **no** other files and **no**
conversation history from this project. Ask:

- Is every rule, layout role, and command the rebuilder needs **inside** the seed?
- Would “see definition / dev-guide / README” appear anywhere? (If yes, fix.)
- Can verification run as written in an empty directory after bootstrap steps?

If not, add the missing text to the seed—never add another file dependency.

---

## Maintainer-only: other docs in the source repo

These may exist while you author; they are **not** part of the handoff:

| Doc | Role for you |
|-----|----------------|
| `.dev-notes/definition.md` | Mine for vision/terms; inline into seed |
| `<path>/dev-guide.md` | Mine for layout/commands; inline into seed |
| `.dev-notes/journal.md` | Never copy into seed |

After a material bootstrap change, suggest the user run this skill; do not auto-run.

---

## Scaffold note

Projects synced via ai-playbook **may** receive a stub from
`artifacts/dev-notes-structure/seed-prompt.md` when live-notes are scaffolded.
Many repos have no `.dev-notes/` until then. Replace the stub with a full seed
using this skill when asked.
