# Session: Targets as atoms (step 2)

**Date:** 2026-08-13  
**Topic:** Targets are the atoms — `add_library`, `add_executable`, `target_link_libraries`  
**Practice path:** `practice/step2-targets/`

## Foundations recall

**1.A configure phase**  
Learner answer: configure phase locks options like which compiler to use, concrete values of variables if any, and other tools etc. It locks the choices in CMakeCache.txt in the build directory.

**1.B source vs build tree**  
Learner answer: The executable is generated in the build tree.

## Mental model offered

Targets are the atoms — graph of named products wired by `target_link_libraries`. Projection: org chart, not file pile. Catchphrase: "Name products, then wire the org chart." Mnemonic: ATG — Add atoms, Target-link edges, Graph drives the build.

## Exercises + verbatim answers

### 3.1 explain-a-concept

> A cmake target is an executable or a library. The target name is a logical name which helps build a dependency graph, it is not necessarily same as the file name like .a or .so created for the the named target.

### 3.2 complete-the-code

> The blanks in order are, 'add_library', 'add_executable', 'target_link_libraries'

### 3.3 predict-output

> 1. Cmake knows about two targets, namely, utils and demo. 2. demo links against the utils target.

### 3.4 from-scratch (hands-on)

Files: `greeter.h`, `greeter.cpp`, `main.cpp`, `CMakeLists.txt` under `practice/step2-targets/`.

```cmake
add_library(greeter STATIC greeter.cpp)
add_executable(app main.cpp)
target_link_libraries(app PRIVATE greeter)
```

Program output (`output.txt`): `Hello, CMake`

## Grades (0–5)

| Item | Score | Comment |
|------|-------|---------|
| 1.A configure | 5 | Clear: decisions + `CMakeCache.txt`; major improvement from step 1. |
| 1.B build tree | 5 | Correct. |
| 3.1 target concept | 5 | Logical name vs on-disk artifact; dependency graph — accurate. |
| 3.2 complete-the-code | 5 | All three commands correct. |
| 3.3 predict-output | 5 | Two targets; links by target name, not path. |
| 3.4 hands-on | 5 | Builds and runs; static lib + exe wired correctly. |

**Strong:** Target graph mental model landed cleanly; configure phase now crisp.  
**Weak:** Minor style: `project(app)` works but `project(... LANGUAGES CXX)` is clearer for C++-only trees (not graded down).

## Oracle

Hands-on: `output.txt` → `Hello, CMake` (success).
