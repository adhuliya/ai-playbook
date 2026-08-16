# Session: Growing the tree (step 4)

**Date:** 2026-08-16  
**Topic:** `add_subdirectory` + target graph ≠ folder tree  
**Worksheet:** [2026-08-16-growing-the-tree-worksheet.md](2026-08-16-growing-the-tree-worksheet.md)

## Foundations recall

**1.A build tree for artifacts**  
Learner answer: It lands in build/ tree as all build artifacts live there without disturbing the source tree.

**1.B folder ≠ auto-link**  
Learner answer: No, app does not automatically link against math library. The source directory tree does not define the targets and their dependence. The source tree is only an organizer or a filing cabinet. To create dependence relations and define all targets we need to use add_subdirectory() and define CMakeLists.txt in the added sub-directories.

## Mental model offered

Growing the tree via `add_subdirectory`; projection: "Folders are filing cabinets; targets are the wiring diagram." Mnemonic ASW — Add subdirectory, Sibling dirs don't auto-wire, Wire with `target_link_libraries`. Configure order: a target must exist before another CMakeLists links to it.

## Exercises + verbatim answers

### 3.1 folder vs target graph

> The folder tree is independent of CMake dependencies, i.e. the source trees can be organized as per the project development requirements. CMakeLists.txt define the dependencies explicitly and refer to the source directory structure as needed to locate the CMakeLists.txt files across the source tree. If the source tree changes, the corresponding change in add_subdirectory() is needed in CMakeLists.txt files.

### 3.2 complete-the-code

```cmake
cmake_minimum_required(VERSION 3.21)
project(step4_demo LANGUAGES CXX)
add_subdirectory(libs/core)
add_subdirectory(app)
```

> The target_link_libraries(app PRIVATE core) will live in the app/CMakeLists.txt. I have added the sub-directory for core before the app sub-directory as app uses the core target, if I flip the sub-directory addition, I suspect the cmake will fail to configure.

### 3.3 predict-output

> 3.3.1: Yes, alpha before beta is the only correct way to define.  
> 3.3.2: No, it does not. After swap beta will refer to the target alpha_lib which shall only be known when alpha's CMakeLists.txt file is loaded.

### 3.4 design

> The root CMakeLists.txt file shall contain:  
> add_subdirectory(ping)  
> add_subdirectory(dump)  
>
> target_link_libraries(ping PRIVATE log)  
> target_link_libraries(ping PRIVATE net)  
> target_link_libraries(dump PRIVATE log)

## Grades (0–5)

| Item | Score | Comment |
|------|-------|---------|
| 1.A build tree | 5 | Correct — out-of-source artifacts under `build/`. |
| 1.B folder ≠ deps | 5 | Filing-cabinet framing matches the model; `add_subdirectory` + per-dir `CMakeLists` required. |
| 3.1 explain | 5 | Clear: layout is organizational; edges are explicit in CMake. |
| 3.2 complete + placement | 5 | Subdirs correct; link belongs in `app/CMakeLists.txt`; `core` before `app` so `core` exists when `app` configures. |
| 3.3.1 order alpha→beta | 5 | Configure succeeds. |
| 3.3.2 swapped order | 5 | `beta` runs before `alpha_lib` exists → configure error. |
| 3.4 root + links | 3 | **Link lines for exes are fine.** Root is incomplete: must load `libs/` (e.g. `add_subdirectory(libs/net)` + `add_subdirectory(libs/log)` with `net` first, or `add_subdirectory(libs)` via a `libs/CMakeLists.txt`). Paths are `tools/ping` and `tools/dump`, not bare `ping`/`dump`. |

**Strong:** Filing cabinet vs wiring diagram; configure-order rule; colocating `target_link_libraries` in the consumer's `CMakeLists.txt`.  
**Weak:** Minimum `add_subdirectory` set at root — easy to wire exes while forgetting to load library subtrees first.

## Model answer (3.4)

```cmake
# root CMakeLists.txt — one valid minimum
add_subdirectory(libs/net)
add_subdirectory(libs/log)
add_subdirectory(tools/ping)
add_subdirectory(tools/dump)
```

Or aggregate:

```cmake
add_subdirectory(libs)    # libs/CMakeLists.txt: add_subdirectory(net); add_subdirectory(log);
add_subdirectory(tools) # tools/CMakeLists.txt: add_subdirectory(ping); add_subdirectory(dump);
```

```cmake
# log/CMakeLists.txt
target_link_libraries(log PRIVATE net)

# tools/ping/CMakeLists.txt
target_link_libraries(ping PRIVATE log net)

# tools/dump/CMakeLists.txt
target_link_libraries(dump PRIVATE log)
```

## Oracle

Conceptual exercises only (no build oracle).
