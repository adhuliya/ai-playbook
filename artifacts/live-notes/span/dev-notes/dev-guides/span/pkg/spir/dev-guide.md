# span/pkg/spir -- Dev-Guide

SPIR runtime and wire format: types through TU, protobuf IO, linking, validation dumps.

## Notes

- Layering overview: `span/pkg/spir/README.md`.
- **Invariants:** wire changes via `spir.proto` only; regenerate `.pb.go` / slang `.pb.*`; coordinate IDs with `pkg/idgen`; prefer three-address IR clarity.
- **Build:** `make gen-proto`, `make gen`; `cd span && go test ./pkg/spir/...`. Follow `.cursor/rules/proto-style.mdc` for proto edits.
- **Key APIs:** `spir.io.go` (load); `serialize.go`/`WriteTU`; `EqualTU`; `ValidateLoadedTU`; `LinkTUs`; verify dumps (`prompts/human-verif.md`, `prompts/span-linker.md`, `prompts/spir-serializer.md`).

## Artifacts

| Name | Description |
|------|-------------|
| `span/pkg/spir/spir.proto` | Wire schema (source of truth) |
| `span/pkg/spir/spir.pb.go` | Generated Go — do not hand-edit |
| `span/pkg/spir/types.go`, `TU.go`, `graph.go` | IR structures |
| `span/pkg/spir/linker.go` | Multi-TU link |
| `span/pkg/spir/spir.io.go`, `serialize.go` | Load / write |
| `span/pkg/spir/validate_load.go`, `equal_tu.go` | Checks and oracles |
| `span/pkg/spir/verify_dump.go`, `verify_report.go` | Human-verif output |
| `slang/` | Frontend emitting this wire format |
