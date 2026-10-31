#!/usr/bin/env bash
# Compile skill templates with Fira (TYPST_FIRA_PATH or TeX-tree default).
# Usage: ./scripts/compile.sh [report|deck|poster|cheatsheet|all]
# Run from skill root or any cwd; paths resolve to skill root.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SELF="$ROOT/scripts/compile.sh"
TPL="$ROOT/templates"

FIRA_DEFAULT="/opt/homebrew/Cellar/texlive/20260301/share/texmf-dist/fonts/opentype/public/fira"
FIRA="${TYPST_FIRA_PATH:-$FIRA_DEFAULT}"
if [[ ! -d "$FIRA" ]]; then
  echo "Fira OpenType dir not found: $FIRA" >&2
  echo "Set TYPST_FIRA_PATH to the folder that contains FiraSans-Regular.otf" >&2
  exit 1
fi

typst_compile() {
  (cd "$TPL" && typst compile --font-path "$FIRA" "$@")
}

target="${1:-all}"
out="$ROOT/sample"
mkdir -p "$out"

case "$target" in
  report|pandoc)
    (cd "$TPL" && pandoc report.md --standalone --pdf-engine=typst \
      --pdf-engine-opt=--font-path --pdf-engine-opt="$FIRA" \
      --include-in-header=pandoc-page.typ \
      --include-before-body=pandoc-before.typ \
      --from markdown+raw_attribute \
      -o "$out/report.pdf")
    cp "$TPL/report.md" "$TPL/refs.bib" "$TPL/assets/swatch.png" "$out/" 2>/dev/null || true
    ;;
  deck)
    typst_compile deck.typ "$out/deck.pdf"
    ;;
  poster)
    typst_compile poster.typ "$out/poster.pdf"
    ;;
  cheatsheet)
    typst_compile cheatsheet.typ "$out/cheatsheet.pdf"
    ;;
  all)
    "$SELF" report
    "$SELF" deck
    "$SELF" poster
    "$SELF" cheatsheet
    ;;
  *)
    echo "Usage: $SELF [report|deck|poster|cheatsheet|all]" >&2
    exit 1
    ;;
esac
