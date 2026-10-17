# `verify-plan`

Critic input: the plan packet. Critics MAY Read paths the plan cites; no
other repo walk.

1. Delete stale slices. Launch the critic pair (`pipeline: verify-plan`).
   Tell the user.
2. Both ready → launch the synthesizer (plan packet + both critic paths).
3. The parent Reads only `synthesis.md` and strips proposals that break
   **Stops**.
4. **Question gate:** answer from session knowledge and patch
   `synthesis.md`. Grill the rest one at a time (**Asking**) and
   patch again. Unanswered items stay out of apply. `- none` → skip.
5. Show `## Proposals`. Ask all / some / none. Never apply in the turn of
   the first Read. Record each proposal as an `agent` point: accepted ones
   per **Reviews** (where points go), rejected ones `rejected: <why>`.
