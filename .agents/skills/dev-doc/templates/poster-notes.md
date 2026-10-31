---
title: Sample poster notes
author: Doc pipeline
---

# Goals

- One visual story per poster.
- Structure survives LaTeX article export.

# Method

1. Draft content in Markdown.
2. Export with `pandoc --standalone -t latex`.
3. Keep headings, lists, and tables.

# Results

| Stage | Tool | Keeps |
|-------|------|-------|
| Poster | Typst | Page layout |
| Export | Pandoc | Structure |

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```
