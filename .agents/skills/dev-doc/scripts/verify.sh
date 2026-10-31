#!/usr/bin/env bash
# Maintainer-only milestone verification for the dev-doc skill.
# Authors: use compile.sh / export-docx.sh / scaffold.sh; do not treat this
# harness as a first-invoke scaffold surface (RU10.20).
# Usage: ./scripts/verify.sh [m1|m2|m3|m4|m5|m6|all]
# Regenerates sample/* PDF/DOCX/TeX during checks; binaries are not committed.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
fail=0
pass() { echo "PASS: $*"; }
fail_msg() { echo "FAIL: $*"; fail=1; }

no_aparajit_docs() {
  if rg -n 'aparajit|/docs/pitch|/docs/pixhawk|/docs/poster|/docs/presentation' \
      --glob '!**/verify.sh' SKILL.md templates references preview sample 2>/dev/null; then
    fail_msg "no-aparajit-docs: found aparajit docs/ cites"
  else
    pass "no-aparajit-docs"
  fi
}

check_router() {
  if rg -q 'references/browser.md' SKILL.md && rg -q 'references/gdocs.md' SKILL.md; then
    pass "router-core / file-split pointers"
  else
    fail_msg "router-core: SKILL.md missing side-file pointers"
  fi
  if rg -q 'File → Save as Google Docs' SKILL.md; then
    fail_msg "file-split: Drive steps in SKILL.md"
  else
    pass "export / Drive stay out of SKILL.md"
  fi
}

# Shared M2 DOCX structure asserts (reused by m3).
assert_docx_structure() {
  local xml="$1"
  local label="${2:-docx-structure}"
  local ok=1
  rg -q 'Introduction|Sample report' "$xml" || ok=0
  rg -q 'w:tbl' "$xml" || ok=0
  rg -q 'w:drawing|a:blip|pic:pic' "$xml" || ok=0
  rg -q 'greet|ValueError|python' "$xml" || ok=0
  rg -q 'Report|Deck|Office|keep indentation' "$xml" || ok=0
  [[ $ok -eq 1 ]] && pass "$label" || fail_msg "$label (heading/table/image/code)"
}

check_m1_units() {
  # guide-citation (RD4): core commands cite REF excerpts
  if rg -q 'REF1' SKILL.md references/install.md references/rendering.md references/browser.md \
     && rg -q 'REF4' SKILL.md references/install.md; then
    pass "guide-citation"
  else
    fail_msg "guide-citation"
  fi

  # browser-pdf (RD8): Typst PDF is page-faithful for reports and decks
  if rg -qi 'page-faithful|Formal preview is the Typst PDF' references/browser.md \
     && rg -qi 'report' references/browser.md \
     && rg -qi 'deck' references/browser.md \
     && rg -q 'typst compile' references/browser.md; then
    pass "browser-pdf"
  else
    fail_msg "browser-pdf"
  fi

  # browser-typst-html-note
  if rg -q -- '--features html' references/browser.md \
     && rg -qi 'incomplete|not this preview|pitfall' references/browser.md; then
    pass "browser-typst-html-note"
  else
    fail_msg "browser-typst-html-note"
  fi

  # table-grid: visible stroke via apply (not Pandoc borderless default)
  if rg -q 'stroke:' templates/style-overrides.typ \
     && rg -q '#show: apply' templates/pandoc-before.typ; then
    pass "table-grid"
  else
    fail_msg "table-grid"
  fi

  # standalone-toc: Pandoc --standalone on report path
  if rg -q -- '--standalone' scripts/compile.sh; then
    pass "standalone-toc"
  else
    fail_msg "standalone-toc"
  fi

  # section-numbering
  if rg -q 'section-numbering:' templates/report.md; then
    pass "section-numbering"
  else
    fail_msg "section-numbering"
  fi

  # captions: table `: ` line + figure alt text
  if rg -q '^: ' templates/report.md \
     && rg -q '!\[[^]]+\]' templates/report.md; then
    pass "captions"
  else
    fail_msg "captions"
  fi

  # show-apply
  if rg -q '#show: apply' templates/pandoc-before.typ \
     && rg -q '#let apply' templates/style-overrides.typ; then
    pass "show-apply"
  else
    fail_msg "show-apply"
  fi

  # cross-ref (Office + Typst label notes / sample markers)
  if rg -qF '{fig:' templates/report.md \
     && rg -qF '{tbl:' templates/report.md \
     && rg -qF '{sec:' templates/report.md; then
    pass "cross-ref"
  else
    fail_msg "cross-ref"
  fi

  # vector-diagram: Fletcher/CeTZ/Chronos body inside fit-box on deck
  if rg -q 'fletcher|cetz|chronos' templates/deck.typ \
     && rg -q 'fit-box' templates/deck.typ \
     && rg -q 'diagram\(|cetz\.canvas|chronos' templates/deck.typ; then
    pass "vector-diagram"
  else
    fail_msg "vector-diagram"
  fi

  # code-line-numbers: apply numbers raw lines; deck has a code fence
  if rg -q 'line\.number' templates/style-overrides.typ \
     && rg -q '```python' templates/deck.typ; then
    pass "code-line-numbers"
  else
    fail_msg "code-line-numbers"
  fi

  # engines-split: report Pandoc→Typst; deck typst compile Touying
  if rg -q 'pandoc report.md' scripts/compile.sh \
     && rg -q 'pdf-engine=typst' scripts/compile.sh \
     && rg -q 'deck\.typ' scripts/compile.sh \
     && rg -qi 'touying' templates/theme/deck.typ templates/deck.typ; then
    pass "engines-split"
  else
    fail_msg "engines-split"
  fi
}

