#!/usr/bin/env bash
# Rich scholarly DOCX: reference.docx + filters + citeproc + section numbers.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1:-$ROOT/templates/report.md}"
OUT="${2:-$ROOT/sample/report.docx}"
[[ "$SRC" = /* ]] || SRC="$ROOT/$SRC"
[[ "$OUT" = /* ]] || OUT="$ROOT/$OUT"
REF="$ROOT/templates/reference.docx"
FILTER_RICH="$ROOT/templates/filters/docx-rich.lua"
FILTER_SCHOLAR="$ROOT/templates/filters/docx-scholar.lua"

if [[ ! -f "$REF" ]]; then
  python3 "$ROOT/scripts/build-reference-docx.py"
fi

mkdir -p "$(dirname "$OUT")"
srcdir="$(cd "$(dirname "$SRC")" && pwd)"
base="$(basename "$SRC")"

# bibliography: prefer sibling refs.bib
BIB="$srcdir/refs.bib"
[[ -f "$BIB" ]] || BIB="$ROOT/templates/refs.bib"

(cd "$srcdir" && pandoc "$base" \
  --reference-doc="$REF" \
  --citeproc \
  --bibliography="$BIB" \
  --number-sections \
  -L "$FILTER_SCHOLAR" \
  -L "$FILTER_RICH" \
  --from markdown+raw_attribute \
  -o "$OUT")
echo "wrote $OUT"
