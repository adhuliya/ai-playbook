# tools -- Dev-Guide

Small standalone SPAN/SPIR utilities; not in core slang/span build unless wired explicitly.

## Notes

- No unified `make tools`. Example: `python3 tools/spir_proto_to_text/spir.py <file.pb>`.
- Regenerate `spir_pb2.py` when `spir.proto` changes; do not hand-edit as source of truth.
- Keep new tools small; document new dirs with a row here.

## Artifacts

| Name | Description |
|------|-------------|
| `tools/spir_proto_to_text/` | Python SPIR protobuf text dump |
| `tools/jupyter-notebooks/` | Ad-hoc notebooks |
| `span/pkg/spir/spir.proto` | Schema for Python pb bindings |
