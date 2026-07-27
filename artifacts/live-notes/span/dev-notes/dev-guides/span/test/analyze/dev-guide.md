# span/test/analyze — dev guide

## Purpose

Lit FileCheck tests for `span analyze` (intra/inter clients). Plan:
[`prompts/analyze-test.md`](../../../../../prompts/analyze-test.md).

## Layout

| Path | Role |
|------|------|
| `botbot_smoke.analyze.c` | P0 harness: `--analysis=botbot` |
| `livevars_intra.analyze.c` | P1: `--analysis=livevars --mode=intra` |
| `pointsto_intra.analyze.c` | P2: `--analysis=pointsto --mode=intra` |
| `waveA_inter.analyze.c` | P3/P4: livevars+pointsto `--mode=inter --k=2` |

## Build / test / run

```bash
make slang-dbg span-dbg
cd span/test && python3 run-tests.py -v -f 'analyze/'
```

## Invariants

- Exactly one `.spir.pb` input (link multi-TU first)
- `--analysis` is required
- Intra analyzes all function bodies; dumps all; `--entry` ignored

## Related

- `span/pkg/analysis` — runners / fact dump
- `span/pkg/clients` — concrete analyses under test
