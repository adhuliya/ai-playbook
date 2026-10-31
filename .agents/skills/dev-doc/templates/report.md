---
title: Sample report
author: Doc pipeline
bibliography: refs.bib
link-citations: true
reference-section-title: References
section-numbering: "1.1"
numbersections: true
papersize: a4
fontsize: 10pt
mainfont: Fira Sans
codefont: Fira Mono
linkcolor: "#1D3A63"
margin:
  x: 2cm
  y: 2cm
---

# Introduction {#sec:introduction}

This starter is Pandoc Markdown compiled through Typst.
The Typst documentation covers raw-block styling [@typstDocs].
Pandoc stays in the export path [@pandocManual].

See {fig:swatch} for the brand swatch and {tbl:tools} for the tool matrix.

![Navy and saffron swatch](assets/swatch.png){#fig:swatch}

```{=typst}
#figure(
  fit-image("assets/swatch.png", width: 55%, max-height: 20%, upscale: false),
  caption: [Navy and saffron swatch (Typst figure)],
) <swatch>
```

# Data {#sec:data}

| Stage | Tool | What it keeps |
|---|---|---|
| Report | Pandoc → Typst | Page layout |
| Deck | Typst slides | Slide layout |
| Office | Pandoc | Structure |

: Tools and what they keep {#tbl:tools}

Unordered list (bullets):

- Report keeps page layout.
- Deck keeps slide layout.
- Office keeps structure.

Ordered list (numbers must survive in DOCX):

1. Author Markdown.
2. Compile PDF with Typst.
3. Export DOCX when asked.

## Subpoints {#sec:subpoints}

Nested detail under Data — should show as a numbered subsection.

# Code {#sec:code}

```python
def greet(name: str) -> str:
    # keep indentation in the box
    if not name:
        raise ValueError("empty name")
    return f"Hello, {name}"
```

# Diagrams {#sec:diagrams}

Office and HTML previews use PNG twins of the Typst vector diagrams (Fletcher / Chronos).

![Markdown to Typst pipeline flow](assets/flow.png){#fig:flow}

![Author edit, compile, view sequence](assets/sequence.png){#fig:sequence}

Cross-check: {fig:flow} and {fig:sequence} belong in {sec:diagrams}.

# Cross-references {#sec:xrefs}

Bibliography cites use `@key` in Markdown (see Introduction).
Office cross-refs use `{fig:…}`, `{tbl:…}`, and `{sec:…}` and resolve at DOCX export.
