# SPAN — project definition

**SPAN** (Synergistic Program Analyzer): modular program-analysis platform on
**abstract interpretation** / **data-flow**. Near-term: C **bug finder**.
Longer-term: reusable engine for abstractions, algorithms, and clients over a
shared IR. Prefer small libraries behind interfaces over monoliths.

**Pipeline:** **slang** (Clang/LLVM C++) lowers C → **SPIR** protobuf;
**span** (Go) loads SPIR, links TUs, runs analyses. Founding layout:
`prompts/001-initial-project.md`. Dev env: `.devcontainer/` (Go, protobuf, LLVM).

## Decision Policy

Prefer the smallest change that advances analysis correctness, SPIR clarity, or
reusable APIs. Stay in scope (below). If a change expands scope or forks a
meaningful design choice, **ask**. Reuse existing modules before inventing new
ones (`.cursor/rules/code-style.mdc`).

## Scope

- **In:** SPIR design/APIs; slang AST→SPIR; span CLI + analysis framework
  (lattices, solvers, IPA); clients; TU linking; supporting tests/build.
- **Language:** C via Clang. Broader languages only if they reuse SPIR cleanly.
- **Out (unless requested):** general compiler opts, unrelated tooling, large
  rewrites that do not serve analysis or SPIR clarity.

## Agent working style

Expert on **SPAN/SLANG**: teach clearly; SOLID/modular; short useful comments.
Follow language best practices (Go, C++, proto). Ground in `README.md` and this
file. Apply the rules in `Decision Policy`. Explain step by step; examples show
usage. SPIR wire format → `.cursor/rules/proto-style.mdc` (`spir.proto` only;
regen; no hand-edits to `.pb.*`). Git → `.cursor/rules/git.mdc`. End each task
with a concise bulleted summary of outcomes and status.

## Platform conventions

- **CLI:** `help` / `analyze` / `link`; dedicated cmdline pkg; global `CmdLine`;
  help on cmdline errors.
- **Lifecycle:** thin `main` — `initialize()` / `finish()`; log start/stop.
- **Logging:** structured `slog`; default text + source (no time/function); JSON optional.
- **SPIR:** `spir` owns `spir.proto`; Makefile gens Go; slang uses C++ protobuf API.
- **slang:** normal Clang args; CMake via top-level Makefile.

## Direction

Grow SPIR as a simple analysis-friendly three-address IR (not LLVM IR). Strengthen
intra/inter-procedural core and clients. Mature multi-file linking (optional
Clang CTU later). Keep components library-like and interface-driven.

## Key terms

| Term | Meaning |
|------|---------|
| **SPIR / SPAN IR** | Analysis three-address IR (types → entities → exprs → insns → BBs → CFG → funcs → TU). Wire: `spir.proto`. |
| **TU** | Translation unit: one SPIR module (usually one C file); may be linked. |
| **slang** | Clang tool: C → SPIR protobuf. |
| **span** | Go analyzer: load / link / analyze SPIR. |
| **CmdLine** | Structured, global parsed CLI state. |
| **Lattice** | Abstract domain element (`span/pkg/analysis/lattice`). |
| **Analysis client** | Pluggable analysis (`span/pkg/clients`). |
| **CFG** | Control-flow graph of a function body. |
