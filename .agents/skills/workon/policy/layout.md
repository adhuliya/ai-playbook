# Layout

Tree and artifact names: `shapes/layout.md`. Slugs are
kebab-case and top-level only; siblings sit side by side. On an ambiguous
slug, list the matches and ask.

Commit `.dev-notes/activities/`, including useful `artifacts/` copies and
the reserved `verify-plan/`, `review/`, `comments/`, `fix/`, and `bg/`
records, but not `inflight.md` (scratch). The agent does not `git add` or
commit unless asked. Huge generated trees stay out of the repo. A
gitignored `.dev-notes/` is valid.

Status tokens (exact): `Planning` | `Approved` | `Active` | `Paused` |
`Blocked` | `Complete`. Preferred lifecycle: `Planning → Approved → Active →
Complete`, with optional `Paused` / `Blocked`. Never `Complete` → `Active`.
