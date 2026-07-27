# span/test/link — dev guide

## Purpose

Lit drivers for **multi-TU link** and **serialize-only** (`span link -o` with
one input). Reuses `slang/test/multi/` C sources — no body copies.

Plan: [`prompts/span-linker.md`](../../../../../prompts/span-linker.md),
[`prompts/spir-serializer.md`](../../../../../prompts/spir-serializer.md).

## Layout

| Path | Role |
|------|------|
| `serialize_one.link.c` | One-file `span link -o` round-trip |
| `multi_foo_bar.link.c` | Link foo.c + bar.c, `--check`, serialize round-trip |
| `multi_with_main.link.c` | Link foo + bar + main_calls |

## Build / test / run

```bash
make slang-dbg span-dbg
cd span/test && python3 run-tests.py -v -f 'link/'
```

## Related

- `span/pkg/spir` — link / serialize APIs
