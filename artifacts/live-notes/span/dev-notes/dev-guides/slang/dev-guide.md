# slang — dev guide

## Purpose

Clang/LLVM C frontend that lowers C to SPIR protobuf (`spir.proto`). Shares the
wire contract with Go `span/pkg/spir`.

## Background

The `main.cpp` and other files are adaptation from an earlier (well tested) implementation
that converted Clang AST to a Python based SPIR. Hence, there is a lot of boiler plate code
that is present to generate a valid python module which contains the whole SPIR.
We are using the existing infra, with minimal changes, to create the proto SPIR now.
The intention (for the time being) is to allow both types of SPIR outputs as needed.

## Caveats

Slang currently does not support the following:

1. Function with var args. For such functions, the function body is never converted.
2. Global curly-brace aggregate init is still incomplete for some record shapes
   (local array init lists work; prefer lit under `test/agg/`).

## Layout

| Path | Role |
|------|------|
| `CMakeLists.txt` | CMake build; links Clang, LLVM, Protobuf |
| `src/main.cpp`, `src/main.h` | Tool entry / Clang AST visitor driver |
| `src/util.cpp`, `src/util.h` | Shared C++ helpers |
| `src/spir.pb.cc`, `src/spir.pb.h` | Generated from `span/pkg/spir/spir.proto` — do not hand-edit |
| `src/genir.cpp` | The original python SPIR only code, present only for temporary reference, which is well tested on an older Clang 14 version. |
| `test/` | LLVM lit-style frontend tests |
| `built/` | Local build output (gitignored; not source) |

## Build / test / run

From repo root:

```bash
make slang-dbg          # debug (primary)
make slang-rel          # release
make clean-slang        # remove slang/built
make gen-proto          # regenerate pb if spir.proto changed
make test-slang VERBOSE=-v
```

Binary: `slang/built/slang`. Prefer the `build-slang` skill for build-fix loops.

## Invariants

- Proto sources of truth: `span/pkg/spir/spir.proto`; regenerate, never hand-edit `.pb.*`
- Accepts normal Clang args; treat as a Clang tool, not a bespoke driver reinvented ad hoc
- Prefer root `Makefile` targets over invoking raw cmake unless debugging the build

## Related

- `span/pkg/spir` — shared `spir.proto` / wire contract
- `slang/test` — lit corpus and frontend checks

## Common tasks

```bash
make slang-dbg
./slang/built/slang --bit-spir --out-dir=. input.c --
./slang/built/slang -p compile_commands.json input.c -bit-spir -out-dir _out
```
