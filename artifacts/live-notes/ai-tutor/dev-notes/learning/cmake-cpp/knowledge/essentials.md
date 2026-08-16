# CMake C++ — Essentials

Day-to-day quick reference. The 20% that covers 80% of use. Grow after sessions.

## Configure / build / install (Ninja)

| Item | Common use / combo | Watch out | → note |
|---|---|---|---|
| `cmake -S . -B build -G Ninja` | Out-of-source configure + generate | Don’t build in source | [configure-generate-build](configure-generate-build.md) |
| `build.ninja` | Ninja’s generated rule graph (after configure) | Not `ninja.build` | [configure-generate-build](configure-generate-build.md) |
| `cmake build` / `cmake -B build` | Re-configure after `CMakeLists` edits | Positional path = **existing build** if `CMakeCache.txt` there, else **source** | [configure-generate-build](configure-generate-build.md) |
| `cmake --build build` | Build | Reconfigure when `CMakeLists` change | — |
| `cmake --install build --prefix <pref>` | Populate install tree | Prefix ≠ build dir | — |

## Targets & usage requirements

| Item | Common use / combo | Watch out | → note |
|---|---|---|---|
| `add_subdirectory(dir)` | Load another `CMakeLists.txt` | Folder ≠ dependency; load lib dirs before exes that link them | [growing-the-tree](growing-the-tree.md) |
| `add_library` / `add_executable` | Create atoms | Prefer targets over directory globals | — |
| `target_link_libraries(t PRIVATE\|PUBLIC\|INTERFACE dep)` | Wire edges + propagate usage | PRIVATE on edge = no re-export to *your* consumers; you still use `dep` | [usage-requirements](usage-requirements.md) |
| `target_include_directories(t …)` | Attach `-I` paths to target | Does not create link edge; propagates along link edges | [usage-requirements](usage-requirements.md) |
| `target_include_directories(t PUBLIC \$<BUILD_INTERFACE:...> \$<INSTALL_INTERFACE:...>)` | Headers for build vs install | Forgetting INSTALL_INTERFACE breaks packages | — |

## Packages & version

| Item | Common use / combo | Watch out | → note |
|---|---|---|---|
| `find_package(Foo CONFIG REQUIRED)` | Consume imported targets | Prefer imported targets over raw vars | — |
| `write_basic_package_version_file` | Compat for `find_package` | Know SameMajor vs Exact | — |

## Cross / multi-platform

| Item | Common use / combo | Watch out | → note |
|---|---|---|---|
| `-DCMAKE_TOOLCHAIN_FILE=...` | One platform per build tree | Set on first configure of that build dir | — |
| Find root modes NEVER / ONLY | Host programs vs target libs | Mixing host/target libs = wrong arch link | — |
| Presets per triple | Host + ARM + RISC-V workflows | One binary dir per preset/platform | — |
