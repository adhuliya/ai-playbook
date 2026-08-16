# Systems DSA & Design

| Key | Value |
|---|---|
| status | Approved |
| slug | system-dsa |
| level | intermediate |
| notes | No Project Lab. C11 primary (C++ OK Chunk 4–5). ~6 h/wk; five 2-month chunks. Modules 1–4 woven in. |

# Goal

Cut everyday systems-programming friction: implement core structures and algorithms fluently, and harden practical systems know-how usable in compilers, embedded OS, and edge-runtime work. Not FAANG-interview drilling — durable craft for career use.

Cadence: brush-up across an area cluster, then from-scratch for that cluster. ~6 hours/week over ~10 months in five 2-month chunks. Depth of many topics is tuned **on the go**; named topics stay on the map.

**Domain modules woven into chunks** (not a separate spine):

| Module | Focus | Depth defaults |
|---|---|---|
| 1 Embedded memory & streams | arrays, bits/fixed-width, rings, pointer safety, MMIO pattern | implement rings/bits; MMIO high-level; atomic flags light until Chunk 4 |
| 2 Compiler linear/hierarchical | tokens/lex, lists-as-contrast, stacks, AST, recursive-descent, Shunting-Yard | **recursive-descent production-grade**; Shunting-Yard high-level; full topic list |
| 3 Symbol tables & lookup | hash (OA vs chaining), tries, FNV/djb2, scoped tables | hash deep; trie insert/search/prefix; hash fns practical 1–2 |
| 4 Scheduling & OS queues | heaps, intrusive DLLs, ready/blocked/timer sketch, locking protocols | intrusive DLL implement; thin scheduler sketch; locking in Chunk 4; payoff in Chunk 5 |

**Add on the go:** small topic → append step + journal; cluster → `notes.md` parking lot then review; Foundations/goal shift → `replan-learning`.

# Foundations

Pinned core mental models. Reinforced every session; new material relates back here.

| Mental model | Essence (when / what / not / relates) | Last reviewed |
|---|---|---|
| Cost model (time + space + constants) | When choosing/comparing algs: expect asymptotics *and* cache/branch/alloc reality; not “Big-O is the whole story”; relates to complexity theory vs hardware cost | (unreviewed) |
| Memory as the first resource | When designing buffers, graphs, kernels: expect layout, locality, ownership, lifetime; not “RAM is infinite”; relates to allocators and data-oriented design | (unreviewed) |
| Indirection vs contiguity | When picking arrays, trees, graphs, hashes: expect pointer-chasing vs scan tradeoffs; not “linked lists are always fine”; relates to CSR vs pointer graphs | (unreviewed) |
| Concurrency as shared-state protocol | When queues, pools, runtimes: expect happens-before, races, wait-freedom vs locks; not “add a mutex and done”; relates to message-passing and ownership | (unreviewed) |
| Layered systems design | When APIs, schedulers, services: expect clear contracts, failure domains, backpressure; not “draw boxes once and ship”; relates to interface vs implementation | (unreviewed) |
| Correctness under constraints | When embedded/compilers/edge: expect invariants, resource bounds, failure modes; not “happy path only”; relates to testing and defensive design | (unreviewed) |

# Curriculum

Ordered session-sized steps. Brush-up → from-scratch per chunk. **Language:** C11 primary; C++ allowed in Chunk 4–5 when threads/atomics save time (record language in session artifact). If a chunk runs hot: shrink brush-up reps, not the recursive-descent track. Chunk 2 overrun: spill **trie** or **thin ICG** into early Chunk 3.

## Chunk 1 — Core structures + Module 1 (months 1–2)

