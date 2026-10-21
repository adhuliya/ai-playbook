#!/usr/bin/env bash
# Quickly view a markdown file (with ```mermaid diagrams) in a browser.
#
# Usage: view_html.sh FILE.md [--serve] [--port N] [--no-open] [--out FILE.html]
#
# Default: builds a self-contained FILE.html next to FILE.md and opens it as
# a file:// URL. With --serve: starts a tiny local HTTP server instead and
# prints/opens a http://127.0.0.1:PORT link. Add --remote to bind 0.0.0.0
# instead, so other devices on your LAN (or anyone who can reach this host)
# can open it too.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $0 FILE.md [--serve] [--remote] [--port N] [--no-open] [--out FILE.html]" >&2
  exit 1
}

[ $# -ge 1 ] || usage
MD_FILE="$1"; shift
SERVE=0
REMOTE=0
PORT=8787
NO_OPEN=0
OUT_HTML=""

while [ $# -gt 0 ]; do
  case "$1" in
    --serve) SERVE=1 ;;
    --remote) SERVE=1; REMOTE=1 ;;
    --port) PORT="$2"; shift ;;
    --no-open) NO_OPEN=1 ;;
    --out) OUT_HTML="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; usage ;;
  esac
  shift
done

BIND_HOST="127.0.0.1"
DISPLAY_HOST="127.0.0.1"
if [ "$REMOTE" = 1 ]; then
  BIND_HOST="0.0.0.0"
  # Best-effort LAN IP for the printed URL; falls back to 0.0.0.0 if not found.
  if command -v ipconfig >/dev/null 2>&1; then
    DISPLAY_HOST="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || true)"
  fi
  if [ -z "$DISPLAY_HOST" ] && command -v hostname >/dev/null 2>&1; then
    DISPLAY_HOST="$(hostname -I 2>/dev/null | awk '{print $1}')"
  fi
  [ -n "$DISPLAY_HOST" ] || DISPLAY_HOST="0.0.0.0"
fi

[ -f "$MD_FILE" ] || { echo "Not a file: $MD_FILE" >&2; exit 1; }
MD_FILE="$(cd "$(dirname "$MD_FILE")" && pwd)/$(basename "$MD_FILE")"

BUILD_ARGS=("$MD_FILE")
[ -n "$OUT_HTML" ] && BUILD_ARGS+=(-o "$OUT_HTML")

OUT_HTML="$(python3 "$SCRIPT_DIR/build_html.py" "${BUILD_ARGS[@]}")"
echo "Wrote $OUT_HTML" >&2

open_target() {
  local target="$1"
  [ "$NO_OPEN" = 1 ] && return 0
  if command -v open >/dev/null 2>&1; then
    open "$target"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$target" >/dev/null 2>&1 &
  else
    echo "(no 'open'/'xdg-open' found; open manually: $target)" >&2
  fi
}

if [ "$SERVE" = 1 ]; then
  DIR="$(dirname "$OUT_HTML")"
  FILE="$(basename "$OUT_HTML")"

  # Find a free-ish port, trying a few in case $PORT is busy.
  for _ in 1 2 3 4 5; do
    if ! (command -v lsof >/dev/null 2>&1 && lsof -i ":$PORT" >/dev/null 2>&1); then
      break
    fi
    PORT=$((PORT + 1))
  done

  if command -v python3 >/dev/null 2>&1; then
    ( cd "$DIR" && exec python3 -m http.server "$PORT" --bind "$BIND_HOST" >/dev/null 2>&1 ) &
    SERVER_PID=$!
  elif command -v npx >/dev/null 2>&1; then
    ( cd "$DIR" && exec npx --yes http-server -p "$PORT" -a "$BIND_HOST" >/dev/null 2>&1 ) &
    SERVER_PID=$!
  else
    echo "Neither python3 nor npx found; cannot start a local server." >&2
    echo "Falling back to opening the file directly." >&2
    open_target "$OUT_HTML"
    exit 0
  fi

  sleep 0.4
  URL="http://${DISPLAY_HOST}:${PORT}/${FILE}"
  if [ "$REMOTE" = 1 ]; then
    echo "WARNING: serving on 0.0.0.0 -- reachable by anyone who can reach this host/network." >&2
  fi
  echo "Serving at $URL  (pid $SERVER_PID; Ctrl+C or 'kill $SERVER_PID' to stop)"
  open_target "$URL"
  wait "$SERVER_PID"
else
  open_target "$OUT_HTML"
  echo "$OUT_HTML"
fi