check_m1_files() {
  for f in SKILL.md templates/report.md templates/deck.typ templates/poster.typ \
           templates/cheatsheet.typ templates/theme/tokens.typ \
           references/browser.md references/rendering.md references/install.md \
           preview/serve.sh preview/index.html; do
    [[ -f "$f" ]] || fail_msg "missing $f"
  done
  rg -q '0\.0\.0\.0' references/browser.md preview/serve.sh && pass "browser-bind-all-interfaces" \
    || fail_msg "browser-bind-all-interfaces"
  rg -qi 'preview|HTML' references/browser.md SKILL.md \
    && pass "browser-html-preview reports-only" \
    || fail_msg "browser-html-preview"
  if rg -qi 'hand-written|escape hatch|\.typ report|Markdown cannot' SKILL.md references/rendering.md; then
    pass "typ-report-escape"
  else
    fail_msg "typ-report-escape"
  fi
  rg -q 'Bibliography cite|bibliography cite|@key' SKILL.md references/rendering.md \
    && pass "cite-vs-label notes" || fail_msg "cite-vs-label"
  rg -q '#0B1F3A' templates/theme/tokens.typ && rg -q '#F29F05' templates/theme/tokens.typ \
    && pass "token-default" || fail_msg "token-default"
  if rg -qi 'touying|cheat sheet|poster' templates/report.md; then
    fail_msg "one-starter: report.md mentions other kinds"
  else
    pass "one-starter report"
  fi
  no_aparajit_docs
  check_router
  check_m1_units
}

compile_m1() {
  ./scripts/compile.sh all
  for pdf in sample/report.pdf sample/deck.pdf sample/poster.pdf sample/cheatsheet.pdf; do
    [[ -s "$pdf" ]] && pass "compiles $(basename "$pdf")" || fail_msg "missing $pdf"
  done
}

