# Source, build, and install trees

Three places artifacts can live; confuse them and packaging/CI breaks.

## When to use

Choosing directories, CI layout, or explaining where consumers should point `find_package`.

## What to expect

- **Source:** `CMakeLists.txt`, `.cpp`, headers — inputs you edit.
- **Build:** Generated CMake/Ninja files, objects, binaries — disposable scratch (usually gitignored).
- **Install:** Relocatable layout under a prefix (`lib/`, `include/`, `bin/`) — what you ship or what downstream consumes.

## What NOT to expect

- In-source builds (objects mixed into source) as the default workflow.
- Long-term consumers `#include` from your **build** dir instead of install or build-interface paths.

## How it relates

- [Configure, generate, build](configure-generate-build.md) — build tree is where configure/generate write.
- Packages are contracts — consumers use install tree or imported targets, not random clone paths.

## Projection

Three boxes: **Source → Build → Install/Package**.
