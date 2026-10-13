---
name: find-typos
description: Find typos, citation/reference mistakes, and directness improvements in LaTeX .tex files. Edits the file in place to apply high-confidence fixes. Use when the user asks to find typos, proofread a .tex file, check citations, check labels, or improve clarity and concision in LaTeX prose. Also suggests easy-to-apply inline edits for the user's editor.
---

# Find Typos and Edit Inline

## Purpose

Review one user-specified `.tex` file for:

- Typos, grammar issues, word-choice mistakes, duplicated words, and punctuation problems.
- Obvious improvements that make statements more direct, clear, and concise.
- Citation command mistakes and missing bibliography keys.
- Missing labels referenced by figure, table, section, diagram, equation, or similar references.

Apply fixes for up to 20 corrections per invocation, directly editing the `.tex` file inline. If more remain, inform the user and suggest rerunning the skill to address the next batch.

## Workflow

1. Identify the target `.tex` file from the user's request. If none is given, ask for one.
2. Read and parse the target file, inspecting prose in order and preserving the user’s technical meaning.
3. Read `main.tex` to identify root paper files included by `\input{...}` or `\include{...}`.
4. When validating labels, search only the root project files included from `main.tex`. Exclude subfolders with their own `main.tex`.
5. Read `references.bib` from the root project and collect all BibTeX keys.
6. Check every citation-like command in the file:
   - `\cCite{...}` may contain comma-separated keys. Each must exist in `references.bib`.
   - `\cite{...}` is an error: replace with `\cCite{...}`.
   - Trim spaces around keys before checking.
7. Validate all references such as `\ref{...}`, `\autoref{...}`, `\cref{...}`, `\Cref{...}`, `\eqref{...}`: ensure each referenced label appears in a `\label{...}` in the root paper files.
8. Prepare the first 20 highest-confidence local corrections, prioritizing:
   - Incorrect citations or missing labels.
   - Real typos/grammar issues.
   - Low-risk clarity improvements.
9. For each correction, create an explicit inline file edit (patch) that will be applied instantly.
10. Apply those edits directly to the file. Summarize the changes made.
11. If more issues remain, inform the user and suggest rerunning the skill to address the next batch.

## Output Format

If any changes were made, output:

```markdown
Applied [N] correction(s) to [filename]:

| Line | Snippet | Correction applied | Reason |
|---:|---|---|---|
| 42 | `original text` | `corrected text` | Brief reason. |

[If applicable: More corrections remain; ask me to run `find-typos` again to fix the next batch.]
```

If no issues are found, say the file looks typo-free from this pass and mention any residual limitation, such as not compiling the paper.

## Review and Edit Standards

- Preserve LaTeX commands unless the command itself is the issue.
- Do not alter math or macro names, labels, citation keys, or technical terms unless incorrect.
- Prefer concise suggestions (e.g., "use active voice", "remove redundant phrase", etc.).
- Make local, actionable changes—never rewrite large passages or make speculative rewrites.
- Change only high-confidence errors and clarity issues; avoid style preferences unless improvement is certain.
- Always apply simple inline edits for each proposed correction using file patching primitives.

## Example Patch (applied inline)

For each fix:

```patch
@@ [filename]:[line number] @@
-replace this typoed sentence.
+replace this typoed sentence.
```

The file is updated directly. All applied changes are summarized.

## Limitations

- Does not compile or check build errors unless explicitly requested.

This skill automates both detection and repair, editing `.tex` files in-place for typo, citation, and clarity issues in LaTeX documents.