# span/pkg/clients — dev guide

## Purpose

Concrete analysis clients that plug into `pkg/analysis`. This is the usual place
to add a new bug-finder or data-flow client.

## Layout

| Path | Role |
|------|------|
| `botbot.go` | Forward/backward Top-Bot propagation demo clients |
| `registry.go` | `NewAnalysis(name)` — `botbot|livevars|pointsto` |
| `livevars.go` | Strong live variables (`LiveVarsSet` / `EidSet`) |
| `pointsto.go` | Flow-sensitive may points-to (`KVLattice` → `MaySet`) |

## Build / test / run

```bash
cd span && go test ./pkg/clients/...
cd span && go test ./pkg/test/...    # harness may construct clients
```

## Invariants

- Implement `analysis.Analysis` (embed `AnalysisClientBase` when appropriate)
- Keep transfer functions here; keep solvers in `pkg/analysis`
- Reuse `pkg/analysis/lattice` types; add a lattice file there if the domain is reusable
- Wire CLI exposure via `cmd/span` only when ready — clients can exist before a subcommand

## Key entry points

- `NewAnalysis` — CLI/registry construction by name
- `ForwardBotBotClient` / `BackwardBotBotClient` — minimal Top-Bot client pattern
- `LiveVarsLT` + livevars client — fuller lattice example
- Points-to client — flow-sensitive `KVLattice` → `MaySet`

## Related

- `span/pkg/analysis` — client interface and solvers

## Common tasks

Add a new client file beside the existing ones; register/construct it from tests
or CLI when appropriate. Mirror patterns in `botbot.go` or `livevars.go`.
