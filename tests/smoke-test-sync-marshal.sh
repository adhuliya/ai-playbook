#!/usr/bin/env bash
# Smoke-test marshal sync: repair, --force, ignores, git-tracked, one-way cursor, syncmap.
set -euo pipefail

PLAYBOOK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYNC="$PLAYBOOK_ROOT/scripts/sync-playbook.sh"
PROJECT="_smoke_marshal_$$"
MACHINE="_smoke_machine_$$"
WORKDIR="$(mktemp -d)"
TARGET="$WORKDIR/target"
HOMEFILES="$WORKDIR/homefiles"
LIVE_NOTES="$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT/dev-notes"
MACHINE_DIR="$PLAYBOOK_ROOT/machines/$MACHINE"
OVERLAY="$PLAYBOOK_ROOT/${PROJECT}.cursor"

cleanup() {
  rm -rf "$WORKDIR"
  rm -rf "$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT"
  rm -rf "$OVERLAY"
  rm -rf "$MACHINE_DIR"
  rm -rf "$PLAYBOOK_ROOT/scripts/_smoke_map_dir" "$PLAYBOOK_ROOT/scripts/_smoke_map_file.txt"
  if [[ -f "$PLAYBOOK_ROOT/projects.txt" ]]; then
    sed -i.bak "/^${PROJECT}$/d" "$PLAYBOOK_ROOT/projects.txt" 2>/dev/null || \
      sed -i "/^${PROJECT}$/d" "$PLAYBOOK_ROOT/projects.txt" 2>/dev/null || true
    rm -f "$PLAYBOOK_ROOT/projects.txt.bak"
  fi
}
trap cleanup EXIT

file_id() { stat -f '%d:%i' "$1" 2>/dev/null; }
same_file() {
  [[ -f "$1" && -f "$2" ]] && [[ "$(file_id "$1")" == "$(file_id "$2")" ]]
}
fail() { echo "smoke-marshal FAIL: $*" >&2; exit 1; }
pass() { echo "smoke-marshal OK: $*"; }

export SYNC_PLAYBOOK_HOSTNAME="$MACHINE"

mkdir -p "$MACHINE_DIR" "$HOMEFILES" "$TARGET" "$OVERLAY/rules" "$LIVE_NOTES/activities" "$LIVE_NOTES/dev-guides"
: >"$MACHINE_DIR/projects.txt"
: >"$MACHINE_DIR/syncmap.txt"
: >"$MACHINE_DIR/ignoresync.txt"

# --- fixture playbook overlay + live notes ---
printf '%s\n' 'overlay rule' >"$OVERLAY/rules/smoke.mdc"
printf '%s\n' 'ignore me' >"$OVERLAY/rules/ignore-me.mdc"
printf '%s\n' 'keep me' >"$OVERLAY/rules/keep-me.mdc"
printf '%s\n' 'live def' >"$LIVE_NOTES/definition.md"
printf '%s\n' 'hub guide' >"$LIVE_NOTES/dev-guides/dev-guide.md"

# project ignore: ignore ignore-me; folder-ignore rules/ with ! keep-me
mkdir -p "$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT"
cat >"$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT/ignoresync.txt" <<EOF
${PROJECT}.cursor/rules/ignore-me.mdc
${PROJECT}.cursor/rules/
!${PROJECT}.cursor/rules/keep-me.mdc
!${PROJECT}.cursor/rules/smoke.mdc
EOF

git -C "$TARGET" init -q
git -C "$TARGET" config user.email "smoke@test"
git -C "$TARGET" config user.name "smoke"

echo "${PROJECT}:${TARGET}" >"$MACHINE_DIR/projects.txt"

# 1) playbook-mode sync
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "initial playbook sync"

