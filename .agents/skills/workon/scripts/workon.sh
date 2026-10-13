#!/usr/bin/env bash
# workon helper. Run from the repo root:
#   bash .agents/skills/workon/scripts/workon.sh <sub> [args]
#
#   load <keyword>          command heading + every section its Reads: line names
#   section <name>...       named sections (file.md, file.md#Heading, or Heading)
#   probe <slug>            session probe: metadata, creates missing notes files, fills missing rows, legacy markers
#   snapshot <slug> [--pin] synced snapshot commit; --pin pins the ref and writes the row
#   base <commit>           synced base of a snapshot and its baseline mode
#   list [--all]            activity table (Complete only with --all)
set -euo pipefail

SKILL_DIR=$(cd "$(dirname "$0")/.." && pwd)
ACT_DIR=.dev-notes/activities
# Search order for bare section names.
SEARCH_FILES="lifecycle.md records.md review-policy.md planning.md building.md notes-files.md subagent-contract.md templates.md commands.md SKILL.md"

die() { echo "error: $*" >&2; exit 1; }

# If a core tool is missing, shadow it with the first available substitute
# (listed alternates, then a busybox applet). With none, fail only on use.
fallback() {
  local tool=$1 alt; shift
  command -v "$tool" >/dev/null 2>&1 && return 0
  for alt in "$@"; do
    command -v "$alt" >/dev/null 2>&1 && { eval "$tool() { command $alt \"\$@\"; }"; return 0; }
  done
  if [[ $'\n'$(busybox --list 2>/dev/null)$'\n' == *$'\n'$tool$'\n'* ]]; then
    eval "$tool() { busybox $tool \"\$@\"; }"
  else
    eval "$tool() { die \"$tool not found\"; }"
  fi
}
fallback awk gawk mawk nawk
fallback grep ggrep
fallback sed gsed
need_git() { command -v git >/dev/null 2>&1 || die "git not found"; }

