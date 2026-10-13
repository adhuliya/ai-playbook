# Vim Agent Access

| Key | Value |
|---|---|
| status | Complete |
| slug | vim-agent |
| branch | none |
| ticket | none |
| notes | |

# Goal

Give classic Vim the same localized Cursor `agent` access the shell already has: ask questions about buffer/selection context, and rewrite text with a review step before applying.

# Scope

Machine-home config work: extend `configs/vimrc` (and small helpers under `configs/`) so Vim can call the Cursor `agent` CLI for localized asks and rewrites, then sync via the existing machine syncmap. Also update `configs/agent.zshrc.sh` so the agent model comes from an environment variable (default `auto`), shared with Vim. Shared Cursor assets (e.g. a vim skill) are out of scope unless a concrete need appears during design. No Neovim support, no product/app code, and no change to project sync beyond machine syncmap destinations already used for these files.

# Current Design

Shipped classic-Vim integration sourced from synced `~/.vim/vim-agent.vim` (via `configs/vimrc`).

## Invocation

- `agent --print --output-format json --trust`; `--mode ask` for questions.
- Model: `AGENT_MODEL` env (default `auto`) in `configs/agent.zshrc.sh` and `configs/vim-agent-run.sh`.

## Keymaps (leader default `\`)

| Mode | Keys | Behavior |
|---|---|---|
| Ask | `<leader>aa` | Scratch `agent-ask` split; Q/A transcript + follow-ups |
| Rewrite | `<leader>ae` | Instruction → proposal; whole buffer = vimdiff; selection = two panes |
| Review | `<leader>ay` / `<leader>an` | Accept / reject (buffer-local in review) |
| Follow-up edit | `<leader>ae` in `agent-new` | In-place refine proposal (no nested review) |

## Context

- No selection → whole buffer.
- Visual `<leader>aa` / `<leader>ae` → selection only (`xnoremap` range); empty visual aborts.

## Must-not-break

- Do not use `[Agent Ask]` as scratch name (breaks `:file` / buffer identity).
- Review buffers use `bufhidden=hide` until explicit close; avoid switching to old buffer inside `agent-new` window (E86).
- Selection rewrite: original file | `agent-new` only (no `agent-old` pane).

## Touched paths

- `configs/agent.zshrc.sh`, `configs/vimrc`
- `configs/vim-agent.vim`, `configs/vim-agent-run.sh`, `configs/vim-agent-help.md` (repo cheat sheet; not syncmap'd)
- `machines/Anshumans-MacBook-Pro.local/syncmap.txt` → `~/.vim/`
- `tests/smoke-test-vim-agent.sh`

# Milestones

1. [x] Shared model env — `AGENT_MODEL` in zsh + runner; `./tests/smoke-test-vim-agent.sh`
2. [x] Ask path — user nod; visual vs whole-file scope; `agent-ask` scratch UX fixes in journal
3. [x] Rewrite + review — user nod; vimdiff whole-file; two-pane selection; accept/reject/edit
4. [x] Machine sync — syncmap entries; `./scripts/sync-playbook.sh --machine --yes`; smoke OK

# Next Steps

- User help: `configs/vim-agent-help.md` (keymaps, setup, smoke/debug, vimdiff review commands).
- Reopen to `Planning` if Neovim, persistent agent session IDs, or shared Cursor skills are needed.
- Fast validation: `./tests/smoke-test-vim-agent.sh`; manual `<leader>aa` / `<leader>ae` after sync.
- Small fixes: keymap clashes in user `vimrc` — adjust chords in `configs/vim-agent.vim` only; re-sync `--machine`.

# References

- `configs/vim-agent-help.md` — cheat sheet (read in repo or `:edit` from playbook path)
- `configs/vimrc`, `configs/vim-agent.vim`, `configs/vim-agent-run.sh`, `configs/agent.zshrc.sh`
- `machines/Anshumans-MacBook-Pro.local/syncmap.txt`
- `tests/smoke-test-vim-agent.sh`
