---
name: fix-latex-errors
description: Build the LaTeX project with make, diagnose compile, bibliography, citation, and reference errors, and suggest focused fixes. Use when the user asks to fix LaTeX build errors, investigate make failures, debug paper compilation, or diagnose citation/reference issues.
disable-model-invocation: true
---

# Fix LaTeX Errors

## Purpose

Diagnose and fix LaTeX project build failures by running `make` at the project root, inspecting the relevant output and logs, and tracing errors back to source `.tex` or bibliography files.

## Workflow

1. Start at the project root and run:

   ```bash
   make
   ```

2. If `make` fails, inspect the error output first. If the output points to a `.log`, `.blg`, `.aux`, or generated file, read only the relevant section around the first real error.
3. Identify the earliest root-cause error before fixing follow-on errors. Common follow-ons include repeated undefined references, missing citations after a failed BibTeX run, and later syntax errors caused by an earlier unclosed brace or environment.
4. For LaTeX syntax errors, map the reported file and line back to source. Check nearby lines for:
   - Unbalanced `{...}`, `[...]`, `$...$`, or environments.
   - Misspelled commands or unavailable macros.
   - Missing package support for a command.
   - Bad figure, table, bibliography, or input paths.
5. For citation and reference errors, use the same checks as `find-typos`:
   - Read `main.tex` to identify root paper files included by `\input{...}` or `\include{...}`.
   - Search only root project files included from `main.tex` when validating labels. Exclude subfolders that contain their own `main.tex`, because they are separate projects.
   - Read `references.bib` in the root project and collect all BibTeX keys.
   - Check `\cCite{...}` commands as comma-separated keys, trimming spaces around each key.
   - Treat `\cite{...}` as an error when this paper should use `\cCite{...}`.
   - Confirm referenced labels in `\ref{...}`, `\autoref{...}`, `\cref{...}`, `\Cref{...}`, `\eqref{...}`, and similar commands appear in a `\label{...}` command in the root paper files.
6. Apply minimal, local fixes when the cause is clear. Preserve technical meaning, macro names, labels, and citation keys unless they are the source of the error.
7. Re-run `make` after each focused batch of fixes. Continue until the project builds or the remaining issue needs user judgment.

## Reporting

When reporting results:

- State whether `make` succeeds or fails.
- If it fails, name the first root-cause error and the source file involved.
- Summarize any edits made, grouped by cause rather than by every touched line.
- Mention remaining warnings only if they affect correctness, references, citations, bibliography output, or final PDF generation.

If no edit is safe, provide a short suggested fix with the evidence from the build output.

## Standards

- Do not rewrite prose while fixing build errors unless the prose itself causes the error.
- Prefer existing project macros and style conventions over adding new packages or commands.
- Avoid broad cleanup, formatting churn, or generated-file edits unless the build system requires them.
- Do not treat all warnings as failures. Prioritize errors and correctness-affecting warnings.
