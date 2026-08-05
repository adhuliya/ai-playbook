# Vim agent cheat sheet

Classic Vim helpers for Cursor **`agent`** (ask + rewrite with review). Loaded from `~/.vim/vim-agent.vim` when `~/.vimrc` sources it.

## Setup

1. Sync playbook machine configs: `./scripts/sync-playbook.sh --machine --yes` from repo root.
2. Ensure **`agent`** is on `PATH` (same concern as GUI Vim vs terminal PATH).
3. Reload: `:source ~/.vimrc` or restart Vim.
4. Check load: `:echo exists('g:loaded_vim_agent')` → `1`.

Repo copies: `configs/vim-agent.vim`, `configs/vim-agent-run.sh` → `~/.vim/` via syncmap.

## Leader

`vimrc` sets **`mapleader` to Space**. Below, `<leader>` means Space.

## Keymaps

| Keys | Mode | Action |
|------|------|--------|
| `<leader>aa` | Normal | Ask about **whole buffer** |
| `<leader>aa` | Visual | Ask about **selection** (lines/chars) |
| `<leader>aa` | In `agent-ask` buffer | Follow-up question (keeps transcript) |
| `<leader>ae` | Normal | Rewrite **whole buffer** → vimdiff review |
| `<leader>ae` | Visual | Rewrite **selection** → original \| `agent-new` panes |
| `<leader>ae` | In `agent-new` | Refine proposal **in place** (no nested review) |
| `<leader>ay` | Review buffers | Accept (apply new side) |
| `<leader>an` | Review buffers | Reject / close review |

**Ask:** opens or reuses scratch buffer **`agent-ask`**. Status line shows context (`entire buffer` vs `selected lines N-M`) before `agent ask>`.

**Rewrite (whole file):** vimdiff **original \| agent-new** — edit the new side, then accept or reject.

**Rewrite (selection):** two windows only; copy from `agent-new` or `<leader>ay` to apply.

## Diff review (whole-buffer rewrite)

Whole-file `<leader>ae` turns on **vimdiff** between the original buffer and **`agent-new`**. Selection rewrite uses two side-by-side panes **without** diff highlighting — use eyes, copy, or `<leader>ay` / `<leader>an` there.

| Command | Action |
|---------|--------|
| `<leader>ay` / `<leader>an` | Accept or reject (preferred; closes review cleanly) |
| `Ctrl-W w` or `Ctrl-W p` | Switch window (original ↔ `agent-new`) |
| `]c` | Jump to **next** change |
| `[c` | Jump to **previous** change |
| Edit in **`agent-new`** | Tweak the proposal, then `<leader>ay` |
| `do` | In current window: **obtain** change from the other pane (manual merge) |
| `dp` | **Put** change from current pane to the other |
| `zo` / `zc` | Open / close fold under cursor (unchanged regions often folded) |
| `:diffupdate` | Refresh diff if display looks wrong |

Tip: focus **`agent-new`**, edit, then `<leader>ay`. Use `do`/`dp` only if you prefer manual diff merging over editing the new pane directly.

## Environment

| Variable | Default | Effect |
|----------|---------|--------|
| `AGENT_MODEL` | `auto` | Passed to `agent --model` (shared with `~/.agent.zshrc.sh`) |
| `AGENT_TIMEOUT` | `180` | Seconds for runner (`timeout` / `gtimeout` when available) |

## If something fails

- `:messages` — look for lines starting with **`agent:`** (warnings, scope, review hints).
- **Runner missing:** sync `vim-agent-run.sh` to `~/.vim/`.
- **Timeout / empty answer:** run `agent` in a shell with the same flags; increase `AGENT_TIMEOUT`.

### Quick tests

```bash
# From ai-playbook root (mock agent + sync paths)
./tests/smoke-test-vim-agent.sh
```

```bash
# Runner only (real agent)
printf '%s\n' 'Reply with one word: hi.' > /tmp/prompt.txt
bash ~/.vim/vim-agent-run.sh ask /tmp/prompt.txt /tmp/out.json
```

## More detail

- Implementation: `configs/vim-agent.vim`, `configs/vim-agent-run.sh`
- Activity handoff: `.dev-notes/activities/vim-agent/activity.md`