# Print the heading whose text starts with $2 (case-insensitive, backticks and
# asterisks ignored) from file $1, through the next heading of the same or a
# higher level.
extract_section() {
  local file=$1 name=$2
  awk -v want="$name" '
    function norm(s) { gsub(/[`*]/, "", s); return tolower(s) }
    /^#{1,6} / {
      if (show) { lvl = length($1); if (lvl <= want_lvl) exit }
      else {
        text = $0; sub(/^#+ /, "", text)
        if (index(norm(text), norm(want)) == 1) { show = 1; want_lvl = length($1) }
      }
    }
    show { print }
  ' "$file"
}

# Resolve one Reads item and print it.
print_item() {
  local item=$1 file name out
  item=$(printf '%s' "$item" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/`//g')
  [ -n "$item" ] || return 0
  if [[ "$item" == *"#"* ]]; then
    file=${item%%#*}; name=${item#*#}
    [ -f "$SKILL_DIR/$file" ] || die "no file $file"
    out=$(extract_section "$SKILL_DIR/$file" "$name")
    [ -n "$out" ] || die "no section '$name' in $file"
    printf '\n<!-- %s#%s -->\n%s\n' "$file" "$name" "$out"
  elif [[ "$item" == *.md ]] && [ -f "$SKILL_DIR/$item" ]; then
    printf '\n<!-- %s -->\n' "$item"; cat "$SKILL_DIR/$item"
  else
    for file in $SEARCH_FILES; do
      [ -f "$SKILL_DIR/$file" ] || continue
      out=$(extract_section "$SKILL_DIR/$file" "$item")
      if [ -n "$out" ]; then
        printf '\n<!-- %s#%s -->\n%s\n' "$file" "$item" "$out"; return 0
      fi
    done
    # Bold term: print the section whose body defines **item**. Pass 1 wants
    # a defining line (term at line start, or followed by is/means/colon);
    # pass 2 accepts any mention.
    local pass
    for pass in 1 2; do
      for file in $SEARCH_FILES; do
        [ -f "$SKILL_DIR/$file" ] || continue
        name=$(awk -v want="$item" -v pass="$pass" '
          function nb(s) { gsub(/`/, "", s); return tolower(s) }
          /^#{1,6} / { h = $0; sub(/^#+ /, "", h) }
          h && (i = index(nb($0), "**" nb(want))) {
            after = substr(nb($0), i + length(nb(want)) + 2)
            if (after !~ /^[.:]?\*\*/) next
            label = (after ~ /^[.:]\*\*/)
            rest = after; sub(/^[.:]?\*\*/, "", rest)
            if (pass == 2 || i == 1 || label || rest ~ /^ (is|means|are) / || rest ~ /^ \([^)]*\):/) { print h; exit }
          }' "$SKILL_DIR/$file")
        if [ -n "$name" ]; then
          out=$(extract_section "$SKILL_DIR/$file" "$name")
          printf '\n<!-- %s#%s (defines %s) -->\n%s\n' "$file" "$name" "$item" "$out"; return 0
        fi
      done
    done
    die "no section or bold term '$item'"
  fi
}

cmd_section() { for n in "$@"; do print_item "$n"; done; }

cmd_load() {
  local kw=${1:?keyword}; local heading reads
  heading=$(awk -v cmd="$kw" '
    /^## / && index($0, "`" cmd "`") { show = 1 }
    show && /^## / && !index($0, "`" cmd "`") { exit }
    show' "$SKILL_DIR/commands.md")
  [ -n "$heading" ] || die "no command '$kw'"
  printf '%s\n' "$heading"
  reads=$(printf '%s\n' "$heading" | awk '/^Reads:/ { sub(/^Reads:[[:space:]]*/, ""); print; exit }')
  [ -n "$reads" ] || return 0
  IFS=';' read -ra items <<< "$reads"
  for it in "${items[@]}"; do print_item "$it"; done
}

row_value() { awk -F'|' -v k="$2" '$2 ~ "^ *"k" *$" { gsub(/^ +| +$/, "", $3); print $3; exit }' "$1"; }

cmd_probe() {
  local slug=${1:?slug} dir f status legacy=0
  dir=$ACT_DIR/$slug
  [ -d "$dir" ] || die "no activity dir $dir"
  echo "## probe $slug"
  if [ -f "$dir/activity.md" ]; then
    echo; echo "metadata:"; awk 'NR<=14 && /^\|/' "$dir/activity.md" | grep -v '^|---' || true
    status=$(row_value "$dir/activity.md" status)
  else
    echo "missing: activity.md (not created by the probe)"; status=""
  fi
  echo; echo "files:"
  while IFS='|' read -r f body; do
    [ -f "$dir/$f" ] || { printf '%b' "$body" > "$dir/$f"; echo "created: $f"; }
  done <<'EOF'
requirement-def.md|# Requirement Definition\n
design-choices.md|# Design Decisions\n
conventions.md|# Conventions\n\n## Setup, build, test and install notes\n
notes-by-user.md|# Notes by User\n
EOF
  if [ -f "$dir/activity.md" ]; then
    echo; echo "rows:"
    for k in status slug branch ticket notes; do
      [ -n "$(awk -F'|' -v k="$k" '$2 ~ "^ *"k" *$"' "$dir/activity.md")" ] || echo "missing: $k (no default; add it)"
    done
    local def
    for k in conventions review-comments base-branch synced; do
      [ -z "$(awk -F'|' -v k="$k" '$2 ~ "^ *"k" *$"' "$dir/activity.md")" ] || continue
      case $k in
        conventions) case $status in Active|Paused|Blocked|Complete) def=ok;; *) def=pending;; esac;;
        review-comments) [ "$status" = Complete ] && def=off || def=on;;
        base-branch) def=main;;
        synced) def=none;;
      esac
      awk -v row="| $k | $def |" '{ lines[NR]=$0; if ($0 ~ /^\|/) last=NR } END { for (i=1;i<=NR;i++) { print lines[i]; if (i==last) print row } }' \
        "$dir/activity.md" > "$dir/activity.md.tmp" && mv "$dir/activity.md.tmp" "$dir/activity.md"
      echo "set: $k=$def"
    done
  fi
  echo; echo "legacy markers:"
  for f in notes.md user-notes.md requirements.md artifacts/self-review.md; do [ -e "$dir/$f" ] && { echo "- $f exists"; legacy=1; }; done
  [ -d "$dir/artifacts/self-review" ] && { echo "- artifacts/self-review/ exists"; legacy=1; }
  if [ -f "$dir/requirement-def.md" ]; then
    grep -q '^## Problem:' "$dir/requirement-def.md" || { echo "- requirement-def.md has no '## Problem:' heading"; legacy=1; }
    grep -E '^## ' "$dir/requirement-def.md" | grep -vE '^## (Problem:|RD[0-9]+:)' | sed 's/^/- requirement-def.md odd heading: /' | grep . && legacy=1
  fi
  [ -f "$dir/design-choices.md" ] && grep -E '^## ' "$dir/design-choices.md" | grep -vE '^## DC[0-9][0-9]:' | sed 's/^/- design-choices.md odd heading: /' | grep . && legacy=1
  [ -f "$dir/conventions.md" ] && grep -E '^## ' "$dir/conventions.md" | grep -vE '^## (CONV[0-9]+:|Setup, build, test and install notes$)' | sed 's/^/- conventions.md odd heading: /' | grep . && legacy=1
  [ -f "$dir/reviews.md" ] && grep -E '^## ' "$dir/reviews.md" | grep -vE '^## (RU[0-9]+:|Renumber)' | sed 's/^/- reviews.md odd heading: /' | grep . && legacy=1
  if [ -f "$dir/activity.md" ]; then
    awk '/^# References/ { r=1; next } /^# / { r=0 } r && /^- / && /`[^`]*[\/.][^`]*`/ && !/REF[0-9]+/' "$dir/activity.md" | sed 's/^/- References bullet without REF<n>: /' | grep . && legacy=1
  fi
  grep -hoE '\b(UR|SR|RRD)[0-9]+\b' "$dir"/*.md 2>/dev/null | sort -u | sed 's/^/- legacy ID: /' | grep . && legacy=1
  grep -hE '^## R[0-9]+:' "$dir"/*.md 2>/dev/null | sed 's/^/- legacy heading: /' | grep . && legacy=1
  [ $legacy -eq 1 ] && echo "legacy: yes" || echo "legacy: no"
}

make_snapshot() {
  local slug=$1 d idx tree
  d=$ACT_DIR/$slug
  idx=$(mktemp -u 2>/dev/null) || idx=$(git rev-parse --git-dir)/workon-index.$$
  GIT_INDEX_FILE=$idx git read-tree HEAD
  GIT_INDEX_FILE=$idx git add -u
  GIT_INDEX_FILE=$idx git add -f "$d"
  tree=$(GIT_INDEX_FILE=$idx git write-tree); rm -f "$idx"
  if [ "$tree" = "$(git rev-parse 'HEAD^{tree}')" ]; then git rev-parse HEAD
  else git commit-tree "$tree" -p HEAD -m "workon synced $slug"; fi
}

cmd_snapshot() {
  local slug=${1:?slug} pin=${2:-} snap act
  need_git
  git rev-parse --git-dir >/dev/null 2>&1 || die "not a git repo"
  snap=$(make_snapshot "$slug")
  echo "snapshot: $snap"
  if [ "$pin" = "--pin" ]; then
    git update-ref "refs/workon/$slug" "$snap"
    act=$ACT_DIR/$slug/activity.md
    awk -v v="$snap" -F'|' '$2 ~ /^ *synced *$/ { print "| synced | " v " |"; next } { print }' "$act" > "$act.tmp" && mv "$act.tmp" "$act"
    echo "pinned: refs/workon/$slug"; echo "row: synced = $snap"
  fi
}

cmd_base() {
  local c=${1:?commit} subj np base
  need_git
  if ! git cat-file -e "$c^{commit}" 2>/dev/null; then echo "base: none"; echo "mode: none"; return 0; fi
  subj=$(git log -1 --format=%s "$c"); np=$(( $(git rev-list --parents -n1 "$c" | wc -w) - 1 ))
  if [[ "$subj" == "workon synced"* ]] || [ "$np" -ge 2 ]; then base=$(git rev-parse "$c^1"); else base=$(git rev-parse "$c"); fi
  echo "base: $base"
  if git merge-base --is-ancestor "$base" HEAD; then echo "mode: ok"; else echo "mode: rewritten"; fi
}

cmd_list() {
  local all=${1:-} f title status slug branch notes
  echo "| title | status | slug | branch | notes |"; echo "|---|---|---|---|---|"
  for f in "$ACT_DIR"/*/activity.md; do
    [ -f "$f" ] || continue
    status=$(row_value "$f" status)
    [ "$status" = Complete ] && [ "$all" != "--all" ] && continue
    title=$(awk '/^# / { sub(/^# /, ""); print; exit }' "$f")
    slug=$(row_value "$f" slug); branch=$(row_value "$f" branch); notes=$(row_value "$f" notes)
    echo "| $title | $status | $slug | $branch | $notes |"
  done
}

sub=${1:-}; shift || true
case $sub in
  load) cmd_load "$@";;
  section) cmd_section "$@";;
  probe) cmd_probe "$@";;
  snapshot) cmd_snapshot "$@";;
  base) cmd_base "$@";;
  list) cmd_list "$@";;
  *) sed -n '2,12p' "$0"; exit 1;;
esac
