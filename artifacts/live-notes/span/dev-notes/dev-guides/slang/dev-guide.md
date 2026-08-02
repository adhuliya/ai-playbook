# slang -- Dev-Guide

Clang/LLVM C frontend that lowers C to SPIR protobuf; shares `spir.proto` with `span/pkg/spir`.

## Notes

- Adapted from an earlier Clang→Python SPIR path; infra still supports both output styles for now.
- **Caveats:** no varargs function bodies; some global curly-brace aggregate inits incomplete (see `slang/test/agg/`).
- **Invariants:** edit `span/pkg/spir/spir.proto` only; regenerate `.pb.*` — never hand-edit. Use root `Makefile` targets; treat as a Clang tool.
- **Build:** `make slang-dbg` (primary), `make slang-rel`, `make clean-slang`, `make gen-proto`, `make test-slang VERBOSE=-v`. Binary: `slang/built/slang`. Use `build-slang` skill for fix loops.
- **Run examples:** `./slang/built/slang --bit-spir --out-dir=. input.c --`; or `-p compile_commands.json … -bit-spir -out-dir _out`.

## Artifacts

| Name | Description |
|------|-------------|
| `slang/CMakeLists.txt` | CMake build (Clang, LLVM, Protobuf) |
| `slang/src/main.cpp`, `main.h` | Entry and AST visitor driver |
| `slang/src/util.cpp`, `util.h` | Shared C++ helpers |
| `slang/src/spir.pb.cc`, `spir.pb.h` | Generated from `spir.proto` |
| `slang/src/genir.cpp` | Legacy Python SPIR reference (Clang 14) |
| `slang/test/` | Lit frontend tests — `slang/test/dev-guide.md` |
| `slang/built/` | Local build output (gitignored) |
| `span/pkg/spir` | Shared wire contract |
