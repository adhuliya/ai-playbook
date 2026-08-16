# Worksheet — Growing the tree

| Key | Value |
|---|---|
| activity | cmake-cpp |
| type | learn-session |
| date | 2026-08-16 |
| curriculum step | 4 — `add_subdirectory` + target graph ≠ folder tree |
| status | filled |
| graded artifact | [2026-08-16-growing-the-tree.md](2026-08-16-growing-the-tree.md) |

**Instructions:** Fill each **Your answer:** block below. Save the file, then tell
the agent you are done. Do not peek at graded artifacts until after submit.

*Retro-created after session — prompts match what was asked; answers copied from
`answer04.md` (verbatim).*

---

## 1. Foundations recall

### 1.A — Source vs build tree

You configure out-of-source: `cmake -S . -B build`. Root `CMakeLists.txt` has
`add_subdirectory(libs/core)`, and `libs/core/CMakeLists.txt` builds a static
library `core`.

Where do `core`'s object files and `libcore.a` typically land — under `libs/core/`
in the source tree, or under `build/`? One sentence, and why.

**Your answer:**

It lands in build/ tree as all build artifacts live there without disturbing the source tree.

### 1.B — Targets are the atoms

Layout:

```text
myproj/
  CMakeLists.txt
  app/main.cpp
  libs/math/math.cpp
```

Root `CMakeLists.txt` only has `project(myproj)` — no `add_subdirectory`, no
`target_link_libraries`.

Does `app` automatically compile against or link `math` because they share a
parent folder? Why or why not?

**Your answer:**

No, app does not automatically link againsh math library. The source directory tree does not define the targets and their dependence. The source tree is only an organizer or a filing cabinet. To create dependence realations and define all targets we need to use add_subdirectory() and define CMakeLists.txt in the added sub-directories.

---

## 3. Graded practice

### 3.1 — Explain-a-concept — folder vs target graph

In 2–3 sentences: why is the folder tree a poor mental model for CMake
dependencies? What model should replace it?

**Your answer:**

The folder tree is independent of CMake dependencies, i.e. the source trees can be organized as per the project development requirements. CMakeLists.txt define the dependencies explicitly and refer to the source directory structure as needed to locate the CMakeLists.txt files across the source tree. If the source tree changes, the corresponding change in add_subdirectory() is needed in CMakeLists.txt files.

### 3.2 — Complete-the-code — root CMakeLists

Fill in the **root** `CMakeLists.txt` only. Assume `libs/core/` and `app/` each
have their own `CMakeLists.txt` defining targets `core` and `app`.

```cmake
cmake_minimum_required(VERSION 3.21)
project(step4_demo LANGUAGES CXX)

# (a) Pull in both subtrees


# (b) Should `target_link_libraries(app PRIVATE core)` live HERE at the root,
#     or inside app/CMakeLists.txt? Pick one and say why in one sentence.
```

**Your answer:**

Root CMakeLists.txt is:
```cmake
cmake_minimum_required(VERSION 3.21)
project(step4_demo LANGUAGES CXX)
add_subdirectory(libs/core)
add_subdirectory(app)
```

The target_lib_libraries(app PRIVATE core) will live in the app/CMakeLists.txt.
I have added the sub-directory for core before the app sub-directory as app uses the core target,
if I flip the sub-directory addition, I suspect the cmake will fail to configure.

### 3.3 — Predict-output — configure order

```cmake
# root CMakeLists.txt
add_subdirectory(alpha)
add_subdirectory(beta)
```

```cmake
# alpha/CMakeLists.txt
add_library(alpha_lib STATIC alpha.cpp)
```

```cmake
# beta/CMakeLists.txt
add_library(beta_lib STATIC beta.cpp)
target_link_libraries(beta_lib PUBLIC alpha_lib)
```

#### 3.3.1

Does configure succeed with `alpha` before `beta`?

**Your answer:**

Yes, alpha before beta is the only correct way to define.

#### 3.3.2

If you swap the root lines (`beta` before `alpha`), does configure still succeed?
Why or why not?

**Your answer:**

No, it does not. After swap beta will refer to the target alpha_lib which shall only be known when alpha's CMakeLists.txt file is loaded.

### 3.4 — Design — multi-dir layout

Layout:

```text
step4/
  CMakeLists.txt
  libs/
    net/CMakeLists.txt   → static lib  net
    log/CMakeLists.txt   → static lib  log  (uses net internally)
  tools/
    ping/CMakeLists.txt  → executable ping  (uses log + net)
    dump/CMakeLists.txt  → executable dump  (uses log only)
```

List:
- which `add_subdirectory(...)` lines belong in **root** `CMakeLists.txt` (minimum set), and
- one `target_link_libraries(...)` line per executable with the right visibility.

Assume `log` links `net` with `PRIVATE` (ping/dump consumers should not re-export `net`).

**Your answer:**

The root CMakeLists.txt file shall contiain:
```cmake
add_subdirectory(ping)
add_subdirectory(dump)
```

The corresponding CMakeLists.txt for ping and dump will contain the following lines:
```cmake
target_link_libraries(ping PRIVATE log)
target_link_libraries(ping PRIVATE net)

target_link_libraries(dump PRIVATE log)
```

---

## Hands-on (optional)

Conceptual session only — no `practice/` build for this step.
