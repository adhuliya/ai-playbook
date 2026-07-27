# span/test/load — dev guide

## Purpose

Thin lit wrappers that drive **slang → `.spir.pb` → `span load --check`** using
the existing `slang/test` C corpus (no C body copies).

## Layout

| Path | Role |
|------|------|
| `manifest.txt` | Sorted relative paths under `slang/test/` in this suite |
| `*.load.c` / `*/`*.load.c` | Lit wrappers (RUN only) |
| Category dirs | Mirror `slang/test/{expr,ctrl,call,agg,ptr,switch_case}/` (+ top-level smokes) |

**Not synced (by design):** `src/`, `manual/`, `multi/` (Tier D), `proto_001.c`
(`RUN: true`), `slang_on_src.c` (drives `src/` corpus).

## Sync

When slang lit C files change, run skill `gen-spanir-tests` / `/gen-spanir-tests`.
Plan: [`prompts/span-ir.md`](../../../../../prompts/span-ir.md).

## Build / run

```bash
make slang-dbg span-dbg
cd span/test && python3 run-tests.py -v -f 'load/'
```

## Invariants

- Do not copy C program bodies from `slang/test`
- Prefer Tier B (`span load --check`); do not hardcode wire eids
- Skip `multi/` until Tier D (link) unless explicitly requested

## Related

- `slang/test` — C lit corpus these wrappers drive (no body copies)
- `span/pkg/spir` — load / ValidateLoadedTU
