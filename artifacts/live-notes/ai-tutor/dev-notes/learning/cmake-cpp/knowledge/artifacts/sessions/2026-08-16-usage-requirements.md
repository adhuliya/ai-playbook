# Session: Usage requirements (step 3)

**Date:** 2026-08-16  
**Topic:** PUBLIC / PRIVATE / INTERFACE — usage requirements on link edges  
**Answers file:** `practice/step2-targets/answers.txt`

## Foundations recall

**1.A `target_link_libraries(app PRIVATE greeter)`**  
Learner answer: app is the consumer of greeter. The PRIVATE label means the consumer of app will not see greeter.

**1.B three trees**  
Learner answer: Source tree contains the project source, the build tree contains artifacts generated like cache, build scripts and project build objects. The install tree contains the finally installed artifacts in a well defined location that the user uses in the long-term.

## Mental model offered

Usage requirements on edges; projection: PRIVATE pocket, INTERFACE handshake, PUBLIC megaphone. Mnemonic PIP. Clarified: `target_include_directories` decorates targets; propagation flows along `target_link_libraries` edges. BUILD_INTERFACE vs INSTALL_INTERFACE preview.

## Exercises + verbatim answers

### 3.1.1 PUBLIC vs PRIVATE for includes

> We choose PUBLIC when we want the consumers of the target know about or use its dependency, e.g. if a include directory requirement for a target foo is PUBLIC, a bar target dependent on foo will also use the foo's PUBLIC include directory..

### 3.1.2 INTERFACE for header-only

> A header only library uses INTERFACE to explicitly state no compilation is needed.

### 3.2 complete-the-code

> In order, 'PUBLIC', 'PRIVATE', 'PRIVATE'.

### 3.3 predict-output (leak scenario)

> 3.3.1: Yes the client compiles with access to internal/ headers as it is labeled PUBLIC in its assocition with secret target, and client target depends on secret target.  
> 3.3.2: Yes, because it is marked PUBLIC in association with secret, so when compiling client the cmake will pass the '-D SECRET_IMPL=1' along to it.  
> 3.3.3: Mark both the dependencies of secret as PRIVATE, as the client does not need them.

### 3.4 design choice

> add_library(engine STATIC engine.cpp)  
> target_link_libraries(engine PRIVATE zlib::zlib)  
> target_link_libraries(engine PUBLIC glm::glm)  
> add_library(stb_image INTERFACE stb_image.h)  
> target_link_libraries(engine PRIVATE stb_image)

## Grades (0–5)

| Item | Score | Comment |
|------|-------|---------|
| 1.A PRIVATE on link | 3 | Consumer/dep correct. **PRIVATE** means `app` does not *re-export* `greeter` to *its* consumers — not that `app` fails to use `greeter`. `app` still links and inherits `greeter`'s PUBLIC usage reqs. |
| 1.B three trees | 5 | Accurate; install tree for long-term consumers. |
| 3.1.1 PUBLIC includes | 5 | Clear propagation example. |
| 3.1.2 INTERFACE | 5 | Header-only = no compile on target. |
| 3.2 complete-the-code | 5 | PUBLIC/PRIVATE/PRIVATE — all correct. |
| 3.3 leak + fix | 5 | Diagnosed PUBLIC leak; PRIVATE fix correct. |
| 3.4 engine deps | 4 | zlib PRIVATE, glm PUBLIC, stb PRIVATE — visibilities right. stb as separate INTERFACE target is unconventional (stb usually compiled in one `.cpp` via `STB_IMAGE_IMPLEMENTATION`); PRIVATE link still correct. |

**Strong:** Leak scenario and 3.2 design choices; PUBLIC/PRIVATE for includes and link deps mostly fluent.  
**Weak:** Link-visibility PRIVATE ≠ “consumer doesn't see dependency”; means no re-export downstream.

## Post-grade clarification (1.A)

`target_link_libraries(app PRIVATE greeter)`:

- `app` **does** link `greeter` and **does** receive `greeter`'s **PUBLIC** usage requirements.
- **PRIVATE** on this edge: if something later linked `app` as a library, it would **not** automatically inherit `greeter` through `app`.

## Oracle

Conceptual exercises only (no build oracle).
