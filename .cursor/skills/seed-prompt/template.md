# Seed prompt file template

**Where the project stores it:** `.dev-notes/seed-prompt.md` (create `.dev-notes/`
if missing).

**How it is used:** the user copies the **entire file** into a new agent session.
That single paste is the only context—the original repo is left behind.

The seed body MUST be fully self-contained. Do not tell the rebuilder to read
other files from the old project; inline every rebuild-critical fact here.

```markdown
# Seed prompt — recreate <project name>

You are rebuilding this project from scratch. **This message is the only spec**
you have—do not assume access to any other repository, file, or prior chat.

Paste into a fresh empty repo / agent session. Goal: <one sentence — what “done” looks like>.

## What it is

<2–4 sentences: product vs tooling, who it is for, what problem it solves.
Include vision/scope/terms here—do not point at an external definition doc.>

## Stack and constraints

- **Runtime / toolchain:** <languages, versions, OS assumptions if any>
- **Build system:** <make, cmake, go modules, … — or “none”>
- **Dependencies:** <how to obtain; pin only what breakage requires>
- **Explicit non-goals:** <what a rebuilder MUST NOT add unless asked>

## Repository layout

<ASCII tree of paths the rebuilder will create — selective, not every file.
List `.dev-notes/` or dev-guides only if the seed agent must create them; describe
their role in this section, not via “see existing repo”.>

## Behavior contract

<Authoritative rules: CLI, APIs, sync semantics, invariants, errors — everything
testable without opening another document.>

## Build / test / run

<Exact commands; no “run make help in the original repo”.>

## Bootstrap order

1. <First step — e.g. init git, create empty dirs from layout>
2. <…>
3. <Each step names deliverables that exist when the step is done>

## Agent / Cursor assets (if any)

<What to create under `.cursor/` etc.; inline critical rule/skill behavior or
minimal verbatim excerpts in this file—do not say “copy from the old repo”.>

## Verification

<Commands + expected outcomes in the new empty workspace.>

## Out of scope for the seed agent

<Deferred work; must not be required to claim “done”.>
```

### Quality bar

- **Single-file test:** if this markdown were the user’s only message, rebuild
  could still complete.
- Every **Behavior contract** and **Bootstrap** item is checkable.
- Prefer **SHALL / MUST NOT** for hard rules; **SHOULD** for defaults.
- No dates. No “see repo / definition / dev-guide”.
- When authoring from a live tree, **embed** facts from that tree; the rebuilder
  never sees the tree.
