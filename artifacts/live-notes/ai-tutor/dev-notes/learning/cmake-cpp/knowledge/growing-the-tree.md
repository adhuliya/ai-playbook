# Growing the tree (`add_subdirectory`)

Split a project across directories while keeping a **target-centric** dependency graph.

## When to use

Multi-dir layouts, monorepos, pulling in subtrees with `add_subdirectory`.

## What to expect

- `add_subdirectory(<source_dir> [<binary_dir>])` runs another `CMakeLists.txt` **during configure**, in call order.
- Targets defined in a subdirectory are visible in the **current directory scope** once that subdirectory has been added.
- Cross-directory wiring uses the same `target_link_libraries` edges as a flat project.
- Optional `[binary_dir]` keeps that subtree's generated files under the build tree.

## What NOT to expect

- Nested folders ⇒ automatic link dependencies.
- `add_subdirectory` alone expressing "this folder depends on that folder" — it only **loads** CMake logic; you **wire** edges explicitly.
- Sibling folders seeing each other's targets without a common ancestor having added both subtrees (and correct order).

## How it relates

- [targets-as-atoms](targets-as-atoms.md) — same nodes/edges, spread across dirs.
- [usage-requirements](usage-requirements.md) — PUBLIC/PRIVATE/INTERFACE propagate along link edges regardless of which subdir defined a target.
- [source-build-install-trees](source-build-install-trees.md) — build artifacts stay under the build tree; optional per-subdir `binary_dir`.

## Projection

**Catchphrase:** "Folders are filing cabinets; targets are the wiring diagram."

```
  root/CMakeLists.txt
        │
        ├── add_subdirectory(libs/core)  ──► target: core
        ├── add_subdirectory(libs/fmt)   ──► target: fmt  ──links──► core
        └── add_subdirectory(app)        ──► target: app   ──links──► fmt
```

**Mnemonic — ASW:** **A**dd subdirectory → targets exist in scope → **S**ibling dirs don't auto-wire → **W**ire with `target_link_libraries`.

## Configure-order rule

A target must **exist** before another `CMakeLists.txt` links to it.

```cmake
# root — alpha before beta
add_subdirectory(alpha)   # defines alpha_lib
add_subdirectory(beta)    # target_link_libraries(beta_lib PUBLIC alpha_lib)  ✓
```

Swapping the two `add_subdirectory` lines at the root breaks configure if `beta` links `alpha_lib`.

When the link line lives in `app/CMakeLists.txt`, add the subdirectory that **defines** `core` **before** `add_subdirectory(app)`.

## Style

Prefer `target_link_libraries` in the **consumer's** `CMakeLists.txt` (e.g. `app/` owns `app → core`), not at the root — unless the root is deliberately orchestrating a small tree.

## Watch out

- Forgetting to `add_subdirectory` library dirs — executables won't find `log` / `net` targets.
- Paths must match the source tree (`tools/ping`, not `ping` at repo root).
- Load order: define providers before consumers (`net` before `log` if `log` links `net`).

## Practice

Session step 4 — `answer04.md`; optional hands-on tree under `practice/step4-growing-tree/` (not yet scaffolded).
