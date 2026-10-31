#!/usr/bin/env bash
# Report HTML preview for dev-doc.
#
# Purpose: serve the skill root so /preview/ (UI) and /templates/ (assets)
# both resolve. Not a Typst compiler; not a deck viewer.
#
# Default URL: http://127.0.0.1:<port>/preview/
set -euo pipefail

PREVIEW="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$PREVIEW/.." && pwd)"
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
  echo "Purpose: report Markdown→HTML preview for dev-doc."
  echo "Entrypoints: ./serve.sh  or  ./preview/serve.sh (same server)."
}

start_server() {
  local port="$1"
  cd "$ROOT"
  print_check_urls "$port"
  echo "Serving skill root $ROOT …"
  python3 -u -m http.server "$port" --bind "$HOST" &
  local pid=$!
  echo "$pid" >"$PIDFILE"
  # Also record which port we actually bound
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
  [[ -n "${prior:-}" ]] && echo "Recorded prior serve.sh PID: ${prior}" >&2
  echo "" >&2
  echo "Choose:" >&2
  echo "  1) Keep the existing server on ${busy_port}, or try the next free ports" >&2
  echo "  2) Kill our prior serve.sh (PID file) and rebind port ${busy_port}" >&2
  echo -n "Enter 1 or 2 [1]: " >&2
  local ans="1"
  if [[ -t 0 ]] || [[ -e /dev/tty ]]; then
    read -r ans </dev/tty 2>/dev/null || read -r ans || ans="1"
  fi
  [[ -z "${ans:-}" ]] && ans="1"

  if [[ "$ans" == "2" ]]; then
    if [[ -n "${prior:-}" ]]; then
      echo "Stopping prior serve.sh PID ${prior}, then rebinding ${busy_port} …" >&2
      kill "$prior" 2>/dev/null || true
      sleep 0.4
      rm -f "$PIDFILE" "${PIDFILE}.port"
      if ! port_in_use "$busy_port"; then
        start_server "$busy_port"
        return
      fi
      echo "Port ${busy_port} still busy after kill. Trying next free ports." >&2
    else
      echo "No recorded prior serve.sh PID — will not kill PID ${listen_pid:-unknown}." >&2
      echo "Trying the next free ports instead." >&2
    fi
    try_next_ports "$busy_port"
    return
  fi

  if [[ -n "${prior:-}" && -n "${listen_pid:-}" && "$prior" == "$listen_pid" ]]; then
    echo "Existing server on ${busy_port} looks like our prior serve.sh — leaving it." >&2
    print_check_urls "$busy_port" >&2
    exit 0
  fi
  echo "Leaving listener on ${busy_port}; trying next free ports." >&2
  print_check_urls "$busy_port" >&2
  try_next_ports "$busy_port"
}

cd "$ROOT"
echo "dev-doc report HTML preview"
echo "Opens /preview/ (index.html). Skill root is the HTTP root (fixes /templates/ assets)."
print_check_urls "$PORT"

if port_in_use "$PORT"; then
  choose_when_busy "$PORT"
else
  start_server "$PORT"
fi
