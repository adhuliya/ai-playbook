# Browser preview

## Page-faithful PDF (reports and decks)

Formal preview is the Typst PDF (REF1):

```bash
typst compile report.typ          # or deck.typ
typst watch report.typ            # rebuild on change
```

Open the PDF in a system viewer. Decks use this path only — no Markdown→HTML, PDF-iframe UI, or PNG carousel in the skill.

## Structured HTML (reports only)

Sole entry:

```bash
./serve.sh              # skill root
```

Binds `0.0.0.0` by default (reachable on remote hosts). HTTP root is the **skill root** (or scaffolded workdir). Open:

`http://127.0.0.1:<port>/preview/`

That loads the Markdown→HTML UI (`index.html`). Assets such as `/templates/assets/swatch.png` resolve (no 404). Purpose: report structured preview with theme tokens, figure/table numbers, citations, and bibliography.

## Port already in use

Always prints a check URL for the port being discussed.

1. Keep the server on the busy port, or try the **next free** ports (URL will show the port actually used).
2. Kill **our** prior `serve.sh` (PID file) and **rebind that same busy port** (the prompt names that port, e.g. 8766 — not a stale default).

Never kills an unrelated process.

## Pitfall

Typst `--features html` is incomplete — not this preview path.
