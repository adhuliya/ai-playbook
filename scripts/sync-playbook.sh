#!/usr/bin/env bash
# Sync ai-playbook assets into target repos (hard links) and optional machine syncmap.
#
# Modes:
#   - Playbook cwd: sync all (or --project) paths listed for this machine.
#   - Target cwd:   sync that repo only (--project required).
#   - --machine:    process machines/<id>/syncmap.txt only (any cwd).
#
# .cursor/: playbook → target only. .dev-notes/ + project guides: bidirectional.
# Same inode: no-op. Different inode, same bytes: re-link. Content conflict:
# prompt (playbook wins) or --force. Target git-tracked paths: warn, never touch.
set -euo pipefail

SEP=$'\x1f'

usage() {
  cat <<'EOF'
Usage:
  sync-playbook.sh [--project <name>] [--yes] [--force] [--ignore-submodules]
  sync-playbook.sh --project <name> [--yes] [--force] [--ignore-submodules]
  sync-playbook.sh --machine [--yes] [--force]            # syncmap only (any cwd)

Modes (auto-detected by cwd, unless --machine):
  Playbook root  Sync project path(s) for this machine from machines/<id>/projects.txt.
                 No --project ⇒ every project path listed for this machine.
  Target root    Sync only this repo (--project required). May register project:pwd.
  --machine      Process machines/<id>/syncmap.txt only. Incompatible with --project.

Machine identity:
  hostname, optionally mapped via machines/aliases.txt (hostname machine-id).
  Unknown host: choose an existing machine (writes alias) or create a new scaffold.

Flags:
  --project <name>  Limit to one project key (required in target-cwd mode).
  --yes             Auto-confirm admin/registry prompts (add project, register path).
                    Missing machine project paths ⇒ skip. Does NOT resolve content conflicts.
                    Does NOT answer nested-submodule guide prompts (use --ignore-submodules).
  --ignore-submodules  Skip dev-guide.md under nested .git (no prompts).
  --force           On content conflict, playbook wins without prompting (re-link dest).
  -h, --help        Show this help.

Files:
  projects.txt                         Project key list
  machines/<id>/projects.txt           project:/abs/path lines (many paths per project OK)
  machines/<id>/project-modules.txt    project:/abs/submodule (nested repo = same project)
  machines/<id>/syncmap.txt            playbook-rel:/abs/dest (files or dirs)
  machines/<id>/ignoresync.txt         machine ignores
  ignoresync.txt                       global ignores
  artifacts/live-notes/<p>/ignoresync.txt  per-project ignores
  machines/aliases.txt                 hostname machine-id

Ignores: playbook-root paths only (no globs); ! unignore; last match wins
(global → machine → project). Ignores do not apply to --machine syncmap.
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLAYBOOK_ROOT="$(cd -P "$SCRIPT_DIR/.." && pwd)"

PROJECT=""
YES=0
FORCE=0
IGNORE_SUBMODULES=0
MACHINE_MODE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { echo "error: --project requires a name" >&2; exit 2; }
      PROJECT="$2"
      shift 2
      ;;
    --machine) MACHINE_MODE=1; shift ;;
    --yes) YES=1; shift ;;
    --ignore-submodules) IGNORE_SUBMODULES=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$MACHINE_MODE" -eq 1 && -n "$PROJECT" ]]; then
  echo "error: --machine is incompatible with --project" >&2
  exit 2
fi

PROJECTS_FILE="$PLAYBOOK_ROOT/projects.txt"
STRUCTURE="$PLAYBOOK_ROOT/artifacts/dev-notes-structure"
MACHINES_DIR="$PLAYBOOK_ROOT/machines"
ALIASES_FILE="$MACHINES_DIR/aliases.txt"
GLOBAL_IGNORE="$PLAYBOOK_ROOT/ignoresync.txt"

# Interactive prompts must not use stdin (often redirected from syncmap/join).
read_tty() {
  read -r "$@" </dev/tty
}

EXCLUDED=()
EXISTING=()
REPAIRED=()
NEW_TO_TARGET=()
NEW_TO_PLAYBOOK=()
TARGET_ONLY=()
CONFLICTS=()
FAILURES=()
MANAGED=()
IGNORED=()
IGNORE_PATTERNS=()

HOSTNAME_KEY="${SYNC_PLAYBOOK_HOSTNAME:-$(hostname)}"
MACHINE_ID=""
MACHINE_DIR=""

# --- helpers ---

file_id() { stat -f '%d:%i' "$1" 2>/dev/null; }

same_file() {
  [[ -f "$1" && -f "$2" ]] || return 1
  local a b
  a="$(file_id "$1")"
  b="$(file_id "$2")"
  [[ -n "$a" && "$a" == "$b" ]]
}

same_bytes() { [[ -f "$1" && -f "$2" ]] && cmp -s "$1" "$2"; }

rel_under() {
  local root="${1%/}" abs="$2"
  echo "${abs#"$root"/}"
}

collect_files() {
  local src_root="$1"
  [[ -d "$src_root" ]] || return 0
  find -P "$src_root" -type f -print0 |
    while IFS= read -r -d '' f; do
      printf '%s%s%s\n' "$(rel_under "$src_root" "$f")" "$SEP" "$f"
    done
}

