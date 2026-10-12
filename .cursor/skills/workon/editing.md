# Editing the workon skill

Read this before you change any file in this directory.
This file is for editors of the skill.
Do not load it while you run an activity.

`SKILL.md` is the hot file. It is loaded on every workon turn.
Every other file is loaded only when a step names it.

## Hot file

Keep a rule in `SKILL.md` when a missed rule would make an ordinary command wrong.
That set is the stops, the session probe, the gates, and the journal.
It also holds `activity.md`, IDs, writing style, the command map, the index, Reads, and command isolation.

Put a procedure in another file when only some commands need it.
Name that file from the command heading, from Reads, or from the step that uses it.

## Where a change goes

| Change | File |
|---|---|
| Keyword steps | The command file that owns that keyword |
| Create, derive, replan, cited context | `planning.md` |
| RD, design decisions, conventions, legacy repair | `notes-files.md` |
| Review cycles and apply timing | `review-policy.md` |
| Test tiers, engineering, comment levels | `building.md` |
| Launch, paths, pipelines, output fields | `subagent-contract.md` |
| Record shapes | `templates.md` |

Command files are `commands-lifecycle.md`, `commands-review.md`, `commands-upkeep.md`, and `commands-help.md`.
Read only the heading for the keyword you are changing.
A `Read` line sits after the status paragraph.
Do not insert it into the middle of that paragraph.

A check of one or two sentences may stay in the command.
Do that when loading a whole policy file would be the only reason to open it.
`approve-plan` and `mark-completed` keep the end-to-end completion rule for that reason.
The test tiers stay in `building.md`.

## What a turn may open

Do not open the index files at the start of a turn.
Open a file when a command heading, the Reads section, or the current step names it.
Do not read the other command files.
Keep a turn to the hot file, one command heading, and one policy file.
Add the contract when the step launches a Task.
Add `templates.md` only for the shape that step writes.

Create, derive, and replan may also open `notes-files.md`.
Open `building.md` as well when that step writes milestone tests.

## Bold names

A bold name points at a heading or a bold term.
Names in the index live in that file.
A qualified name such as **Reviews** fix first lives in the file that owns the first name.
Any other bold name lives in `SKILL.md`.
Apply the named text.
Do not restate it.

When you move a policy, add its names to the index.
After the edit, search for the bold name and confirm it still resolves.

Do not put a moved name in a reminder that every turn reads.
Stops, Portability, and Update cadence are such reminders.
A bold name there makes the agent open that file on every turn.

## Wording

Follow **Writing style** in `SKILL.md` when you rewrite a sentence.
Use full sentences with articles.
Use the imperative.
Put one instruction in each sentence.
Keep an instruction to 20 words or fewer.
Keep a description to 25 words or fewer.
Use one term for one meaning.
Keep keywords, status tokens, IDs, paths, and commands exact.
Do not invent abbreviations.

State each fact once.
Elsewhere, point at the heading that owns it.
A shorter sentence that drops a constraint is a behavior change.
Keep the old sentence when a cut would make the order or the condition unclear.

## Contract

Keep `subagent-contract.md` as one file.
Remove a rule only when the same rule is already stated in one other place.
Keep every pipeline step, path row, critic kind, weight, and output field.
The parent pastes those fields into a prompt.
A missing field is a behavior change.

## Legacy repair

The session probe in `SKILL.md` runs before the first activity-file read.
It creates a missing notes file.
It fills a missing metadata row.
It opens `notes-files.md` only when the activity is legacy.
Keep the legacy steps in **Repair**.
Do not copy those steps back into the hot file.

## Before you finish

Search for the old path or the old heading name.
Fix each command `Read` line that names a file you moved.
Check that `help all` still prints the command map from `SKILL.md`.
Measure `SKILL.md` when you add more than a few lines.
The hot file should stay near its current size.
