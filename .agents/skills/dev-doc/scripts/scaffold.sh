#!/usr/bin/env bash
# Scaffold a work directory for chosen formats.
# Usage: ./scripts/scaffold.sh /path/to/workdir --formats=report,deck,html,docx,latex
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

TARGET="${1:-}"
shift || true
FORMATS="report,html"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --formats=*) FORMATS="${1#--formats=}" ;;
    --formats) FORMATS="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <target-dir> [--formats=report,deck,html,docx,latex,poster,cheatsheet]" >&2
  exit 1
fi

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
need() { [[ ",$FORMATS," == *",$1,"* ]]; }

echo "Scaffolding into $TARGET"
echo "Formats: $FORMATS"

mkdir -p "$TARGET/theme" "$TARGET/assets" "$TARGET/filters" "$TARGET/scripts"

copy_asset() {
  local name="$1"
  mkdir -p "$TARGET/assets"
  cp "$ROOT/templates/assets/$name" "$TARGET/assets/$name"
}

# Theme/styles for any Typst or report path
if need report || need deck || need poster || need cheatsheet || need docx || need html || need latex; then
  cp -R "$ROOT/templates/theme/"* "$TARGET/theme/"
  cp "$ROOT/templates/style-overrides.typ" "$TARGET/"
fi

# Report Markdown cites assets/swatch.png, flow.png, sequence.png
if need report || need docx || need html || need latex; then
  cp "$ROOT/templates/report.md" "$TARGET/"
  cp "$ROOT/templates/pandoc-page.typ" "$TARGET/"
  cp "$ROOT/templates/pandoc-before.typ" "$TARGET/"
  cp "$ROOT/templates/refs.bib" "$TARGET/"
  copy_asset swatch.png
  copy_asset flow.png
  copy_asset sequence.png
fi

if need deck; then
  cp "$ROOT/templates/deck.typ" "$TARGET/"
  # deck.typ loads assets/swatch.png (same path as report)
  copy_asset swatch.png
fi
need poster && cp "$ROOT/templates/poster.typ" "$TARGET/"
need cheatsheet && cp "$ROOT/templates/cheatsheet.typ" "$TARGET/"

if need docx; then
  [[ -f "$ROOT/templates/reference.docx" ]] || python3 "$ROOT/scripts/build-reference-docx.py"
  cp "$ROOT/templates/reference.docx" "$TARGET/"
  cp "$ROOT/templates/filters/docx-rich.lua" "$TARGET/filters/"
  cp "$ROOT/templates/filters/docx-scholar.lua" "$TARGET/filters/"
fi

if need html; then
  mkdir -p "$TARGET/preview" "$TARGET/templates"
  cp "$ROOT/preview/index.html" "$ROOT/preview/preview.css" "$ROOT/preview/preview.js" \
     "$ROOT/preview/report-browser.md" "$TARGET/preview/"
  # Preview JS/MD use /templates/… relative to HTTP root (workdir).
  # Symlink workdir sources so those URLs resolve without rewriting preview files.
  if [[ -f "$TARGET/report.md" ]]; then
    ln -sfn ../report.md "$TARGET/templates/report.md"
  else
    cp "$ROOT/templates/report.md" "$TARGET/templates/report.md"
  fi
  if [[ -f "$TARGET/refs.bib" ]]; then
    ln -sfn ../refs.bib "$TARGET/templates/refs.bib"
  else
    cp "$ROOT/templates/refs.bib" "$TARGET/templates/refs.bib"
  fi
  if [[ -d "$TARGET/assets" ]]; then
    ln -sfn ../assets "$TARGET/templates/assets"
  else
    mkdir -p "$TARGET/templates/assets"
    cp "$ROOT/templates/assets/swatch.png" "$ROOT/templates/assets/flow.png" \
       "$ROOT/templates/assets/sequence.png" "$TARGET/templates/assets/"
  fi
  # Port-busy UX mirrors skill preview/serve.sh (busy URL + rebind choice).
  cat > "$TARGET/scripts/serve-preview.sh" <<'EOS'