1. [ ] Cost model refresh — model: asymptotic vs constants — practice: explain-a-concept, predict-output — evidence: explain ≥4 on “when O(n) loses to O(n log n)” — ties to: Cost model
2. [ ] Contiguous vs pointers + fixed-width — model: static arrays, `stdint`, stack vs heap limits — practice: explain-a-concept, predict-output — evidence: name ownership/lifetime/layout risks ≥4 — ties to: Memory; Correctness under constraints
3. [ ] Pointer arithmetic safety — model: bounds, provenance intuition — practice: predict-output, complete-the-code — evidence: spot UB in snippets ≥4 — ties to: Memory; Correctness
4. [ ] Bit manipulation & bit arrays — model: mask/set/clear/test; packed flags — practice: complete-the-code, explain — evidence: register-style mask ops correct ≥4 — ties to: Memory; Cost model
5. [ ] MMIO pattern (high-level) — model: volatile + width + mask for “registers” — practice: explain-a-concept — evidence: when/not of MMIO-style access ≥4 — ties to: Layered systems design; Memory
6. [ ] Dynamic array / growth — model: amortised growth policy — practice: complete-the-code, predict-output — evidence: amortised cost reasoning ≥4 — ties to: Memory; Indirection vs contiguity
7. [ ] Ring buffers (UART/SPI story) — model: circular buffer, empty/full, power-of-two mask — practice: explain-a-concept, complete-the-code — evidence: empty/full distinction ≥4 — ties to: Memory; Correctness
8. [ ] Atomic flags (light intro) — model: flag as protocol stub — practice: explain-a-concept — evidence: what this is not (full atomics later) ≥4 — ties to: Concurrency
9. [ ] Open-address hashing — model: probing + load factor + short-string hash preview — practice: predict-output, explain — evidence: tombstone vs rehash ≥4 — ties to: Cost model; Contiguity
10. [ ] Binary heap / priority queue — model: implicit heap; scheduler foreshadow — practice: complete-the-code, predict-output — evidence: sift-up/down ≥4 — ties to: Cost model; Contiguity
11. [ ] From-scratch: growable vector (C) — model: growth + length/capacity — practice: from-scratch — evidence: push/pop/reserve tests ≥4 — ties to: Memory; Cost model
12. [ ] From-scratch: ring buffer (C) — model: stream buffer ready for SPSC later — practice: from-scratch — evidence: wrap + empty/full ≥4 — ties to: Memory; Correctness
13. [ ] From-scratch: open-address hashmap (C) — model: probe + load + rehash — practice: from-scratch — evidence: insert/find/erase ≥4 — ties to: Cost model; Module 3 prep

## Chunk 2 — Graphs + Modules 2–3 compiler cluster (months 3–4)

14. [ ] Graph representations — model: adj list vs CSR/COO — practice: explain-a-concept — evidence: choose rep for sparse graph ≥4 — ties to: Indirection vs contiguity; Memory
15. [ ] BFS / DFS on graphs — model: frontier vs stack — practice: predict-output, complete-the-code — evidence: trace ≥4 — ties to: Cost model
16. [ ] Topological order — model: Kahn / DFS postorder — practice: explain, predict-output — evidence: cycle vs order ≥4 — ties to: Layered systems design; Correctness
17. [ ] Union-Find — model: parent + rank/path compression — practice: complete-the-code, predict-output — evidence: amortised intuition ≥4 — ties to: Cost model
18. [ ] Worklists & fixed-point (thin) — model: iterative dataflow — practice: explain-a-concept — evidence: when fixed-point reached / what it is not ≥4 — ties to: Correctness
19. [ ] From-scratch: CSR + topo (C) — model: build CSR + Kahn — practice: from-scratch — evidence: topo or cycle ≥4 — ties to: Contiguity; Cost model
20. [ ] From-scratch: Union-Find (C) — model: DSU — practice: from-scratch — evidence: components API ≥4 — ties to: Cost model
21. [ ] From-scratch: tiny worklist dataflow (thin, C) — model: bitvector lattice + worklist — practice: from-scratch — evidence: one small fixed-point ≥4 — ties to: Correctness
22. [ ] Lexing / token stream — model: scanner → contiguous token array (list only as contrast) — practice: explain, complete-the-code — evidence: lex identifiers/numbers/keywords sketch ≥4 — ties to: Layered systems design; Contiguity
23. [ ] Linked lists as contrast — model: token chains when indirection wins — practice: explain-a-concept — evidence: when/not vs contiguous tokens ≥4 — ties to: Indirection vs contiguity
24. [ ] Stacks for parse/eval — model: LIFO for descent and shunting — practice: complete-the-code, predict-output — evidence: expression/stack traces ≥4 — ties to: Cost model
25. [ ] AST as N-ary tree — model: hierarchy for syntax — practice: explain-a-concept, predict-output — evidence: build/read small AST ≥4 — ties to: Indirection vs contiguity; Layered systems design
26. [ ] DFS walk / emit sketch — model: tree walk for code emission — practice: complete-the-code — evidence: preorder/postorder emit ≥4 — ties to: Cost model
27. [ ] Shunting-Yard (high-level) — model: infix → postfix intuition — practice: explain-a-concept, predict-output — evidence: when/not vs recursive-descent ≥4 — ties to: Layered systems design
28. [ ] Recursive-descent (deep) part 1 — model: grammar → mutually recursive parsers — practice: explain, complete-the-code — evidence: parse a small expression grammar ≥4 — ties to: Correctness; Layered systems design
29. [ ] Recursive-descent (deep) part 2 — model: errors, precedence, left-recursion pitfalls — practice: from-scratch (start) — evidence: error recovery strategy stated ≥4 — ties to: Correctness
30. [ ] From-scratch: production-leaning recursive-descent (C) — model: lexer + parser + AST — practice: from-scratch — evidence: graded ≥4 on agreed grammar subset — ties to: Module 2 primary track
31. [ ] Hash functions (FNV-1a / djb2) — model: short-string hashes — practice: complete-the-code, explain — evidence: implement 1–2; know failure modes ≥4 — ties to: Cost model; Module 3
32. [ ] Chaining vs open addressing under memory pressure — model: collision policy — practice: explain-a-concept — evidence: choose under tight RAM ≥4 — ties to: Memory; Cost model
33. [ ] Symbol tables & scope — model: stack of tables / nested scopes — practice: explain, complete-the-code — evidence: resolve identifier across scopes ≥4 — ties to: Layered systems design; Correctness
34. [ ] Tries (prefix trees) — model: insert/search/prefix for keywords — practice: complete-the-code, explain — evidence: trie ops ≥4 (not Patricia unless expanded later) — ties to: Cost model; Memory
35. [ ] From-scratch: scoped symbol table (C) — model: hash map(s) + scope enter/exit — practice: from-scratch — evidence: define/lookup/shadow ≥4 — ties to: Module 3
36. [ ] From-scratch: trie keyword router (C) — model: insert/search/prefix — practice: from-scratch — evidence: ≥4 — ties to: Module 3
37. [ ] ICG sketch (thin) — model: AST walk → tiny 3-address or bytecode-ish — practice: explain, complete-the-code — evidence: emit for a tiny AST ≥4 — ties to: Layered systems design — spill to Chunk 3 if needed

