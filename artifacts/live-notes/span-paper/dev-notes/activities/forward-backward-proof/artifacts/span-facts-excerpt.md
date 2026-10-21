# Excerpt: SPAN facts the forward-backward proof relies on

Header: copied facts (paraphrased tightly, equations kept) from the root paper.
Sources: `approach.tex`, `theta.tex`, `sv.tex`, `policy.tex`, `proof.tex`,
`overview_new.tex`, `instrumentation.tex`. Line numbers drift; use the labels.

## Composite flow function (`approach.tex`, `eq:spanFF`)

For analyses `A_i = (D_i, F_i, AbsSim_i, Policy_i)`, statement `s`, tuple-fact `(v_1..v_n)`:

    v_k' = JOIN { F^k_{Sts}(v_k) | j in 1..n, Sts = Policy_k(s, AbsSim_j(s, v_j)) }
    F^k_{Sts}(v) = MEET_{t in Sts} F^k_t(v)

- Order convention: top = most under-approximate (empty set of states), bottom = most over-approximate.
- MEET merges at control-flow joins (over-approximates). JOIN combines views (more precise).
- A view is a *set of alternatives*: `(Sts)(c) = union_{t in Sts} t(c)`. `emptyset` = `nil` view (top, blocks flow).
- Forward-backward (`approach.tex`, "Forward-Backward Analyses"): each fact is a pair `(IN_j, OUT_j)`;
  `AbsSim_j` may read `IN_j`, `OUT_j`, or both.

## Theta, restricted views, view/policy properties

- `Theta^s(Sts)` = maximal set of concrete states for which view `Sts` soundly over-approximates `s` (`theta.tex`, `def:theta`).
  Cases: `x=e` with `{x=c_1..c_k}`; `x=*y` with `{x=u_1..u_k}`; `*x=y` with `{u_1=y..u_k=y}`;
  `assume(e)` with `{assume(0)}` (states where e=0), `{assume(1)}` (all states); `{s}` -> all states; `emptyset` -> empty.
- View order (`eq:theta.partialOrder`): `Sts' weaker Sts` iff `Theta^s(Sts') superset Theta^s(Sts)`.
- Restricted views (`def:restricted.view`): `emptyset` only if the producer fact is top; deref statements get `{s}` or pointee
  assignments (non-points-to producers must use all address-taken variables); `v=expr` gets `{v=c_i}`; `assume` gets `{assume(1)}`, `{s}`, or `{assume(0)}` if provably false.
- `eq:sv.sound`: `unin(gamma_j(v_j)) superset Theta^s(AbsSim_j(s, v_j))` (designer obligation).
- `eq:sv.monotone`: `v_j' weaker v_j  =>  AbsSim_j(s, v_j') weaker AbsSim_j(s, v_j)`.
- `eq:policy.sound`: for all `S`, `C` with `unin(C) superset Theta^s(S)`: `(Policy_k(s,S))(C) weaker (s)(C)`.
- `eq:policy.monotone`: `S' weaker S  =>  (Policy_k(s,S'))(v) weaker (Policy_k(s,S))(v)`.
- Concretization (`def:gamma`): monotone, completely multiplicative (`gamma(JOIN Y) = JOIN gamma(Y)`, i.e. join of facts <-> intersection of states).
- Widening (`def:span.widen`): approximates both arguments; finite on descending chains.

## Example producers and consumers

- `AbsSim_PTA(s,d)` (`algo:sv.pta`): `d=top -> emptyset`; `*x=y -> {u=y | u in d[x]}`; `x=*y -> {x=u | u in d[y]}`;
  `assume(v)` -> `assume(0)` if `d[v]={nullptr}`, `assume(1)` if `v in d` and `nullptr not in d[v]`; else `{s}`.
- `Policy_PTA`, `Policy_IA`: accept every restricted view.
- `Policy_LV` (`algo:policy.livevars`): `sts = emptyset or {s}` -> `sts`; `*x=y` with pointee-assignment view -> `{use(x)} + sts`;
  `x=*y` with view `{x=u..}` -> `{x = use(y)} + sts`; `assume(v)` with `assume(0)` or `assume(1)` view -> `{use(v)} + sts`;
  otherwise `{s}`. It does not look at which analysis produced the view. It rejects constant views of plain assignments.
- `AbsSim_LV` is *not* defined in the paper text. Overview says LV yields `nil` for a dead assignment (now replaced, see below).
- Overview example: LV needs points-to pointees (`*z = &A` with `z -> y` becomes view `{y=&A}`; policy adds `use(z)`)
  and branch outcomes; points-to needs LV deadness. Neither analysis knows about the other.

## Existing local soundness proof (`proof.tex`, theorem "Soundness")

Per consumer `k` and producer `j`: `gamma_k(F_{Sts_j}(v_k)) weaker (Sts_j)(feasible_k)` using `eq:sv.sound`, `eq:policy.sound`,
and multiplicativity of gamma for the join. Soundness and monotonicity proofs assume all analyses are forward.

## Appendix sketch being superseded (`proof.tex`, "Forward-Backward Analysis Proof Outline")

- Concrete: `sf_n(f,b) := transf_n(nstate_n(f), b)`; `transf_n` sets dead variables to `-`; non-modular.
- Abstract: join of forward views, then backward view `SV_b(stmt, b1)`, then forward policy.
- Obligations (S1) backward view over-approximates `transf(s,b)` for `b in gamma_b(b1)`; (S2) forward policy over-approximates w.r.t. forward instrumentation.
- Liveness remark: `gamma_b(b1) = {b1}`; rewrite `x=e` to `x=top` when `x` dead.

## Defence slides (`20260223-defence/ppt/spandeadcode.tex`, `lv_cp_example.tex`)

- Dead assignment as `nop` is non-monotone/imprecise in loops: old `(x,10)` stays while `(x,Live)` gives `(x,5)`.
- Old fix `filter(x)` is retired. User now uses `x = x` (identity) viewed as `x = top` when `x` is dead; `x = top` is generated only for LHS variables;
  `x = x` is inserted only after statements that have `x` on the RHS and not on the LHS.
- CP/strong-liveness example: `x=5; b=1; if(b) y=20 else y=x*2; use(y)`. CP knows `b=1`, so the else edge is `assume(0)`;
  LV then does not gen `x`, so `x=5` is viewed as `x=top`.
