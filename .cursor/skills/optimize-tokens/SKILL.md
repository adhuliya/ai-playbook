---
name: optimize-tokens
description: Reduce token usage while preserving clarity and required constraints. Optimize responses, rules, prompts, and skills by removing repetition and centralizing repeated policy. Use when the user asks to shorten output, compress instructions, or improve token-to-information efficiency.
disable-model-invocation: true
---

# Optimize Tokens

Single operating mode: balanced compression for clarity and token efficiency.

Goal: keep meaning and constraints, remove repetition, stay human-readable.

## Non-negotiables

1. Never remove safety warnings, acceptance criteria, or required constraints.
2. Keep API names, function names, commands, flags, schema names, and exact error strings verbatim.
3. If wording becomes ambiguous, rewrite for clarity even if it costs a few tokens.

## Deterministic workflow

1. Detect repetition:
   - Same policy/decision appears 2+ times.
   - Same instruction appears with minor wording changes.
2. Centralize policy:
   - Create one canonical section: `## Decision Policy` (or `## <topic> Policy`).
   - Move complete decision logic there.
3. Replace duplicates:
   - Use: `Apply the rules in \`Decision Policy\`.`
4. Tighten local sections:
   - Keep only section-specific actions.
   - Remove repeated policy text.
5. Validate:
   - Every reference resolves to a real section.
   - No required rule was removed.
   - No duplicate policy blocks remain.

## Rewrite rules (in order)

1. Remove filler:
   - `It is important to note that` -> remove
   - `In order to` -> `To`
   - `at this point in time` -> `now`
2. Replace weak modality:
   - `should generally` -> `should` or `must` (choose explicitly)
   - `try to` -> `do` or `do not`
3. Merge overlap:
   - Merge bullets expressing the same action.
   - Keep the most specific wording.
4. Keep terminology canonical:
   - Use one term consistently (`skill`, not `skill/tool/helper` mix).
5. Keep only high-value examples:
   - Keep examples only when they show a unique transformation pattern.

## Policy centralization pattern

Trigger:
- A decision rule appears in 2+ places.

Implementation:
1. Add `## Decision Policy`.
2. Move decision conditions into that section.
3. Replace duplicates with `Apply the rules in \`Decision Policy\`.`
4. Keep local sections focused on execution steps only.

## Examples

Example 1 - verbose response -> concise response
- Before: "I can certainly help you with that task. What I would like to do first is inspect the repository so I can better understand the implementation before proceeding."
- After: "I'll inspect the repository first, then apply the changes."

Example 2 - scattered policy -> centralized policy
- Before: Intake, Execution, and Validation each restate branch-selection logic.
- After: One `## Branch-Selection` section; dependent sections use `Apply the rules in the \`Branch-Selection\` section.`

## Final quality gate

- Required constraints and safety text preserved.
- Repeated policy centralized or intentionally kept with a documented exception.
- References valid and unambiguous.
- Text is shorter, clearer, and quick to scan.