#!/usr/bin/env bash
# Workdir report HTML preview. HTTP root is the workdir so /preview/ and
# /templates/ both resolve. Port-busy messaging matches skill preview/serve.sh.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PREVIEW="$ROOT/preview"
PORT="${PORT:-8765}"
HOST="${HOST:-0.0.0.0}"
PIDFILE="${PIDFILE:-$PREVIEW/.serve.pid}"
MAX_PORT_TRIES="${MAX_PORT_TRIES:-10}"

url_for() {
  local port="$1"
  if [[ "$HOST" == "0.0.0.0" || "$HOST" == "::" ]]; then
    echo "http://127.0.0.1:${port}/preview/"
  else
    echo "http://${HOST}:${port}/preview/"
  fi
}

port_in_use() {
  local port="$1"
  if command -v lsof >/dev/null 2>&1; then
    lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1
  else
    (echo >/dev/tcp/127.0.0.1/"$port") >/dev/null 2>&1
  fi
}

listener_pid() {
  local port="$1"
  if command -v lsof >/dev/null 2>&1; then
    lsof -nP -iTCP:"$port" -sTCP:LISTEN -t 2>/dev/null | head -1 || true
  fi
}

our_prior_pid() {
  if [[ -f "$PIDFILE" ]]; then
    local p
    p="$(cat "$PIDFILE" 2>/dev/null || true)"
    if [[ -n "${p:-}" ]] && kill -0 "$p" 2>/dev/null; then
      echo "$p"
      return 0
    fi
  fi
  return 1
}

print_check_urls() {
  local port="$1"
  echo "Check the preview UI at: $(url_for "$port")"
  echo "  (also assets under http://127.0.0.1:${port}/templates/ …)"
  echo "  (remote: http://<host-ip>:${port}/preview/ — binds ${HOST})"
  echo "Purpose: report Markdown→HTML preview (workdir)."
  echo "Entrypoint: scripts/serve-preview.sh (workdir is HTTP root)."
}

start_server() {
  local port="$1"
  cd "$ROOT"
  print_check_urls "$port"
  echo "Serving workdir $ROOT …"
  python3 -u -m http.server "$port" --bind "$HOST" &
  local pid=$!
  echo "$pid" >"$PIDFILE"
  echo "$port" >"${PIDFILE}.port"
  wait "$pid"
}

try_next_ports() {
  local base="$1"
  local try i
  for ((i = 1; i <= MAX_PORT_TRIES; i++)); do
    try=$((base + i))
    if ! port_in_use "$try"; then
      echo "Using free port ${try} (requested ${base} was busy)." >&2
      start_server "$try"
      return 0
    fi
  done
  echo "No free port in ${base}..$((base + MAX_PORT_TRIES))." >&2
  print_check_urls "$base" >&2
  return 1
}

choose_when_busy() {
  local busy_port="$1"
  local listen_pid prior
  listen_pid="$(listener_pid "$busy_port")"
  prior="$(our_prior_pid || true)"

  echo "Port ${busy_port} is already in use." >&2
  print_check_urls "$busy_port" >&2
  [[ -n "${listen_pid:-}" ]] && echo "Listener PID on ${busy_port}: ${listen_pid}" >&2
  [[ -n "${prior:-}" ]] && echo "Recorded prior serve-preview.sh PID: ${prior}" >&2
  echo "" >&2
  echo "Choose:" >&2
  echo "  1) Keep the existing server on ${busy_port}, or try the next free ports" >&2
  echo "  2) Kill our prior serve-preview.sh (PID file) and rebind port ${busy_port}" >&2
  echo -n "Enter 1 or 2 [1]: " >&2
  local ans="1"
  if [[ -t 0 ]] || [[ -e /dev/tty ]]; then
    read -r ans </dev/tty 2>/dev/null || read -r ans || ans="1"
  fi
  [[ -z "${ans:-}" ]] && ans="1"

  if [[ "$ans" == "2" ]]; then
    if [[ -n "${prior:-}" ]]; then
      echo "Stopping prior serve-preview.sh PID ${prior}, then rebinding ${busy_port} …" >&2
      kill "$prior" 2>/dev/null || true
      sleep 0.4
      rm -f "$PIDFILE" "${PIDFILE}.port"
      if ! port_in_use "$busy_port"; then
        start_server "$busy_port"
        return
      fi
      echo "Port ${busy_port} still busy after kill. Trying next free ports." >&2
    else
      echo "No recorded prior serve-preview.sh PID — will not kill PID ${listen_pid:-unknown}." >&2
      echo "Trying the next free ports instead." >&2
    fi
    try_next_ports "$busy_port"
    return
  fi

  if [[ -n "${prior:-}" && -n "${listen_pid:-}" && "$prior" == "$listen_pid" ]]; then
    echo "Existing server on ${busy_port} looks like our prior serve-preview.sh — leaving it." >&2
    print_check_urls "$busy_port" >&2
    exit 0
  fi
  echo "Leaving listener on ${busy_port}; trying next free ports." >&2
  print_check_urls "$busy_port" >&2
  try_next_ports "$busy_port"
}

