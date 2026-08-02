# span/pkg/idgen -- Dev-Guide

Unique SPIR entity IDs; correctness-critical for IR identity and analysis facts.

## Notes

- **Invariants:** no parallel ID schemes in `spir`/clients; respect pool prefix/bit layout (overflow panics); free/reuse must match pool rules; bit-layout changes need explicit agreement.
- **Tests:** `cd span && go test ./pkg/idgen/... -count=1 -v` — treat failures as high priority.
- **APIs:** `GetNextIdA/B/C`; pool-based `IDGenerator`.

## Artifacts

| Name | Description |
|------|-------------|
| `span/pkg/idgen/idgen.go` | Counters and pool generator |
| `span/pkg/idgen/idgen_test.go` | Unit tests |
