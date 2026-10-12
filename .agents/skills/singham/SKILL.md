---
name: singham
description: >-
  Evidence-based verification of agent completion claims, user-claimed tasks, and
  factual statements in files via a fresh general-purpose verifier sub-agent.
  Use when the user invokes singham, asks to verify claims/tasks/docs, or wants a
  pass/fail verdict with suggested fixes.
disable-model-invocation: true
---

# Singham

Verify claims against reality. Parent extracts a **claims-only** package and
launches **exactly one** fresh general-purpose verifier sub-agent. Trust only
observed commands/reads. Do not rubber-stamp summaries. Do not verify in the
parent session (avoids self-verification bias). Sub-agent terms map to your
harness per `.agents/rules/dev-main.md` (harness-neutral terms).

Sub-agent prompt shapes, package schema, return schema, resume payload:
[subagent-contract.md](subagent-contract.md).

## Roles

| Role | Owns |
|------|------|
| **Parent** | Claim extraction, candidate confirm (escape hatch), verifier launch/resume, grill via `grill-me`, integrity gate, final Singham verdict |
| **Verifier** | Run checks, fill Expected/Actual/Evidence/Status, suggest in-line edits for FAILs — no user dialogue, no file writes |

## Workflow

```
Progress:
- [ ] 1. Resolve claim set (user-named → else last assistant turn → escape hatch)
- [ ] 2. Build claims-only package (no done-narrative)
- [ ] 3. Launch exactly one verifier sub-agent (inherit model unless user named one)
- [ ] 4. Integrity gate on return
- [ ] 5. If BLOCKED rows need policy: grill (parent), then at most one resume
- [ ] 6. Deliver Singham verdict; do not apply edits
```

### 1. Resolve claim set

Priority:

1. User-named claims, files, or checklist items
2. Else: checkable assertions from the **last assistant turn** only (completion / “done” summary)
3. **Escape hatch:** if that yield is empty, huge, or too vague → list candidate claims and confirm with the user **before** launching the verifier (use `grill-me`: one question, recommended answer)

Skip pure opinions and unstated future work unless the user asks.

Cover all kinds that apply:

| Kind | Source | Question |
|------|--------|----------|
| agent | Assistant results, paths created, commands said to succeed | Did this happen / is it true? |
| user | Explicit checklist, “we have X”, acceptance criteria | True in the workspace? |
| file | Guides, READMEs, skills, comments, scripts | Live tree/build/test matches? |

Extract concrete assertions only (paths, commands, exit codes, contents, counts,
exists, builds, tests pass).

### 2. Claims-only package

Build the package per [subagent-contract.md](subagent-contract.md). Include:

- Absolute **repo root**
- Numbered claims: kind, claim text, expected observation, optional check hint
- **Do not** paste the agent’s done-narrative or prior chat justification

### 3. Launch verifier

Exactly one sub-agent:

- general-purpose
- foreground unless the user asked for background
- description / label: `Singham verifier`
- inherit the model unless the user explicitly requested one
- Prompt: self-contained; paste claims package + contract rules (verifier does not see parent chat)

### 4. Integrity gate

Trust PASS/FAIL when each row has Expected, Actual, and Evidence (command or read + key result).

If a row lacks evidence or Actual is hand-wavy (“looks fine”, “should work”):

- Downgrade that row to **BLOCKED** (do not silently keep PASS)
- Do not re-run the full check set in the parent

### 5. Grill → one resume

When BLOCKED rows need judgment/policy (vague claim, env failure unrelated to claim, ambiguous file fact, user vs agent conflict):

1. Parent explores only if a quick read resolves it without the user
2. Else grill via `grill-me` (one question at a time, recommended answer); batch answers
3. **At most one** resume of the same verifier with the clarification payload (no resume in the harness → one fresh verifier with the original package plus clarifications)
4. Leftover ambiguity stays **BLOCKED** in the final verdict

### 6. Verdict (required)

Publish the structure below. Prefer the verifier’s table after the integrity gate;
parent may adjust Overall and BLOCKED rows only as above.

```markdown
## Singham verdict

**Overall:** PASS | FAIL | BLOCKED | MIXED

### Claims
| # | Kind | Claim | Expected | Actual | Status |
|---|------|-------|----------|--------|--------|
| 1 | agent/user/file | … | … | … | PASS/FAIL/BLOCKED |

### Evidence
- Claim 1: `<command or read>` → `<key output / exit code>`
- …

### Suggested edits
For each FAIL: path, old → new (or concrete snippet), why (which claim).
```

**Overall:** any FAIL → FAIL; else any BLOCKED with no PASS → BLOCKED; else
PASS+BLOCKED → MIXED; all PASS → PASS.

Do **not** apply suggested edits unless the user explicitly asks after the verdict.

## Evidence rules (parent must enforce on the verifier)

1. **Run or inspect** — run commands, read and search files as needed
2. **No credit without evidence**
3. **Match expectation** — PASS only on match
4. **Allowed commands** — read-only inspection always OK; also run the **exact** build/test/make (or equivalent) the claim asserts. No commit, push, delete, or unrelated write. Do not invent a second test suite
5. **Live tree wins** over docs for structure facts; doc mismatch = FAIL file-fact + suggest edit

## Anti-patterns

- Parent verifying instead of the verifier sub-agent
- Dumping chat/done-narrative into the verifier prompt
- Passing because the agent “would have” done it
- Fan-out of multiple verifier agents
- Full parent re-verify of every check
- Silent fixing during verification
- Unbounded grill/resume loops
- Style FAILs with no stated expectation

## Examples

**Agent claim:** “Added `.dev-notes/dev-guides/span/pkg/idgen/dev-guide.md`.”
- Expect: file exists and is non-empty
- Check: `test -f … && wc -l …`
- PASS only if present

**User claim:** “`make slang-dbg` succeeds in this environment.”
- Run: `make slang-dbg` from repo root
- PASS only on exit 0

**File fact:** Guide says `genir.cpp` is built by CMake.
- Read `slang/CMakeLists.txt` `add_executable` list
- FAIL if absent; suggest guide wording fix
