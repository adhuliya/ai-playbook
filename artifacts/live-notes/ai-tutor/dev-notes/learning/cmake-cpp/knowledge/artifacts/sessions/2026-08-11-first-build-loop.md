# Session: First build loop (step 1)

**Date:** 2026-08-11  
**Topic:** Configure → Generate → Build with Ninja  
**Practice path:** `practice/step1-first-build/`

## Foundations recall

**A. Source vs build tree**  
Learner answer: Source has `*.cpp`; build has object files after build.

**B. Catchphrase**  
Learner answer: Ninja cooks; CMake configures and writes ninja build files; ninja executes them.

## Mental model offered

Configure → Generate → Build; projection: architect (CMake) vs line cook (Ninja). Mnemonic C→G→B.

## Exercises + verbatim answers

### 3.1 explain-a-concept (configure / generate / build)

> In configure I am not clear, in generate the ninja.build files are written, and in build ninja executes the build files.

### 3.2 complete-the-command

> Assuming step1-first-build is the cwd: `cmake -S . -B build -G Ninja` to configure and generate; `cmake --build build` to build.

### 3.3 predict-output

> Ninja reads 'ninja.build' file and it contains build instructions to execute for any particular target.

### 3.4 reconfigure after CMakeLists change

> `cmake build` will re-generate the build commands for ninja to pick up correctly.

### 3.5 hands-on

> I get 'hello from step1' after building.

## Grades (0–5)

| Item | Score | Comment |
|------|-------|---------|
| 1.A source vs build | 4 | Correct core; build tree also holds **generated** files (`build.ninja`, `CMakeCache.txt`), not only `.o`. |
| 1.B catchphrase | 5 | Clear and accurate. |
| 3.1 three phases | 2 | Generate/build OK; **configure** still fuzzy (main gap). |
| 3.2 commands | 5 | Correct out-of-source Ninja flow from practice cwd. |
| 3.3 predict file | 3 | Right idea; file is **`build.ninja`** (not `ninja.build`). |
| 3.4 reconfigure | 5 | `cmake build` re-runs configure+generate into existing dir. |
| 3.5 hands-on | 5 | Successful build output. |

**Strong:** Runnable command muscle memory; build loop works end-to-end.  
**Weak:** Configure phase definition; exact Ninja manifest filename.

## Configure clarification (post-grade)

- **Configure:** CMake reads `CMakeLists.txt`, detects toolchain/compiler, evaluates variables, records decisions in **`CMakeCache.txt`** (and related metadata). Errors here are “CMake didn’t accept your project description.”
- **Generate:** CMake writes backend files — for Ninja, chiefly **`build.ninja`** plus helper files under `build/CMakeFiles/`.
- With `-G Ninja`, one `cmake -S … -B …` invocation typically runs configure **then** generate back-to-back (still two logical phases).

## Oracle

Hands-on: learner reported `hello from step1` (success).
