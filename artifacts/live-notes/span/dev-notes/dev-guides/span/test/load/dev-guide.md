# span/test/load -- Dev-Guide

Lit wrappers: slang → `.spir.pb` → `span load --check` using `slang/test` C (no body copies).

## Notes

- **Sync:** when slang lit C changes, `gen-spanir-tests` / plan `prompts/span-ir.md`.
- **Invariants:** no copied C bodies; Tier B (`span load --check`); skip `multi/` until Tier D unless requested.
- **Not in manifest (by design):** `slang/test/src/`, `manual/`, `multi/`, `proto_001.c`, `slang_on_src.c` pattern.
- **Run:** `make slang-dbg span-dbg`; `cd span/test && python3 run-tests.py -v -f 'load/'`.

## Artifacts

| Name | Description |
|------|-------------|
| `span/test/load/manifest.txt` | Sorted `slang/test/` paths in suite |
| `span/test/load/*.load.c` | Lit RUN-only wrappers |
| `slang/test/` | Source C programs |
| `span/pkg/spir` | Load and `ValidateLoadedTU` |
