# span/test/link -- Dev-Guide

Lit drivers for multi-TU link and single-input serialize (`span link -o`).

## Notes

- Reuses `slang/test/multi/` sources — no body copies.
- Plans: `prompts/span-linker.md`, `prompts/spir-serializer.md`.
- **Run:** `make slang-dbg span-dbg`; `cd span/test && python3 run-tests.py -v -f 'link/'`.

## Artifacts

| Name | Description |
|------|-------------|
| `span/test/link/serialize_one.link.c` | One-file link round-trip |
| `span/test/link/multi_foo_bar.link.c` | Link foo+bar with `--check` |
| `span/test/link/multi_with_main.link.c` | Link with main TU |
| `span/pkg/spir` | Link / serialize APIs |
