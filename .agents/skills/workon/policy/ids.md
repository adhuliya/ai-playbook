# IDs

Activity entries carry stable IDs. IDs give humans a short, stable name
for an entry and let an agent read exactly that entry without loading the
whole file.

| ID | Entry | Home |
|---|---|---|
| `RD<n>` | Requirement Definition | `spec-req-def.md` `## RD<n>: <title>` |
| `DD<n>` | current design statement | `spec-design.md` `### DD<n>: <title>` under `## Decisions` |
| `DC<nn>` | design choice (two digits, append-only) | `spec-design-choice.md` `## DC<nn>: <title>` |
| `CONV<n>` | convention rule (Setup H2 has no ID) | `conventions.md` `## CONV<n>: <title>` |
| `REF<n>` | reference | `references.md` `- REF<n>:` entry |
| `RU<n>`, `RU<n>.<m>` | Review Update: review cycle, point | `reviews.md` |
| `M<n>` | milestone | `agent-activity.md` `# Milestones` |
| `AC<n>` | acceptance criteria for `RD<n>` | `spec-req-def.md`, `AC<n>:` under `## RD<n>` |
| `TC<n>` | test case set for `RD<n>` | `spec-design.md` `## Test Plan`, `TC<n>:` line |

Assign the next free number. Do not reuse a retired (superseded or removed)
ID, except through `fix-activity` renumbering. `replaces:` names the old
ID. IDs stay out of shipped work and `artifacts/guide-for-users.md`
(**Engineering while focused**). `spec-plan-outline.md` and
`artifacts/detailed-design.md` stay readable without IDs (**Writing style**).

`AC<n>` and `TC<n>` are not independently numbered: each always shares its
`RD<n>`'s number, so `RD3` pairs with `AC3` and `TC3`. `AC<n>` exists once
`add-ac` drafts it. A missing `AC<n>` is normal. Renumbering `RD<n>`
(`fix-activity`) renumbers its `AC<n>` and `TC<n>` the same way, in the
same pass. Renumbering also updates every `reads:` line and every `cites:`
line.

A `DD<n>` is the current statement a milestone builds from. Rewrite it in
place. It cites the `DC<nn>` entries it rests on. Those entries keep the
alternatives and why they lost. `DC<nn>` stays the append-only history.

## Citing and reading by ID

Recommended, not strict. `spec-plan-outline.md` and `artifacts/detailed-design.md` are the
exception in **Writing style**.

- **Cite by ID** in records and replies instead of repeating the title or
  the text: "per RD3", "see DD2", "see DC02", "AC3 covers it", "TC3 is green".
  On first mention in a reply, add a few words of gloss so the reader need
  not look it up: "RD3 (CSV column order)". Skip the gloss when the
  context already makes it plain.
- **Read one entry, not the file.** An entry is a `##` block, so print only
  what you need:

  ```bash
  awk '/^## /{p=($2 ~ /^(RD3|RD5):$/)} p' .dev-notes/activities/<slug>/spec-req-def.md
  ```

  Use the same call for `DC`, `CONV`, and `RU` entries in their files. A
  `DD<n>` entry is a `###` block:

  ```bash
  awk '/^### /{p=($2 ~ /^(DD2|DD4):$/)} p' .dev-notes/activities/<slug>/spec-design.md
  ```

  For `REF<n>` and `M<n>`, which are list items, use `rg -n -A 8 'REF2:'` or
  `rg -n -A 12 'M3:'`. For `AC<n>` and `TC<n>`, which are lines or lists
  inside another entry, use `rg -n -A 4 'AC3:'` on `spec-req-def.md` or
  `rg -n -A 2 'TC3:'` on `spec-design.md`. When `AC3:` is absent, stop after the
  `RD3` block.
- Read a whole notes file only to grill, review, or rewrite it as a whole.

## Milestone read

Run this before splitting a milestone's jobs (**Milestone**). It writes
`artifacts/bg/M<n>/slice.md`. Read that file. Do not Read `spec-req-def.md`,
`spec-design.md`, or `spec-design-choice.md` for that milestone. Pass the slice path
in the workers' and milestone critics' `inputs`.

