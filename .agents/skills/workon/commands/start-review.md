# `start-review`

Status: any. No status change, no journal. Never applies (**Apply timing**).
Never launches a sub-agent or a critic. Usage: `start-review [<milestones>]`.

Reads: policy/reviews.md, policy/apply-timing.md, shapes/reviews.md

This command opens the user's review. It works on the regular cycle only
and never touches a fix cycle (**Reviews**). It records the user's points.
An automated pass of checked milestones is `agent-review`, and only when
the user types that keyword.

0. **Checks.** A fix cycle is `open` → warn that the results will need the
   recheck and suggest `apply-review` first. Stop; continue next turn only
   after a yes. A named milestone that is not checked → warn and drop it
   from scope.
1. **Cycle.** If a regular cycle is `open`, refresh `state:`. Rewrite
   `scope:` only when the cycle has no `(agent-review)` point. When it has
   one, keep that scope and note the user's milestones in `state:`. Else
   append a new `RU<n>` to `reviews.md` with `status: open`,
   `scope:`, and a `state:` note. Scope is the named milestones, else the
   **Reviews** default. Nothing in scope and not `Planning` → say so and ask
   whether to open the cycle for user points. Stop; open it next turn only
   after a yes. When the cycle is open or refreshed, follow **Agent notes**.
2. Tell the user to add, edit, or strike points in `reviews.md` or in chat.
   Do not offer `agent-review`. `apply-review` applies the cycle. Stop.
