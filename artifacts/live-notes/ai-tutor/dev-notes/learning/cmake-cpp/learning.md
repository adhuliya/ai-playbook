# CMake for C++ (Intermediate Mental Models)

| Key | Value |
|---|---|
| status | Active |
| slug | cmake-cpp |
| level | beginner → intermediate |
| notes | 2–4 h/wk; drills then tiny projects; macOS + Ninja; CMake 3.21+ floor |

# Goal

Build a durable intermediate mental model of CMake for C++: how configure/generate/build work, how to structure and grow multi-target projects, how to install/export/package with versioning, and how to think when the same project must build for multiple platforms (e.g. host + ARM + RISC-V) with matching packages — without needing LLVM-specific layout knowledge.

# Foundations

Pinned core mental models. Reinforced every session.

| Mental model | Essence (when / what / not / relates) | Last reviewed |
|---|---|---|
| Configure → Generate → Build | When touching a build: CMake configures + generates Ninja files; Ninja builds. Not the compiler. Relates to IDE generators vs Ninja. | 2026-08-13 |
| Targets are the atoms | When wiring libs/exes/deps: named targets + edges. Not one giant source list or “directory = dependency.” Relates to Make file-rules. | 2026-08-16 |
| Usage requirements on edges | When headers/flags/deps must reach consumers: PRIVATE / INTERFACE / PUBLIC propagate. Not global include_directories. Relates to package API vs impl. | 2026-08-16 |
| Source vs build vs install tree | When developing, CI, shipping: out-of-source build; consumers use install tree. Not build-in-source or `#include` from a clone. Relates to packaging contract. | 2026-08-16 |
| Packages are contracts | When depending or shipping: `find_package` ↔ export/Config files + imported targets. Not hard-coded paths. Relates to FetchContent vs system pkgs; CPack ≠ Config. | (unreviewed) |
| Version, policy, compatibility | When bumping CMake or your project: `cmake_minimum_required`/policies = dialect; `VERSION` + package version files = your compat story. Not “git tag only.” Relates to API vs ABI/SOVERSION. | (unreviewed) |
| One configure ↔ one target platform | When multi-arch/embedded (ARM, RISC-V, …): one build tree + toolchain file per platform; package per arch. Not one configure emitting all arches. Relates to host tools vs target artifacts; presets. | (unreviewed) |

# Curriculum

Ordered session-sized steps (~20 min graded core; weekly time allows 1–2 sessions + a tiny project stretch).

1. [x] First build loop — model: Configure → Generate → Build — practice: complete-the-command, predict-output — evidence: explain the three phases + run out-of-source Ninja build — session 2026-08-11 + positional-path clarify — ties to: Configure→Generate→Build; source vs build tree
2. [x] Targets as atoms — model: Targets are the atoms — practice: complete-the-code, from-scratch mini — evidence: exe + static lib linked via `target_link_libraries` — session 2026-08-13 — ties to: Targets
3. [x] Usage requirements — model: PUBLIC / PRIVATE / INTERFACE — practice: predict-output, explain-a-concept — evidence: correct propagation choice for headers + link deps (≥4) — session 2026-08-16 — ties to: Usage requirements; Packages
4. [x] Growing the tree — model: `add_subdirectory` + target graph ≠ folder tree — practice: complete-the-code, explain — evidence: multi-dir project with clear target edges (≥4; 3.4 root load order gap) — session 2026-08-16 — ties to: Targets; source/build tree
5. [ ] Cache, options, and “why did that stick?” — model: cache vs normal vars — practice: predict-output, complete-the-command — evidence: flip an `option()`, reconfigure, explain cache — ties to: Configure phase; Version/policy
6. [ ] Build type & genex (Ninja single-config) — model: config-time vs build-time selection — practice: complete-the-code — evidence: Debug/Release flags via genex or `CMAKE_BUILD_TYPE` correctly — ties to: Configure→Build; Usage requirements
7. [ ] Consuming packages — model: Packages are contracts (consumer) — practice: complete-the-code, explain — evidence: `find_package` + imported target link (no raw paths) — ties to: Packages; Usage requirements
8. [ ] Install tree — model: Source vs build vs install — practice: complete-the-command, from-scratch — evidence: `cmake --install` layout with libs/headers/bin — ties to: Install tree; Packages
9. [ ] Exporting your package — model: Packages are contracts (provider) — practice: from-scratch, explain — evidence: Config file + imported targets consumable from another project — ties to: Packages; Usage requirements
10. [ ] Versioning & compatibility — model: Version, policy, compatibility — practice: predict-output, explain — evidence: `project(VERSION)`, `write_basic_package_version_file`, state SameMajorVersion vs Exact — ties to: Version/policy; Packages
11. [ ] Maintaining CMake dialect — model: `cmake_minimum_required` + policies — practice: explain-a-concept, complete-the-code — evidence: justify a minimum version and one policy effect — ties to: Version/policy
12. [ ] Dependency strategies — model: find_package vs FetchContent/vendoring — practice: explain, predict — evidence: choose strategy for a given constraint (≥4) — ties to: Packages; Targets
13. [ ] Cross-compiling with toolchains — model: One configure ↔ one target platform — practice: complete-the-code, explain — evidence: toolchain file + separate build dirs for two “arches”; host≠target find modes — ties to: One-platform; Configure; Install tree
14. [ ] Multi-platform packaging — model: package-per-arch + host tools vs target artifacts — practice: from-scratch stretch, explain — evidence: two install/package outputs (e.g. host + fake-embedded) with versioned Config — ties to: One-platform; Packages; Version
15. [ ] Presets for many platforms — model: presets encode platform dials — practice: complete-the-command — evidence: `CMakePresets.json` with host + cross configure presets driving Ninja — ties to: One-platform; Configure→Generate→Build
16. [ ] Large-project thinking — model: modular CMake + target graph at scale — practice: explain-a-concept (patterns inspired by large trees, not LLVM tour) — evidence: sketch module boundaries, helper functions vs macros, what belongs in toolchain vs project — ties to: all Foundations
17. [ ] Capstone tiny project — model: integrate Foundations — practice: from-scratch — evidence: small multi-lib C++ repo: options, install/export/version, two platform presets (host + cross toolchain), graded review ≥4 overall — ties to: all Foundations