check_m2() {
  for f in references/latex.md references/docx.md references/gdocs.md; do
    [[ -f "$f" ]] || fail_msg "missing $f"
  done
  rg -q 'visible on' references/latex.md && pass "overlay-note" || fail_msg "overlay-note"
  rg -q 'Save as Google Docs' references/gdocs.md && pass "docs-copy" || fail_msg "docs-copy"
  if rg -q 'brew install' references/gdocs.md; then
    fail_msg "task-scoped-load: install in gdocs"
  else
    pass "task-scoped-load (gdocs free of install)"
  fi

  mkdir -p sample
  # Full-article LaTeX (RD7 / DC22): report + poster-or-cheat Markdown twins
  pandoc templates/report.md --standalone -t latex -o sample/report.tex
  pandoc templates/poster-notes.md --standalone -t latex -o sample/poster.tex
  # Beamer from deck outline twin
  pandoc templates/deck-outline.md --standalone -t beamer -o sample/deck.tex

  if [[ -s sample/report.tex ]] && rg -q '\\documentclass' sample/report.tex; then
    pass "latex-article report"
    pass "latex-full-article report"
  else
    fail_msg "latex-article report (need \\documentclass)"
  fi
  if [[ -s sample/poster.tex ]] && rg -q '\\documentclass' sample/poster.tex \
     && rg -q 'Goals|Method|Results|Stage' sample/poster.tex; then
    pass "latex-article-poster-or-cheat"
    pass "latex-full-article poster-or-cheat"
  else
    fail_msg "latex-article-poster-or-cheat (need full article + structure)"
  fi
  if [[ -s sample/deck.tex ]] && rg -qF '\begin{frame}' sample/deck.tex; then
    pass "latex-beamer"
  else
    fail_msg "latex-beamer (need \\begin{frame})"
  fi

  ./scripts/export-docx.sh templates/report.md sample/report.docx
  [[ -s sample/report.docx ]] && pass "docx produced" || fail_msg "docx produced"
  tmp=$(mktemp -d)
  unzip -q sample/report.docx -d "$tmp"
  assert_docx_structure "$tmp/word/document.xml" "docx-structure"
  rm -rf "$tmp"
}

check_m3() {
  ./scripts/compile.sh report
  ./scripts/export-docx.sh templates/report.md sample/report.docx
  [[ -s sample/report.pdf ]] && [[ -s sample/report.docx ]] \
    && pass "e2e sample-work PDF+DOCX" || fail_msg "e2e sample-work"
  tmp=$(mktemp -d)
  unzip -q sample/report.docx -d "$tmp"
  # Reuse M2 docx-structure checks (RU10.13)
  assert_docx_structure "$tmp/word/document.xml" "m3-structure-reuse / e2e docx full structure"
  rm -rf "$tmp"
}

check_docx_visual() {
  [[ -s sample/report.docx ]] || ./scripts/export-docx.sh templates/report.md sample/report.docx
  tmp=$(mktemp -d)
  unzip -q sample/report.docx -d "$tmp"
  xml="$tmp/word/document.xml"
  ok=1
  rg -q 'TableGrid' "$xml" || ok=0
  rg -q 'w:drawing|a:blip' "$xml" || ok=0
  rg -q 'greet|ValueError' "$xml" || ok=0
  rg -q 'w:tbl' "$xml" || ok=0
  [[ $ok -eq 1 ]] && pass "docx-visual (TableGrid + drawing + code text)" \
    || fail_msg "docx-visual"
  rm -rf "$tmp"
}

