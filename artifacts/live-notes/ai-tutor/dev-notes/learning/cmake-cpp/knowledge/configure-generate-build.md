# Configure, generate, build (Ninja)

Three logical phases; with Ninja they usually happen in one `cmake -S -B` invocation.

## When to use

Any CMake build, debugging “change didn’t apply,” or separating “CMake problem” vs “compiler problem.”

## What to expect

| Phase | What happens | Telltales in build tree |
|-------|----------------|-------------------------|
| **Configure** | Read `CMakeLists.txt`, pick generator/toolchain, set cache vars, detect compiler | `CMakeCache.txt`, `cmake_install.cmake`, `CMakeFiles/` |
| **Generate** | Write rules for the backend | **`build.ninja`** (Ninja’s main graph) |
| **Build** | Backend compiles/links | `hello`, `*.o`, etc. |

**Catchphrase:** CMake writes the recipe; Ninja cooks.

## What NOT to expect

- CMake is not the everyday compiler driver when using Ninja — `cmake --build` delegates to `ninja`.
- Configure is not “only when you first create `build/`” — edit `CMakeLists.txt` → re-run configure (e.g. `cmake build` or `cmake -B build`) before building.
- The Ninja manifest is not named `ninja.build`; it is **`build.ninja`**.
- The bare positional argument is not “always source” — see **Positional path** below.

## Positional path (one slot, two roles)

`cmake [<options>] <path>` accepts **either**:

1. **Path to source** — that directory must contain a top-level `CMakeLists.txt`. CMake uses **current working directory** as the build tree (classic in-tree configure), *or* you use `-B` for out-of-tree.
2. **Path to existing build** — that directory must already contain `CMakeCache.txt` from a prior configure. CMake **reloads the source location from the cache** and re-runs configure+generate into that build tree.

CMake picks which role by inspecting what is at `<path>` (cache present → existing build; else must look like source).

Examples:

- From source parent: `cmake build` → if `build/` is an existing build tree, **reconfigure `build/`** (not “source is `build/`”).
- From inside `build/`: `cmake .` → **reconfigure this build tree** (source path comes from cache).
- First-time out-of-source: `cmake -S . -B build` — explicit; no ambiguity.

Prefer **`-S` / `-B`** when you want the contract spelled out in the command line.

## How it relates

- [Source vs build vs install](source-build-install-trees.md) — configure/generate outputs live in the **build** tree.
- Foundations in `learning.md`: Configure → Generate → Build; One configure ↔ one platform (later).

## Watch out

Single-config generators (Ninja, Makefiles): set `CMAKE_BUILD_TYPE` at **configure** time, not by switching configs in the IDE like multi-config generators.
