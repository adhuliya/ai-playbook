# Collect vs evaluate

Use one agent to collect facts: outcomes, paths, pass or fail, and joins.
A milestone `pass` checks it; do not launch a critic pair there.
Use critics only in `verify-plan` and review (`start-review` or a fix
cycle). Always launch both sides. The pipeline step assigns each focus.
`briefs/critic.md` is the critic brief. The synthesizer reconciles.
