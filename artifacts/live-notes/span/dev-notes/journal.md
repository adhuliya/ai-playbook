# Design journal (append-only)

Brief, durable notes about **important design choices** in this project.
Future agents should read this for context before changing architecture or
conventions.

Normal updates: **append only** at the bottom (never edit, reorder, or delete
prior entries). Exception: user-approved `condense-journal` via the `journal`
skill may rewrite this file shorter. Activity history under
`.dev-notes/activities/<slug>/journal.md` is a different file (workon).

Workflow: `.cursor/skills/journal/SKILL.md`.

## Entries

- Rewrote `main.mdc` as short global agent rules: ground in README/DEFINITION/STRUCTURE; ask on design forks; reuse-first; append HISTORY; follow proto-style for SPIR.
- Renamed structure map to `DEV_GUIDE.mdc`; added hierarchical local `DEV_GUIDE.md` files + `dev-guides` skill (grill on policy; dual-audience; same-change sync; major index + convention).
- Slang SPIR plan locked in `prompts/slang.md`: lit FileCheck (semi-deep + named id captures) then Go round-trip; no Python-SPIR parity; staged C corpus → benchmarks later.
- SPIR: function types = return shape only (`EFUNC` on entity); member chains `x.y.z` as linked `EVAR_*` vars (`member_access`+`parentEid`); documented in `spir.proto` + `prompts/slang.md`.
- Arrow `p->y` is `XMEMBER_ACCESS(p,y)`; longer arrows split with tmps. Dot chains stay synthetic `EVAR_*` vars (not nested arrow exprs).
- Slang Bit path: wire Do/For + char/float/string lits; set `BitFunc.typeEid`; emit synthetic dot-chain EVAR vars; lit suite under `test/{expr,ctrl,call,agg,ptr}/` (keep `src/`); Go `IsBasic` includes `TVOID` for void returns.
- Milestones C/D: C11 expr/stmt lit corpus + `multi/` multi-TU tests; Bit path folds `_Alignof`/`_Generic` result; sizeof/alignof Bit converters return literals.
- Agent directive for C11 expr/stmt coverage: skill `c11-coverage-tests` + command `/gen-c11-tests`; one small lit file per construct; checklist in skill `c11-checklist.md`.
- C11 skill scope widened: required host decls — function-pointer calls (`call_fp*`), anonymous/complex records, VLAs, incomplete array params (`a[]`, `a[10][]`); checklist re-audited vs N1570 §6.5/§6.8.
- Compound literals `(T){…}` lower to `EVAR_LOCL_TMP` + existing InitList assigns; subsequent `.mem` uses synthetic EVAR chains like named locals.
- Span IR load plan in `prompts/span-ir.md`: reuse `slang/test` corpus; thin `span/test/load` wrappers + `ValidateLoadedTU`; skill `gen-spanir-tests` / `/gen-spanir-tests` syncs wrappers when slang lit changes.
- Landed `ValidateLoadedTU` + `span load --check`; seeded `span/test/load` (hello_world + one per expr/ctrl/call/agg/ptr); lit subst `%slang_test_root` (avoid `%slang` prefix clash).
- Full-sync `span/test/load` to slang lit (123 wrappers); load handles `ELIT_STR`/`TPTR_TO_CHAR`; validate dedupes duplicate `BitFunc` fids (last-wins, matches convert).
- Span linker plan in `prompts/span-linker.md`: BitTU serializer first; N-way CLI left-folds pairwise (base keeps ids); C/lld-ish globals/funcs; weak/archives/COMDAT/analyze-auto-link deferred.
- Span serializer plan in `prompts/spir-serializer.md`: round-trip `EqualTU`; span `origin` keeps 32-bit ids (reserve sorted); Clang 64-bit remap unchanged; `span link -o` (1-file = serialize-only).
- Landed BitTU serializer + span-origin load + `EqualTU`; `span link` N-way fold with C/lld-ish globals/funcs; lit `span/test/link/`; empty insn list = function decl for link.
- SPEC convert/load plan in `prompts/spec-test.md`: 2017 pure-C **rate** only + 2006 C from `BenchmarksInfo.txt`; smallest→largest milestones; resume via Current focus / Status log (gitignored `not-for-git/`).
- SPEC compile DB: locked **path B** (`intercept-build` + config `CC=intercept-cc`); helper `not-for-git/spec-2017/gen-compile-db.sh`; path A (object.pm synthesize) is fallback only.
- SPEC protos: save under `not-for-git/spir-spec2017/<bench>/`; Phase S (slang only) before Phase L (span load/link on saved pb); git of protos deferred.
- Slang SPEC hardening: skip system-header FunctionDecl traversal (lazy DeclRef register); DeclRef callee id = definition; restore `currBitFunc` after lazy register; 8/16-bit integer types.
- Span: break FILE*-style cycles when building QualTypes and in `qualTypesEqual` (link/EqualTU); needed for libc-using SPEC TUs.
- Slang Bit: array subscript must set `qualType`; arrow member record type from Clang `MemberExpr` base (fixes `a[i]->field` / `fopids(-1)` crash on mcf).
- SPEC Phase S persist: copy `compile_commands.json` into `spir-spec2017/<name>/` beside `MANIFEST.txt` + `.spir.pb`.
- Slang: FunctionNoProtoType function pointers emit a real `funcPrototype` BitDataType (int return); do not use sentinel subtype eid 0.
- Span load: pointer BitDataType with subtypeeid 0 / failed pointee resolve synthesizes a basic pointee from pointer vkind (avoids nil `PointerVT.pointee`).
- Span link/serialize: vkind-only vars get QualType on load; NamesToIds drops stale link keys; `remapQualType` is cycle-safe (FILE*); validate accepts `static::<tu>::name`.
- Slang: file-static functions set EntityInfo `QGLBL_STATIC` so the linker can isolate same-named statics across TUs.
- Span link: incompatible decl/def types → **warn** (keep definition), not hard error; matches C/lld (no link-time type check) for SPEC K&R headers.
- Span: wire type eid 0 is **reserved INT32** (`spir.proto`); load/serialize/validate/link always treat `DataTypes[0]` / `dataTypeEid==0` as int32.
- Human-verif v1: staged `--verify-report` + selective `--dump-*` on `load`/`link` (no dump subcommand); library in `spir` (`WriteTUStageReport`, call graph, CFG DOT).
- Call expr accessors: `GetCallee`=Opr1, `GetCallSiteId`=Opr2 (match `CallX` / Bit load / serialize); prior swap zeroed direct call-graph edges.
- CFG build (`ConstructCFG`): split at `MaxBBInsnCount` (64), end BB on call/call-assign (`HasCallExpr`), unique exit BB with `nop`; DOT uses C-like calls, `BB : label` headers, top/bottom ports.
- Analyze P0: `RunIntraTU` + `WriteFactDump` in `pkg/analysis`; `AnalyzeCallStub` hook; `*TU` query/pretty + `EnsureFuncCFG` (BB ids/preds/insn ids); CLI `span analyze --analysis=` (required), single `.pb`, intra-all-funcs; IPA will wrap IntraPAN (boundaries + call-sites only).
- Analyze P1–P4: LiveVars=`EidSet` lattice; PointsTo=flow-sensitive `KVLattice`→`MaySet` (member eids field-aware); `RunInterTU` k-limiting call-string IPA wraps IntraPAN (boundary meet + summary at calls); CLI `--mode=inter --k=1..4`.
- Slang Bit: sizeof/alignof fold via EvaluateAsInt / getTypeOfArgument (unevaluated); do not lower operand CFG (fixes x264 ratecontrol abort on sizeof(cond?…)).
- Slang Bit: convert FunctionNoProtoType as funcPrototype; if-temps always TINT32; genTmpBitEntity falls back on type convert failure (perlbench av.c).
- Slang Bit: GNU void ?: (void arms) — no tmp/assign; void calls already emit ICALL (fixes perl OpslabREFCNT_dec / op.c).
- Slang Bit: VAArgExpr → typed tmp (opaque); ELIT_STR non-UTF8 bytes hex-escaped for protobuf; default LogLevel ERROR (TRACE OOM/hours on SPEC).
- SPEC CDB helper: inject SPEC_LP64 + perlbench SPEC_LINUX_AARCH64 + integer EXTRA_CFLAGS; large-bench link via pairwise left-fold when all-at-once OOMs (~8GB hosts).
- Activity manager skill `workon`: durable records under `.dev-notes/activities/<slug>/` (`activity.md` current truth + append-only `journal.md`); reserved cmds `pause-work`/`resume-work`/`complete-work`; MECE milestones with embedded evidence; max child depth 2.
- `workon` activity folder includes optional `artifacts/` for activity-specific durable files (create on demand; link from References; huge corpora stay in `not-for-git/`).
- Dev guides moved to `.dev-notes/dev-guides/` (`dev-guide.md` mirror; ancestor skips OK); thin always-on `DEV_GUIDE.mdc` is scheme+discovery only; `DEFINITION.mdc` → `.dev-notes/definition.md`; hybrid sync + skill grill for material guide work.
- Renamed append-only design log `HISTORY.mdc` → `journal.mdc` (same append-only contract; “history” wording → journal).
- Renamed thin scheme rule `DEV_GUIDE.mdc` → `dev-guide.mdc` (matches `journal.mdc` / notes naming).
- Dev-guide economy: leaf-only reads + Related (project paths); drop Parent/Children; thin root map; `dev-guide.mdc` not always-on. Project journal moved `.cursor/rules/journal.mdc` → `.dev-notes/journal.md` + `journal` skill; `condense-journal` rewrites only with user approval.
