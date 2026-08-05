#!/usr/bin/env bash
# Smoke-test dev-guide sync under nested .git (submodules): inference, project-modules,
# --ignore-submodules, and separate-project hubs.
set -euo pipefail

PLAYBOOK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYNC="$PLAYBOOK_ROOT/scripts/sync-playbook.sh"
PARENT="_smoke_sub_parent_$$"
CHILD="_smoke_sub_child_$$"
MACHINE="_smoke_sub_machine_$$"
WORKDIR="$(mktemp -d)"
TARGET="$WORKDIR/parent"
SUBMOD="$TARGET/vendor/nested"
MACHINE_DIR="$PLAYBOOK_ROOT/machines/$MACHINE"
PARENT_LIVE="$PLAYBOOK_ROOT/artifacts/live-notes/$PARENT/dev-notes"
CHILD_LIVE="$PLAYBOOK_ROOT/artifacts/live-notes/$CHILD/dev-notes"
PARENT_GUIDES="$PARENT_LIVE/dev-guides"
CHILD_GUIDES="$CHILD_LIVE/dev-guides"

cleanup() {
  rm -rf "$WORKDIR"
  rm -rf "$PLAYBOOK_ROOT/artifacts/live-notes/$PARENT"
  rm -rf "$PLAYBOOK_ROOT/artifacts/live-notes/$CHILD"
  rm -rf "$MACHINE_DIR"
  for key in "$PARENT" "$CHILD"; do
    if [[ -f "$PLAYBOOK_ROOT/projects.txt" ]]; then
      sed -i.bak "/^${key}$/d" "$PLAYBOOK_ROOT/projects.txt" 2>/dev/null || \
        sed -i "/^${key}$/d" "$PLAYBOOK_ROOT/projects.txt" 2>/dev/null || true
      rm -f "$PLAYBOOK_ROOT/projects.txt.bak"
    fi
  done
}
trap cleanup EXIT

export SYNC_PLAYBOOK_HOSTNAME="$MACHINE"

file_id() { stat -f '%d:%i' "$1" 2>/dev/null; }
same_file() {
  [[ -f "$1" && -f "$2" ]] && [[ "$(file_id "$1")" == "$(file_id "$2")" ]]
}
fail() { echo "smoke-submodule FAIL: $*" >&2; exit 1; }
pass() { echo "smoke-submodule OK: $*"; }

init_repo() {
  local root="$1"
  git -C "$root" init -q
  git -C "$root" config user.email "smoke@test"
  git -C "$root" config user.name "smoke"
}

mkdir -p "$MACHINE_DIR" "$TARGET/vendor/nested" "$PARENT_GUIDES" "$CHILD_GUIDES" \
  "$PARENT_LIVE/activities" "$CHILD_LIVE/activities"
: >"$MACHINE_DIR/syncmap.txt"
: >"$MACHINE_DIR/ignoresync.txt"
: >"$MACHINE_DIR/project-modules.txt"
: >"$MACHINE_DIR/projects.txt"

printf '%s\n' "$PARENT" "$CHILD" >>"$PLAYBOOK_ROOT/projects.txt"
printf '%s\n' 'parent hub root' >"$PARENT_GUIDES/dev-guide.md"
printf '%s\n' 'child hub root' >"$CHILD_GUIDES/dev-guide.md"
printf '%s\n' 'parent live def' >"$PARENT_LIVE/definition.md"
printf '%s\n' 'child live def' >"$CHILD_LIVE/definition.md"

init_repo "$TARGET"
init_repo "$SUBMOD"

printf '%s\n' 'parent hub root' >"$TARGET/dev-guide.md"
mkdir -p "$SUBMOD/pkg"
printf '%s\n' 'nested only local' >"$SUBMOD/dev-guide.md"
printf '%s\n' 'nested pkg guide' >"$SUBMOD/pkg/dev-guide.md"

# --- 1) Unmapped nested: must not land in parent hub ---
echo "${PARENT}:${TARGET}" >"$MACHINE_DIR/projects.txt"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PARENT" --yes --force ) >/dev/null
[[ -f "$TARGET/dev-guide.md" ]] || fail "parent root guide missing after sync"
if [[ -f "$PARENT_GUIDES/vendor/nested/dev-guide.md" ]]; then
  fail "unmapped nested guide mirrored into parent hub"
fi
if same_file "$SUBMOD/dev-guide.md" "$PARENT_GUIDES/vendor/nested/dev-guide.md" 2>/dev/null; then
  fail "unmapped nested guide hard-linked into parent hub"
fi
pass "unmapped nested skipped for parent hub"

