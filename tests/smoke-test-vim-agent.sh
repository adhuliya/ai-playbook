#!/usr/bin/env bash
# Smoke-test vim-agent-run.sh with a mocked `agent` on PATH.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RUNNER="$ROOT/configs/vim-agent-run.sh"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/vim-agent-smoke.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/bin"
cat >"$TMP/bin/agent" <<'EOF'
#!/usr/bin/env bash
# Minimal mock: emit JSON with the last non-flag arg as result payload marker.
prompt=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --print|--trust|--mode|--output-format|--model) shift 2 2>/dev/null || shift ;;
    *) prompt="$1"; shift ;;
  esac
done
# Simpler: ignore parsing; fixed result
printf '%s\n' '{"result":"SMOKE_OK"}'
EOF
chmod +x "$TMP/bin/agent"

# Fix mock — agent receives many flags; just always emit fixed JSON.
cat >"$TMP/bin/agent" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' '{"result":"SMOKE_OK"}'
EOF
chmod +x "$TMP/bin/agent"

export PATH="$TMP/bin:$PATH"
export AGENT_MODEL=test-model

prompt="$TMP/prompt.txt"
out="$TMP/out.json"
printf '%s\n' 'hello from smoke' >"$prompt"

result="$(bash "$RUNNER" ask "$prompt" "$out")"
[[ "$result" == "SMOKE_OK" ]] || { echo "FAIL: expected SMOKE_OK got: $result" >&2; exit 1; }

# Confirm model env is visible to a probing mock
cat >"$TMP/bin/agent" <<'EOF'
#!/usr/bin/env bash
for a in "$@"; do
  if [[ "$a" == "test-model" ]]; then
    printf '%s\n' '{"result":"MODEL_OK"}'
    exit 0
  fi
done
printf '%s\n' '{"result":"MODEL_MISSING"}'
EOF
chmod +x "$TMP/bin/agent"

result="$(bash "$RUNNER" edit "$prompt" "$out")"
[[ "$result" == "MODEL_OK" ]] || { echo "FAIL: AGENT_MODEL not passed; got: $result" >&2; exit 1; }

# Default model auto when unset
unset AGENT_MODEL
cat >"$TMP/bin/agent" <<'EOF'
#!/usr/bin/env bash
for a in "$@"; do
  if [[ "$a" == "auto" ]]; then
    printf '%s\n' '{"result":"AUTO_OK"}'
    exit 0
  fi
done
printf '%s\n' '{"result":"AUTO_MISSING"}'
EOF
chmod +x "$TMP/bin/agent"
result="$(bash "$RUNNER" ask "$prompt" "$out")"
[[ "$result" == "AUTO_OK" ]] || { echo "FAIL: default auto missing; got: $result" >&2; exit 1; }

# AGENT_MODEL in zsh helper path (source fragment check)
rg -n 'AGENT_MODEL' "$ROOT/configs/agent.zshrc.sh" >/dev/null
rg -n 'AGENT_MODEL' "$ROOT/configs/vim-agent.vim" >/dev/null
rg -n 'vim-agent.vim' "$ROOT/configs/vimrc" >/dev/null
rg -n 'vim-agent' "$ROOT/machines/Anshumans-MacBook-Pro.local/syncmap.txt" >/dev/null

# Linked destinations exist after sync
[[ -f "$HOME/.vim/vim-agent.vim" ]] || { echo "FAIL: ~/.vim/vim-agent.vim missing (run --machine sync)" >&2; exit 1; }
[[ -f "$HOME/.vim/vim-agent-run.sh" ]] || { echo "FAIL: ~/.vim/vim-agent-run.sh missing" >&2; exit 1; }

echo "vim-agent smoke: OK"
