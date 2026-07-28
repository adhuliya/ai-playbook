#!/usr/bin/env bash
# Two-way sync between ai-playbook and a target git repo (run from target root).
# No symlinks: every path is a real directory with hardlinked files.
#
#   - .cursor/  : fully bidirectional, merging the playbook's whole shared
#     .cursor/ tree and the project's <project>.cursor overlay (overlay wins
#     on overlap) against the target's whole .cursor/ tree. Anything found
#     only in the target is pulled back into the project's overlay.
#   - .dev-notes: fully bidirectional against
#     artifacts/live-notes/<project>/dev-notes in the playbook.
#
# Paths already hard-linked to the correct counterpart are no-ops, so this is
# safe to re-run. Paths that exist on both sides with *different* content are
# reported as conflicts and never auto-resolved.
#
# Paths already committed to the target repo's own git history are excluded
# from sync entirely (a `git checkout` in the target repo can rewrite such a
# file's content in place, which would corrupt the playbook's copy through
# the shared inode). The excluded set is written to
# .cursor/.sync-playbook-excluded on every run.
set -euo pipefail

# Field separator for internal rel<SEP>path records. NOT a tab: bash treats
# tab as "IFS whitespace" and collapses consecutive tabs when splitting with
# `read`, silently eating empty fields (e.g. a missing side of a join). Unit
# Separator (0x1f) is a normal (non-whitespace) IFS char so empty fields are
# preserved, and it can't appear in a real file path.
SEP=$'\x1f'

usage() {
  cat <<'EOF'
Usage: sync-playbook.sh --project <name> [--yes]

Run from the target git repo root (directory must contain .git/).

  --project <name>   Project key (live-notes + optional top-level <name>.cursor)
  --yes              Auto-confirm prompts (register unknown project, unlink
                      paths that became git-tracked while still hardlinked)
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLAYBOOK_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PROJECT=""
YES=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { echo "error: --project requires a name" >&2; exit 2; }
      PROJECT="$2"
      shift 2
      ;;
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
STRUCTURE="$PLAYBOOK_ROOT/artifacts/dev-notes-structure"
LIVE_NOTES="$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT/dev-notes"
OVERLAY_ROOT="$PLAYBOOK_ROOT/${PROJECT}.cursor"
SHARED_CURSOR="$PLAYBOOK_ROOT/.cursor"
DEVNOTES_DEST="$TARGET_ROOT/.dev-notes"
EXCLUDE_FILE="$TARGET_ROOT/.cursor/.sync-playbook-excluded"

EXCLUDED=()
EXISTING=()
NEW_TO_TARGET=()
NEW_TO_PLAYBOOK=()
CONFLICTS=()
FAILURES=()
MANAGED=()

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

# Print "relpath<SEP>abspath" for regular files under root (no symlink follow).
collect_files() {
  local src_root="$1"
  [[ -d "$src_root" ]] || return 0
  find -P "$src_root" -type f -print0 |
    while IFS= read -r -d '' f; do
      printf '%s%s%s\n' "$(rel_under "$src_root" "$f")" "$SEP" "$f"
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

# Paths committed to the target repo's own git history are off-limits: a
# `git checkout` there can rewrite the file's content in place and corrupt
# the playbook's copy through the shared inode.
compute_exclusions() {
  mkdir -p "$TARGET_ROOT/.cursor"
  if git -C "$TARGET_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
    git -C "$TARGET_ROOT" ls-files -- .cursor .dev-notes 2>/dev/null | LC_ALL=C sort -u >"$EXCLUDE_FILE"
  else
    : >"$EXCLUDE_FILE"
  fi
}

is_excluded() {
  local rel="$1"
  [[ -f "$EXCLUDE_FILE" ]] || return 1
  grep -qxF "$rel" "$EXCLUDE_FILE"
}

# A path that's excluded (now git-tracked in target) may still be hardlinked
# to a playbook source from a previous run. Since checkout could corrupt the
# shared inode, offer to break the hardlink (keep content, new inode).
handle_excluded_but_linked() {
  local rel_full="$1" dest="$2" candidate_src="$3"
  [[ -e "$dest" ]] || return 0
  [[ -n "$candidate_src" && -f "$candidate_src" ]] || return 0
  same_file "$dest" "$candidate_src" || return 0

  echo "warning: $rel_full is git-tracked in target but still hardlinked to $candidate_src" >&2
  local ans
  if [[ "$YES" -eq 1 ]]; then
    ans=y
  else
    printf "Unlink now to make it independent? [y/N] (N aborts sync) " >&2
    read -r ans
  fi
  case "$ans" in
    y|Y|yes|YES)
      local tmp
      tmp="$(mktemp)"
      cp "$dest" "$tmp"
      rm -f "$dest"
      mv "$tmp" "$dest"
      echo "note: unlinked $rel_full (now an independent copy)"
      ;;
    *)
      echo "error: aborting sync — resolve $rel_full manually (git-tracked but still hardlinked)" >&2
      exit 1
      ;;
  esac
}

# Forward plan (playbook -> target) for the .cursor domain: the playbook's
# whole shared .cursor/ tree, plus the whole project overlay tree, mapped
# 1:1 onto the target's .cursor/ tree.
# Format: dest_relpath<SEP>source_abs (last line wins -> overlay overrides shared)
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