cd "$ROOT"
echo "dev-doc workdir report HTML preview"
echo "Opens /preview/ (index.html). Workdir is the HTTP root (fixes /templates/ assets)."
print_check_urls "$PORT"

if port_in_use "$PORT"; then
  choose_when_busy "$PORT"
else
  start_server "$PORT"
fi
EOS
  chmod +x "$TARGET/scripts/serve-preview.sh"
fi

# build.sh — only implements selected formats
{
  cat <<'EOS'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
FIRA_DEFAULT="/opt/homebrew/Cellar/texlive/20260301/share/texmf-dist/fonts/opentype/public/fira"
FIRA="${TYPST_FIRA_PATH:-$FIRA_DEFAULT}"
cmd="${1:-all}"
run_report() {
  pandoc report.md --standalone --pdf-engine=typst \
    --pdf-engine-opt=--font-path --pdf-engine-opt="$FIRA" \
    --include-in-header=pandoc-page.typ \
    --include-before-body=pandoc-before.typ \
    --from markdown+raw_attribute \
    -o report.pdf
}
case "$cmd" in
EOS
  need report || need html || need docx || need latex && cat <<'EOS'
  report|pdf) run_report ;;
EOS
  need deck && cat <<'EOS'
  deck) typst compile --font-path "$FIRA" deck.typ deck.pdf ;;
EOS
  need poster && cat <<'EOS'
  poster) typst compile --font-path "$FIRA" poster.typ poster.pdf ;;
EOS
  need cheatsheet && cat <<'EOS'
  cheatsheet) typst compile --font-path "$FIRA" cheatsheet.typ cheatsheet.pdf ;;
EOS
  need docx && cat <<'EOS'
  docx) pandoc report.md --reference-doc=reference.docx --citeproc --bibliography=refs.bib --number-sections -L filters/docx-scholar.lua -L filters/docx-rich.lua --from markdown+raw_attribute -o report.docx ;;
EOS
  need latex && cat <<'EOS'
  latex) pandoc report.md --standalone -t latex -o report.tex ;;
EOS
  echo '  all)'
  need report || need html || need docx || need latex && echo '    run_report'
  need deck && echo '    "$0" deck'
  need poster && echo '    "$0" poster'
  need cheatsheet && echo '    "$0" cheatsheet'
  need docx && echo '    "$0" docx'
  need latex && echo '    "$0" latex'
  echo '    ;;'
  cat <<'EOS'
  *)
    echo "Usage: $0 [report|deck|poster|cheatsheet|docx|latex|all]" >&2
    exit 1
    ;;
esac
EOS
} > "$TARGET/scripts/build.sh"
chmod +x "$TARGET/scripts/build.sh"

cat > "$TARGET/BUILD.md" <<EOF
# Build plan (dev-doc scaffold)

Formats: \`$FORMATS\`

\`\`\`bash
./scripts/build.sh all
./scripts/build.sh report
$(need docx && echo './scripts/build.sh docx')
$(need deck && echo './scripts/build.sh deck')
$(need html && echo './scripts/serve-preview.sh')
\`\`\`

Continue editing here without reloading **dev-doc**.
Reinvoke the skill only for conversions or pipeline help.
EOF

echo "Done. See $TARGET/BUILD.md"
