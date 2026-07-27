#!/usr/bin/env bash
# Sync ai-playbook into the current target git repo (run from target root).
# Safe to re-run: paths already hard-linked to the final source (overlay wins
# over shared) and a correct .dev-notes symlink are no-ops.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: sync-playbook.sh --project <name> [--overwrite] [--yes]

Run from the target git repo root (directory must contain .git/).

  --project <name>   Project key (live-notes + optional top-level <name>.cursor)
  --overwrite        Replace conflicting pre-existing paths
  --yes              Auto-confirm (append unknown project to projects.txt)
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLAYBOOK_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PROJECT=""
OVERWRITE=0
YES=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { echo "error: --project requires a name" >&2; exit 2; }
      PROJECT="$2"
      shift 2
      ;;
    --overwrite) OVERWRITE=1; shift ;;
    --yes) YES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$PROJECT" ]]; then
  echo "error: --project is required" >&2
  usage >&2
  exit 2
fi

TARGET_ROOT="$(pwd)"
if [[ ! -d "$TARGET_ROOT/.git" ]]; then
  echo "error: current directory is not a git repo root (missing .git/): $TARGET_ROOT" >&2
  exit 1
fi

PROJECTS_FILE="$PLAYBOOK_ROOT/projects.txt"
MANIFEST="$TARGET_ROOT/.cursor/.sync-playbook-manifest"
STRUCTURE="$PLAYBOOK_ROOT/artifacts/dev-notes-structure"
LIVE_NOTES="$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT/dev-notes"
OVERLAY_ROOT="$PLAYBOOK_ROOT/${PROJECT}.cursor"
SHARED_CURSOR="$PLAYBOOK_ROOT/.cursor"

CONFLICTS=()
FAILURES=()
LINKED=()

file_id() {
  # device:inode — macOS/BSD stat
  stat -f '%d:%i' "$1" 2>/dev/null
}

same_file() {
  [[ -f "$1" && -f "$2" ]] || return 1
  local a b
  a="$(file_id "$1")"
  b="$(file_id "$2")"
  [[ -n "$a" && "$a" == "$b" ]]
}

rel_under() {
  local root="${1%/}" abs="$2"
  echo "${abs#"$root"/}"
}

# Print "relpath<TAB>abspath" for regular files under root (no symlink follow).
collect_files() {
  local src_root="$1"
  [[ -d "$src_root" ]] || return 0
  find -P "$src_root" -type f -print0 |
    while IFS= read -r -d '' f; do
      printf '%s\t%s\n' "$(rel_under "$src_root" "$f")" "$f"
    done
}

ensure_project_known() {
  touch "$PROJECTS_FILE"
  if grep -qxF "$PROJECT" "$PROJECTS_FILE" 2>/dev/null; then
    return 0
  fi
  if [[ "$YES" -eq 1 ]]; then
    echo "$PROJECT" >>"$PROJECTS_FILE"
    echo "note: appended '$PROJECT' to projects.txt"
    return 0
  fi
  printf "Project '%s' is not in projects.txt. Add it? [y/N] " "$PROJECT"
  local ans
  read -r ans
  case "$ans" in
    y|Y|yes|YES)
      echo "$PROJECT" >>"$PROJECTS_FILE"
      echo "note: appended '$PROJECT' to projects.txt"
      ;;
    *)
      echo "error: aborted (project not registered)" >&2
      exit 1
      ;;
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

# Plan file: dest_relpath<TAB>source_abs (last line wins → overlay overrides shared)
build_plan_file() {
  local out="$1"
  : >"$out"

  local rel src
  while IFS=$'\t' read -r rel src; do
    [[ -n "$rel" ]] || continue
    printf 'skills/%s\t%s\n' "$rel" "$src"
  done < <(collect_files "$SHARED_CURSOR/skills") >>"$out"

  while IFS=$'\t' read -r rel src; do
    [[ -n "$rel" ]] || continue
    printf 'rules/%s\t%s\n' "$rel" "$src"
  done < <(collect_files "$SHARED_CURSOR/rules") >>"$out"

  if [[ -d "$OVERLAY_ROOT" ]]; then
    while IFS=$'\t' read -r rel src; do
      [[ -n "$rel" ]] || continue
      printf '%s\t%s\n' "$rel" "$src"
    done < <(collect_files "$OVERLAY_ROOT") >>"$out"
  else
    echo "warning: no overlay at ${PROJECT}.cursor (shared only)"
  fi

  local merged
  merged="$(mktemp)"
  awk -F '\t' 'NF >= 2 { last[$1] = $0 } END { for (k in last) print last[k] }' "$out" >"$merged"
  mv "$merged" "$out"
}

install_hardlink() {
  local dest_rel="$1" src="$2"
  local dest="$TARGET_ROOT/.cursor/$dest_rel"

  if [[ ! -f "$src" ]]; then
    FAILURES+=("$dest_rel (missing source)")
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -f "$dest" ]] && same_file "$dest" "$src"; then
      LINKED+=("$dest_rel")
      return 0
    fi
    if [[ "$OVERWRITE" -eq 1 ]]; then
      rm -rf "$dest"
    else
      CONFLICTS+=("$dest_rel")
      return 0
    fi
  fi

  local err
  err="$(mktemp)"
  if ln "$src" "$dest" 2>"$err"; then
    LINKED+=("$dest_rel")
  else
    FAILURES+=("$dest_rel ($(tr '\n' ' ' <"$err"))")
  fi
  rm -f "$err"
}

