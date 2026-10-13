# span/test/analyze -- Dev-Guide

Lit FileCheck tests for `span analyze` (intra/inter clients).

## Notes

- Plan: `prompts/analyze-test.md`.
- **Invariants:** exactly one `.spir.pb` input (link first if needed); `--analysis` required; intra analyzes all bodies; `--entry` ignored on intra.
- **Run:** `make slang-dbg span-dbg`; `cd span/test && python3 run-tests.py -v -f 'analyze/'`.

## Artifacts

| Name | Description |
|------|-------------|
| `span/test/analyze/botbot_smoke.analyze.c` | `--analysis=botbot` |
| `span/test/analyze/livevars_intra.analyze.c` | `--analysis=livevars --mode=intra` |
| `span/test/analyze/pointsto_intra.analyze.c` | `--analysis=pointsto --mode=intra` |
| `span/test/analyze/waveA_inter.analyze.c` | Inter mode `--k=2` |
| `span/pkg/analysis`, `span/pkg/clients` | Runners and analyses under test |