check_docx_precise() {
  python3 scripts/build-reference-docx.py >/dev/null
  ./scripts/export-docx.sh templates/report.md sample/report.docx
  tmp=$(mktemp -d)
  unzip -q sample/report.docx -d "$tmp"
  xml="$tmp/word/document.xml"
  styles="$tmp/word/styles.xml"
  ok=1
  rg -q 'w:styleId="TableGrid"' "$styles" || ok=0
  rg -q 'w:type="firstRow"' "$styles" || ok=0
  rg -q 'w:fill="D6E3F0"|w:fill="D9E2F3"' "$styles" || ok=0
  rg -q 'TableGrid' "$xml" || ok=0
  rg -q 'SourceCode|Source Code' "$xml" || ok=0
  rg -q '│' "$xml" || ok=0
  rg -q 'greet' "$xml" || ok=0
  if python3 - "$xml" <<'PY'
import sys, re
from pathlib import Path
xml = Path(sys.argv[1]).read_text(encoding="utf-8")
for m in re.finditer(r"<w:tbl\b.*?</w:tbl>", xml, re.S):
    cells = re.findall(r"<w:t[^>]*>(.*?)</w:t>", m.group(0))
    texts = [re.sub(r"\s+", " ", t) for t in cells]
    if len(texts) >= 2 and texts[0].strip() in {"1", "01"} and any("greet" in t for t in texts):
        sys.exit(1)
sys.exit(0)
PY
  then
    :
  else
    ok=0
    echo "  (detected number|code data-table pattern for listings)" >&2
  fi
  drawings=$(rg -c '<w:drawing' "$xml" || echo 0)
  [[ "${drawings:-0}" -ge 3 ]] || ok=0
  [[ $ok -eq 1 ]] && pass "docx-precise (header fill style, SourceCode box, ≥3 drawings)" \
    || fail_msg "docx-precise (header/code-box/diagrams)"
  rm -rf "$tmp"
}

assert_docx_lists_numfmt() {
  local tmp="$1"
  local xml="$tmp/word/document.xml"
  local numbering="$tmp/word/numbering.xml"
  [[ -f "$numbering" ]] || { fail_msg "docx-lists-numfmt (missing numbering.xml)"; return; }
  if python3 - "$xml" "$numbering" <<'PY'
import re, sys
from pathlib import Path
doc = Path(sys.argv[1]).read_text(encoding="utf-8")
num = Path(sys.argv[2]).read_text(encoding="utf-8")
abs_fmts = {}
for m in re.finditer(
    r'<w:abstractNum\b[^>]*w:abstractNumId="(\d+)"[^>]*>(.*?)</w:abstractNum>',
    num,
    re.S,
):
    aid, body = m.group(1), m.group(2)
    abs_fmts[aid] = set(re.findall(r'<w:numFmt\b[^>]*w:val="([^"]+)"', body))
num_map = {}
for m in re.finditer(
    r'<w:num\b[^>]*w:numId="(\d+)"[^>]*>\s*<w:abstractNumId\b[^>]*w:val="(\d+)"',
    num,
    re.S,
):
    num_map[m.group(1)] = m.group(2)
body_ids = set(re.findall(r'numId w:val="(\d+)"', doc))
seen = set()
for nid in body_ids:
    aid = num_map.get(nid)
    if aid is None:
        continue
    seen |= abs_fmts.get(aid, set())
if "bullet" in seen and "decimal" in seen:
    sys.exit(0)
sys.exit(1)
PY
  then
    pass "docx-lists-numfmt"
  else
    fail_msg "docx-lists-numfmt (need body-linked bullet + decimal)"
  fi
}

check_m4() {
  if [[ "$(basename "$ROOT")" == "dev-doc" ]] && rg -q '^name: dev-doc' SKILL.md; then
    pass "named-dev-doc"
  else
    fail_msg "named-dev-doc"
  fi
  if [[ -d /Users/anshumandhuliya/mydata/ai-playbook/.agents/skills/doc-pipeline ]]; then
    fail_msg "old doc-pipeline skill folder still present"
  else
    pass "old folder removed"
  fi
  rg -qi 'invoke once|without.*skill|Reinvoke only|reinvoke only' SKILL.md \
    && pass "one-shot-usage" || fail_msg "one-shot-usage"
  rg -qi 'Purpose|purpose' preview/serve.sh references/browser.md \
    && pass "serve-purpose" || fail_msg "serve-purpose"
  rg -q 'index.html' preview/serve.sh references/browser.md \
    && pass "serve-landing" || fail_msg "serve-landing"
  rg -q 'Enter 1 or 2|Choose:' preview/serve.sh \
    && rg -qi 'Kill our prior|next free ports' preview/serve.sh \
    && pass "serve-port-choice" || fail_msg "serve-port-choice"
  if rg -q 'sample/report.docx|verify\.sh' references/docx.md SKILL.md; then
    pass "docx sample path documented"
  else
    fail_msg "docx sample path documented"
  fi
  [[ -f templates/reference.docx ]] || python3 scripts/build-reference-docx.py
  [[ -f templates/filters/docx-rich.lua ]] || fail_msg "missing docx-rich.lua"
  check_docx_visual
  check_m3
}