The slice holds, in order: `## Current Design`; the milestone block; each
`RD` on the `reads:` line (the `AC` list is included when present); the
Traceability case names for those RDs tagged with this `M` (`planned for`,
`done by`, or `implemented by`); each `DD` on the `reads:` line; each `DC`
named in those `cites:` lines, plus any `DC` on the `reads:` line; each
`REF` on the `reads:` line; each `RU<n>` section cited in the milestone
block, or the `RU<n>.<m>` bullet when the cycle itself is not cited. A
`CONV` id becomes the line `CONV<n>: see conventions.md`. The prompt still
passes `conventions.md`. A missing `AC` prints no `AC` lines and is not a
`missing:` line. `reads: none` loads no RD. A `missing:` line names an ID
the milestone asked for and the file did not hold.

Tools are `mkdir` and `awk` (POSIX `sh`). They are enough on Linux, macOS,
and Git Bash. The program strips CR. Copy it as-is. Replace `<slug>` and
set `m` to the milestone id (`M2` in the copy).

```bash
s=.dev-notes/activities/<slug>
m=M2
mkdir -p "$s/artifacts/bg/$m"
awk -v m="$m" -v act="$s/agent-activity.md" -v des="$s/spec-design.md" -v rd="$s/spec-req-def.md" -v dc="$s/spec-design-choice.md" -v ref="$s/references.md" -v ru="$s/reviews.md" '
function load(path,    line, n) {
  n = 0
  while ((getline line < path) > 0) {
    sub(/\r$/, "", line)
    n++
    L[path, n] = line
  }
  close(path)
  N[path] = n
}
function has(list, id) { return index(list, " " id " ") > 0 }
function add(list, id) {
  if (!has(list, id)) list = list id " "
  return list
}
function push(kind, id,    k) {
  if (has(seen, id)) return
  seen = add(seen, id)
  k = ++cnt[kind]
  ord[kind, k] = id
}
function whole(text, id,    rest, tok) {
  rest = text
  while (match(rest, /[A-Z]+[0-9]+/)) {
    tok = substr(rest, RSTART, RLENGTH)
    if (tok == id) return 1
    rest = substr(rest, RSTART + RLENGTH)
  }
  return 0
}
function trim(s) {
  gsub(/^[ \t]+|[ \t]+$/, "", s)
  return s
}
function emit(path, start, end,    i, p, line) {
  p = 0
  if (N[path] < 1) return 0
  for (i = 1; i <= N[path]; i++) {
    line = L[path, i]
    if (!p) {
      if (line ~ start) { p = 1; print line }
    } else if (line ~ end) return 1
    else print line
  }
  return p
}
function take(text, mode,    rest, tok, kind) {
  rest = text
  while (match(rest, /(RD|DD|DC|CONV|REF|RU)[0-9]+(\.[0-9]+)?/)) {
    tok = substr(rest, RSTART, RLENGTH)
    kind = ""
    if (mode == "reads") {
      if (tok ~ /^RD/) kind = "rd"
      else if (tok ~ /^DD/) kind = "dd"
      else if (tok ~ /^DC/) kind = "dc"
      else if (tok ~ /^CONV/) kind = "conv"
      else if (tok ~ /^REF/) kind = "ref"
    } else if (tok ~ /^RU[0-9]+$/) kind = "ruc"
    else if (tok ~ /^RU/) kind = "rup"
    if (kind != "") push(kind, tok)
    rest = substr(rest, RSTART + RLENGTH)
  }
}
function take_dc(text,    rest, tok) {
  rest = text
  while (match(rest, /DC[0-9]+/)) {
    tok = substr(rest, RSTART, RLENGTH)
    push("dc", tok)
    rest = substr(rest, RSTART + RLENGTH)
  }
}
function emit_ref(id,    i, p, line, start) {
  start = "^- " id ":"
  p = 0
  if (N[ref] < 1) return 0
  for (i = 1; i <= N[ref]; i++) {
    line = L[ref, i]
    if (!p) {
      if (line ~ start) { p = 1; print line }
    } else if (line ~ /^- |^# /) return 1
    else print line
  }
  return p
}
function emit_point(id,    i, p, line, start) {
  start = "^- " id "([^0-9.]|$)"
  p = 0
  if (N[ru] < 1) return 0
  for (i = 1; i <= N[ru]; i++) {
    line = L[ru, i]
    if (!p) {
      if (line ~ start) { p = 1; print line }
    } else if (line ~ /^[ \t]/) print line
    else return 1
  }
  return p
}
function show(kind, path, start_fmt, end,    i, id, start, ok) {
  ok = 1
  for (i = 1; i <= cnt[kind]; i++) {
    id = ord[kind, i]
    start = start_fmt
    gsub(/ID/, id, start)
    if (!emit(path, start, end)) { print "missing: " id; ok = 0 }
    print ""
  }
  return ok
}
BEGIN {
  load(act); load(des); load(rd); load(dc); load(ref); load(ru)
  seen = " "
  hdr = "^- (\\[[ xX]\\] )?" m ":"
  mend = "^- (\\[[ xX]\\] )?M[0-9]+:|^# "
  block = ""
  p = 0
  for (i = 1; i <= N[act]; i++) {
    line = L[act, i]
    if (!p) {
      if (line ~ hdr) { p = 1; block = block line "\n" }
    } else if (line ~ mend) break
    else block = block line "\n"
  }
  print "# Slice " m
  print ""
  if (N[des] < 1) { print "missing: spec-design.md"; print "" }
  else if (emit(des, "^## Current Design$", "^## ")) print ""
  if (p) { printf "%s", block; print "" }
  else { print "missing: milestone " m; print "" }
  n = split(block, blines, "\n")
  reads = ""
  for (i = 1; i <= n; i++) if (blines[i] ~ /^[ \t]*- reads:/) reads = blines[i]
  if (p && reads == "") { print "missing: reads"; print "" }
  take(reads, "reads")
  take(block, "ru")
  show("rd", rd, "^## ID:", "^## ")
  any = 0
  scanning = 0
  for (i = 1; i <= N[des]; i++) {
    line = L[des, i]
    if (!scanning) {
      if (line ~ /^## Traceability$/) scanning = 1
      continue
    }
    if (line ~ /^## /) break
    if (line !~ /^\|/) continue
    if (split(line, f, "|") < 5) continue
    rdid = trim(f[2])
    if (!has(seen, rdid)) continue
    cn = split(f[4], segs, ";")
    for (k = 1; k <= cn; k++) {
      if (whole(segs[k], m)) {
        if (!any) { print "## Cases"; any = 1 }
        print "- " rdid ": " trim(segs[k])
      }
    }
  }
  if (any) print ""
  for (i = 1; i <= cnt["dd"]; i++) {
    id = ord["dd", i]
    start = "^### " id ":"
    end = "^### |^## "
    grabbing = 0
    if (!emit(des, start, end)) { print "missing: " id; print ""; continue }
    print ""
    for (j = 1; j <= N[des]; j++) {
      line = L[des, j]
      if (line ~ start) { grabbing = 1; continue }
      if (grabbing && line ~ end) break
      if (grabbing && line ~ /cites:/) take_dc(line)
    }
    grabbing = 0
  }
  show("dc", dc, "^## ID:", "^## ")
  for (i = 1; i <= cnt["ref"]; i++) {
    id = ord["ref", i]
    if (!emit_ref(id)) { print "missing: " id }
    print ""
  }
  printed = " "
  for (i = 1; i <= cnt["ruc"]; i++) {
    id = ord["ruc", i]
    start = "^## " id ":"
    if (!emit(ru, start, "^## ")) { print "missing: " id; print ""; continue }
    print ""
    printed = add(printed, id)
  }
  for (i = 1; i <= cnt["rup"]; i++) {
    id = ord["rup", i]
    cycle = id
    sub(/\..*$/, "", cycle)
    if (has(printed, cycle)) continue
    if (!emit_point(id)) { print "missing: " id }
    print ""
  }
  if (cnt["conv"] > 0) {
    print "## Conventions"
    for (i = 1; i <= cnt["conv"]; i++) print ord["conv", i] ": see conventions.md"
    print ""
  }
}

' > "$s/artifacts/bg/$m/slice.md"
```

When `awk` or `mkdir` is missing, or the command exits non-zero, do not
rewrite the program. Build the same slice with Read and the one-entry
recipes above, in the same order. Keep only Traceability case segments
tagged with this `M`.
