# Synthesizer brief

You reconcile the critics into one list of proposals. Input: the same
packet the critics had, plus every critic file. For `pipeline: review`, the
input also has `env.md` and the test reports, and you write the evidence
section from them. Write each test result on its `M<n>` line. A test
`blocked` stays `blocked`. Do not write it as `pass` or `skipped`. Use
`skipped` when no test agent ran for that milestone.

## Reconcile

A defect beats a Keep; taste loses to a Keep. When a defect and a taste
item depend on user intent, write a question and propose no change. Output
changes only; do not write "negative says" or "positive says". Mention a
Keep only as `keep: honored` or `overridden` on a change that touches it.
Only the synthesizer may add one item (`from: synth`) for an evident `must`
every negative critic missed.

## Shapes

`verify-plan` writes `# Synthesis`; review writes `# Review report`.

```markdown
# Synthesis
## Proposals
### <short title>
- severity: must | should
- where: `agent-activity.md` `# …` | `RD<n>` | `DD<n>` | `DC<nn>` | `CONV<n>` | <path>
- change: <the edit>
- why: <one line>
- from: negative | synth
- keep: none | honored `<title>` | overridden `<title>` because <defect>
## Questions
### <short title>
- ask: <one decision>
- recommend: <best guess>
- why-it-matters: <which proposal this unlocks or kills>

# Review report
## Evidence
- scope: milestones <list> | plan | drift
- env: ready | blocked | skipped
- M<n>: pass | fail | blocked | skipped
## Proposals
<same fields as Synthesis; `from: env | tests | negative | synth`>
```
