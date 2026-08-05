# Journal

## Planning kickoff

Created `vim-agent` for machine-home Vim access to Cursor `agent` (ask + rewrite with vimdiff review). Project fit: configs + syncmap; shared Cursor assets only if needed. Locked: whole-file context when no selection; selection ask vs rewrite by keymap; vimdiff accept/reject/edit; classic Vim; same agent invocation with `AGENT_MODEL` (default auto) shared with `agent.zshrc.sh`; auto-test if practical else manual nod. Drafted plan for file review.

## Plan approved

User approved the plan. Ready to build; waiting for `start-building`.

## Build started

Status → Active. Implementing AGENT_MODEL shared knob, then Vim ask/rewrite + vimdiff review.

## Implementation checkpoint

Shipped `configs/vim-agent.vim` + `configs/vim-agent-run.sh`, sourced from `vimrc`, syncmap'd to `~/.vim/`. `AGENT_MODEL` (default auto) in zsh runner and Vim path. Smoke: `./tests/smoke-test-vim-agent.sh` OK. Awaiting user keymap nod for ask + rewrite/review.

## Fix: ask answer not visible

Cause: scratch named `[Agent Ask]` — `:file` prints `--No lines in buffer--` and identity was unreliable. Renamed to `agent-ask`, write via `appendbufline`, focus split after answer. User should reload plugin and retry `<leader>aa`.

## Fix: visual ask used whole file

Visual `<leader>aa` now passes `'<,'>` line range at map time (`xnoremap`) and aborts if selection is empty instead of falling back to whole buffer. Status echo shows context scope before the question prompt.

## Fix: whole-file edit review E86

`OpenReview` switched to the old buffer inside the `agent-new` window; with `bufhidden=wipe` that destroyed `agent-new` (E86). Now use `wincmd p` for maps and `bufhidden=hide` until explicit close.

## UX: selection edit is two panes

Selection rewrite no longer opens `agent-old`. Layout is original file | `agent-new` (proposed snippet). Copy manually or `<leader>ay` to apply. Whole-file edit still uses vimdiff.

## Fix: follow-up edit in agent-new

`<leader>ae` inside `agent-new` now replaces selection/buffer in place (no nested OpenReview). Avoids CloseReview wiping the proposal buffer (E86).

## Complete

User nod on ask + rewrite/review UX. Status → Complete. Smoke `./tests/smoke-test-vim-agent.sh` green. Decisions kept: `AGENT_MODEL` shared knob; `agent-ask` scratch; selection = two-pane apply; whole-file = vimdiff. Gaps accepted: no Neovim; one-shot agent calls per turn; manual trial not re-run at close. Resume from Complete: reopen Planning for new scope, or patch `configs/vim-agent*.vim/sh` + syncmap + smoke for keymap/UX tweaks.

## Post-complete: help doc

Added `configs/vim-agent-help.md` (keymaps, setup, tests, vimdiff review commands). Activity references updated; file stays repo-only (not on syncmap).