# Milestones

1. [ ] Can drive configure/generate/build with Ninja out-of-source and explain each phase — evidence: session ≥4 on step 1 + verbal explain — reached:
2. [ ] Can author target-centric multi-dir CMake with correct PUBLIC/PRIVATE/INTERFACE — evidence: steps 2–4 practice ≥4 — reached: steps 2–3 ≥4; step 4 mostly ≥4 (3.4 root `add_subdirectory` set needs reinforcement)
3. [ ] Can install + export a versioned Config package and consume it via `find_package` — evidence: steps 8–10 working solution — reached:
4. [ ] Can cross-build the same project for two platforms (separate build trees/toolchains) and package accordingly — evidence: steps 13–15 working solution — reached:
5. [ ] Capstone graded ≥4 — evidence: step 17 session/artifact — reached:

# Mastery

| Topic | Level | Evidence | Notes |
|---|---|---|---|
| Configure / generate / build / Ninja | learning | Sessions 2026-08-11, 2026-08-13: configure now crisp (`CMakeCache.txt`); commands solid | Ready to mark solid after one more ≥4 recall |
| Targets & `target_*` | learning | Session 2026-08-13 step 2: all exercises ≥5; hands-on `practice/step2-targets/` | |
| PUBLIC / PRIVATE / INTERFACE | learning | Session 2026-08-16 step 3: 3.2–3.4 ≥4; leak scenario solid | Clarify: PRIVATE link edge ≠ consumer doesn't use dep |
| Multi-directory layout | learning | Session 2026-08-16 step 4: 3.1–3.3 ≥5; 3.4 root load order gap (3) | Remember libs/ before tools/ |
| Cache & options | novice | — | |
| Genex / build type | novice | — | |
| find_package (consumer) | novice | — | |
| install / export / Config packages | novice | — | |
| Versioning & compatibility | novice | — | |
| Policies / min CMake | novice | — | |
| FetchContent vs find_package | novice | — | |
| Toolchains / cross-compile | novice | — | |
| Multi-platform packaging & presets | novice | — | |
| Large-project CMake structure | novice | — | |

Strong points: configure phase; target graph; PUBLIC/PRIVATE for includes + leak diagnosis; configure-order rule for `add_subdirectory`
Weak points: root minimum `add_subdirectory` set (load lib subtrees before exes); PRIVATE on link edge (re-export vs use); packaging/cross-compile (planned)

# Mental Models

(Seeded at planning; expanded each session.)

## Configure → Generate → Build
- When to use: any CMake invocation or “why isn’t my change picked up?”
- Expect: configure reads `CMakeLists` → generate writes Ninja → build compiles/links
- Not: CMake is not the everyday compile driver; Ninja is
- Relates to: presets (saved configure); toolchain (configure-time platform dial)
- Projection: catchphrase — “CMake writes the recipe; Ninja cooks.”
- Mnemonics: C→G→B — Cache/decide, Generate files, Build binaries

