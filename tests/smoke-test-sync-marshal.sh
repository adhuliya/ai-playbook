#!/usr/bin/env bash
# Smoke-test marshal sync: repair, --force, conflict direction, ignores, git-tracked, one-way cursor, syncmap.
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
OVERLAY_REL="artifacts/live-notes/$PROJECT/.cursor"
OVERLAY="$PLAYBOOK_ROOT/$OVERLAY_REL"
AGENTS_OVERLAY="$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT/.agents"

cleanup() {
  rm -rf "$WORKDIR"
  rm -rf "$PLAYBOOK_ROOT/artifacts/live-notes/$PROJECT"
  rm -rf "$OVERLAY" "$AGENTS_OVERLAY"
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
${OVERLAY_REL}/rules/ignore-me.mdc
${OVERLAY_REL}/rules/
!${OVERLAY_REL}/rules/keep-me.mdc
!${OVERLAY_REL}/rules/smoke.mdc
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
[[ -f "$TARGET/.cursor/rules/only-in-target.mdc" ]] || fail "user-authored target-only file was pruned"
pass "cursor one-way (no pull)"

# 2b) .agents: shared + overlay linked; AGENTS.md pointer created once
same_file "$TARGET/.agents/dev-guide.md" "$PLAYBOOK_ROOT/.agents/dev-guide.md" || fail "shared .agents not linked"
same_file "$TARGET/.claude/agents/spell-check.md" "$PLAYBOOK_ROOT/.claude/agents/spell-check.md" || \
  fail "shared .claude subagent not linked"
same_file "$TARGET/.codex/agents/spell-check.toml" "$PLAYBOOK_ROOT/.codex/agents/spell-check.toml" || \
  fail "shared .codex subagent not linked"
mkdir -p "$AGENTS_OVERLAY/skills/smoke"
printf '%s\n' 'smoke skill' >"$AGENTS_OVERLAY/skills/smoke/SKILL.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail ".agents overlay sync"
same_file "$TARGET/.agents/skills/smoke/SKILL.md" "$AGENTS_OVERLAY/skills/smoke/SKILL.md" || \
  fail ".agents overlay not linked"
[[ "$(grep -cF '.agents/dev-guide.md' "$TARGET/AGENTS.md")" == 1 ]] || fail "AGENTS.md pointer missing or duplicated"
pass ".agents domain + AGENTS.md pointer"

# 2c) existing AGENTS.md / CLAUDE.md get the pointer appended (not with @AGENTS.md import)
printf '%s' '# Own rules' >"$TARGET/AGENTS.md"
printf '%s\n' '# Claude notes' >"$TARGET/CLAUDE.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "pointer append sync"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "pointer idempotent sync"
[[ "$(head -1 "$TARGET/AGENTS.md")" == "# Own rules" ]] || fail "AGENTS.md content lost"
[[ "$(grep -cF '.agents/dev-guide.md' "$TARGET/AGENTS.md")" == 1 ]] || fail "AGENTS.md pointer not appended once"
[[ "$(grep -cF '.agents/dev-guide.md' "$TARGET/CLAUDE.md")" == 1 ]] || fail "CLAUDE.md pointer not appended once"
printf '%s\n' '@AGENTS.md' >"$TARGET/CLAUDE.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "pointer import sync"
grep -qF '.agents/dev-guide.md' "$TARGET/CLAUDE.md" && fail "pointer added to CLAUDE.md that imports AGENTS.md"
pass "pointer append to existing AGENTS.md / CLAUDE.md"

# 2d) legacy pointer line is rewritten in place
printf '%s\n' '# Own rules' 'Read and follow `.agents/dev-guide.md` (always-on rules and skills) before starting any task.' >"$TARGET/AGENTS.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "pointer upgrade sync"
[[ "$(grep -cF '.agents/dev-guide.md' "$TARGET/AGENTS.md")" == 1 ]] || fail "pointer duplicated on upgrade"
grep -qF 'only if it exists' "$TARGET/AGENTS.md" || fail "legacy pointer not rewritten"
[[ "$(head -1 "$TARGET/AGENTS.md")" == "# Own rules" ]] || fail "AGENTS.md content lost on upgrade"
pass "legacy pointer rewritten"

# 2d) prune: playbook moves an asset from .cursor overlay to .agents overlay
mkdir -p "$OVERLAY/skills/moved"
printf '%s\n' 'moving skill' >"$OVERLAY/skills/moved/SKILL.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "pre-move sync"
same_file "$TARGET/.cursor/skills/moved/SKILL.md" "$OVERLAY/skills/moved/SKILL.md" || fail "pre-move link"
mkdir -p "$AGENTS_OVERLAY/skills/moved"
mv "$OVERLAY/skills/moved/SKILL.md" "$AGENTS_OVERLAY/skills/moved/SKILL.md"
rmdir "$OVERLAY/skills/moved" "$OVERLAY/skills"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "post-move sync"
[[ ! -e "$TARGET/.cursor/skills" ]] || fail "stale .cursor/skills copy not pruned"
same_file "$TARGET/.agents/skills/moved/SKILL.md" "$AGENTS_OVERLAY/skills/moved/SKILL.md" || fail "moved skill not linked"
[[ -f "$TARGET/.cursor/rules/only-in-target.mdc" ]] || fail "prune removed user-authored file"
pass "prune stale playbook copies"

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
grep -qxF "TGIT_TRACKED: .cursor/rules/tracked.mdc" "$TARGET/.agents/.sync-playbook-excluded" || \
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
  "$TARGET/.agents/.sync-playbook-excluded" || fail "expected SYNC_IGNORED __pycache__/ dir line"
grep -qxF "SYNC_IGNORED: .cursor/skills/demo/scripts/.DS_Store" \
  "$TARGET/.agents/.sync-playbook-excluded" || fail "expected SYNC_IGNORED .DS_Store line"
# exclude file must not dump unrelated git-tracked trees
grep -E '^(TGIT_TRACKED|SYNC_IGNORED): ' "$TARGET/.agents/.sync-playbook-excluded" >/dev/null
grep -Ev '^(#|TGIT_TRACKED: |SYNC_IGNORED: |$)' "$TARGET/.agents/.sync-playbook-excluded" && \
  fail "exclude file has unexpected lines"
pass "anywhere ignores + exclude file format"

# 6) bidirectional .dev-notes still pulls
printf '%s\n' 'from target' >"$TARGET/.dev-notes/from-target.md"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "devnotes pull sync"
same_file "$TARGET/.dev-notes/from-target.md" "$LIVE_NOTES/from-target.md" || fail "dev-notes pull failed"
pass "dev-notes bidirectional pull"

# 6b) content conflict: target wins (.dev-notes)
rm -f "$TARGET/.dev-notes/definition.md"
printf '%s\n' 'target latest notes' >"$TARGET/.dev-notes/definition.md"
same_file "$TARGET/.dev-notes/definition.md" "$LIVE_NOTES/definition.md" && \
  fail "expected notes conflict before target-wins"
( cd "$PLAYBOOK_ROOT" && SYNC_PLAYBOOK_CONFLICT=t "$SYNC" --project "$PROJECT" --yes ) || \
  fail "target-wins notes sync"
[[ "$(cat "$LIVE_NOTES/definition.md")" == "target latest notes" ]] || fail "playbook notes not replaced"
same_file "$TARGET/.dev-notes/definition.md" "$LIVE_NOTES/definition.md" || \
  fail "notes not hard-linked after target wins"
pass "dev-notes conflict target wins"

# 6c) content conflict: target wins (project dev-guide.md)
rm -f "$TARGET/dev-guide.md"
printf '%s\n' 'target latest guide' >"$TARGET/dev-guide.md"
same_file "$TARGET/dev-guide.md" "$LIVE_NOTES/dev-guides/dev-guide.md" && \
  fail "expected guide conflict before target-wins"
( cd "$PLAYBOOK_ROOT" && SYNC_PLAYBOOK_CONFLICT=t "$SYNC" --project "$PROJECT" --yes ) || \
  fail "target-wins guide sync"
[[ "$(cat "$LIVE_NOTES/dev-guides/dev-guide.md")" == "target latest guide" ]] || \
  fail "playbook guide not replaced"
same_file "$TARGET/dev-guide.md" "$LIVE_NOTES/dev-guides/dev-guide.md" || \
  fail "guide not hard-linked after target wins"
pass "dev-guide.md conflict target wins"

# 6d) content conflict: playbook wins via p (.dev-notes)
rm -f "$TARGET/.dev-notes/definition.md"
printf '%s\n' 'target diverged again' >"$TARGET/.dev-notes/definition.md"
( cd "$PLAYBOOK_ROOT" && SYNC_PLAYBOOK_CONFLICT=p "$SYNC" --project "$PROJECT" --yes ) || \
  fail "playbook-wins notes sync"
[[ "$(cat "$TARGET/.dev-notes/definition.md")" == "target latest notes" ]] || \
  fail "target notes not replaced by playbook"
same_file "$TARGET/.dev-notes/definition.md" "$LIVE_NOTES/definition.md" || \
  fail "notes not hard-linked after playbook wins"
pass "dev-notes conflict playbook wins"

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

# 9) --stats: read-only; tags + inodes for pending work
printf '%s\n' 'stats new' >"$AGENTS_OVERLAY/skills/smoke/NEW.md"
rm -f "$TARGET/.agents/skills/smoke/SKILL.md"
printf '%s\n' 'smoke skill' >"$TARGET/.agents/skills/smoke/SKILL.md"
printf '%s\n' 'stats pull' >"$TARGET/.dev-notes/stats-pull.md"
stats_log="$WORKDIR/stats.log"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --stats --project "$PROJECT" ) >"$stats_log" 2>&1 || fail "--stats run"
grep -Eq '^  > +[0-9]+ +- +\.agents/skills/smoke/NEW\.md' "$stats_log" || fail "stats: new asset not '>'"
grep -Eq '^  ~ +[0-9]+ +[0-9]+ +\.agents/skills/smoke/SKILL\.md' "$stats_log" || fail "stats: relink not '~'"
grep -Eq '^  < +- +[0-9]+ +\.dev-notes/stats-pull\.md' "$stats_log" || fail "stats: pull not '<'"
ino="$(stat -f '%i' "$PLAYBOOK_ROOT/.agents/dev-guide.md")"
grep -Eq "^  = +$ino +$ino +\.agents/dev-guide\.md" "$stats_log" || fail "stats: in-sync inodes not shown"
grep -q '^status: [0-9]* pending' "$stats_log" || fail "stats: missing pending status"
[[ ! -e "$TARGET/.agents/skills/smoke/NEW.md" ]] || fail "stats linked a file"
[[ ! -e "$LIVE_NOTES/stats-pull.md" ]] || fail "stats pulled a file"
same_file "$TARGET/.agents/skills/smoke/SKILL.md" "$AGENTS_OVERLAY/skills/smoke/SKILL.md" && fail "stats re-linked"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --project "$PROJECT" --yes ) || fail "sync after stats"
( cd "$PLAYBOOK_ROOT" && "$SYNC" --stats --project "$PROJECT" ) >"$stats_log" 2>&1 || fail "--stats rerun"
grep -q '^status: in sync' "$stats_log" || fail "stats: not in sync after sync"
pass "--stats read-only report"

pass "all marshal cases"
