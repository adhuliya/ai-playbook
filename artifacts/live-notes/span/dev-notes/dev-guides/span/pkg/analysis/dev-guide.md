# span/pkg/analysis — dev guide

## Purpose

Analysis framework: client interface, intra-procedural solver, IPA hooks, and
lattice domains. Concrete analyses live in `pkg/clients`, not here.

## Layout

| Path | Role |
|------|------|
| `analysis.go` | `Analysis` interface, `AnalysisClientBase`, instance IDs |
| `analyze.go` | `Analyzer` / `IntraPAN` worklist solver over CFG |
| `run_intra.go` | TU-level `RunIntraTU` (all defined funcs) |
| `run_ipa.go` | k-limiting call-string IPA (`RunInterTU`; wraps IntraPAN) |
| `fact_dump.go` | `WriteFactDump` / report-dir helper |
| `ipa.go` | Inter-procedural analysis hooks (IPA uses IntraPAN; L15) |
| `callstrings.go`, `cascading.go`, `lerners.go` | CallString + IPA helpers |
| `span.go`, `util.go` | Small framework utilities |
| `lattice/` | Lattice base and domains (`lattice.go`, `pair`, `topbot`, `maysets`, `kvlattice`, `range`, `factid`, …) |

## Build / test / run

```bash
cd span && go test ./pkg/analysis/...
cd span && go test ./pkg/analysis/lattice/...
```

End-to-end client exercises often live under `pkg/test` or lit tests.

## Invariants

- New analyses should implement `Analysis` (usually via `AnalysisClientBase`) in `pkg/clients`
- Solvers own iteration/merge; clients own transfer functions and lattices
- Prefer extending lattices under `lattice/` over ad-hoc maps in clients
- Do not duplicate SPIR graph traversal already provided by the solver/worklist APIs

## Key entry points

- `Analysis` — what a client must implement (`AnalyzeCallStub` for intra call sites)
- `IntraPAN` / `AnalyzeGraph` — run an analysis on a graph
- `RunIntraTU` — analyze all defined functions in a TU
- `RunInterTU` — k-limiting call-string IPA over the TU
- `WriteFactDump` — BB/insn fact dump (stdout / report-dir)
- `lattice.Lattice`, `lattice.Pair` — fact representation

## Related

- `span/pkg/clients` — concrete analysis clients
- `span/pkg/spir` — IR / CFG the solvers walk

## Common tasks

```bash
cd span && go test ./pkg/analysis/... ./pkg/clients/... ./pkg/test/...
```
