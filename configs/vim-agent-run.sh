#!/usr/bin/env bash
# Run Cursor agent for Vim helpers. Prompt is read from a file to avoid shell quoting issues.
#
# Usage:
#   vim-agent-run.sh ask|edit PROMPT_FILE OUT_FILE
#
# Env:
#   AGENT_MODEL  model id (default: auto)
#   AGENT_TIMEOUT  seconds (default: 180)

set -euo pipefail

mode="${1:?mode required (ask|edit)}"
prompt_file="${2:?prompt file required}"
out_file="${3:?out file required}"

case "$mode" in
  ask|edit) ;;
  *) echo "usage: vim-agent-run.sh ask|edit PROMPT_FILE OUT_FILE" >&2; exit 2 ;;
esac

model="${AGENT_MODEL:-auto}"
timeout="${AGENT_TIMEOUT:-180}"

if ! command -v agent >/dev/null 2>&1; then
  echo "agent CLI not found on PATH" >&2
  exit 127
fi

if [[ ! -f "$prompt_file" ]]; then
  echo "prompt file not found: $prompt_file" >&2
  exit 2
fi

prompt="$(cat -- "$prompt_file")"

args=(--print --output-format json --trust --model "$model")
# Both modes use ask (read-only) so the CLI does not edit files; Vim applies changes.
args+=(--mode ask)

# Run with timeout when available.
if command -v timeout >/dev/null 2>&1; then
  timeout "$timeout" agent "${args[@]}" "$prompt" >"$out_file" 2>/dev/null
elif command -v gtimeout >/dev/null 2>&1; then
  gtimeout "$timeout" agent "${args[@]}" "$prompt" >"$out_file" 2>/dev/null
else
  agent "${args[@]}" "$prompt" >"$out_file" 2>/dev/null
fi

python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("result",""), end="")' "$out_file" 2>/dev/null || cat -- "$out_file"
