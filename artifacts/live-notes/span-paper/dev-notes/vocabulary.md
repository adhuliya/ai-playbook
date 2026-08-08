# Vocabulary

| Term | Description |
|------|-------------|
| abstract domain | Set of abstract facts for one analysis; forms a complete lattice. Also called: domain of an analysis. |
| abstract transfer function | Maps abstract facts across a statement (or set of statements). Also called: flow function. Not: concrete transfer function. |
| automated combination of analyses | Building a composite system without hand-written cross-product transfer functions for every analysis pair. SPAN is one such approach. |
| backward-flow analysis | Information flows against control-flow (e.g. live variables). Not: forward-flow. |
| cascading | Running analyses sequentially; later analyses see a program specialized by earlier fixpoints via program transformations. Enables coarse-grained collaboration. |
| coarse-grained collaboration | Analyses exchange information only after each completes its fixpoint. Typical of cascading. Not: fine-grained collaboration. |
| composite analysis | Single analysis whose domain and transfers combine several participating analyses (often via cross product). Also called: composite analysis system. |
| composite flow function | SPAN’s per-statement transfer over the tuple of participating domains; defined in the Span formulation (eq. spanFF). Also called: composite transfer function. |
| composite lattice | Product of participating abstract domains; facts are tuple-facts. |
| concretization function | Maps an abstract fact to a set of (instrumented) concrete states it represents. Also called: meaning function (Γ). |
| consumer | Participating analysis that selects views from producers via its policy and applies its transfer functions to those views. Not: producer. |
| context-sensitive inter-procedural data flow analysis | Multi-procedure analysis with calling context; SPAN plugs into suitable frameworks (e.g. k-limited call-strings, value-context). |
| data flow analysis | Static inference of properties at program points via lattice facts, transfers, and fixpoint iteration. |
| descending chain condition | Every descending chain in a lattice has finite length; with monotone transfers, Kildall yields an exact MFP. When it fails, widening is used. |
| evanescent views | Statement views exist only for the current visit to a node; they are not persistent rewrites of the program. Central contrast to transformation-based collaboration. |
| fine-grained collaboration | Information exchanged at statement level during fixpoint computation (including interleaved forward and backward analyses). SPAN’s goal. |
| fixpoint | Solution where data-flow facts stop changing; computed by algorithms such as Kildall’s. |
| forward-flow analysis | Information flows along control-flow (e.g. points-to). Not: backward-flow. |
| forward-backward extension | SPAN treats each analysis fact as (IN, OUT) pairs so forward and backward analyses can coexist; view generators may use either side. |
| instrumented concrete state | Concrete variable values plus analysis-specific instrumentation (tuple per analysis). Needed for non-value analyses. |
| k-limited call-strings | Scalable inter-procedural context abstraction (call string length bounded by k). |
| Lerner's approach | Fine-grained cascading on one statement at a time with in-place local transformations; lock-step order limits mixing forward and backward analyses. |
| maximum fixpoint (MFP) | Most precise solution obtainable from the given monotone transfers when the descending chain condition holds. With widening: sound terminating approximation, not necessarily exact MFP. |
| meet and join | In this paper, meet (⊓) merges facts at control-flow merges (over-approximation); join (⊔) combines results from multiple views (under-approximation). ⊥ is most over-approximate; ⊤ is most under-approximate at start. |
| modular specification | Each analysis is specified and proved (soundness, monotonicity) largely independently of others; SPAN combines them automatically. |
| nil statement view | View that blocks information flow across a statement (e.g. dead assignment as no-op for points-to). |
| non-value analysis | Does not abstract concrete values of entities (e.g. live variables, reaching definitions). May restrict which views policies accept. Not: value-based analysis. |
| partial order of views | Views for a statement s ordered by Θˢ: weaker view ⇔ larger (weaker) set of states Θˢ(view). Used for view-generator monotonicity. |
| policy function | Consumer predicate Πₖ(s, views) returning the subset of producer views the analysis will use; must satisfy policy soundness and monotonicity. |
| producer | Analysis that generates statement views from its current fact via the view generator. Not: consumer. |
| program transformation | Persistent syntactic change to the program used by cascading and Lerner-style methods. Not: statement view (evanescent). |
| reduced cross product | Manually built most-precise product lattice and transfers (Cousot & Cousot). SPAN is weaker in precision guarantee but automatic. |
| soundness (view generator) | Concretization of the fact must refine Θˢ(views produced); ensures views conservatively approximate the original statement for client analyses. |
| SPAN | Synergistic Program Analyzer: framework for modular collaborative data-flow analyses via statement views, view generators, and policies. Also called: Span. |
| Span IR | SPAN’s three-address intermediate representation; constrains which statement views may be produced and defines Θˢ. |
| standard concrete state | Function from variables to concrete values; universe 𝒞. Basis before instrumentation. |
| statement view | Alternative interpretation of a statement (often a set of statements) proposed for one visit without changing source text. Also called: view. |
| synergistic system | Set of analyses combined by SPAN so they collaborate through views while retaining separate domains. |
| Theta (Θˢ) | Family of functions mapping a view set to the maximal concrete states for which the view must soundly over-approximate statement s; defined on Span IR forms. |
| transformation-based collaboration | Coarse- or fine-grained methods that specialize code in place (cascading, Lerner). Contrasts with SPAN’s evanescent views. |
| tuple-fact | Element of the composite domain: one abstract fact per participating analysis, e.g. (fact₁, …, factₙ). |
| user-defined collaboration | Manual cross-product domain and hand-crafted combined transfer functions. High precision, high proof and maintenance cost. |
| value-based analysis | Abstracts possible values or locations (e.g. points-to, intervals). Often produces views that specialize assignments and dereferences. |
| value-context | Inter-procedural method trading scalability for precision; may need widening with infinite domains. |
| view generator | Analysis function AbsSimⱼ(s, fact) producing a set of statement views from the producer’s fact. Must be sound and monotone in the view partial order. Also called: AbsSim, view generation function. |
| widening operator | Accelerates fixpoint on infinite-height domains; applied elementwise to tuple-facts in SPAN. |
