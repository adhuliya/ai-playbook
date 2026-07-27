# span/pkg/idgen — dev guide

## Purpose

Unique ID generation for SPIR entities. Correctness-critical: bad IDs corrupt
IR identity, sets, and analysis facts.

## Layout

| Path | Role |
|------|------|
| `idgen.go` | Simple counters (`GetNextIdA/B/C`) and pool-based `IDGenerator` |
| `idgen_test.go` | Unit tests (treat failures as high priority) |

## Build / test / run

```bash
cd span && go test ./pkg/idgen/...
cd span && go test ./pkg/idgen/... -count=1 -v
```

## Invariants

- Do not invent parallel ID schemes in `spir` or clients — extend this package
- Respect pool prefix / sequence bit-length encoding; overflows panic by design
- Free/reuse paths must stay consistent with pool invariants (see tests)
- Changing ID bit layouts is an API/contract change — ask before widening scope

## Key entry points

- `GetNextIdA`, `GetNextIdB`, `GetNextIdC` — simple monotonic counters
- `IDGenerator` — allocate/free IDs from prefix pools

## Common tasks

```bash
cd span && go test ./pkg/idgen/... -count=1
```
