#!/usr/bin/env bash
# Smoke-test project-tree dev-guide sync (guides domain + dev-notes exclusion).
set -euo pipefail

PLAYBOOK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="_smoke_guides_$$"
MACHINE="_smoke_guides_machine_$$"
LIVE_NOTES="$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT/dev-notes"
LIVE_GUIDES="$LIVE_NOTES/dev-guides"
WORKDIR="$(mktemp -d)"
TARGET="$WORKDIR/target"
MACHINE_DIR="$PLAYBOOK_ROOT/machines/$MACHINE"
export SYNC_PLAYBOOK_HOSTNAME="$MACHINE"
trap 'rm -rf "$WORKDIR"; rm -rf "$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT"; rm -rf "$MACHINE_DIR"; sed -i "" "/^${PROJECT}$/d" "$PLAYBOOK_ROOT/projects.txt" 2>/dev/null || sed -i "/^${PROJECT}$/d" "$PLAYBOOK_ROOT/projects.txt" 2>/dev/null || true' EXIT

mkdir -p "$MACHINE_DIR"
: >"$MACHINE_DIR/projects.txt"
: >"$MACHINE_DIR/syncmap.txt"
: >"$MACHINE_DIR/ignoresync.txt"

file_id() { stat -f '%d:%i' "$1" 2>/dev/null; }
same_file() {
  [[ -f "$1" && -f "$2" ]] && [[ "$(file_id "$1")" == "$(file_id "$2")" ]]
}

fail() { echo "smoke-test FAIL: $*" >&2; exit 1; }
pass() { echo "smoke-test OK: $*"; }

mkdir -p "$TARGET"
git -C "$TARGET" init -q
git -C "$TARGET" config user.email "smoke@test"
git -C "$TARGET" config user.name "smoke"

mkdir -p "$LIVE_GUIDES/app/pkg" "$LIVE_NOTES/activities"
printf '%s\n' 'hub root guide' >"$LIVE_GUIDES/dev-guide.md"
printf '%s\n' 'hub pkg guide' >"$LIVE_GUIDES/app/pkg/dev-guide.md"
printf '%s\n' 'activities guide' >"$LIVE_NOTES/activities/dev-guide.md"
printf '%s\n' 'definition stub' >"$LIVE_NOTES/definition.md"
printf '%s\n' 'journal stub' >"$LIVE_NOTES/journal.md"

# Legacy layout on target (should warn, not auto-delete).
mkdir -p "$TARGET/.dev-notes/dev-guides/legacy"
printf '%s\n' 'legacy only' >"$TARGET/.dev-notes/dev-guides/legacy/dev-guide.md"

SYNC="$PLAYBOOK_ROOT/scripts/sync-playbook.sh"
log="$WORKDIR/sync1.log"
( cd "$TARGET" && "$SYNC" --project "$PROJECT" --yes ) 2>&1 | tee "$log"
grep -q 'obsolete' "$log" || fail "expected legacy .dev-notes/dev-guides warning"

[[ -f "$TARGET/dev-guide.md" ]] || fail "missing repo-root dev-guide.md"
[[ -f "$TARGET/app/pkg/dev-guide.md" ]] || fail "missing app/pkg/dev-guide.md"
[[ -f "$TARGET/.dev-notes/activities/dev-guide.md" ]] || fail "missing activities guide"
same_file "$TARGET/dev-guide.md" "$LIVE_GUIDES/dev-guide.md" || fail "root guide not hard-linked to hub"
same_file "$TARGET/app/pkg/dev-guide.md" "$LIVE_GUIDES/app/pkg/dev-guide.md" || \
  fail "pkg guide not hard-linked to hub"
same_file "$TARGET/.dev-notes/activities/dev-guide.md" "$LIVE_NOTES/activities/dev-guide.md" || \
  fail "activities guide not hard-linked via dev-notes domain"

# Hub dev-guides/ must not be mirrored into target .dev-notes/.
if [[ -f "$TARGET/.dev-notes/dev-guides/dev-guide.md" ]]; then
  fail "hub dev-guides mirrored into target .dev-notes"
fi

# User workflow: delete in-tree guide, re-sync from hub.
rm -f "$TARGET/app/pkg/dev-guide.md"
log2="$WORKDIR/sync2.log"
( cd "$TARGET" && "$SYNC" --project "$PROJECT" --yes ) 2>&1 | tee "$log2"
[[ -f "$TARGET/app/pkg/dev-guide.md" ]] || fail "pkg guide not restored after delete + sync"
[[ "$(cat "$TARGET/app/pkg/dev-guide.md")" == "hub pkg guide" ]] || fail "pkg guide content wrong after re-sync"

pass "guides domain, dev-notes exclusion, delete+sync restore"
