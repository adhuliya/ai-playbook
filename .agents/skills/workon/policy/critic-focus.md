# Critic focus

Assign one `focus` to each critic. Every critic gets the full packet.

## Negative

Milestones share a group when one outcome feeds the next, or they
implement the same requirement. Never split a related group. Other
milestones are separate groups.

On review, assign one negative per group in this run's scope.

On `verify-plan`, assign one negative for requirements when entries
exist. Assign one for design choices when entries exist. That focus
includes Design Decisions. Assign one per milestone group.

Do not assign one critic per requirement, file, or test.

## Positive

Assign one positive when there are one or two negative focuses. Its
focus is the whole set.

Assign two positives when there are three or more negative focuses.
Order the focuses as requirements, design choices, then milestone
groups. Give the first half, rounded up, to one positive. Give the
rest to the other. Never assign a third positive.

## Launch

Launch every critic in one message. Set `side` to `positive` or
`negative`. The assigned file is `<dir>critic-<side>-<k>.md`. The slice
dir is `<dir><side>-<k>/`. `<dir>` is the pipeline directory with its
slash. Start `<k>` at 1 for each side. In `focus:`, name milestone
ids, `requirements`, `design choices`, or a combination.

Launch the synthesizer when every critic file is ready. Pass the packet
and every critic path.
