# span/test — dev guide

## Purpose

LLVM lit-style integration tests for the span analyzer side (distinct from
`pkg/test` Go harness tests and from `slang/test` frontend tests).

## Layout

| Path | Role |
|------|------|
| `lit.cfg.py` | Lit configuration |
| `run-tests.py` | Test runner |
| `llvm-lit-tests/` | Lit suite tree (includes its own lit/run helpers) |
| `load/` | Thin lit wrappers that reuse `slang/test/**/*.c` via `%slang_test_root` — no C body copies; see [`load/dev-guide.md`](load/dev-guide.md) + `prompts/span-ir.md` |
| `link/` | Multi-TU link + serialize-only (`span link -o`); see [`link/dev-guide.md`](link/dev-guide.md) + `prompts/span-linker.md` |
| `analyze/` | `span analyze` client smoke (BotBot / LiveVars / PointsTo); see [`analyze/dev-guide.md`](analyze/dev-guide.md) + `prompts/analyze-test.md` |
| `test.c` | Sample / placeholder input |
| `.test_output/` | Local lit output (gitignored; not source) |

**Load suite sync:** when slang lit C files change, use skill
`gen-spanir-tests` / command `/gen-spanir-tests` to update `load/` +
`load/manifest.txt`. Plan: [`prompts/span-ir.md`](../../../../prompts/span-ir.md).

## Build / test / run

```bash
make slang-dbg span-dbg   # load/ suite needs both binaries
make test-span
cd span/test && python3 run-tests.py -v -f 'load/'
cd span/test && python3 run-tests.py -v -f 'link/'
cd span/test && python3 run-tests.py -v -f 'analyze/'
```

Or invoke `run-tests.py` in this directory (see script `--help`).

For pure Go package tests, use `cd span && go test ./...` or `Makefile.test`
targets — those are not lit.

## Invariants

- This suite is for span integration via lit, not slang proto emission
- Load wrappers must not duplicate C bodies from `slang/test` — point at them
- Do not commit `.test_output/`
- Prefer root `make test-span` so binary/tool paths match CI expectations
- Load lit needs both slang and span binaries (`make slang-dbg span-dbg`)

## Common tasks

```bash
make test-span
```