check_m5() {
  rg -qi 'ask once|Which formats|feature' SKILL.md && pass "feature-intake" || fail_msg "feature-intake"
  [[ -x scripts/scaffold.sh ]] || chmod +x scripts/scaffold.sh
  tmp=$(mktemp -d)
  ./scripts/scaffold.sh "$tmp/work" --formats=report,html,docx >/dev/null
  [[ -f "$tmp/work/scripts/build.sh" && -f "$tmp/work/BUILD.md" && -f "$tmp/work/report.md" ]] \
    && pass "scaffold-at-path" || fail_msg "scaffold-at-path"
  rm -rf "$tmp"

  [[ -x serve.sh ]] || chmod +x serve.sh
  rg -q 'preview/serve.sh' serve.sh && pass "serve-entrypoint" || fail_msg "serve-entrypoint"
  if rg -q 'busy_port' preview/serve.sh && rg -q '/preview/' preview/serve.sh; then
    pass "serve-port-message"
  else
    fail_msg "serve-port-message"
  fi
  rg -q 'skill root|Serving skill root|HTTP root' preview/serve.sh references/browser.md \
    && pass "serve-assets-ok (root serves templates)" || fail_msg "serve-assets-ok"

  check_docx_precise
  check_m3
}

check_m6() {
  [[ -f templates/filters/docx-scholar.lua ]] || fail_msg "missing docx-scholar.lua"
  rg -q 'citeproc|number-sections' scripts/export-docx.sh && pass "export citeproc+sections" \
    || fail_msg "export citeproc+sections"
  ./scripts/export-docx.sh templates/report.md sample/report.docx
  tmp=$(mktemp -d)
  unzip -q sample/report.docx -d "$tmp"
  xml="$tmp/word/document.xml"
  ok=1
  rg -q 'References' "$xml" && rg -q 'Typst Documentation|Pandoc User' "$xml" \
    && pass "docx-bib" || { fail_msg "docx-bib"; ok=0; }
  rg -q 'Figure 1\.' "$xml" && rg -q 'Table 1\.' "$xml" \
    && pass "docx-captions" || { fail_msg "docx-captions"; ok=0; }
  rg -q 'SectionNumber' "$xml" && rg -q '>1</w:t>|>2</w:t>|>2\.1</w:t>' "$xml" \
    && pass "docx-section-nums" || { fail_msg "docx-section-nums"; ok=0; }
  ids=$(rg -o 'numId w:val="[0-9]+"' "$xml" | sort -u | wc -l | tr -d ' ')
  [[ "${ids:-0}" -ge 2 ]] && rg -q 'Author Markdown' "$xml" \
    && pass "docx-lists" || { fail_msg "docx-lists"; ok=0; }
  assert_docx_lists_numfmt "$tmp"
  rg -q 'Figure 1</w:t>|Figure 2</w:t>' "$xml" && rg -q 'Table 1</w:t>' "$xml" \
    && pass "docx-xrefs" || { fail_msg "docx-xrefs"; ok=0; }
  rm -rf "$tmp"
  check_m3
}

target="${1:-all}"
case "$target" in
  m1) check_m1_files; compile_m1 ;;
  m2) check_m2 ;;
  m3) check_m3 ;;
  m4) check_m4 ;;
  m5) check_m5 ;;
  m6) check_m6 ;;
  all) check_m1_files; compile_m1; check_m2; check_m3; check_m4; check_m5; check_m6 ;;
  *) echo "Usage: $0 [m1|m2|m3|m4|m5|m6|all]" >&2; exit 1 ;;
esac

if [[ $fail -ne 0 ]]; then
  echo "VERIFY FAILED"
  exit 1
fi
echo "VERIFY OK ($target)"
