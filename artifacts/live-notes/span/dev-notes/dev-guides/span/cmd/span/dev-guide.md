# span/cmd/span — dev guide

## Purpose

Main CLI entry for the `span` tool. Expected to grow (more subcommands, richer
`CmdLine` state). Keep `main` thin; put option surface and command wiring here.

## Layout

| Path | Role |
|------|------|
| `main.go` | `initialize()` → execute cobra root → `finish()`; start/stop logs |
| `cmdline.go` | `CmdLine` struct, persistent flags, subcommands (`analyze`, `load`, `link`, …) |
| `util.go` | Small CLI helpers (e.g. error folding) |

## Build / test / run

```bash
make span-dbg
# binary location depends on Makefile; often span/bin/span or span/span
span analyze <spir.pb...>
span load <spir.pb...>
span link -o out.spir.pb <a.spir.pb> <b.spir.pb...>
```

Persistent / shared flags include log level/format, `--dump-txt`, `--check`
(`ValidateLoadedTU`), and human-verif dumps (`prompts/human-verif.md`):

| Flag | Role |
|------|------|
| `--verify-report` | Staged tree under `verify-report/{load/<tu>/,link/}` |
| `--verify-report-dir` | Override report root |
| `--verify-report-inputs` | Link only: also dump each input under `load/` |
| `--cfg-all` | With verify-report, emit CFGs even on link stage |
| `--dump-funcs` / `--dump-globals` / `--dump-records` / `--dump-externals` / `--dump-calls` / `--dump-global-init` / `--dump-cfg` | Selective flat `*.dump.md` / `*.dump.dot` |
| `--dump-func=` | Filter CFG dumps by function name substring |
| `--dump-dir` | Flat dump directory (default `.`, overwrite) |
| `--render` | Graphviz `dot` → SVG for `.dump.dot` only |

## Invariants

- Parsed CLI state lives in a structured, globally accessible `CmdLine` object
- Print help on cmdline errors; expect the option surface to grow
- Subcommand bodies should call into `pkg/*` — avoid embedding analysis/IR logic in `main`
- `pkg/cmdline` is reserved/empty; current wiring is in this package (`cmdline.go`)

## Key entry points

- `processCmdLine` / `configureCommand` — flag and subcommand registration
- `analyzeCmd` — `span analyze --analysis=…` (P0: `botbot` intra; see `prompts/analyze-test.md`)
- `loadCmd` → `load` — load SPIR protobuf; optional `--check` / verify-report / flat dumps
- `linkCmd` → `link` — N-way link + serialize; same dump flags

## Common tasks

```bash
make span-dbg
span load --dump-txt path/to/file.pb
span load --check --verify-report path/to/file.pb
span link --check --verify-report --verify-report-inputs -o linked.spir.pb a.pb b.pb
span analyze path/to/file.pb
```
