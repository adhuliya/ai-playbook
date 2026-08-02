# span/test -- Dev-Guide

LLVM lit integration tests for span (distinct from `span/pkg/test` and `slang/test`).

## Notes

- **Invariants:** span integration via lit, not slang proto checks; load wrappers must not copy C from `slang/test`; no `.test_output/` in git; prefer `make test-span`; load needs `make slang-dbg span-dbg`.
- **Suites:** `load/`, `link/`, `analyze/` — each has a `dev-guide.md`. When slang lit C changes, run `gen-spanir-tests` / `/gen-spanir-tests` (`prompts/span-ir.md`).
- **Run:** `make test-span`; or `cd span/test && python3 run-tests.py -v -f 'load|link|analyze/'`.

## Artifacts

| Name | Description |
|------|-------------|
| `span/test/lit.cfg.py`, `run-tests.py` | Lit config and runner |
| `span/test/load/` | Slang corpus → `span load --check` |
| `span/test/link/` | Multi-TU link tests |
| `span/test/analyze/` | `span analyze` FileCheck tests |
| `span/test/llvm-lit-tests/` | Nested lit helpers |
| `slang/test/` | C corpus for load wrappers |
