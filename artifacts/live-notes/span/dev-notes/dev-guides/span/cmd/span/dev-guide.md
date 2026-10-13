# span/cmd/span -- Dev-Guide

Main `span` CLI: cobra commands, flags, thin `main` wiring into `pkg/*`.

## Notes

- **Invariants:** CLI state in structured `CmdLine`; help on errors; subcommands delegate to `pkg/*` (no analysis logic in `main`). `pkg/cmdline` is reserved; wiring lives in `cmdline.go`.
- **Build:** `make span-dbg`; binary often `span/bin/span` or `span/span`.
- **Subcommands:** `load`, `link`, `analyze` — see `processCmdLine`, `loadCmd`, `linkCmd`, `analyzeCmd` in `cmdline.go`.
- **Verify / dumps:** `--verify-report`, `--check`, `--dump-*`, `--render` (Graphviz); see `prompts/human-verif.md`.
- **Examples:** `span load --dump-txt f.pb`; `span link --check --verify-report -o out.pb a.pb b.pb`; `span analyze --analysis=botbot f.pb`.

## Artifacts

| Name | Description |
|------|-------------|
| `span/cmd/span/main.go` | `initialize` → cobra → `finish` |
| `span/cmd/span/cmdline.go` | Flags, subcommands, `CmdLine` |
| `span/cmd/span/util.go` | CLI helpers |
| `span/pkg/spir` | Load, link, serialize |
| `span/pkg/analysis`, `span/pkg/clients` | Analyses |
