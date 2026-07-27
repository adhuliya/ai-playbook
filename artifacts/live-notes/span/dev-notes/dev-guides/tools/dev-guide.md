# tools — dev guide

## Purpose

Small standalone utilities related to SPAN/SPIR. Not part of the slang or span
build graphs unless a Makefile target wires them explicitly.

## Layout

| Path | Role |
|------|------|
| `spir_proto_to_text/` | Python helper to dump SPIR protobuf as text (`spir.py`, generated `spir_pb2.py`) |
| `jupyter-notebooks/` | Ad-hoc notebooks / demos (e.g. `hello.ipynb`) |

## Build / test / run

No unified `make tools` target. Typical usage:

```bash
python3 tools/spir_proto_to_text/spir.py <file.pb>
```

Regenerate Python pb bindings when `spir.proto` changes (same contract as other
generated pb files — do not hand-edit `spir_pb2.py` as source of truth).

## Invariants

- Keep tools small and optional; core pipeline remains slang → SPIR → span
- Treat generated `*_pb2.py` like other pb outputs
- Prefer documenting a new tool here with one role line when you add it

## Related

- `span/pkg/spir` — `spir.proto` (regenerate Python pb when it changes)

## Common tasks

```bash
python3 tools/spir_proto_to_text/spir.py path/to/tu.pb
```
