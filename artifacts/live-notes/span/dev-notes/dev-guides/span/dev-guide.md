# span — dev guide

## Purpose

Go module for the SPAN analyzer: CLI, SPIR runtime, analysis engine, and
clients. Module path: `github.com/adhuliya/span`.

## Layout

| Path | Role |
|------|------|
| `go.mod`, `go.sum` | Module identity and deps |
| `cmd/span/` | CLI entry (`main`, cobra cmdline) |
| `pkg/spir/` | SPIR IR + `spir.proto` |
| `pkg/analysis/` | Analysis interfaces and solvers |
| `pkg/analysis/lattice/` | Lattice domains |
| `pkg/clients/` | Concrete analysis clients |
| `pkg/idgen/` | Unique ID generation (correctness-critical) |
| `pkg/logger/` | Global structured logging |
| `pkg/test/` | Go harness / integration helpers |
| `pkg/cmdline/`, `pkg/system/`, `pkg/transform/` | Empty / reserved stubs |
| `internal/util/` | Internal helpers (`dsa/`, `errs/`) — not for external import |
| `test/` | LLVM lit-style integration tests |
| `Makefile.api`, `Makefile.test` | Span-local make fragments |
| `scripts/` | Span-specific helpers |
| `bin/`, `span` | Local binaries (not source of truth) |

Do not treat `pkg/mod` or `pkg/sumdb` as project source (module cache paths).

## Build / test / run

From repo root:

```bash
make span-dbg           # codegen + debug build
make span-dev           # codegen + non-release build
make span-rel           # release
make test-span
make vet && make fmt
make gen                # proto + go codegen
```

Go tests from `span/`: see `Makefile.test` (`test-all`, `test-unit`, …).

## Invariants

- Keep `main` thin: `initialize()` / `finish()` around work; logging via `pkg/logger`
- Public libraries live under `pkg/`; `internal/` is not an external API
- Prefer composing small packages behind interfaces over monolithic features

## Common tasks

```bash
make span-dbg
./span/bin/span --help    # or path produced by your local make/bin layout
cd span && go test ./pkg/spir/...
```