devnotes_rel_ok() {
  local rel="$1"
  [[ "$rel" == dev-guides || "$rel" == dev-guides/* ]] && return 1
  return 0
}

collect_devnotes_files() {
  local src_root="$1"
  [[ -d "$src_root" ]] || return 0
  find -P "$src_root" -type f -print0 |
    while IFS= read -r -d '' f; do
      local rel
      rel="$(rel_under "$src_root" "$f")"
      devnotes_rel_ok "$rel" || continue
      printf '%s%s%s\n' "$rel" "$SEP" "$f"
    done
}

collect_project_guides_files() {
  local root="$1"
  [[ -d "$root" ]] || return 0
  find -P "$root" -type f -name dev-guide.md -print0 |
    while IFS= read -r -d '' f; do
      local rel
      rel="$(rel_under "$root" "$f")"
      [[ "$rel" == .dev-notes/* ]] && continue
      printf '%s%s%s\n' "$rel" "$SEP" "$f"
    done
}

collect_live_guides_forward() {
  local src_root="$1"
  [[ -d "$src_root" ]] || return 0
  find -P "$src_root" -type f -name dev-guide.md -print0 |
    while IFS= read -r -d '' f; do
      printf '%s%s%s\n' "$(rel_under "$src_root" "$f")" "$SEP" "$f"
    done
}

scaffold_machine_dir() {
  local dir="$1"
  mkdir -p "$dir"
  [[ -f "$dir/projects.txt" ]] || : >"$dir/projects.txt"
  [[ -f "$dir/syncmap.txt" ]] || : >"$dir/syncmap.txt"
  [[ -f "$dir/ignoresync.txt" ]] || : >"$dir/ignoresync.txt"
  [[ -f "$dir/project-modules.txt" ]] || : >"$dir/project-modules.txt"
}

dir_has_git() {
  local d="${1%/}"
  [[ -e "$d/.git" ]]
}

# Closest strict ancestor of guide file below target_root that has .git (not target_root).
nested_git_root_for_guide() {
  local target_root="${1%/}" guide_abs="$2"
  local dir
  target_root="$(cd -P "$target_root" && pwd)"
  if [[ -f "$guide_abs" ]]; then
    dir="$(cd -P "$(dirname "$guide_abs")" && pwd)"
  else
    dir="$(cd -P "$(dirname "$guide_abs")" 2>/dev/null && pwd)" || return 1
  fi
  while [[ "$dir" != "$target_root" && "$dir" == "$target_root"/* ]]; do
    if dir_has_git "$dir"; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

# When the guide file is missing on disk, infer nested root from rel path under target_root.
nested_git_root_for_rel() {
  local target_root="$1" rel="$2"
  target_root="$(cd -P "$target_root" && pwd)"
  local dir_rel="${rel%/*}"
  [[ "$dir_rel" != "$rel" ]] || return 1
  local cur="$target_root" p
  while IFS= read -r -d '' p; do
    [[ -n "$p" ]] || continue
    cur="$cur/$p"
    if dir_has_git "$cur"; then
      echo "$(cd -P "$cur" && pwd)"
      return 0
    fi
  done < <(printf '%s\0' ${dir_rel//\//$'\0'})
  return 1
}

nested_git_root_for_target_guide() {
  local target_root="$1" rel="$2"
  local guide_abs="$target_root/$rel"
  if [[ -e "$guide_abs" ]]; then
    nested_git_root_for_guide "$target_root" "$(cd -P "$(dirname "$guide_abs")" && pwd)/$(basename "$rel")"
  else
    nested_git_root_for_rel "$target_root" "$rel"
  fi
}

lookup_project_for_abs_path() {
  local want="${1%/}"
  [[ -f "$MACHINE_DIR/projects.txt" ]] || return 1
  local line proj path
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    proj="${line%%:*}"
    path="${line#*:}"
    if [[ "$proj" == "$line" || -z "$proj" || -z "$path" ]]; then
      continue
    fi
    path="$(cd -P "$path" 2>/dev/null && pwd)" || continue
    if [[ "$path" == "$want" ]]; then
      echo "$proj"
      return 0
    fi
  done <"$MACHINE_DIR/projects.txt"
  return 1
}

lookup_project_module_owner() {
  local want="${1%/}"
  [[ -f "$MACHINE_DIR/project-modules.txt" ]] || return 1
  local line proj path
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    proj="${line%%:*}"
    path="${line#*:}"
    if [[ "$proj" == "$line" || -z "$proj" || -z "$path" ]]; then
      continue
    fi
    path="$(cd -P "$path" 2>/dev/null && pwd)" || continue
    if [[ "$path" == "$want" ]]; then
      echo "$proj"
      return 0
    fi
  done <"$MACHINE_DIR/project-modules.txt"
  return 1
}

append_project_module_line() {
  local proj="$1" path="$2"
  local line="${proj}:${path}"
  touch "$MACHINE_DIR/project-modules.txt"
  grep -qxF "$line" "$MACHINE_DIR/project-modules.txt" 2>/dev/null && return 0
  echo "$line" >>"$MACHINE_DIR/project-modules.txt"
  echo "note: registered $line in machines/${MACHINE_ID}/project-modules.txt"
}

append_machine_project_line() {
  local proj="$1" path="$2"
  local line="${proj}:${path}"
  touch "$MACHINE_DIR/projects.txt"
  grep -qxF "$line" "$MACHINE_DIR/projects.txt" 2>/dev/null && return 0
  echo "$line" >>"$MACHINE_DIR/projects.txt"
  echo "note: registered $line in machines/${MACHINE_ID}/projects.txt"
}

list_known_project_keys() {
  [[ -f "$PROJECTS_FILE" ]] || return 0
  awk 'NF && $0 !~ /^#/ { print }' "$PROJECTS_FILE" | LC_ALL=C sort -u
}

prompt_nested_guide_resolution() {
  local nested_abs="$1" guide_rel="$2"
  echo "Nested git repo (dev-guide.md at ${guide_rel}): $nested_abs" >&2
  if [[ "$IGNORE_SUBMODULES" -eq 1 ]]; then
    return 1
  fi
  printf "Submodule guides: [s]kip / same project as '%s' [m] / separate project [p]? " "$PROJECT" >&2
  local ans
  read_tty ans
  case "$ans" in
    m|M)
      append_project_module_line "$PROJECT" "$nested_abs"
      echo "module"
      ;;
    p|P)
      local keys=() pick=""
      while IFS= read -r k; do
        [[ -n "$k" ]] && keys+=("$k")
      done < <(list_known_project_keys)
      if [[ ${#keys[@]} -gt 0 ]]; then
        echo "Known project keys:" >&2
        local i
        for i in "${!keys[@]}"; do
          echo "  $((i + 1))) ${keys[$i]}" >&2
        done
        echo "  n) new project key" >&2
        printf "Choose [1-%d/n]: " "${#keys[@]}" >&2
        read_tty ans
        local pick=""
        if [[ "$ans" == "n" || "$ans" == "N" ]]; then
          printf "New project key: " >&2
          read_tty pick
        elif [[ "$ans" =~ ^[0-9]+$ ]] && ((ans >= 1 && ans <= ${#keys[@]})); then
          pick="${keys[$((ans - 1))]}"
        else
          echo "note: invalid choice — skip nested guide" >&2
          return 1
        fi
        [[ -n "$pick" ]] || return 1
        ensure_project_known "$pick"
        append_machine_project_line "$pick" "$nested_abs"
        echo "project:$pick"
      else
        printf "New project key: " >&2
        read_tty pick
        [[ -n "$pick" ]] || return 1
        ensure_project_known "$pick"
        append_machine_project_line "$pick" "$nested_abs"
        echo "project:$pick"
      fi
      ;;
    *)
      echo "note: skip nested guide at $guide_rel" >&2
      return 1
      ;;
  esac
}

# Deduped nested guide syncs: project<SEP>abs_root (global for one sync_one_target run)
NESTED_GUIDE_SYNCS=()
NESTED_GUIDE_SYNC_SEEN=""

queue_nested_guide_sync() {
  local proj="$1" root="$2"
  root="$(cd -P "$root" && pwd)"
  local key="${proj}${SEP}${root}"
  [[ "$NESTED_GUIDE_SYNC_SEEN" == *"$SEP$key$SEP"* ]] && return 0
  NESTED_GUIDE_SYNC_SEEN+="${SEP}${key}${SEP}"
  NESTED_GUIDE_SYNCS+=("$key")
}

collect_project_guides_files_filtered() {
  local root="$1"
  [[ -d "$root" ]] || return 0
  root="$(cd -P "$root" && pwd)"
  local f rel nested nested_abs mod_owner reg_proj resolution pick_proj
  while IFS= read -r -d '' f; do
    rel="$(rel_under "$root" "$f")"
    [[ "$rel" == .dev-notes/* ]] && continue
    nested="$(nested_git_root_for_guide "$root" "$f" 2>/dev/null)" || nested=""
    if [[ -z "$nested" ]]; then
      printf '%s%s%s\n' "$rel" "$SEP" "$f"
      continue
    fi
    nested_abs="$(cd -P "$nested" && pwd)"
    if [[ "$IGNORE_SUBMODULES" -eq 1 ]]; then
      echo "note: --ignore-submodules — skip $rel" >&2
      continue
    fi
    mod_owner="$(lookup_project_module_owner "$nested_abs" 2>/dev/null)" || mod_owner=""
    if [[ -n "$mod_owner" ]]; then
      if [[ "$mod_owner" == "$PROJECT" ]]; then
        printf '%s%s%s\n' "$rel" "$SEP" "$f"
      else
        queue_nested_guide_sync "$mod_owner" "$nested_abs"
      fi
      continue
    fi
    reg_proj="$(lookup_project_for_abs_path "$nested_abs" 2>/dev/null)" || reg_proj=""
    if [[ -n "$reg_proj" ]]; then
      queue_nested_guide_sync "$reg_proj" "$nested_abs"
      continue
    fi
    resolution="$(prompt_nested_guide_resolution "$nested_abs" "$rel" 2>/dev/null)" || continue
    case "$resolution" in
      module)
        printf '%s%s%s\n' "$rel" "$SEP" "$f"
        ;;
      project:*)
        pick_proj="${resolution#project:}"
        queue_nested_guide_sync "$pick_proj" "$nested_abs"
        ;;
    esac
  done < <(find -P "$root" -type f -name dev-guide.md -print0)
}

list_machine_ids() {
  [[ -d "$MACHINES_DIR" ]] || return 0
  find "$MACHINES_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | LC_ALL=C sort
}

resolve_machine() {
  mkdir -p "$MACHINES_DIR"
  local alias_id=""
  if [[ -f "$ALIASES_FILE" ]]; then
    alias_id="$(awk -v h="$HOSTNAME_KEY" 'NF>=2 && $1==h { print $2; exit }' "$ALIASES_FILE")"
  fi
  if [[ -n "$alias_id" && -d "$MACHINES_DIR/$alias_id" ]]; then
    MACHINE_ID="$alias_id"
  elif [[ -d "$MACHINES_DIR/$HOSTNAME_KEY" ]]; then
    MACHINE_ID="$HOSTNAME_KEY"
  else
    local ids=()
    while IFS= read -r id; do
      [[ -n "$id" ]] && ids+=("$id")
    done < <(list_machine_ids)
    if [[ ${#ids[@]} -eq 0 ]]; then
      echo "note: new machine '$HOSTNAME_KEY' — creating empty scaffold"
      MACHINE_ID="$HOSTNAME_KEY"
      scaffold_machine_dir "$MACHINES_DIR/$MACHINE_ID"
    else
      echo "Hostname '$HOSTNAME_KEY' is not a known machine."
      echo "Existing machines:"
      local i
      for i in "${!ids[@]}"; do
        echo "  $((i + 1))) ${ids[$i]}"
      done
      echo "  n) new machine '$HOSTNAME_KEY'"
      if [[ "$YES" -eq 1 ]]; then
        echo "note: --yes ⇒ creating new machine '$HOSTNAME_KEY'"
        MACHINE_ID="$HOSTNAME_KEY"
        scaffold_machine_dir "$MACHINES_DIR/$MACHINE_ID"
      else
        printf "Choose [1-%d/n]: " "${#ids[@]}"
        local ans
        read_tty ans
        if [[ "$ans" == "n" || "$ans" == "N" ]]; then
          MACHINE_ID="$HOSTNAME_KEY"
          scaffold_machine_dir "$MACHINES_DIR/$MACHINE_ID"
        elif [[ "$ans" =~ ^[0-9]+$ ]] && ((ans >= 1 && ans <= ${#ids[@]})); then
          MACHINE_ID="${ids[$((ans - 1))]}"
          echo "$HOSTNAME_KEY $MACHINE_ID" >>"$ALIASES_FILE"
          echo "note: aliased '$HOSTNAME_KEY' -> '$MACHINE_ID'"
        else
          echo "error: invalid choice" >&2
          exit 1
        fi
      fi
    fi
  fi
  MACHINE_DIR="$MACHINES_DIR/$MACHINE_ID"
  scaffold_machine_dir "$MACHINE_DIR"
}

# --- ignores ---

path_matches_ignore() {
  local path="$1" pat="${2%/}"
  [[ "$path" == "$pat" || "$path" == "$pat"/* ]]
}

load_ignore_file() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  local line pat check
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    IGNORE_PATTERNS+=("$line")
    if [[ "$line" == !* ]]; then
      pat="${line#!}"
      pat="${pat%/}"
    else
      pat="${line%/}"
    fi
    check="$PLAYBOOK_ROOT/$pat"
    if [[ ! -e "$check" ]]; then
      echo "warning: ignoresync path not found in playbook: $pat (from $file)" >&2
    fi
  done <"$file"
}

load_ignores_for_project() {
  local project="$1"
  IGNORE_PATTERNS=()
  load_ignore_file "$GLOBAL_IGNORE"
  load_ignore_file "$MACHINE_DIR/ignoresync.txt"
  load_ignore_file "$PLAYBOOK_ROOT/artifacts/live-notes/$project/ignoresync.txt"
}

is_ignored() {
  local path="$1"
  local state=0 pat
  for pat in "${IGNORE_PATTERNS[@]+"${IGNORE_PATTERNS[@]}"}"; do
    if [[ "$pat" == !* ]]; then
      path_matches_ignore "$path" "${pat#!}" && state=0
    else
      path_matches_ignore "$path" "$pat" && state=1
    fi
  done
  [[ "$state" -eq 1 ]]
}

filter_forward_ignored() {
  # stdin/stdout: rel<SEP>abs ; drop lines whose playbook-rel abs is ignored
  local rel abs prel
  while IFS="$SEP" read -r rel abs; do
    [[ -n "$rel" ]] || continue
    prel="$(rel_under "$PLAYBOOK_ROOT" "$abs")"
    if is_ignored "$prel"; then
      IGNORED+=("$prel")
      continue
    fi
    printf '%s%s%s\n' "$rel" "$SEP" "$abs"
  done
}

# --- link / repair ---

hardlink_to() {
  # ln src dest (dest must not exist)
  local src="$1" dest="$2" err
  mkdir -p "$(dirname "$dest")"
  err="$(mktemp)"
  if ln "$src" "$dest" 2>"$err"; then
    rm -f "$err"
    return 0
  fi
  echo "$(tr '\n' ' ' <"$err")"
  rm -f "$err"
  return 1
}

relink_playbook_wins() {
  local src="$1" dest="$2" rel_full="$3" err
  rm -f "$dest"
  err="$(hardlink_to "$src" "$dest")" && return 0
  FAILURES+=("$rel_full ($err)")
  return 1
}

resolve_both_sides() {
  local src="$1" dest="$2" rel_full="$3"
  if same_file "$dest" "$src"; then
    EXISTING+=("$rel_full")
    MANAGED+=("$rel_full")
    return 0
  fi
  if same_bytes "$src" "$dest"; then
    if relink_playbook_wins "$src" "$dest" "$rel_full"; then
      REPAIRED+=("$rel_full")
      MANAGED+=("$rel_full")
    fi
    return 0
  fi
  # content conflict
  local ans=n
  if [[ "$FORCE" -eq 1 ]]; then
    ans=y
  else
    printf "Conflict %s: different content (inode differs). Replace dest with playbook hard link? [y/N] " "$rel_full" >&2
    read_tty ans
  fi
  case "$ans" in
    y|Y|yes|YES)
      if relink_playbook_wins "$src" "$dest" "$rel_full"; then
        REPAIRED+=("$rel_full")
        MANAGED+=("$rel_full")
      fi
      ;;
    *)
      CONFLICTS+=("$rel_full")
      ;;
  esac
}

# allow_pull: 1 = bidirectional, 0 = one-way (cursor)
# playbook_path_for_rel: function name or empty — for ignore checks on pull dest
process_domain() {
  local forward_file="$1" target_file="$2" dest_root="$3" pull_root="$4"
  local report_prefix="$5" allow_pull="$6"
  local playbook_prefix_for_ignore="${7:-}" # e.g. artifacts/live-notes/p/dev-notes/

  local sf tf
  sf="$(mktemp)"
  tf="$(mktemp)"
  LC_ALL=C sort -t "$SEP" -k1,1 "$forward_file" >"$sf"
  LC_ALL=C sort -t "$SEP" -k1,1 "$target_file" >"$tf"

  local rel src tgt rel_full dest err pull_dest prel
  while IFS="$SEP" read -r rel src tgt; do
    [[ -n "$rel" ]] || continue
    rel_full="${report_prefix}${rel}"
    dest="$dest_root/$rel"

    if is_git_tracked "$rel_full"; then
      echo "warning: $rel_full is git-tracked in target — leaving untouched" >&2
      EXCLUDED+=("$rel_full")
      continue
    fi

    if [[ -n "$src" ]]; then
      prel="$(rel_under "$PLAYBOOK_ROOT" "$src")"
      if is_ignored "$prel"; then
        IGNORED+=("$prel")
        continue
      fi
    fi

    if [[ -n "$src" && -n "$tgt" ]]; then
      resolve_both_sides "$src" "$dest" "$rel_full"
    elif [[ -n "$src" && -z "$tgt" ]]; then
      err="$(hardlink_to "$src" "$dest")" && {
        NEW_TO_TARGET+=("$rel_full")
        MANAGED+=("$rel_full")
      } || FAILURES+=("$rel_full ($err)")
    elif [[ -z "$src" && -n "$tgt" ]]; then
      if [[ "$allow_pull" -ne 1 ]]; then
        TARGET_ONLY+=("$rel_full")
        continue
      fi
      pull_dest="$pull_root/$rel"
      if [[ -n "$playbook_prefix_for_ignore" ]]; then
        prel="${playbook_prefix_for_ignore}${rel}"
        if is_ignored "$prel"; then
          IGNORED+=("$prel")
          continue
        fi
      fi
      err="$(hardlink_to "$tgt" "$pull_dest")" && {
        NEW_TO_PLAYBOOK+=("$rel_full")
        MANAGED+=("$rel_full")
      } || FAILURES+=("$rel_full ($err)")
    fi
  done < <(join -t "$SEP" -a1 -a2 -e '' -o 0,1.2,2.2 "$sf" "$tf")

  rm -f "$sf" "$tf"
}

# --- project sync ---

EXCLUDE_FILE=""
TARGET_ROOT=""
LIVE_NOTES=""
LIVE_GUIDES=""
OVERLAY_ROOT=""
SHARED_CURSOR=""
DEVNOTES_DEST=""

is_git_tracked() {
  local rel="$1"
  [[ -f "$EXCLUDE_FILE" ]] || return 1
  grep -qxF "$rel" "$EXCLUDE_FILE"
}

compute_git_tracked() {
  mkdir -p "$TARGET_ROOT/.cursor"
  EXCLUDE_FILE="$TARGET_ROOT/.cursor/.sync-playbook-excluded"
  if git -C "$TARGET_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
    git -C "$TARGET_ROOT" ls-files | LC_ALL=C sort -u >"$EXCLUDE_FILE"
  else
    : >"$EXCLUDE_FILE"
  fi
}

ensure_project_known() {
  local project="$1"
  touch "$PROJECTS_FILE"
  grep -qxF "$project" "$PROJECTS_FILE" 2>/dev/null && return 0
  if [[ "$YES" -eq 1 ]]; then
    echo "$project" >>"$PROJECTS_FILE"
    echo "note: appended '$project' to projects.txt"
    return 0
  fi
  printf "Project '%s' is not in projects.txt. Add it? [y/N] " "$project"
  local ans
  read_tty ans
  case "$ans" in
    y|Y|yes|YES) echo "$project" >>"$PROJECTS_FILE"; echo "note: appended '$project' to projects.txt" ;;
    *) echo "error: aborted (project not registered)" >&2; exit 1 ;;
  esac
}

scaffold_live_notes_if_needed() {
  if [[ -d "$LIVE_NOTES" ]]; then
    return 0
  fi
  if [[ ! -d "$STRUCTURE" ]]; then
    echo "error: missing scaffold template: $STRUCTURE" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$LIVE_NOTES")"
  cp -R "$STRUCTURE" "$LIVE_NOTES"
  echo "note: scaffolded $LIVE_NOTES"
}

build_cursor_forward_file() {
  local out="$1"
  : >"$out"
  collect_files "$SHARED_CURSOR" >"$out"
  if [[ -d "$OVERLAY_ROOT" ]]; then
    collect_files "$OVERLAY_ROOT" >>"$out"
  else
    echo "warning: no overlay at ${PROJECT}.cursor (shared only)"
  fi
  local merged
  merged="$(mktemp)"
  awk -F "$SEP" 'NF >= 2 { last[$1] = $0 } END { for (k in last) print last[k] }' "$out" >"$merged"
  mv "$merged" "$out"
}

warn_legacy_devnotes_devguides() {
  [[ -d "$DEVNOTES_DEST/dev-guides" ]] || return 0
  echo "warning: $DEVNOTES_DEST/dev-guides/ is obsolete (guides now live at <P>/dev-guide.md). Remove manually when ready." >&2
}

migrate_legacy_devnotes_symlink() {
  [[ -L "$DEVNOTES_DEST" ]] || return 0
  local live_resolved target_resolved
  live_resolved="$(cd -P "$LIVE_NOTES" && pwd)"
  target_resolved="$(cd -P "$DEVNOTES_DEST" 2>/dev/null && pwd)" || target_resolved=""
  if [[ -n "$target_resolved" && "$target_resolved" == "$live_resolved" ]]; then
    rm -f "$DEVNOTES_DEST"
    echo "note: migrated legacy .dev-notes symlink to a hardlinked directory"
  else
    CONFLICTS+=(".dev-notes (unexpected symlink target; resolve manually)")
    return 1
  fi
}

sync_cursor_domain() {
  mkdir -p "$TARGET_ROOT/.cursor"
  local forward_file target_file filtered
  forward_file="$(mktemp)"
  target_file="$(mktemp)"
  filtered="$(mktemp)"
  build_cursor_forward_file "$forward_file"
  filter_forward_ignored <"$forward_file" >"$filtered"
  collect_files "$TARGET_ROOT/.cursor" |
    awk -F "$SEP" -v skip="$(basename "$EXCLUDE_FILE")" '$1 != skip' >"$target_file"
  process_domain "$filtered" "$target_file" "$TARGET_ROOT/.cursor" \
    "$OVERLAY_ROOT" ".cursor/" 0
  rm -f "$forward_file" "$target_file" "$filtered"
}

sync_devnotes_domain() {
  if [[ -e "$DEVNOTES_DEST" && ! -L "$DEVNOTES_DEST" && ! -d "$DEVNOTES_DEST" ]]; then
    CONFLICTS+=(".dev-notes (exists but is not a directory; resolve manually)")
    return
  fi
  if [[ -L "$DEVNOTES_DEST" ]]; then
    migrate_legacy_devnotes_symlink || return
  fi
  mkdir -p "$DEVNOTES_DEST"
  local forward_file target_file filtered
  forward_file="$(mktemp)"
  target_file="$(mktemp)"
  filtered="$(mktemp)"
  collect_devnotes_files "$LIVE_NOTES" >"$forward_file"
  filter_forward_ignored <"$forward_file" >"$filtered"
  collect_devnotes_files "$DEVNOTES_DEST" >"$target_file"
  process_domain "$filtered" "$target_file" "$DEVNOTES_DEST" \
    "$LIVE_NOTES" ".dev-notes/" 1 "artifacts/live-notes/${PROJECT}/dev-notes/"
  rm -f "$forward_file" "$target_file" "$filtered"
}

filter_guides_nested_policy() {
  local root="$1" infile="$2"
  local outfile rel abs guide_abs nested mod_owner reg_proj
  root="$(cd -P "$root" && pwd)"
  outfile="$(mktemp)"
  while IFS="$SEP" read -r rel abs; do
    [[ -n "$rel" ]] || continue
    nested="$(nested_git_root_for_target_guide "$root" "$rel" 2>/dev/null)" || nested=""
    if [[ -z "$nested" ]]; then
      if [[ -n "$abs" ]]; then
        printf '%s%s%s\n' "$rel" "$SEP" "$abs"
      else
        printf '%s%s%s\n' "$rel" "$SEP" ""
      fi
      continue
    fi
    nested="$(cd -P "$nested" && pwd)"
    if [[ "$IGNORE_SUBMODULES" -eq 1 ]]; then
      echo "note: --ignore-submodules — skip $rel" >&2
      continue
    fi
    mod_owner="$(lookup_project_module_owner "$nested" 2>/dev/null)" || mod_owner=""
    if [[ -n "$mod_owner" && "$mod_owner" == "$PROJECT" ]]; then
      if [[ -n "$abs" ]]; then
        printf '%s%s%s\n' "$rel" "$SEP" "$abs"
      else
        printf '%s%s%s\n' "$rel" "$SEP" ""
      fi
      continue
    fi
    reg_proj="$(lookup_project_for_abs_path "$nested" 2>/dev/null)" || reg_proj=""
    if [[ -n "$reg_proj" ]]; then
      continue
    fi
    echo "note: skip unmapped nested guide path $rel (resolve via prompt on next interactive sync)" >&2
  done <"$infile" >"$outfile"
  mv "$outfile" "$infile"
}

sync_guides_domain_core() {
  mkdir -p "$LIVE_GUIDES"
  local forward_file target_file filtered
  forward_file="$(mktemp)"
  target_file="$(mktemp)"
  filtered="$(mktemp)"
  collect_live_guides_forward "$LIVE_GUIDES" >"$forward_file"
  filter_forward_ignored <"$forward_file" >"$filtered"
  collect_project_guides_files_filtered "$TARGET_ROOT" >"$target_file"
  filter_guides_nested_policy "$TARGET_ROOT" "$filtered"
  filter_guides_nested_policy "$TARGET_ROOT" "$target_file"
  process_domain "$filtered" "$target_file" "$TARGET_ROOT" \
    "$LIVE_GUIDES" "" 1 "artifacts/live-notes/${PROJECT}/dev-notes/dev-guides/"
  rm -f "$forward_file" "$target_file" "$filtered"
}

sync_guides_domain_at() {
  local project="$1" target="$2"
  local save_project="$PROJECT" save_target="$TARGET_ROOT"
  local save_live="$LIVE_NOTES" save_guides="$LIVE_GUIDES"
  local save_devnotes="$DEVNOTES_DEST" save_overlay="$OVERLAY_ROOT"
  local save_exclude="$EXCLUDE_FILE"

  PROJECT="$project"
  TARGET_ROOT="$target"
  LIVE_NOTES="$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT/dev-notes"
  LIVE_GUIDES="$LIVE_NOTES/dev-guides"
  load_ignores_for_project "$PROJECT"
  ensure_project_known "$PROJECT"
  scaffold_live_notes_if_needed
  compute_git_tracked
  sync_guides_domain_core

  PROJECT="$save_project"
  TARGET_ROOT="$save_target"
  LIVE_NOTES="$save_live"
  LIVE_GUIDES="$save_guides"
  DEVNOTES_DEST="$save_devnotes"
  OVERLAY_ROOT="$save_overlay"
  EXCLUDE_FILE="$save_exclude"
}

run_queued_nested_guide_syncs() {
  local entry proj root
  while [[ ${#NESTED_GUIDE_SYNCS[@]} -gt 0 ]]; do
    entry="${NESTED_GUIDE_SYNCS[0]}"
    NESTED_GUIDE_SYNCS=("${NESTED_GUIDE_SYNCS[@]:1}")
    proj="${entry%%"$SEP"*}"
    root="${entry#*"$SEP"}"
    sync_guides_domain_at "$proj" "$root"
  done
}

sync_guides_domain() {
  NESTED_GUIDE_SYNCS=()
  NESTED_GUIDE_SYNC_SEEN=""
  sync_guides_domain_core
  run_queued_nested_guide_syncs
}

reset_report_arrays() {
  EXCLUDED=()
  EXISTING=()
  REPAIRED=()
  NEW_TO_TARGET=()
  NEW_TO_PLAYBOOK=()
  TARGET_ONLY=()
  CONFLICTS=()
  FAILURES=()
  MANAGED=()
  IGNORED=()
}

print_report() {
  local label="$1"
  echo
  echo "=== sync report: $label ==="
  echo "=== gitignore ==="
  echo "git config --global core.excludesFile '~/.gitignore_global'"
  if [[ ${#MANAGED[@]} -gt 0 ]]; then
    printf '%s\n' "${MANAGED[@]}" | LC_ALL=C sort -u
  fi
  echo "=== end gitignore ==="

  if [[ ${#EXCLUDED[@]} -gt 0 ]]; then
    echo
    echo "=== Git-tracked in target (untouched) ==="
    printf '%s\n' "${EXCLUDED[@]}" | LC_ALL=C sort -u | sed 's/^/  /'
  fi
  if [[ ${#IGNORED[@]} -gt 0 ]]; then
    echo
    echo "=== Ignored (ignoresync) ==="
    printf '%s\n' "${IGNORED[@]}" | LC_ALL=C sort -u | sed 's/^/  /'
  fi
  if [[ ${#TARGET_ONLY[@]} -gt 0 ]]; then
    echo
    echo "=== Target-only .cursor (not pulled) ==="
    printf '%s\n' "${TARGET_ONLY[@]}" | LC_ALL=C sort -u | sed 's/^/  /'
  fi
  if [[ ${#REPAIRED[@]} -gt 0 ]]; then
    echo
    echo "=== Re-linked (inode repair / playbook wins) ==="
    printf '%s\n' "${REPAIRED[@]}" | LC_ALL=C sort -u | sed 's/^/  /'
  fi
  if [[ ${#NEW_TO_TARGET[@]} -gt 0 ]]; then
    echo
    echo "=== Newly linked: playbook -> target ==="
    printf '%s\n' "${NEW_TO_TARGET[@]}" | LC_ALL=C sort -u | sed 's/^/  /'
  fi
  if [[ ${#NEW_TO_PLAYBOOK[@]} -gt 0 ]]; then
    echo
    echo "=== Newly linked: target -> playbook ==="
    printf '%s\n' "${NEW_TO_PLAYBOOK[@]}" | LC_ALL=C sort -u | sed 's/^/  /'
  fi
  echo
  echo "sync: existing=${#EXISTING[@]} repaired=${#REPAIRED[@]} new_to_target=${#NEW_TO_TARGET[@]} new_to_playbook=${#NEW_TO_PLAYBOOK[@]} excluded=${#EXCLUDED[@]} ignored=${#IGNORED[@]} target_only=${#TARGET_ONLY[@]}"
}

sync_one_target() {
  local project="$1" target="$2"
  PROJECT="$project"
  TARGET_ROOT="$target"
  LIVE_NOTES="$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT/dev-notes"
  LIVE_GUIDES="$LIVE_NOTES/dev-guides"
  OVERLAY_ROOT="$PLAYBOOK_ROOT/${PROJECT}.cursor"
  SHARED_CURSOR="$PLAYBOOK_ROOT/.cursor"
  DEVNOTES_DEST="$TARGET_ROOT/.dev-notes"

  reset_report_arrays
  load_ignores_for_project "$PROJECT"
  ensure_project_known "$PROJECT"
  scaffold_live_notes_if_needed
  compute_git_tracked

  sync_cursor_domain
  sync_devnotes_domain
  warn_legacy_devnotes_devguides
  sync_guides_domain

  print_report "$PROJECT @ $TARGET_ROOT"

  local exit_code=0
  if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
    echo
    echo "=== Conflicts (skipped; re-run with --force to apply playbook) ==="
    printf '  %s\n' "${CONFLICTS[@]}"
    exit_code=1
  fi
  if [[ ${#FAILURES[@]} -gt 0 ]]; then
    echo
    echo "=== Failures ==="
    printf '  %s\n' "${FAILURES[@]}"
    exit_code=1
  fi
  return "$exit_code"
}

register_machine_path() {
  local project="$1" path="$2"
  local line="${project}:${path}"
  touch "$MACHINE_DIR/projects.txt"
  if grep -qxF "$line" "$MACHINE_DIR/projects.txt" 2>/dev/null; then
    return 0
  fi
  if [[ "$YES" -eq 1 ]]; then
    echo "$line" >>"$MACHINE_DIR/projects.txt"
    echo "note: registered $line in machines/${MACHINE_ID}/projects.txt"
    return 0
  fi
  printf "Register %s in machines/%s/projects.txt? [y/N] " "$line" "$MACHINE_ID"
  local ans
  read_tty ans
  case "$ans" in
    y|Y|yes|YES)
      echo "$line" >>"$MACHINE_DIR/projects.txt"
      echo "note: registered $line"
      ;;
  esac
}

rewrite_machine_projects_line() {
  local old_line="$1" new_line="$2"
  local tmp
  tmp="$(mktemp)"
  awk -v o="$old_line" -v n="$new_line" 'BEGIN{done=0} $0==o && !done { print n; done=1; next } { print }' \
    "$MACHINE_DIR/projects.txt" >"$tmp"
  mv "$tmp" "$MACHINE_DIR/projects.txt"
}

delete_machine_projects_line() {
  local old_line="$1"
  local tmp
  tmp="$(mktemp)"
  awk -v o="$old_line" '$0!=o' "$MACHINE_DIR/projects.txt" >"$tmp"
  mv "$tmp" "$MACHINE_DIR/projects.txt"
}

handle_missing_path() {
  local project="$1" path="$2" line="$3"
  echo "warning: path missing or not a git root for $project: $path" >&2
  if [[ "$YES" -eq 1 ]]; then
    echo "note: --yes ⇒ skip $line" >&2
    return 1
  fi
  printf "update / skip / delete [u/s/d]? " >&2
  local ans newp
  read_tty ans
  case "$ans" in
    u|U)
      printf "New absolute path: " >&2
      read_tty newp
      rewrite_machine_projects_line "$line" "${project}:${newp}"
      if [[ -d "$newp/.git" ]]; then
        echo "$newp"
        return 0
      fi
      echo "warning: new path still invalid — skip" >&2
      return 1
      ;;
    d|D)
      delete_machine_projects_line "$line"
      echo "note: deleted $line" >&2
      return 1
      ;;
    *)
      echo "note: skip $line" >&2
      return 1
      ;;
  esac
}

# --- syncmap ---

sync_one_map_file() {
  local src="$1" dest="$2" label="$3"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -f "$dest" ]]; then
      resolve_both_sides "$src" "$dest" "$label"
    else
      FAILURES+=("$label (dest exists and is not a regular file)")
    fi
  else
    local err
    err="$(hardlink_to "$src" "$dest")" && {
      NEW_TO_TARGET+=("$label")
      MANAGED+=("$label")
    } || FAILURES+=("$label ($err)")
  fi
}

process_syncmap() {
  reset_report_arrays
  local map="$MACHINE_DIR/syncmap.txt"
  [[ -f "$map" ]] || { echo "note: no syncmap at $map"; return 0; }
  local line src dest src_abs f rel dest_f
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    src="${line%%:*}"
    dest="${line#*:}"
    if [[ "$src" == "$line" || -z "$src" || -z "$dest" ]]; then
      echo "warning: bad syncmap line (want playbook-rel:/abs/dest): $line" >&2
      continue
    fi
    src_abs="$PLAYBOOK_ROOT/$src"
    if [[ ! -e "$src_abs" ]]; then
      echo "warning: syncmap source missing — skip: $src" >&2
      continue
    fi
    if [[ -f "$src_abs" ]]; then
      sync_one_map_file "$src_abs" "$dest" "$src=>$dest"
    elif [[ -d "$src_abs" ]]; then
      while IFS= read -r -d '' f; do
        rel="$(rel_under "$src_abs" "$f")"
        dest_f="$dest/$rel"
        sync_one_map_file "$f" "$dest_f" "$src/$rel=>$dest_f"
      done < <(find -P "$src_abs" -type f -print0)
    else
      echo "warning: syncmap source not file/dir — skip: $src" >&2
    fi
  done <"$map"
  print_report "syncmap @ $MACHINE_ID"
  local exit_code=0
  [[ ${#CONFLICTS[@]} -eq 0 ]] || exit_code=1
  [[ ${#FAILURES[@]} -eq 0 ]] || exit_code=1
  return "$exit_code"
}

# --- main ---

CWD="$(pwd -P 2>/dev/null || pwd)"
OVERALL_EXIT=0

# Playbook cwd: same sync script path as this process (handles path aliasing).
is_playbook_cwd() {
  [[ -f "$CWD/scripts/sync-playbook.sh" ]] && same_file "$CWD/scripts/sync-playbook.sh" "$SCRIPT_DIR/sync-playbook.sh"
}

if [[ "$MACHINE_MODE" -eq 1 ]]; then
  resolve_machine
  process_syncmap || OVERALL_EXIT=$?
  exit "$OVERALL_EXIT"
fi

if is_playbook_cwd; then
  resolve_machine
  local_lines=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    local_proj="${line%%:*}"
    local_path="${line#*:}"
    if [[ "$local_proj" == "$line" || -z "$local_proj" || -z "$local_path" ]]; then
      echo "warning: bad projects.txt line (want project:/abs/path): $line" >&2
      continue
    fi
    if [[ -n "$PROJECT" && "$local_proj" != "$PROJECT" ]]; then
      continue
    fi
    local_lines=1
    if [[ ! -d "$local_path/.git" ]]; then
      new_path=""
      if new_path="$(handle_missing_path "$local_proj" "$local_path" "$line")"; then
        local_path="$new_path"
      else
        continue
      fi
    fi
    sync_one_target "$local_proj" "$local_path" || OVERALL_EXIT=$?
  done <"$MACHINE_DIR/projects.txt"
  if [[ "$local_lines" -eq 0 ]]; then
    if [[ -n "$PROJECT" ]]; then
      echo "error: no paths for project '$PROJECT' on machine '$MACHINE_ID'" >&2
      exit 1
    fi
    echo "note: no project paths in machines/${MACHINE_ID}/projects.txt — nothing to sync"
  fi
  exit "$OVERALL_EXIT"
fi

# Target-cwd mode
if [[ -z "$PROJECT" ]]; then
  echo "error: --project is required when run from a target repo" >&2
  usage >&2
  exit 2
fi
if [[ ! -d "$CWD/.git" ]]; then
  echo "error: current directory is not a git repo root (missing .git/): $CWD" >&2
  exit 1
fi

resolve_machine
load_ignores_for_project "$PROJECT"
register_machine_path "$PROJECT" "$CWD"
sync_one_target "$PROJECT" "$CWD" || OVERALL_EXIT=$?
exit "$OVERALL_EXIT"
