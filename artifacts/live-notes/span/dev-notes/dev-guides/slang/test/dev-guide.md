# slang/test — dev guide

## Purpose

LLVM lit-style tests that check SPIR protobuf lowering from C inputs.

## Layout

| Path | Role |
|------|------|
| `lit.cfg.py` | Lit configuration (`src/` and `manual/` excluded from discovery) |
| `run-tests.py` | Test runner (finds lit, supports `--filter`) |
| `*.c` (top) | Smoke / legacy stubs (`hello_world`, `globals_*`, `slang_on_*`) |
| `expr/` | Literals, unary/binary/assign, casts, comma, `?:` (C11 §6.5) |
| `ctrl/` | Statements: `if`/`while`/`do`/`for`/`goto`/`switch`/break/continue |
| `call/` | Calls, prototypes, void return |
| `agg/` | Arrays, structs/unions, member access (dot/arrow), mixed forms, inits |
| `ptr/` | Pointers, addr-of, deref |
| `multi/` | Multi-file / multi-TU lit (Milestone D) |
| `switch_case/` | Focused switch/case cases |
| `src/` | Larger legacy corpus — keep; driven by `slang_on_src.c` smoke |
| `manual/` | Manual / exploratory cases (+ README) |
| `.test_output/` | Local lit output (gitignored; not source) |

## Build / test / run

Requires a built slang binary. From repo root:

```bash
make slang-dbg
make test-slang
make test-slang VERBOSE=-v
```

Focused runs (prefer while iterating):

```bash
cd slang/test
python3 run-tests.py -v -f hello_world
python3 run-tests.py -v -f 'expr/|ctrl/|call/|agg/|ptr/|multi/'
python3 -m lit -v expr/ ctrl/ call/ agg/ ptr/ multi/ hello_world.c
```

## Invariants

- Tests validate SPIR proto emission for C programs — not the Go analyzer
- Prefer **semi-deep** FileCheck with **named id captures**; decode `.spir.pb`
- Every lit `.c` needs What/Why/Expect comments (see `prompts/slang.md`)
- Do not delete `src/`; copy into category dirs when adding FileCheck coverage
- Do not commit `.test_output/`

## Related

- `span/test/load` — thin wrappers that reuse this corpus for span load

## Common tasks

```bash
make slang-dbg
cd slang/test && python3 run-tests.py -v -f struct_dot
```