## Chunk 3 — Memory & locality + Module 1 budgets (months 5–6)

38. [ ] Allocators map — model: bump/arena vs freelist/pool vs general heap — practice: explain-a-concept — evidence: when/not ≥4 — ties to: Memory; Layered systems design
39. [ ] Arena / bump — model: monotonic region + reset — practice: complete-the-code — evidence: lifetime rules ≥4 — ties to: Memory; Correctness
40. [ ] Object pool / freelist — model: fixed-size reuse — practice: predict-output, explain — evidence: fragmentation tradeoff ≥4 — ties to: Memory; Cost model
41. [ ] SoA vs AoS — model: layout for scan vs identity — practice: explain-a-concept — evidence: pick layout for hot loop ≥4 — ties to: Indirection vs contiguity
42. [ ] Systems sorting intuition — model: radix / in-place / comparison when — practice: explain, predict-output — evidence: when radix wins ≥4 — ties to: Cost model; Memory
43. [ ] Embedded budget revisit — model: fixed stacks/heaps/pools under caps — practice: explain-a-concept — evidence: design under hard mem cap ≥4 — ties to: Correctness under constraints
44. [ ] From-scratch: arena + object pool (C) — model: bump + typed freelist — practice: from-scratch — evidence: alloc/free/reset + bounds ≥4 — ties to: Memory; Correctness
45. [ ] From-scratch: cache-aware rewrite — model: SoA or contiguous rewrite of an earlier structure — practice: from-scratch — evidence: before/after rationale + code ≥4 — ties to: Contiguity; Cost model
46. [ ] (Spill slot) Trie or thin ICG if deferred from Chunk 2 — model: per earlier step — practice: as needed — evidence: ≥4 — ties to: Module 2–3

## Chunk 4 — Concurrency + locking (months 7–8)

