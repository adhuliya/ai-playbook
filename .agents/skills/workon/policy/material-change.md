# Material-change

A change is **material** when it rewrites the Goal or Scope, when it adds,
drops, or rewords an RD entry after approval beyond an in-scope plan
refresh, or when it adds independently durable new work. In-scope
tightening of the plan, design, or conventions on the same Goal is not
material.

On a material change, prompt the matching choice; do not rewrite scope
first.

| Status | Keyword |
|---|---|
| In flight (`Planning` / `Approved` / `Active` / `Paused` / `Blocked`) | `replan-work` (same slug) or `create-sibling` |
| `Complete` | stay-on-slug (minor) or `create-sibling` (major). Never `replan-work` |

**Complete stay-on-slug** reopens `Complete` → `Planning`, never → `Active`.
Two commands do it. `resume-work` grills and classifies first.
`apply-review` is intake only: stay-on-slug, no sibling, no resume grill;
it reopens only when the cycle adds a review milestone, and a material open
point applies nothing (ask `create-sibling`). For the grill-and-classify
fork, the user runs `resume-work` first. **Complete sibling:** prompt
`create-sibling`. The parent stays `Complete` with no journal entry. Only
the sibling records `derived-from:`; the parent never points at the sibling.
