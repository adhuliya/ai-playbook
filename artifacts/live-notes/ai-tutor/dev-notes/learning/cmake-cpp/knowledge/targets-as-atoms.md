# Targets are the atoms

CMake models a project as a **graph of named targets** (executables, libraries), not a flat source list.

## When to use

Adding libs/exes, wiring dependencies, reading any non-trivial `CMakeLists.txt`.

## What to expect

- `add_executable` / `add_library` **create** targets (nodes).
- `target_link_libraries(consumer … dep)` **wire** edges (consumer → dependency).
- Target **name** is the handle for linking and propagation — not necessarily the `.a` / `.so` / `.exe` filename on disk.
- Configure builds the graph; generate writes backend rules per target; Ninja builds them.

## What NOT to expect

- Folder hierarchy alone defining dependencies.
- One mega `set(SOURCES …)` with no target structure.
- CMake compiling code directly (Ninja/Make do the build).

## How it relates

- [configure-generate-build](configure-generate-build.md) — configure creates the target graph.
- Usage requirements (PUBLIC / PRIVATE / INTERFACE) ride on the same link edges — next curriculum step.
- Packages expose **imported targets** — same atom idea at consume time.

## Projection

**Catchphrase:** "Name products, then wire the org chart."

```
     ┌─────────┐
     │   app   │  executable
     └────┬────┘
          │ target_link_libraries
     ┌────▼────┐
     │ greeter │  static library
     └─────────┘
```

## Essentials

```cmake
add_library(greeter STATIC greeter.cpp)
add_executable(app main.cpp)
target_link_libraries(app PRIVATE greeter)
```

**Watch out:** Link against the **target name** (`greeter`), not a guessed path to `libgreeter.a`.

## Practice

`practice/step2-targets/` — greeter static lib + `app` executable.
