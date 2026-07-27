# span/pkg/spir — dev guide

## Purpose

SPIR (SPAN IR) runtime: types → entities → exprs → instructions → BBs → CFG →
functions → TU, plus protobuf IO and linking hooks. Shared wire contract with
slang via `spir.proto`.

Conceptual IR layering: see [`span/pkg/spir/README.md`](../../../../../span/pkg/spir/README.md).

## Layout

| Path | Role |
|------|------|
| `spir.proto` | Serialized SPIR schema (source of truth for wire format) |
| `spir.pb.go` | Generated Go protobuf — do not hand-edit |
| `types.go` | IR types |
| `entityid.go`, `entitysets.go`, `entitystack.go` | Entities / ID sets |
| `expressions.go`, `instructions.go` | Exprs and instructions |
| `graph.go` | CFG / basic blocks / worklists |
| `TU.go` | Translation unit |
| `tu_query.go` | Pretty names, var sets/filters, `EnsureFuncCFG` / `DefinedFunctions` |
| `linker.go` | Multi-TU link (`LinkTUs` / `LinkTUsWithOptions`) |
| `spir.io.go` | Load BitTU; Clang remap vs span-origin identity load |
| `serialize.go` | `ConvertInternalTUToBitTU`, `WriteTU` (span origin) |
| `equal_tu.go` | `EqualTU` round-trip oracle |
| `validate_load.go` | `ValidateLoadedTU` after convert (ids/types/names/insns) |
| `verify_dump.go`, `verify_report.go`, `callgraph.go` | Human-verif dumps (MD catalogs, CFG/call DOT, staged report) |
| `context.go`, `srclocation.go`, `consts.go`, `util.go` | Context and helpers |
| `*_test.go`, `example_tus.go` | Tests and examples |

## Build / test / run

```bash
make gen-proto          # regenerate Go + C++ pb from spir.proto
make gen                # proto + other codegen
cd span && go test ./pkg/spir/...
```

Follow `.cursor/rules/proto-style.mdc` for proto edits.

## Invariants

- Edit `spir.proto` only for wire changes; regenerate — never hand-edit `.pb.go` / slang `.pb.*`
- Prefer analysis-friendly three-address IR clarity over cloning LLVM IR
- ID allocation for entities coordinates with `pkg/idgen` — do not invent ad-hoc ID schemes
- Prefer live tree + proto over stale docs; fix clearly stale one-liners in the same change

## Key entry points

- `spir.io.go` — deserialize TUs for the CLI/`load` (span-origin keeps 32-bit ids)
- `serialize.go` / `WriteTU` — emit span-origin `.spir.pb` (`OriginSpanIR`)
- `EqualTU` — structural round-trip equality (see `prompts/spir-serializer.md`)
- `ValidateLoadedTU` — structural checks used by `span load --check` / `link --check`
- `TU.go`, `graph.go` — structures analyses walk
- `LinkTUs` — multi-file linking (`prompts/span-linker.md`); CLI: `span link -o`
- `WriteTUStageReport` / `WriteFlatDumps` / `FormatCallGraph` — human-verif (`prompts/human-verif.md`)

## Related

- `slang` — frontend that emits this wire format

## Common tasks

```bash
make gen-proto
cd span && go test ./pkg/spir/ -count=1
# staged report (example SPEC TU dir):
span link --check --verify-report --verify-report-inputs -o linked.spir.pb *.c.spir.pb
```