## Targets are the atoms
- When to use: adding libraries/exes, wiring deps, reading a large tree
- Expect: graph of named targets; edges carry link + usage requirements
- Not: folder hierarchy alone; one mega source variable
- Relates to: usage requirements; packages (imported targets)
- Projection: analogy — org chart of products, not a pile of `.cpp` files
- Mnemonics: —

## Usage requirements on edges (PRIVATE / INTERFACE / PUBLIC)
- When to use: headers, defines, link deps for implementers vs consumers
- Expect: PRIVATE=me; INTERFACE=them; PUBLIC=both; they propagate along link edges
- Not: global `include_directories` / `add_definitions` as default style
- Relates to: install/export (what you ship as API)
- Projection: catchphrase — “PRIVATE pocket, INTERFACE handshake, PUBLIC megaphone.”
- Mnemonics: PIP — Private Internal, Interface Public-facing-only, Public both

## Source vs build vs install tree
- When to use: layout, CI, packaging, “where do consumers look?”
- Expect: source=inputs; build=scratch outputs; install=relocatable product layout
- Not: in-source builds; consumers pointing at your build dir long-term
- Relates to: packages; multi-platform (one install tree per platform build)
- Projection: diagram — three boxes: Source → Build → Install/Package
- Mnemonics: —

## Packages are contracts
- When to use: depending on or publishing libraries
- Expect: Config + imported targets + usage requirements; version file states compat
- Not: absolute paths; CPack alone as the “package API”
- Relates to: FetchContent (different contract); usage requirements
- Projection: analogy — shipping a sealed adapter plug, not bare wires
- Mnemonics: —

## Version, policy, compatibility
- When to use: bumps, supporting multiple consumers, reading old projects
- Expect: min CMake+policies set dialect; project/package version set your compat promise
- Not: version only in git tags; ignoring policy warnings forever
- Relates to: packages; maintenance of large trees
- Projection: catchphrase — “Policies are CMake’s dialect; VERSION is your promise.”
- Mnemonics: —

## One configure ↔ one target platform
- When to use: embedded/multi-arch (ARM, RISC-V, host tools, …)
- Expect: toolchain file + dedicated build tree per platform; package per arch; host programs vs target libs (find root modes)
- Not: one configure producing all architectures; mixing host and target libs in `find_*`
- Relates to: install trees; presets; packages-as-contracts
- Projection: catchphrase — “One kitchen (build dir) per cuisine (triple).”
- Mnemonics: NEVER programs / ONLY libs+headers (find root modes)

## Growing the tree (`add_subdirectory`)
- When to use: multi-dir projects; loading subtrees; monorepo-style layouts
- Expect: `add_subdirectory` loads another `CMakeLists.txt` in configure order; targets become linkable by name; wire edges with `target_link_libraries`
- Not: folder nesting = automatic deps; `add_subdirectory` without explicit link edges
- Relates to: targets are atoms; usage requirements; source vs build tree (`binary_dir`)
- Projection: catchphrase — “Folders are filing cabinets; targets are the wiring diagram.”
- Mnemonics: ASW — Add subdirectory, Sibling dirs don't auto-wire, Wire explicitly

# Next Steps

1. `learn-session` — curriculum step 5 (cache, options, and “why did that stick?”).
2. Optional reinforcement: sketch root `add_subdirectory` lines for the step 4 `libs/` + `tools/` layout (see session artifact 3.4 model answer).
3. Optional skim: `knowledge/growing-the-tree.md`.

# References

- knowledge: `knowledge/knowledge.md`
- essentials: `knowledge/essentials.md`
- resources (links): `knowledge/artifacts/resources/README.md`
- Official manuals (primary):
  - [cmake(1)](https://cmake.org/cmake/help/latest/manual/cmake.1.html)
  - [cmake-buildsystem(7)](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html)
  - [cmake-packages(7)](https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html)
  - [cmake-toolchains(7)](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html)
  - [cmake-presets(7)](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html)
  - [CMake Tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
  - [Cross Compiling With CMake (Mastering CMake)](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html)
- Strong free guide: [An Introduction to Modern CMake (cliutils)](https://cliutils.gitlab.io/modern-cmake/)
- Optional deep book (paid, excellent): *Professional CMake: A Practical Guide* (Craig Scott)
- Large-project inspiration (patterns only, not a lab): LLVM/CMake as existence proof of target-centric scale — do not study LLVM layout unless you later bind a Project Lab