install_dev_notes_symlink() {
  local dest="$TARGET_ROOT/.dev-notes"
  local abs_live
  abs_live="$(cd "$LIVE_NOTES" && pwd)"

  if [[ -L "$dest" ]]; then
    local cur
    cur="$(readlink "$dest")"
    if [[ "$cur" == "$abs_live" ]]; then
      LINKED+=(".dev-notes")
      return 0
    fi
    if [[ "$OVERWRITE" -eq 1 ]]; then
      rm -f "$dest"
    else
      CONFLICTS+=(".dev-notes")
      return 0
    fi
  elif [[ -e "$dest" ]]; then
    if [[ "$OVERWRITE" -eq 1 ]]; then
      rm -rf "$dest"
    else
      CONFLICTS+=(".dev-notes")
      return 0
    fi
  fi

  local err
  err="$(mktemp)"
  if ln -s "$abs_live" "$dest" 2>"$err"; then
    LINKED+=(".dev-notes")
  else
    FAILURES+=(".dev-notes ($(tr '\n' ' ' <"$err"))")
  fi
  rm -f "$err"
}

path_exists_in_target() {
  local p="$1"
  if [[ "$p" == ".dev-notes" ]]; then
    [[ -e "$TARGET_ROOT/.dev-notes" || -L "$TARGET_ROOT/.dev-notes" ]]
  else
    [[ -e "$TARGET_ROOT/.cursor/$p" || -L "$TARGET_ROOT/.cursor/$p" ]]
  fi
}

# Manifest paths use: ".dev-notes" or paths relative to .cursor/
# IGNORE_PATHS holds target-root-relative ignore entries (union, all runs).
IGNORE_PATHS=()

manifest_to_ignore_path() {
  local p="$1"
  if [[ "$p" == ".dev-notes" ]]; then
    echo ".dev-notes"
  else
    echo ".cursor/$p"
  fi
}

write_manifest() {
  mkdir -p "$(dirname "$MANIFEST")"
  local old=""
  if [[ -f "$MANIFEST" ]]; then
    old="$(mktemp)"
    cp "$MANIFEST" "$old"
  fi

  local merged
  merged="$(mktemp)"
  {
    if [[ -n "$old" ]]; then
      cat "$old"
    fi
    if [[ ${#LINKED[@]} -gt 0 ]]; then
      printf '%s\n' "${LINKED[@]}"
    fi
  } | sed '/^$/d' | sort -u >"$merged"
  mv "$merged" "$MANIFEST"

  local linked_set
  linked_set="$(mktemp)"
  if [[ ${#LINKED[@]} -gt 0 ]]; then
    printf '%s\n' "${LINKED[@]}" | sort -u >"$linked_set"
  else
    : >"$linked_set"
  fi

  IGNORE_PATHS=()
  local p
  while IFS= read -r p || [[ -n "${p:-}" ]]; do
    [[ -n "${p:-}" ]] || continue
    IGNORE_PATHS+=("$(manifest_to_ignore_path "$p")")
    if [[ -n "$old" ]] && ! grep -qxF "$p" "$linked_set"; then
      if path_exists_in_target "$p"; then
        echo "warning: stale path (not removed): $p"
      fi
    fi
  done <"$MANIFEST"

  rm -f "$linked_set"
  if [[ -n "$old" ]]; then
    rm -f "$old"
  fi
}

print_gitignore_paths() {
  echo
  echo "=== gitignore ==="
  echo "git config --global core.excludesFile '~/.gitignore_global'"
  if [[ ${#IGNORE_PATHS[@]} -gt 0 ]]; then
    printf '%s\n' "${IGNORE_PATHS[@]}" | sort -u
  fi
  echo "=== end gitignore ==="
}

ensure_project_known
scaffold_live_notes_if_needed

PLAN_FILE="$(mktemp)"
build_plan_file "$PLAN_FILE"

while IFS=$'\t' read -r rel src; do
  [[ -n "${rel:-}" ]] || continue
  install_hardlink "$rel" "$src"
done <"$PLAN_FILE"
rm -f "$PLAN_FILE"

install_dev_notes_symlink
write_manifest
print_gitignore_paths

exit_code=0
if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
  echo
  echo "=== Conflicts (skipped; use --overwrite to replace) ==="
  printf '  %s\n' "${CONFLICTS[@]}"
  exit_code=1
fi
if [[ ${#FAILURES[@]} -gt 0 ]]; then
  echo
  echo "=== Failures ==="
  printf '  %s\n' "${FAILURES[@]}"
  exit_code=1
fi

if [[ "$exit_code" -eq 0 ]]; then
  echo
  echo "sync ok: project=$PROJECT paths=${#LINKED[@]}"
fi
exit "$exit_code"
