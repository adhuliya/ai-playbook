# span/pkg/analysis -- Dev-Guide

Analysis framework: client interface, intra/inter solvers, lattice domains; clients live in `pkg/clients`.

## Notes

- **Invariants:** new analyses implement `Analysis` in `pkg/clients`; solvers own iteration; clients own transfers; extend `lattice/` for reusable domains.
- **Tests:** `cd span && go test ./pkg/analysis/... ./pkg/analysis/lattice/...`; E2E often in `pkg/test` or lit.
- **Entry points:** `Analysis`, `IntraPAN`/`AnalyzeGraph`, `RunIntraTU`, `RunInterTU`, `WriteFactDump`, `lattice.Lattice`/`Pair`.

## Artifacts

| Name | Description |
|------|-------------|
| `span/pkg/analysis/analysis.go` | `Analysis` interface, client base |
| `span/pkg/analysis/analyze.go` | Intra worklist solver |
| `span/pkg/analysis/run_intra.go`, `run_ipa.go` | TU-level runners |
| `span/pkg/analysis/lattice/` | Lattice domains |
| `span/pkg/clients/` | Concrete clients |
| `span/pkg/spir/` | CFG / IR walked by solvers |