47. [ ] Shared-state protocols — model: mutex / CV as protocol (resource locking) — practice: explain-a-concept — evidence: bounded buffer with CV ≥4 — ties to: Concurrency; Module 4
48. [ ] Atomics & ordering (full) — model: loads/stores/RMW + happens-before — practice: predict-output, explain — evidence: identify a race ≥4 — ties to: Concurrency; Correctness — payoff for Module 1 atomic-flags intro
49. [ ] ABA & progress — model: lock-free vs blocking — practice: explain-a-concept — evidence: what lock-free does/not ≥4 — ties to: Concurrency; Cost model
50. [ ] SPSC vs MPMC — model: ring vs multi-producer queues — practice: explain, complete-the-code — evidence: choose correctly ≥4 — ties to: Concurrency; Memory
51. [ ] From-scratch: SPSC lock-free ring — model: atomic indices + padding — practice: from-scratch — evidence: stress or agent-review ≥4 — ties to: Concurrency; Memory — C or C++
52. [ ] From-scratch: small thread pool — model: queue + workers + shutdown — practice: from-scratch — evidence: submit/wait/shutdown ≥4 — ties to: Concurrency; Layered systems design — C++ OK

## Chunk 5 — Synthesis + Module 4 payoff (months 9–10)

53. [ ] Pipelines & stages — model: staged processing + batching — practice: explain-a-concept — evidence: compile-like or I/O pipeline sketch ≥4 — ties to: Layered systems design
54. [ ] Backpressure — model: bounded queues signal “slow down” — practice: explain, predict-output — evidence: unbounded failure mode ≥4 — ties to: Correctness; Concurrency
55. [ ] Intrusive doubly linked lists — model: O(1) unlink; ready/blocked queues — practice: explain, complete-the-code — evidence: insert/remove/iterate ≥4 — ties to: Indirection vs contiguity; Module 4
56. [ ] Timer / timeout events — model: heap of timeouts + list of waiters — practice: explain-a-concept — evidence: tick dispatch sketch ≥4 — ties to: Cost model; Module 4
57. [ ] Scheduler sketch — model: ready queue priorities/fairness + blocked lists — practice: explain-a-concept — evidence: FIFO vs priority tradeoffs ≥4 — ties to: Layered systems design; Module 4
58. [ ] From-scratch: intrusive DLL + timer heap (C) — model: ready/blocked + extract-min timeouts — practice: from-scratch — evidence: ≥4 — ties to: Module 4
59. [ ] Capstone part 1 — model: pool + queues + heap wired — practice: from-scratch — evidence: interim ≥3 — ties to: all Foundations
60. [ ] Capstone part 2 — model: backpressure + failure domains + clean shutdown — practice: from-scratch — evidence: reject/block when full; ≥4 — ties to: Correctness; Concurrency; Module 4
61. [ ] Capstone review — model: design retrospective — practice: explain-a-concept — evidence: when/not of each piece ≥4 — ties to: all Foundations

# Milestones

1. [ ] Chunk 1 complete — evidence: vector + ring + open-address map ≥4 — reached:
2. [ ] Chunk 2 graphs slice — evidence: CSR+topo + Union-Find + thin worklist ≥4 — reached:
3. [ ] Chunk 2 compiler slice — evidence: recursive-descent (lexer+parser+AST) ≥4; symbol table ≥4; trie ≥4; Shunting-Yard explanation ≥4 — reached:
4. [ ] Chunk 3 complete — evidence: arena+pool + cache-aware rewrite ≥4 — reached:
5. [ ] Chunk 4 complete — evidence: SPSC ring + thread pool ≥4 — reached:
6. [ ] Chunk 5 complete — evidence: intrusive DLL+timer heap ≥4; capstone ≥4 + retrospective ≥4 — reached:

# Mastery

Levels: novice → learning → solid → mastered. Advance only on repeated ≥4 evidence.

| Topic | Level | Evidence | Notes |
|---|---|---|---|
| Classic sequential DSA | learning | (none yet) | Fluency/speed target |
| Module 1 embedded bits/rings/MMIO pattern | novice | (none yet) | |
| Systems DSA (CSR, allocators) | novice | (none yet) | |
| Graphs & thin worklist | learning | (none yet) | |
| Module 2 recursive-descent / AST / lex | novice | (none yet) | Primary deep track |
| Module 3 symbol tables / tries / hashes | novice | (none yet) | |
| Memory & locality | learning | (none yet) | |
| Concurrency structures | novice | (none yet) | |
| Module 4 intrusive lists / scheduler | novice | (none yet) | Payoff in Chunk 5 |
| Systems design (pipelines/backpressure) | learning | (none yet) | |

