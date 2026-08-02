# span -- Dev-Guide

Go SPAN analyzer: CLI, SPIR runtime, analysis engine, clients. Module: `github.com/adhuliya/span`.

## Notes

- **Invariants:** thin `main` with `initialize()`/`finish()`; public API under `pkg/`; `internal/` not for external import.
- **Build:** `make span-dbg`, `span-dev`, `span-rel`, `test-span`, `make gen`, `make vet && make fmt`. Go tests: `span/Makefile.test`.
- Do not treat `pkg/mod` or `pkg/sumdb` as project source.

## Artifacts

| Name | Description |
|------|-------------|
| `span/go.mod`, `go.sum` | Module identity |
| `span/cmd/span/` | CLI — `span/cmd/span/dev-guide.md` |
| `span/pkg/spir/` | IR + `spir.proto` |
| `span/pkg/analysis/` | Analysis framework |
| `span/pkg/clients/` | Concrete analyses |
| `span/pkg/idgen/` | Entity ID generation |
| `span/pkg/logger/` | Structured logging |
| `span/pkg/test/` | Go harness helpers |
| `span/internal/util/` | Internal helpers (not external API) |
| `span/test/` | Lit integration tests |
| `span/Makefile.api`, `Makefile.test` | Local make fragments |
