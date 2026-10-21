# Design Choices

- DC1: Baseline = dynamic strong-liveness purge of standard runs; partial maps (`*`). Why: user Q6.
- DC2: Prove vs static `b`-restricted runs, derive dynamic as corollary. Why: avoids circularity.
- DC3: Dead assignment = `x=x` node viewed `x=T`; no `filter`, no no-op. Why: no-op not monotone.
- DC4: `eq:spanFF` unchanged; sketch's two stages/S2 removed.
- DC5: Replaced Q11 instrumented Theta with local argument (guards in F4, step lemma).
- DC6 (flag): explicit unreachable element distinct from all-purged fact (Q8 default A).
- DC7 (flag): `use(v)` components are pure gens (strong kills kept); stores always use pointer.
- DC8 (flag): `assume(e)` generalized from `assume(v)`; address-taken vars in `x=*y` liveness.
- DC9 (flag): LV policy rejects constant views of plain assignments; needed for step lemma (a).
- DC10: Intraprocedural only; relational-domain lifting deferred.
