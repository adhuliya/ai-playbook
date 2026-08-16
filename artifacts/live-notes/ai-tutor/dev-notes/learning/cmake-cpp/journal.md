# Journal

## 2026-08-11 — Planning started

Motivation: novice → intermediate CMake mental model for complex C++ projects (build + packaging + versioning/maintenance); multi-platform/embedded (ARM, RISC-V, etc.) with per-platform packages. Time: ~2–4 h/week. Style: short graded drills first, tiny projects later. Env: macOS + Ninja. Floor: CMake 3.21+. Foundations agreed (7 models, including one-configure↔one-platform). No Project Lab (LLVM cited as scale example only). Next: learner reviews `learning.md`, may add resources, then `approve-plan`.

## 2026-08-11 — Curriculum approved

Status → `Approved`. No Project Lab / guide-spine. Foundations (7) and 17-step curriculum accepted. Next: `learn-session` (step 1 — first build loop).

## 2026-08-11 — Session 1: first build loop

Step 1 (~partial). Scores: foundations 4–5; 3.1=2, 3.2=5, 3.3=3, 3.4=5, 3.5=5. Strong: commands + hands-on. Weak: configure definition; `build.ninja` vs `ninja.build`. Status → `Active`. Artifact: `knowledge/artifacts/sessions/2026-08-11-first-build-loop.md`. Notes: `configure-generate-build.md`, `source-build-install-trees.md`. Next: self-quiz configure trio, then step 2 targets.

## 2026-08-11 — Self-quiz (configure / generate / build)

Learner tied configure+generate to `cmake` invocations; named `CMakeCache.txt` + `build.ninja` in `build/`; build via `cmake --build build`. Follow-up Q: why `cmake build` vs `cmake .` — clarified `path-to-source | path-to-existing-build` disambiguation via cache. Step 1 marked complete.

## 2026-08-13 — Session 2: targets as atoms

Step 2. Scores: foundations 5/5; exercises 3.1–3.4 all 5. Strong: configure definition fixed; target graph clear. Weak: none blocking (minor: explicit `LANGUAGES CXX` habit). Mastery: targets → learning. Artifact: `knowledge/artifacts/sessions/2026-08-13-targets-as-atoms.md`. Note: `knowledge/targets-as-atoms.md`. Next: step 3 usage requirements.

## 2026-08-16 — Session 4: growing the tree

Step 4. Worksheet: `knowledge/artifacts/sessions/2026-08-16-growing-the-tree-worksheet.md`. Scores: 1.A=5, 1.B=5, 3.1=5, 3.2=5, 3.3=5, 3.4=3. Strong: filing-cabinet vs wiring diagram; configure-order rule; link in consumer's CMakeLists. Weak: root must load `libs/` (correct paths) before `tools/` exes. Mastery: multi-dir layout → learning. Artifact: `knowledge/artifacts/sessions/2026-08-16-growing-the-tree.md`. Note: `knowledge/growing-the-tree.md`. Next: step 5 cache/options.
