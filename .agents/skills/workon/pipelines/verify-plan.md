# `verify-plan`

Critic input: the plan packet file. Critics MAY Read paths the plan cites; no
other repo walk.

1. Delete stale slices. Write `verify-plan/packet.md` (**Plan packet**).
   Read **Critic focus**. Launch those critics (`pipeline: verify-plan`)
   with the packet path. Tell the user.
2. Every critic file ready → launch the synthesizer with the packet path
   and every critic path.
3. The parent Reads only `synthesis.md` and strips proposals that break
   **Stops**.
4. **Question gate:** answer from session knowledge and patch
   `synthesis.md`. Grill the rest one at a time (**Asking**) and
   patch again. Unanswered items stay out of apply. `- none` → delete
   `inflight.md` and skip step 5.
5. Show `## Proposals`. Ask all / some / none. Never apply in the turn of
   the first Read. Record each proposal as an `agent` point: accepted ones
   per **Reviews** (where points go), rejected ones `rejected: <why>`.
   Then delete `inflight.md`.