Strong points: systems-design theory; can eventually solve DSA problems.
Weak points: implementation speed; systems-DSA fluency; concurrency under time pressure; production parsing.

# Mental Models

## Cost model (time + space + constants)
- When to use: choosing structures/algorithms; reviewing hot paths
- Expect: Big-O plus constants, cache misses, allocations, branches
- Not: a substitute for measuring; not “faster asymptotic always wins”
- Relates to: Memory (constants often are memory); Complexity theory (nearby but abstract)
- Projection: “The stopwatch and the whiteboard must agree” — asymptotics propose; hardware disposes
- Mnemonics: SCAN beats CHASE when data is dense (contiguity tax)

## Memory as the first resource
- When to use: any buffer, graph, kernel, embedded budget
- Expect: ownership, lifetime, layout, peak vs steady usage
- Not: “allocate freely and free later” as default systems style
- Relates to: Allocators (mechanism); Correctness under constraints (bounds)
- Projection: Analogy — memory is the fuel tank, not the scenery
- Mnemonics: OWN → LAYOUT → LIFETIME (check in that order)

## Indirection vs contiguity
- When to use: arrays vs nodes; pointer graphs vs CSR; tokens contiguous vs linked
- Expect: predictable scans vs flexible linking
- Not: “linked structures are elegant therefore fast”
- Relates to: Cost model; Graph representations; intrusive OS lists (when linking is the point)
- Projection: Catchphrase — “Pointers are express lanes that may be empty”
- Mnemonics: AoS walks objects; SoA walks fields

## Concurrency as shared-state protocol
- When to use: queues, pools, shared buffers, shutdown, resource locking
- Expect: explicit rules for who may touch what, when
- Not: sprinkling mutexes; not “lock-free == always faster”
- Relates to: Message-passing (alternative); Atomics (tools inside the protocol)
- Projection: Story — two clerks, one ledger: the protocol is the clerk handbook
- Mnemonics: HAPPENS-BEFORE or it didn’t

## Layered systems design
- When to use: APIs, pipelines, schedulers, compiler phases (lex → parse → AST → ICG)
- Expect: contracts, failure domains, replaceable layers
- Not: one diagram equals a design
- Relates to: Backpressure (cross-layer signal); Correctness (per-layer invariants)
- Projection: Diagram — boxes with arrows *and* labeled “full/error” edges
- Mnemonics: CONTRACT → FAILURE → PRESSURE

## Correctness under constraints
- When to use: embedded, compilers, edge, any hard limit
- Expect: invariants, bounded resources, explicit failure
- Not: demo-on-happy-path as done
- Relates to: Testing; Memory budgets; Backpressure; parser error handling
- Projection: Catchphrase — “Works until the tank is empty” is a bug
- Mnemonics: INVARIANT · BOUND · FAILURE MODE (name all three)

## Recursive-descent as executable grammar
- When to use: writing or reading hand-written parsers
- Expect: each nonterminal ≈ a function; tokens consumed left-to-right; precedence via grammar layering
- Not: Shunting-Yard; not parser generators; not “recurse until it works” without error strategy
- Relates to: AST (output); lexing (input); Shunting-Yard (high-level alternative for expressions)
- Projection: Catchphrase — “The grammar is the call graph”
- Mnemonics: LEX → LOOKAHEAD → MATCH → DESCEND → ERROR

# Next Steps

1. Run `learn-session` — Chunk 1 step 1 (cost model refresh).
2. Adopt resources only when a topic is in session (do not bulk-add weak aggregate URLs).

# References

- resources: see `knowledge/artifacts/resources/` (add when a topic is learned; one preferred parsable source per topic)
- knowledge: `knowledge/knowledge.md`
- essentials: `knowledge/essentials.md`
- Seed shortlist (adopt selectively; not cover-to-cover):
  - CLRS (or equivalent) — classic DSA refresh
  - *Systems Performance* (Brendan Gregg) — cost/hardware reality
  - *The Art of Multiprocessor Programming* (Herlihy & Shavit) — selected concurrency chapters
  - *Crafting Interpreters* (Nystrom) — candidate when Chunk 2 lex/parse/AST runs (adopt then)
  - FreeRTOS architecture overview — candidate when Module 4 queue patterns run (adopt then)
- Policy: no bulk GeeksforGeeks/Medium/Scribd ingestion; stronger defaults chosen per session with learner input
