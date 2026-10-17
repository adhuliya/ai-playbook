# Paths and readiness

Root: `.dev-notes/activities/<slug>/artifacts/`. `M<n>` is the milestone
number (`M2`); `<side>` is `positive` or `negative`. The brief column names the
file under `briefs/`.

| Role | Brief | Assigned file | Ready marker | Slice dir |
|---|---|---|---|---|
| `verify-plan` critic | `critic` | `verify-plan/critic-<side>.md` | `^# Critic` | `verify-plan/<side>/` |
| `verify-plan` synthesizer | `synthesizer` | `verify-plan/synthesis.md` | `^# Synthesis` | `verify-plan/synth/` |
| review env | `env` | `review/env.md` | `^status: (ready\|blocked)` | `review/env/` |
| review test | `test` | `review/M<n>.md` | `^# Milestone` | `review/M<n>/` |
| review critic | `critic` | `review/critic-<side>.md` | `^# Critic` | `review/<side>/` |
| review synthesizer | `synthesizer` | `review/report.md` | `^# Review report` | `review/synth/` |
| fix-cycle review (all four roles above) | same | same names under `fix/review/` | same | same names under `fix/review/` |
| plan packet (parent) | — | `verify-plan/packet.md`, `review/packet.md`, `fix/review/packet.md` | none | none |
| comment snapshot (parent) | — | `comments/before/<path>` | none | none |
| comment editor | `comment-editor` | `comments/job-<k>.md` + assigned files (comments only) | `^# Comments job` | `comments/job-<k>/` |
| comment verifier | `comment-verifier` | `comments/verify.md` | `^# Comments verify` | none |
| drift scanner | `drift-scanner` | `fix/drift.md` | `^# Drift` | `fix/drift/` |
| milestone worker | `worker` | `bg/M<n>/<job>.md` + assigned code/test paths | `^# Job` | `bg/M<n>/<job>/` |
| milestone collator | `collator` | `bg/M<n>/collate.md` | `^# Collate` | none |
| milestone critic | `critic` | `bg/M<n>/critic-<side>.md` | `^# Critic` | `bg/M<n>/<side>/` |
| explore | `explore` | `bg/<name>.md` (optional) | none | `bg/<name>/` |

**Ready** means a completion notice, or `test -f` plus `rg -l '<marker>'`
on the assigned file. Missing, empty, or no match means not ready.
