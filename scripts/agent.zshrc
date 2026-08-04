# Cursor Agent terminal shortcuts -- source this file in ~/.zshrc
# Requires: Working `agent` command and CURSOR_API_KEY.
#
# Ctrl-G  agent> on the line → Enter generates a shell command (command only).
# Ctrl-O  agent> on the line → Enter runs a one-shot ask (no persistent session).
# Ctrl-C  cancel agent mode and restore any partial command.

[[ -t 0 ]] || return 0
command -v agent >/dev/null 2>&1 || return 0

typeset -g _AGENT_PREFIX='agent> '
typeset -gi zsh_agent_prompt_mode=0   # 0=off, 1=command, 2=ask
typeset -g _agent_context_cmd=''
typeset -g _agent_buffer_prefix=''

typeset -ga _AGENT_PRINT_FLAGS=(
  --print
  --output-format json
  --trust
  --model auto
)

_agent_trim() {
  local text="$1"
  text="${text#"${text%%[![:space:]]*}"}"
  text="${text%"${text##*[![:space:]]}"}"
  print -r -- "$text"
}

_agent_request_from_buffer() {
  local request="${BUFFER#$_agent_buffer_prefix}"
  _agent_trim "$request"
}

_agent_set_prompt_buffer() {
  if [[ -n "$_agent_context_cmd" ]]; then
    _agent_buffer_prefix="${_AGENT_PREFIX}[${_agent_context_cmd}] "
  else
    _agent_buffer_prefix="$_AGENT_PREFIX"
  fi
  BUFFER="$_agent_buffer_prefix"
  CURSOR=${#BUFFER}
}

_agent_reset_prompt_mode() {
  zsh_agent_prompt_mode=0
  _agent_context_cmd=''
  _agent_buffer_prefix=''
}

# Redraw a clean shell prompt with an optional command on the line.
_agent_redraw_prompt() {
  local cmd="${1:-}"

  zle -I
  if [[ -n "$cmd" ]]; then
    BUFFER="$cmd"
    CURSOR=${#BUFFER}
  else
    BUFFER=""
    CURSOR=0
  fi
  zle -R -c
  zle reset-prompt
}

# Remove fences, prompts, and commentary from a command-only response.
_agent_strip_command() {
  local raw="$1" line

  while IFS= read -r line; do
    [[ -n "${line//[[:space:]]/}" ]] && break
  done <<< "$raw"

  line="${line//\`\`\`bash/}"
  line="${line//\`\`\`sh/}"
  line="${line//\`\`\`zsh/}"
  line="${line//\`\`\`/}"
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [[ "$line" == '$ '* ]] && line="${line:2}"
  print -r -- "$line"
}

# Spinner with elapsed time; kills the job on timeout (default 120s).
_agent_show_progress() {
  local pid=$1 msg=$2 timeout=${3:-120}
  local spin='|/-\' i=0 start=$SECONDS elapsed

  while kill -0 "$pid" 2>/dev/null; do
    elapsed=$(( SECONDS - start ))
    printf "\r\x1b[2K%s %c (%ds)" "$msg" "${spin:$((i%4)):1}" "$elapsed" >&2
    (( i++ ))
    if (( elapsed >= timeout )); then
      kill "$pid" 2>/dev/null
      wait "$pid" 2>/dev/null
      printf "\r\x1b[2K%s timed out after %ds\n" "$msg" "$timeout" >&2
      return 124
    fi
    sleep 0.12
  done

  wait "$pid"
  local st=$?
  printf "\r\x1b[2K\n" >&2
  return $st
}

_agent_run_print() {
  local outfile=$1 timeout=$2
  shift 2

  ( command agent "${_AGENT_PRINT_FLAGS[@]}" "$@" >"$outfile" 2>/dev/null ) &
  local pid=$!
  _agent_show_progress "$pid" "Agent working..." "$timeout"
}

_agent_print_ask_summary() {
  local context="$1" question="$2"

  if [[ -n "$context" ]]; then
    print "The user has this command on their terminal command line:"
    print -r -- "$context"
    print ""
    print "Their question:"
  else
    print "Their question:"
  fi
  print -r -- "$question"
  print ""
}

_agent_build_ask_prompt() {
  local context="$1" question="$2"

  if [[ -n "$context" ]]; then
    print -r -- "The user has this command on their terminal command line:
$context

Their question:
$question"
  else
    print -r -- "$question"
  fi
}

_agent_parse_result() {
  local file=$1
  python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("result",""), end="")' "$file" 2>/dev/null
}

agent-prompt-cancel() {
  if (( zsh_agent_prompt_mode )); then
    if [[ -n "$_agent_context_cmd" ]]; then
      BUFFER="$_agent_context_cmd"
    else
      BUFFER=""
    fi
    CURSOR=${#BUFFER}
    _agent_reset_prompt_mode
    zle -M "agent: cancelled"
    zle reset-prompt
    return 0
  fi
  zle send-break
}

zle -N agent-prompt-cancel

agent-command-submit() {
  local request context llm_prompt tmpfile raw result

  request="$(_agent_request_from_buffer)"
  context="$_agent_context_cmd"

  if [[ -z "$request" ]]; then
    if [[ -n "$context" ]]; then
      BUFFER="$context"
    else
      BUFFER=""
    fi
    CURSOR=${#BUFFER}
    _agent_reset_prompt_mode
    zle reset-prompt
    return 0
  fi

  if [[ -n "$context" ]]; then
    llm_prompt="You are a shell command line editor. Output ONLY a single shell command. No explanation, no markdown, no backticks, no prefix like \$ or #, no trailing commentary.

Current partial command on the line:
$context

User request:
$request

Edit or replace the command to fulfill the request. Output only the final command on one line."
  else
    llm_prompt="You are a shell command generator. Output ONLY a single shell command. No explanation, no markdown, no backticks, no prefix like \$ or #, no trailing commentary.

User request:
$request"
  fi

  zle -I
  print ""

  tmpfile="$(mktemp "${TMPDIR:-/tmp}/agent-cmd.XXXXXX")"
  if ! _agent_run_print "$tmpfile" 120 "$llm_prompt"; then
    rm -f "$tmpfile"
    _agent_reset_prompt_mode
    BUFFER=""
    CURSOR=0
    zle -M "agent: failed or timed out"
    zle reset-prompt
    return 1
  fi

  raw="$(_agent_parse_result "$tmpfile")"
  [[ -z "$raw" ]] && raw="$(<"$tmpfile")"
  rm -f "$tmpfile"
  _agent_reset_prompt_mode

  result="$(_agent_strip_command "$raw")"

  if [[ -z "$result" ]]; then
    BUFFER=""
    CURSOR=0
    zle -M "agent: empty response"
    zle reset-prompt
    return 1
  fi

  BUFFER="$result"
  CURSOR=${#BUFFER}
  zle -M "agent: command ready"
  zle reset-prompt
}

agent-ask-submit() {
  local question context llm_prompt tmpfile raw answer

  question="$(_agent_request_from_buffer)"
  context="$_agent_context_cmd"

  if [[ -z "$question" ]]; then
    if [[ -n "$context" ]]; then
      BUFFER="$context"
    else
      BUFFER=""
    fi
    CURSOR=${#BUFFER}
    _agent_reset_prompt_mode
    zle reset-prompt
    return 0
  fi

  if [[ -n "$context" ]]; then
    llm_prompt="$(_agent_build_ask_prompt "$context" "$question")"
  else
    llm_prompt="$question"
  fi

  zle -I
  print ""

  tmpfile="$(mktemp "${TMPDIR:-/tmp}/agent-ask.XXXXXX")"
  if ! _agent_run_print "$tmpfile" 180 --mode ask "$llm_prompt"; then
    rm -f "$tmpfile"
    _agent_reset_prompt_mode
    zle -M "agent ask: failed or timed out"
    _agent_redraw_prompt "$context"
    return 1
  fi

  raw="$(_agent_parse_result "$tmpfile")"
  [[ -z "$raw" ]] && raw="$(<"$tmpfile")"
  rm -f "$tmpfile"
  _agent_reset_prompt_mode

  answer="$(_agent_trim "$raw")"

  _agent_print_ask_summary "$context" "$question"
  print -r -- "$answer"
  print ""
  _agent_redraw_prompt "$context"
}

# Ctrl-G: enter command mode with an explicit agent> prefix on the line.
agent-command-start() {
  if (( zsh_agent_prompt_mode == 1 )); then
    agent-prompt-cancel
    return 0
  fi

  _agent_context_cmd="$(_agent_trim "$BUFFER")"
  zsh_agent_prompt_mode=1
  _agent_set_prompt_buffer
  zle vi-insert 2>/dev/null
  if [[ -n "$_agent_context_cmd" ]]; then
    zle -M "agent command mode: command in [brackets]; type request, Enter to generate"
  else
    zle -M "agent command mode: type request, Enter to generate, Ctrl-C to cancel"
  fi
}

zle -N agent-command-start

# Ctrl-O: enter ask mode with an explicit agent> prefix on the line.
agent-ask-start() {
  if (( zsh_agent_prompt_mode == 2 )); then
    agent-prompt-cancel
    return 0
  fi

  _agent_context_cmd="$(_agent_trim "$BUFFER")"
  zsh_agent_prompt_mode=2
  _agent_set_prompt_buffer
  zle vi-insert 2>/dev/null
  if [[ -n "$_agent_context_cmd" ]]; then
    zle -M "agent ask mode: command in [brackets]; type question, Enter to ask"
  else
    zle -M "agent ask mode: type question, Enter to ask, Ctrl-C to cancel"
  fi
}

zle -N agent-ask-start

# Chain Enter through agent modes, then the existing shell-integration handler.
if zle -l please-fix-or-accept-line &>/dev/null; then
  zle -A please-fix-or-accept-line .agent-orig-accept-line
else
  zle -A accept-line .agent-orig-accept-line
fi

agent-prompt-accept-line() {
  if (( zsh_agent_prompt_mode == 1 )); then
    agent-command-submit
    return
  fi
  if (( zsh_agent_prompt_mode == 2 )); then
    agent-ask-submit
    return
  fi
  zle .agent-orig-accept-line
}

zle -N agent-prompt-accept-line

# Prevent deleting into the fixed agent> prefix (and any shown context).
agent-prompt-backward-delete() {
  if (( zsh_agent_prompt_mode && CURSOR <= ${#_agent_buffer_prefix} )); then
    agent-prompt-cancel
    return 0
  fi
  zle backward-delete-char
}

zle -N agent-prompt-backward-delete

_agent_bind_shortcuts() {
  local map

  for map in emacs viins vicmd; do
    bindkey -M "$map" '^G' agent-command-start
    bindkey -M "$map" '^O' agent-ask-start
    bindkey -M "$map" '^M' agent-prompt-accept-line
    bindkey -M "$map" '^C' agent-prompt-cancel
    bindkey -M "$map" '^?' agent-prompt-backward-delete
  done
}

_agent_bind_shortcuts

alias sonnetagent='agent --model claude-sonnet-5-medium'
alias opusagent='agent --model claude-opus-4-8-high'
alias composeragent='agent --model composer-2.5'
alias grokagent='agent --model cursor-grok-4.5-high'

