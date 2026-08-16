# Usage requirements (PRIVATE / PUBLIC / INTERFACE)

Visibility on **target commands** controls who inherits compile/link metadata. Propagation flows **along** `target_link_libraries` edges.

## When to use

Headers, defines, flags, or link deps must reach implementers vs consumers — or stay internal.

## What to expect

| Visibility | This target | Direct consumers | Propagates further |
|------------|-------------|------------------|--------------------|
| **PRIVATE** | yes | no | no |
| **INTERFACE** | no | yes | yes |
| **PUBLIC** | yes | yes | yes |

- `target_include_directories`, `target_compile_definitions`, `target_compile_options` — **decorate** a target (no new link edge).
- `target_link_libraries(consumer … dep)` — **creates** consumer → dep link edge **and** pulls dep's propagated requirements.

**Link edge visibility:** `target_link_libraries(app PRIVATE greeter)` means `app` uses `greeter` but does **not** re-export `greeter` to *app's* downstream consumers. `app` still gets `greeter`'s **PUBLIC** requirements.

## What NOT to expect

- Directory-scope `include_directories()` / `add_definitions()` as default style (global leak).
- `target_include_directories` creating a dependency edge by itself.

## How it relates

- [targets-as-atoms](targets-as-atoms.md) — requirements ride on the same target graph.
- Install/export — `BUILD_INTERFACE` / `INSTALL_INTERFACE` rewire paths for install-tree consumers.

## Projection

**Catchphrase:** "PRIVATE pocket, INTERFACE handshake, PUBLIC megaphone."  
**Mnemonic:** PIP — Private internal · Interface consumers-only · Public both

## Decision guide

| Situation | Visibility |
|-----------|------------|
| API headers in `include/` | **PUBLIC** `target_include_directories` |
| Internal headers in `src/` | **PRIVATE** includes |
| Dep only in `.cpp` | **PRIVATE** link |
| Dep types in public `.h` | **PUBLIC** link |
| Header-only library | **INTERFACE** target + **INTERFACE** includes |

## Build vs install (sketch)

```cmake
target_include_directories(mylib
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)
```

- **Build:** in-tree consumers get source-tree paths.
- **Install:** exported targets give install-prefix-relative paths to `find_package` users.

## Watch out

Marking internal paths or impl defines **PUBLIC** leaks them to every direct linker — classic CMake foot-gun (see session 3.3 scenario).