# Bidirectional reconciliation for one domain. Any path present on only one
# side gets hardlinked to the other (push if playbook-only, pull back if
# target-only); paths on neither/both sides are handled via the branches
# below (no-op, or conflict if content differs).
#   forward_file : dest_relpath<SEP>source_abs  (playbook-side files)
#   target_file  : dest_relpath<SEP>abspath      (target-side files)
#   dest_root    : where forward pushes land (under target)
#   pull_root    : where target-only files get pulled back to (in playbook)
#   report_prefix: prefix for reporting/exclusion lookups (".cursor/" | ".dev-notes/")
process_domain() {
  local forward_file="$1" target_file="$2" dest_root="$3" pull_root="$4"
  local report_prefix="$5"

  local sf tf
  sf="$(mktemp)"
  tf="$(mktemp)"
  LC_ALL=C sort -t "$SEP" -k1,1 "$forward_file" >"$sf"
  LC_ALL=C sort -t "$SEP" -k1,1 "$target_file" >"$tf"

  local rel src tgt rel_full dest err
  while IFS="$SEP" read -r rel src tgt; do
    [[ -n "$rel" ]] || continue
    rel_full="${report_prefix}${rel}"
    dest="$dest_root/$rel"

    if is_excluded "$rel_full"; then
      EXCLUDED+=("$rel_full")
      handle_excluded_but_linked "$rel_full" "$dest" "$src"
      continue
    fi

    if [[ -n "$src" && -n "$tgt" ]]; then
      if same_file "$dest" "$src"; then
        EXISTING+=("$rel_full")
        MANAGED+=("$rel_full")
      else
        CONFLICTS+=("$rel_full")
      fi
    elif [[ -n "$src" && -z "$tgt" ]]; then
      mkdir -p "$(dirname "$dest")"
      err="$(mktemp)"
      if ln "$src" "$dest" 2>"$err"; then
        NEW_TO_TARGET+=("$rel_full")
        MANAGED+=("$rel_full")
      else
        FAILURES+=("$rel_full ($(tr '\n' ' ' <"$err"))")
      fi
      rm -f "$err"
    elif [[ -z "$src" && -n "$tgt" ]]; then
      local pull_dest="$pull_root/$rel"
      mkdir -p "$(dirname "$pull_dest")"
      err="$(mktemp)"
      if ln "$tgt" "$pull_dest" 2>"$err"; then
        NEW_TO_PLAYBOOK+=("$rel_full")
        MANAGED+=("$rel_full")
      else
        FAILURES+=("$rel_full ($(tr '\n' ' ' <"$err"))")
      fi
      rm -f "$err"
    fi
  done < <(join -t "$SEP" -a1 -a2 -e '' -o 0,1.2,2.2 "$sf" "$tf")

  rm -f "$sf" "$tf"
}

sync_cursor_domain() {
  mkdir -p "$TARGET_ROOT/.cursor"
  local forward_file target_file
  forward_file="$(mktemp)"
  target_file="$(mktemp)"
  build_cursor_forward_file "$forward_file"
  # Exclude the sync bookkeeping file itself: it's a run artifact, not
  # project content, and must never be pulled back into the playbook.
  collect_files "$TARGET_ROOT/.cursor" | awk -F "$SEP" -v skip="$(basename "$EXCLUDE_FILE")" '$1 != skip' >"$target_file"

  process_domain "$forward_file" "$target_file" "$TARGET_ROOT/.cursor" \
    "$OVERLAY_ROOT" ".cursor/"

  rm -f "$forward_file" "$target_file"
}

# If a legacy symlink (from the old symlink-based sync) points at the
# expected live-notes dir, migrate it to a real directory automatically.
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

sync_devnotes_domain() {
  if [[ -e "$DEVNOTES_DEST" && ! -L "$DEVNOTES_DEST" && ! -d "$DEVNOTES_DEST" ]]; then
    CONFLICTS+=(".dev-notes (exists but is not a directory; resolve manually)")
    return
  fi
  if [[ -L "$DEVNOTES_DEST" ]]; then
    migrate_legacy_devnotes_symlink || return
  fi
  mkdir -p "$DEVNOTES_DEST"

  local forward_file target_file
  forward_file="$(mktemp)"
  target_file="$(mktemp)"
  collect_files "$LIVE_NOTES" >"$forward_file"
  collect_files "$DEVNOTES_DEST" >"$target_file"

  process_domain "$forward_file" "$target_file" "$DEVNOTES_DEST" \
    "$LIVE_NOTES" ".dev-notes/"

  rm -f "$forward_file" "$target_file"
}

print_report() {
  echo
  echo "=== gitignore ==="
  echo "git config --global core.excludesFile '~/.gitignore_global'"
  if [[ ${#MANAGED[@]} -gt 0 ]]; then
    printf '%s\n' "${MANAGED[@]}" | LC_ALL=C sort -u
  fi
  echo "=== end gitignore ==="

  if [[ ${#EXCLUDED[@]} -gt 0 ]]; then
    echo
    echo "=== Excluded (git-tracked in target; see .cursor/.sync-playbook-excluded) ==="
    printf '%s\n' "${EXCLUDED[@]}" | LC_ALL=C sort -u | sed 's/^/  /'
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
  echo "sync: existing=${#EXISTING[@]} new_to_target=${#NEW_TO_TARGET[@]} new_to_playbook=${#NEW_TO_PLAYBOOK[@]} excluded=${#EXCLUDED[@]}"
}

ensure_project_known
scaffold_live_notes_if_needed
compute_exclusions

sync_cursor_domain
sync_devnotes_domain

print_report

exit_code=0
if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
  echo
  echo "=== Conflicts (present on both sides with different content; resolve manually) ==="
  printf '  %s\n' "${CONFLICTS[@]}"
  exit_code=1
fi
if [[ ${#FAILURES[@]} -gt 0 ]]; then
  echo
  echo "=== Failures ==="
  printf '  %s\n' "${FAILURES[@]}"
  exit_code=1
fi

exit "$exit_code"
