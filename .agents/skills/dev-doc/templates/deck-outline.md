---
title: Sample deck
author: Doc pipeline
---

# Pipeline

Report and deck share one style path.

- Report: Pandoc → Typst
- Deck: Typst + Touying
- Office: structure export

# Key numbers

1. Shared `apply` for tables and code.
2. Report margin defaults to 2 cm.

# Table

| Stage | Tool | Keeps |
|-------|------|-------|
| Report | Pandoc → Typst | Page layout |
| Deck | Typst / Touying | Slide layout |

# Code

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```
