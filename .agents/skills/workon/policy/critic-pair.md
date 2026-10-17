# Collect vs evaluate

Use one agent to collect facts: outcomes, paths, pass or fail, and joins.
Use a **critic pair** to judge quality, rank options, or decide a change;
never one agent. Launch the pair in one message with the same input and
opposite `side` values; `briefs/critic.md` carries both briefs and the
focus list for each pipeline. The reconciler is the synthesizer for
`verify-plan` and review, and the parent for a milestone.
