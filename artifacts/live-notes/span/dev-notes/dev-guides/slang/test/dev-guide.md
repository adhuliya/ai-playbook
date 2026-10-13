# slang/test -- Dev-Guide

LLVM lit-style tests for SPIR protobuf lowering from C.

## Notes

- Needs built slang: `make slang-dbg`, then `make test-slang` or `cd slang/test && python3 run-tests.py -v`.
- **Invariants:** tests check proto emission, not Go analyzer; FileCheck with named id captures; each `.c` needs What/Why/Expect (see `prompts/slang.md`); do not delete `src/`; no `.test_output/` in git.
- **Focused runs:** `python3 run-tests.py -v -f hello_world`; `python3 run-tests.py -v -f 'expr/|ctrl/|call/|agg/|ptr/|multi/'`; `python3 -m lit -v expr/ ctrl/ …`
- Reused by `span/test/load` (thin wrappers, no C copies).

## Artifacts

| Name | Description |
|------|-------------|
| `slang/test/lit.cfg.py` | Lit config (`src/`, `manual/` excluded) |
| `slang/test/run-tests.py` | Runner (`--filter`) |
| `slang/test/expr/`, `ctrl/`, `call/`, `agg/`, `ptr/`, `multi/` | C11 coverage by category |
| `slang/test/switch_case/` | Switch/case cases |
| `slang/test/src/` | Larger legacy corpus (`slang_on_src.c` smoke) |
| `slang/test/manual/` | Exploratory cases |
| `span/test/load` | Span load wrappers over this corpus |