same_file "$TARGET/.cursor/rules/smoke.mdc" "$OVERLAY/rules/smoke.mdc" || fail "overlay not hard-linked"
[[ ! -e "$TARGET/.cursor/rules/ignore-me.mdc" ]] || fail "ignored file was synced"
same_file "$TARGET/.cursor/rules/keep-me.mdc" "$OVERLAY/rules/keep-me.mdc" || fail "keep-me not linked"
same_file "$TARGET/dev-guide.md" "$LIVE_NOTES/dev-guides/dev-guide.md" || fail "guide not linked"
pass "playbook sync + ignores"

# 2) .cursor one-way: target-only file not pulled
printf '%s\n' 'target only' >"$TARGET/.cursor/rules/only-in-target.mdc"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "sync after target-only"
[[ ! -e "$OVERLAY/rules/only-in-target.mdc" ]] || fail "target-only .cursor was pulled into overlay"
pass "cursor one-way (no pull)"

# 3) inode repair (same bytes, different inode)
rm -f "$TARGET/.cursor/rules/smoke.mdc"
printf '%s\n' 'overlay rule' >"$TARGET/.cursor/rules/smoke.mdc"
same_file "$TARGET/.cursor/rules/smoke.mdc" "$OVERLAY/rules/smoke.mdc" && fail "expected broken link before repair"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "repair sync"
same_file "$TARGET/.cursor/rules/smoke.mdc" "$OVERLAY/rules/smoke.mdc" || fail "same-bytes repair failed"
pass "inode repair same content"

# 4) content conflict + --force
rm -f "$TARGET/.cursor/rules/smoke.mdc"
printf '%s\n' 'target diverged' >"$TARGET/.cursor/rules/smoke.mdc"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes --force ) || fail "force conflict sync"
same_file "$TARGET/.cursor/rules/smoke.mdc" "$OVERLAY/rules/smoke.mdc" || fail "--force playbook wins failed"
[[ "$(cat "$TARGET/.cursor/rules/smoke.mdc")" == "overlay rule" ]] || fail "force content wrong"
pass "--force playbook wins"

# 5) git-tracked: warn when diverged; silent when already hard-linked to playbook
mkdir -p "$TARGET/.cursor/rules"
printf '%s\n' 'tracked content' >"$TARGET/.cursor/rules/tracked.mdc"
git -C "$TARGET" add -f .cursor/rules/tracked.mdc
git -C "$TARGET" commit -q -m "track cursor file"
# playbook also has a different overlay file with same rel path — should not overwrite tracked
printf '%s\n' 'playbook tracked' >"$OVERLAY/rules/tracked.mdc"
log="$WORKDIR/tracked.log"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes --force ) 2>&1 | tee "$log" || true
grep -q 'git-tracked' "$log" || fail "expected git-tracked warning"
[[ "$(cat "$TARGET/.cursor/rules/tracked.mdc")" == "tracked content" ]] || fail "git-tracked file was modified"
grep -qxF "TGIT_TRACKED: .cursor/rules/tracked.mdc" "$TARGET/.cursor/.sync-playbook-excluded" || \
  fail "expected TGIT_TRACKED line in exclude file"

rm -f "$TARGET/.cursor/rules/linked-tracked.mdc"
printf '%s\n' 'linked tracked' >"$OVERLAY/rules/linked-tracked.mdc"
ln "$OVERLAY/rules/linked-tracked.mdc" "$TARGET/.cursor/rules/linked-tracked.mdc"
git -C "$TARGET" add -f .cursor/rules/linked-tracked.mdc
git -C "$TARGET" commit -q -m "track hard-linked cursor file"
log_linked="$WORKDIR/linked-tracked.log"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) 2>&1 | tee "$log_linked"
grep -E 'warning:.*linked-tracked\.mdc.*git-tracked' "$log_linked" && \
  fail "unexpected git-tracked warning for already-linked file"
same_file "$TARGET/.cursor/rules/linked-tracked.mdc" "$OVERLAY/rules/linked-tracked.mdc" || \
  fail "linked-tracked inode changed"
pass "git-tracked warn and skip"

