# Sub-agent contract (singham)

Parent pastes a **self-contained** Task prompt. The verifier does not see the
parent chat. Return **only** the structured result below — no preamble.

## Shared rules (verifier)

- Work only the claims in the package; do not invent new acceptance criteria
- Prefer the check hint on each claim; otherwise choose the minimal observation
  that would confirm or refute Expected
- **Allowed commands:** Read / Grep / Glob / `ls` / `test` / `rg` / similar
  read-only inspection always OK. Also run the **exact** build/test/make (or
  equivalent) a claim asserts. No commit, push, delete, or other writes. Do not
  invent extra test suites beyond the claim
- PASS only when Actual matches Expected with cited Evidence
- If you cannot decide without user policy input, mark **BLOCKED** and state
  what question the parent should ask — do not guess PASS/FAIL
- Suggest in-line edits for each FAIL; do not apply them
- Parallelize independent checks when safe

## Claims package (parent → verifier)

Parent includes this block verbatim in the Task prompt:

```markdown
## Singham claims package

- **Repo root:** `/absolute/path/to/repo`
- **Source of claims:** last-assistant-turn | user-named | confirmed-candidates

### Claims
| # | Kind | Claim | Expected | Check hint |
|---|------|-------|----------|------------|
| 1 | agent | … | … | e.g. `test -f path` |
| 2 | user | … | … | e.g. `make …` |
| 3 | file | … | … | e.g. `rg -n … file` |
```

Kind is exactly one of: `agent` | `user` | `file`.

## Initial Task prompt skeleton

```text
You are the Singham verifier. Read and follow the singham subagent contract
rules in this prompt. Verify every claim against the live workspace. Do not
write files. Do not ask the user questions — mark BLOCKED instead.

Repo root: <absolute path>
Working directory for commands: <absolute path>

## Contract rules
<paste Shared rules (verifier) from subagent-contract.md>

## Singham claims package
<paste package>

## Required return
Return ONLY the Verifier result markdown from the contract (Claims table,
Evidence, Suggested edits, Blockers for parent). No preamble.
```

Launch: `subagent_type: generalPurpose`, `description: "Singham verifier"`,
`run_in_background: false` unless the user asked for background. Model: inherit
unless the user explicitly named a listed model.

## Verifier result (required return)

```markdown
## Verifier result

**Overall:** PASS | FAIL | BLOCKED | MIXED

### Claims
| # | Kind | Claim | Expected | Actual | Status |
|---|------|-------|----------|--------|--------|
| 1 | agent/user/file | … | … | … | PASS/FAIL/BLOCKED |

### Evidence
- Claim 1: `<command or read>` → `<key output / exit code>`
- …

### Suggested edits
- Claim <n>: `path` — old → new (or snippet); why

### Blockers for parent
- Claim <n>: <question parent should grill the user with> | none
```

**Overall:** any FAIL → FAIL; else any BLOCKED → BLOCKED if no PASS, else MIXED;
all PASS → PASS.

## Resume payload (parent → same verifier, at most once)

After parent grilling, resume the **same** agent once:

```text
Singham resume — clarifications from the user. Re-check only BLOCKED claims
(and any claim whose Expected changed). Update the Verifier result. Still no
file writes. Still no user questions — leftover ambiguity stays BLOCKED.

### Clarifications
| Claim # | User answer | Updated Expected (if any) |
|---------|-------------|---------------------------|
| n | … | … or unchanged |
```

## Integrity gate (parent, after return)

For each Claims row:

- Missing Evidence, or Actual is vague (“looks fine”, “should work”) → set Status
  to BLOCKED before publishing
- Do not re-run the full check set in the parent
- Publish the Singham verdict from the gated table; do not apply Suggested edits
  unless the user asks after the verdict