# --- 2) projects.txt path match: child checkout under parent tree ---
echo "${PARENT}:${TARGET}" >"$MACHINE_DIR/projects.txt"
echo "${CHILD}:${SUBMOD}" >>"$MACHINE_DIR/projects.txt"
rm -f "$SUBMOD/dev-guide.md" "$SUBMOD/pkg/dev-guide.md"
printf '%s\n' 'nested stale' >"$SUBMOD/dev-guide.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PARENT" --yes --force ) >/dev/null
same_file "$SUBMOD/dev-guide.md" "$CHILD_GUIDES/dev-guide.md" || \
  fail "nested root guide not linked to child hub via projects.txt inference"
[[ "$(cat "$SUBMOD/dev-guide.md")" == "child hub root" ]] || \
  fail "nested root guide content not from child hub"
pass "projects.txt path infers separate project hub"

# --- 3) Nested pkg guide syncs relative to nested root in child hub ---
mkdir -p "$CHILD_GUIDES/pkg"
printf '%s\n' 'child pkg hub' >"$CHILD_GUIDES/pkg/dev-guide.md"
rm -f "$SUBMOD/pkg/dev-guide.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PARENT" --yes --force ) >/dev/null
same_file "$SUBMOD/pkg/dev-guide.md" "$CHILD_GUIDES/pkg/dev-guide.md" || \
  fail "nested pkg guide not linked to child hub"
pass "nested subtree guides use child hub paths"

# --- 4) project-modules: nested tree counts as parent project ---
rm -f "$MACHINE_DIR/projects.txt"
echo "${PARENT}:${TARGET}" >"$MACHINE_DIR/projects.txt"
echo "${PARENT}:${SUBMOD}" >"$MACHINE_DIR/project-modules.txt"
mkdir -p "$PARENT_GUIDES/vendor/nested"
printf '%s\n' 'parent module hub nested' >"$PARENT_GUIDES/vendor/nested/dev-guide.md"
rm -f "$SUBMOD/dev-guide.md"
printf '%s\n' 'wrong nested' >"$SUBMOD/dev-guide.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PARENT" --yes --force ) >/dev/null
same_file "$SUBMOD/dev-guide.md" "$PARENT_GUIDES/vendor/nested/dev-guide.md" || \
  fail "project-modules guide not linked to parent hub path"
[[ "$(cat "$SUBMOD/dev-guide.md")" == "parent module hub nested" ]] || \
  fail "project-modules content not from parent hub"
if same_file "$SUBMOD/dev-guide.md" "$CHILD_GUIDES/dev-guide.md" 2>/dev/null; then
  fail "project-modules guide incorrectly linked to child hub"
fi
pass "project-modules same-project layout"

# --- 5) --ignore-submodules skips even when child path registered ---
: >"$MACHINE_DIR/project-modules.txt"
echo "${CHILD}:${SUBMOD}" >>"$MACHINE_DIR/projects.txt"
printf '%s\n' 'ignored nested' >"$SUBMOD/dev-guide.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PARENT" --yes --force --ignore-submodules ) >/dev/null || fail "sync with --ignore-submodules failed"
[[ "$(cat "$SUBMOD/dev-guide.md")" == "ignored nested" ]] || fail "ignore flag mutated nested guide"
if same_file "$SUBMOD/dev-guide.md" "$CHILD_GUIDES/dev-guide.md" 2>/dev/null; then
  fail "--ignore-submodules still linked nested guide to child hub"
fi
pass "--ignore-submodules leaves nested guides untouched"

# --- 6) Target-cwd sync still runs nested inference ---
printf '%s\n' 'child pull test' >"$CHILD_GUIDES/dev-guide.md"
rm -f "$SUBMOD/dev-guide.md"
( cd "$TARGET" && "$SYNC" --project "$PARENT" --yes --force ) >/dev/null || fail "target-cwd parent sync failed"
same_file "$SUBMOD/dev-guide.md" "$CHILD_GUIDES/dev-guide.md" || \
  fail "target-cwd parent sync did not nested-sync child guide"
pass "target-cwd parent project triggers nested child guide sync"

# --- 7) Bidirectional pull from nested target into child hub ---
printf '%s\n' 'edited on nested target' >"$SUBMOD/dev-guide.md"
( cd "$TARGET" && "$SYNC" --project "$PARENT" --yes --force ) >/dev/null
same_file "$SUBMOD/dev-guide.md" "$CHILD_GUIDES/dev-guide.md" || \
  fail "nested target edit not pulled to child hub"
[[ "$(cat "$CHILD_GUIDES/dev-guide.md")" == "edited on nested target" ]] || \
  fail "child hub content not updated from nested target"
pass "bidirectional nested guide pull into child hub"

pass "all submodule guide smoke checks"
