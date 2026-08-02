# span/pkg/clients -- Dev-Guide

Concrete analysis clients plugged into `pkg/analysis`; usual place for new bug-finders.

## Notes

- **Invariants:** implement `analysis.Analysis`; transfers here, solvers in `pkg/analysis`; reuse `lattice/` types; CLI wiring in `cmd/span` when ready.
- **Tests:** `cd span && go test ./pkg/clients/...` and `./pkg/test/...`.
- **Registry:** `NewAnalysis(name)` — `botbot|livevars|pointsto`. Patterns in `botbot.go`, `livevars.go`.

## Artifacts

| Name | Description |
|------|-------------|
| `span/pkg/clients/botbot.go` | Top-Bot demo clients |
| `span/pkg/clients/livevars.go` | Strong live variables |
| `span/pkg/clients/pointsto.go` | May points-to |
| `span/pkg/clients/registry.go` | Name → client constructor |
| `span/pkg/analysis/` | Interface and solvers |
