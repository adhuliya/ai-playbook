---
name: optimize-tokens
description: Reduce token usage while preserving clarity and required constraints. Optimize responses, rules, prompts, and skills by removing repetition and centralizing repeated policy. Use when the user asks to shorten output, compress instructions, or improve token-to-information efficiency.
disable-model-invocation: true
---

# Optimize Tokens

Goal: keep all meaning and constraints, remove repetition, and stay easy to read.

Balance the two. If shortening text makes it unclear, keep it clear even if it costs a few tokens. Clarity always wins over saving tokens.

## Never remove

1. Safety warnings, acceptance criteria, or required constraints.
2. Exact names: API names, function names, commands, flags, schema names, and exact error strings. Copy them character-for-character.

## Steps

Do these in order.

1. Cut filler words. Examples:
   - "It is important to note that" -> delete the whole phrase.
   - "In order to" -> "To".
   - "at this point in time" -> "now".
2. Make weak wording firm. Pick one clear meaning:
   - "should generally" -> "should" or "must".
   - "try to" -> "do" or "do not".
3. Merge duplicate bullets. If two bullets say the same action, keep one. Keep the more specific wording.
4. Use one word for one thing. Do not mix "user", "customer", and "client" for the same idea. Choose one and use it everywhere.
5. Keep only examples that teach something new. Delete examples that repeat a pattern already shown.
6. Centralize repeated policy. See below.

## Centralize repeated policy

Do this only when the same decision rule appears in 2 or more places.

1. Create one section named "Decision Policy" (or "<Topic> Policy").
2. Move the full decision rule into that section.
3. In each place that used the rule, replace it with this sentence:
   Apply the rules in the "Decision Policy" section.
4. Leave the local sections with their own steps only. Do not repeat the policy.

## Before and after examples

Verbose response -> concise response:
- Before: "I can certainly help you with that task. What I would like to do first is inspect the repository so I can better understand the implementation before proceeding."
- After: "I'll inspect the repository first, then apply the changes."

Scattered policy -> one shared section:
- Before: The Intake, Execution, and Validation sections each explain the same branch-selection logic.
- After: One "Branch-Selection" section holds the logic. The other sections say: Apply the rules in the "Branch-Selection" section.

## Check before finishing

- No safety warning or required constraint was removed.
- Every "Apply the rules in ..." sentence points to a section that exists.
- No policy is written in two places.
- The text is shorter and still clear on one read.