# 5b) anywhere-dir ignore (__pycache__) + exclude file SYNC_IGNORED dir form
mkdir -p "$OVERLAY/skills/demo/scripts/__pycache__"
printf '%s\n' 'bytecode' >"$OVERLAY/skills/demo/scripts/__pycache__/mod.pyc"
printf '%s\n' 'ok' >"$OVERLAY/skills/demo/scripts/mod.py"
printf '%s\n' 'noise' >"$OVERLAY/skills/demo/scripts/.DS_Store"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "pycache ignore sync"
[[ ! -e "$TARGET/.cursor/skills/demo/scripts/__pycache__" ]] || fail "__pycache__ was synced"
[[ ! -e "$TARGET/.cursor/skills/demo/scripts/.DS_Store" ]] || fail ".DS_Store was synced"
same_file "$TARGET/.cursor/skills/demo/scripts/mod.py" "$OVERLAY/skills/demo/scripts/mod.py" || \
  fail "non-ignored script not linked"
grep -qxF "SYNC_IGNORED: .cursor/skills/demo/scripts/__pycache__/" \
  "$TARGET/.cursor/.sync-playbook-excluded" || fail "expected SYNC_IGNORED __pycache__/ dir line"
grep -qxF "SYNC_IGNORED: .cursor/skills/demo/scripts/.DS_Store" \
  "$TARGET/.cursor/.sync-playbook-excluded" || fail "expected SYNC_IGNORED .DS_Store line"
# exclude file must not dump unrelated git-tracked trees
grep -E '^(TGIT_TRACKED|SYNC_IGNORED): ' "$TARGET/.cursor/.sync-playbook-excluded" >/dev/null
grep -Ev '^(#|TGIT_TRACKED: |SYNC_IGNORED: |$)' "$TARGET/.cursor/.sync-playbook-excluded" && \
  fail "exclude file has unexpected lines"
pass "anywhere ignores + exclude file format"

# 6) bidirectional .dev-notes still pulls
printf '%s\n' 'from target' >"$TARGET/.dev-notes/from-target.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "devnotes pull sync"
same_file "$TARGET/.dev-notes/from-target.md" "$LIVE_NOTES/from-target.md" || fail "dev-notes pull failed"
pass "dev-notes bidirectional pull"

# 7) --machine syncmap file + dir
mkdir -p "$PLAYBOOK_ROOT/scripts/_smoke_map_dir/nest"
printf '%s\n' 'agent map' >"$PLAYBOOK_ROOT/scripts/_smoke_map_file.txt"
printf '%s\n' 'dir a' >"$PLAYBOOK_ROOT/scripts/_smoke_map_dir/a.txt"
printf '%s\n' 'dir b' >"$PLAYBOOK_ROOT/scripts/_smoke_map_dir/nest/b.txt"

cat >"$MACHINE_DIR/syncmap.txt" <<EOF
scripts/_smoke_map_file.txt:${HOMEFILES}/.agent.zshrc
scripts/_smoke_map_dir:${HOMEFILES}/hooks
EOF

( cd "$TARGET" && "$SYNC" --machine --yes --force ) || fail "machine syncmap"
same_file "$HOMEFILES/.agent.zshrc" "$PLAYBOOK_ROOT/scripts/_smoke_map_file.txt" || fail "syncmap file link"
same_file "$HOMEFILES/hooks/a.txt" "$PLAYBOOK_ROOT/scripts/_smoke_map_dir/a.txt" || fail "syncmap dir a"
same_file "$HOMEFILES/hooks/nest/b.txt" "$PLAYBOOK_ROOT/scripts/_smoke_map_dir/nest/b.txt" || fail "syncmap dir nest"
pass "--machine syncmap file+dir"

# 8) target-cwd mode (ignoresync still present)
( cd "$TARGET" && "$SYNC" --project "$PROJECT" --yes ) || fail "target-cwd sync"
[[ ! -e "$TARGET/.cursor/rules/ignore-me.mdc" ]] || fail "ignored file appeared in target-cwd sync"
pass "target-cwd mode"

pass "all marshal cases"
