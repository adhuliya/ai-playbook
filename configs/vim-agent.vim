" vim-agent.vim — Cursor agent ask/rewrite helpers for classic Vim
" Requires: agent on PATH; optional companion ~/.vim/vim-agent-run.sh
"
" Keys (leader defaults to <Space> from vimrc):
"   <leader>aa  Ask about buffer (normal) or selection (visual)
"   <leader>ae  Rewrite buffer (normal) or selection (visual) → vimdiff review
" In ask scratch (buffer agent-ask):  <leader>aa  follow-up question (keeps transcript)
" In rewrite review:
"   whole-file: vimdiff original | agent-new
"   selection:  original file | agent-new (proposed snippet; copy or accept)
"   In agent-new: <leader>ae replaces text in place (no nested review)
"   <leader>ay  Accept  <leader>an  Reject/close
"   Edit the new side freely, then <leader>ay to apply.

if exists('g:loaded_vim_agent')
  finish
endif
let g:loaded_vim_agent = 1

let s:ask_bufname = 'agent-ask'
let s:ask_bufnr = -1
let s:runner = expand('~/.vim/vim-agent-run.sh')

" Review state
let s:review = {}

function! s:Model() abort
  return $AGENT_MODEL !=# '' ? $AGENT_MODEL : 'auto'
endfunction

function! s:Runner() abort
  if filereadable(s:runner)
    return s:runner
  endif
  " Fall back to playbook path when not yet syncmap'd (dev convenience).
  let alt = expand('<sfile>:p:h') . '/vim-agent-run.sh'
  if filereadable(alt)
    return alt
  endif
  return s:runner
endfunction

function! s:Echo(msg) abort
  redraw | echohl ModeMsg | echomsg 'agent: ' . a:msg | echohl None
endfunction

function! s:Warn(msg) abort
  redraw | echohl WarningMsg | echomsg 'agent: ' . a:msg | echohl None
endfunction

" Return text for an inclusive line range (visual selection). Empty if invalid.
function! s:TextForLineRange(start, end) abort
  if a:start <= 0 || a:end <= 0 || a:end < a:start
    return ''
  endif
  return join(getline(a:start, a:end), "\n")
endfunction

" Best-effort character/line/block selection via marks (no gv — more reliable
" after :<C-u> leaves visual mode).
function! s:GetVisualText() abort
  let start = getpos("'<")
  let end = getpos("'>")
  if start[1] <= 0 || end[1] <= 0
    return ''
  endif
  let lines = getline(start[1], end[1])
  if empty(lines)
    return ''
  endif
  let vmode = visualmode()
  if vmode ==# 'V'
    return join(lines, "\n")
  endif
  " Character or block: trim first/last line to selected columns.
  let c1 = start[2]
  let c2 = end[2]
  if len(lines) == 1
    let lines[0] = lines[0][c1 - 1 : c2 - 1]
  else
    let lines[0] = lines[0][c1 - 1 :]
    let lines[-1] = lines[-1][: c2 - 1]
  endif
  return join(lines, "\n")
endfunction

function! s:GetVisualLineRange() abort
  let start = line("'<")
  let end = line("'>")
  if start <= 0 || end <= 0
    return [0, 0]
  endif
  return [start, end]
endfunction

function! s:BufferMeta() abort
  let path = expand('%:p')
  let ft = &filetype
  let lines = []
  if path !=# ''
    call add(lines, 'File: ' . path)
  else
    call add(lines, 'File: (unnamed buffer)')
  endif
  if ft !=# ''
    call add(lines, 'Filetype: ' . ft)
  endif
  return join(lines, "\n")
endfunction

function! s:WholeBufferText() abort
  return join(getline(1, '$'), "\n")
endfunction

function! s:BuildAskPrompt(context, question, history, scope_note) abort
  let parts = []
  call add(parts, 'You are answering a question about code or text in the user''s Vim buffer.')
  call add(parts, 'Be concise and concrete. Do not edit files; answer only.')
  call add(parts, '')
  call add(parts, s:BufferMeta())
  call add(parts, 'Context scope: ' . a:scope_note)
  call add(parts, '')
  call add(parts, 'Context:')
  call add(parts, '```')
  call add(parts, a:context)
  call add(parts, '```')
  if a:history !=# ''
    call add(parts, '')
    call add(parts, 'Conversation so far:')
    call add(parts, a:history)
  endif
  call add(parts, '')
  call add(parts, 'Question:')
  call add(parts, a:question)
  return join(parts, "\n")
endfunction

function! s:BuildEditPrompt(context, instruction, is_selection) abort
  let parts = []
  call add(parts, 'You are a code/text editor assistant inside Vim.')
  call add(parts, 'Output ONLY the full replacement text for the target region.')
  call add(parts, 'No markdown fences, no explanation, no preamble, no trailing commentary.')
  call add(parts, '')
  call add(parts, s:BufferMeta())
  call add(parts, '')
  if a:is_selection
    call add(parts, 'Target: the selected region below. Return the full replacement for that selection only.')
  else
    call add(parts, 'Target: the entire buffer below. Return the full replacement for the entire buffer.')
  endif
  call add(parts, '')
  call add(parts, 'Current text:')
  call add(parts, '```')
  call add(parts, a:context)
  call add(parts, '```')
  call add(parts, '')
  call add(parts, 'Edit instruction:')
  call add(parts, a:instruction)
  return join(parts, "\n")
endfunction

" Strip accidental markdown fences from rewrite output.
function! s:StripFences(text) abort
  let lines = split(a:text, "\n", 1)
  while len(lines) && lines[0] =~# '^\s*$'
    call remove(lines, 0)
  endwhile
  while len(lines) && lines[-1] =~# '^\s*$'
    call remove(lines, -1)
  endwhile
  if len(lines) >= 2 && lines[0] =~# '^```'
    call remove(lines, 0)
    if lines[-1] =~# '^```\s*$'
      call remove(lines, -1)
    endif
  endif
  return join(lines, "\n")
endfunction

function! s:RunAgent(mode, prompt) abort
  let runner = s:Runner()
  if !filereadable(runner)
    call s:Warn('runner not found: ' . runner . ' (sync configs/vim-agent-run.sh)')
    return ''
  endif
  if !executable(runner) && !filereadable(runner)
    call s:Warn('runner not executable: ' . runner)
    return ''
  endif

  let prompt_file = tempname()
  let out_file = tempname()
  call writefile(split(a:prompt, "\n", 1), prompt_file)

  call s:Echo('working (model=' . s:Model() . ')...')
  redraw

  let cmd = 'bash ' . shellescape(runner) . ' ' . shellescape(a:mode) . ' '
        \ . shellescape(prompt_file) . ' ' . shellescape(out_file)
  let result = system(cmd)
  let err = v:shell_error

  call delete(prompt_file)
  call delete(out_file)

  if err != 0
    call s:Warn('failed or timed out (exit ' . err . ')')
    return ''
  endif

  let result = substitute(result, '[\r\n]\+$', '', '')
  if result ==# ''
    call s:Warn('empty response')
    return ''
  endif
  return result
endfunction

" ---------- Ask ----------

function! s:FindAskBuf() abort
  if s:ask_bufnr > 0 && bufexists(s:ask_bufnr)
    return s:ask_bufnr
  endif
  for b in range(1, bufnr('$'))
    if bufexists(b) && fnamemodify(bufname(b), ':t') ==# s:ask_bufname
      let s:ask_bufnr = b
      return b
    endif
  endfor
  return -1
endfunction

function! s:OpenAskScratch() abort
  let b = s:FindAskBuf()
  if b > 0
    let wins = win_findbuf(b)
    if !empty(wins)
      call win_gotoid(wins[0])
    else
      execute 'botright split'
      execute 'buffer' b
    endif
    return b
  endif

  botright split
  enew
  setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
  setlocal filetype=markdown
  " Avoid bracket/space names: :file [Agent Ask] prints '--No lines in buffer--'
  " and is a poor buffer identity.
  silent execute 'file' fnameescape(s:ask_bufname)
  let b = bufnr('%')
  let s:ask_bufnr = b
  call setbufline(b, 1, [
        \ '# Agent Ask',
        \ '',
        \ 'Use <leader>aa here for a follow-up. Transcript below.',
        \ '',
        \ '---',
        \ ])
  return b
endfunction

function! s:AppendAskTurn(question, answer) abort
  let b = s:OpenAskScratch()
  let lines = ['', '## Q', a:question, '', '## A']
  call extend(lines, split(a:answer, "\n", 1))
  call extend(lines, ['', '---', ''])
  call appendbufline(b, '$', lines)

  " Ensure the ask window is focused and scrolled to the new answer.
  let wins = win_findbuf(b)
  if !empty(wins)
    call win_gotoid(wins[0])
  endif
  execute 'buffer' b
  normal! G
  redraw
endfunction

function! s:AgentAsk(use_visual, ...) abort
  " Line range passed from xnoremap so marks are read at map-execute time.
  let range_start = a:0 >= 1 ? a:1 : 0
  let range_end = a:0 >= 2 ? a:2 : 0

  let in_ask = (bufnr('%') == s:FindAskBuf()) || (fnamemodify(bufname('%'), ':t') ==# s:ask_bufname)
  let history = ''
  let context = ''
  let scope_note = 'entire buffer'

  if in_ask
    let history = join(getline(1, '$'), "\n")
    if exists('w:agent_ask_context')
      let context = w:agent_ask_context
    elseif exists('s:ask_context')
      let context = s:ask_context
    else
      let context = '(no original buffer context; follow-up only)'
    endif
    let scope_note = 'follow-up (prior context retained)'
  elseif a:use_visual
    " Prefer explicit range from the mapping; fall back to marks/text helper.
    if range_start > 0 && range_end >= range_start
      let context = s:TextForLineRange(range_start, range_end)
      let scope_note = 'selected lines ' . range_start . '-' . range_end
    else
      let context = s:GetVisualText()
      let [range_start, range_end] = s:GetVisualLineRange()
      let scope_note = 'selected lines ' . range_start . '-' . range_end
    endif
    if context ==# ''
      call s:Warn('no visual selection captured; aborting (not using whole file)')
      return
    endif
    let s:ask_context = context
  else
    let context = s:WholeBufferText()
    let s:ask_context = context
    let scope_note = 'entire buffer'
  endif

  call s:Echo('ask context: ' . scope_note)
  let question = input('agent ask> ')
  echo "\n"
  if question =~# '^\s*$'
    call s:Echo('cancelled')
    return
  endif

  let prompt = s:BuildAskPrompt(context, question, history, scope_note)
  let answer = s:RunAgent('ask', prompt)
  if answer ==# ''
    return
  endif

  call s:AppendAskTurn(question, answer)
  let w:agent_ask_context = context
  call s:Echo('answer ready (see agent-ask split below; ' . scope_note . ')')
endfunction

" ---------- Rewrite / review ----------

function! s:CloseReview() abort
  if empty(s:review)
    return
  endif
  let new_buf = get(s:review, 'new_bufnr', -1)
  let old_buf = get(s:review, 'old_bufnr', -1)
  let orig_buf = get(s:review, 'orig_bufnr', -1)
  let orig_win = get(s:review, 'orig_winid', 0)
  if new_buf > 0 && bufexists(new_buf)
    execute 'bwipeout!' new_buf
  endif
  if old_buf > 0 && old_buf != orig_buf && bufexists(old_buf)
    execute 'bwipeout!' old_buf
  endif
  if orig_win > 0
    call win_gotoid(orig_win)
    if exists(':diffoff')
      diffoff!
    endif
  endif
  let s:review = {}
endfunction

function! s:ReviewAccept() abort
  if empty(s:review)
    call s:Warn('no active review')
    return
  endif
  let new_buf = s:review.new_bufnr
  let orig_buf = s:review.orig_bufnr
  let mode = s:review.mode
  let start = s:review.start
  let end = s:review.end
  let new_lines = getbufline(new_buf, 1, '$')

  let orig_win = get(s:review, 'orig_winid', 0)
  if orig_win > 0
    call win_gotoid(orig_win)
  endif
  execute 'buffer' orig_buf

  if mode ==# 'buffer'
    call setline(1, new_lines)
    if line('$') > len(new_lines)
      execute (len(new_lines) + 1) . ',$delete_'
    endif
  else
    " Replace line range with new lines.
    if end >= start
      execute start . ',' . end . 'delete_'
    endif
    call append(start - 1, new_lines)
  endif

  call s:CloseReview()
  call s:Echo('accepted')
endfunction

function! s:ReviewReject() abort
  if empty(s:review)
    call s:Warn('no active review')
    return
  endif
  call s:CloseReview()
  call s:Echo('rejected')
endfunction

function! s:OpenReview(orig_bufnr, new_text, mode, start, end) abort
  call s:CloseReview()

  let orig_win = win_getid()
  let new_lines = split(a:new_text, "\n", 1)

  " Always keep the original file visible. Selection reviews use two panes only
  " (file | proposed snippet) — no agent-old scratch. Whole-file reviews use
  " vimdiff against agent-new.
  execute 'buffer' a:orig_bufnr
  let old_buf = a:orig_bufnr

  if a:mode ==# 'range'
    " Jump to the selected region so both panes are easy to compare by eye.
    if a:start > 0
      execute 'normal!' a:start . 'G'
    endif
    " No diffthis: whole-file vs snippet diffs are misleading.
  else
    diffthis
  endif

  vnew
  setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
  silent file agent-new
  call setline(1, new_lines)
  if a:mode !=# 'range'
    diffthis
  endif
  let new_buf = bufnr('%')

  let s:review = {
        \ 'mode': a:mode,
        \ 'orig_bufnr': a:orig_bufnr,
        \ 'orig_winid': orig_win,
        \ 'old_bufnr': old_buf,
        \ 'new_bufnr': new_buf,
        \ 'start': a:start,
        \ 'end': a:end,
        \ }

  nnoremap <buffer> <silent> <leader>ay :call <SID>ReviewAccept()<CR>
  nnoremap <buffer> <silent> <leader>an :call <SID>ReviewReject()<CR>
  wincmd p
  nnoremap <buffer> <silent> <leader>ay :call <SID>ReviewAccept()<CR>
  nnoremap <buffer> <silent> <leader>an :call <SID>ReviewReject()<CR>
  wincmd p

  if a:mode ==# 'range'
    call s:Echo('review: copy from agent-new, or <leader>ay apply / <leader>an close')
  else
    call s:Echo('review: edit new side if needed; <leader>ay accept, <leader>an reject')
  endif
endfunction

function! s:IsAgentNewBuf(...) abort
  let b = a:0 ? a:1 : bufnr('%')
  return bufexists(b) && fnamemodify(bufname(b), ':t') ==# 'agent-new'
endfunction

" Replace lines in the current buffer (used for in-place agent-new follow-ups).
function! s:ReplaceLineRange(start, end, text) abort
  let new_lines = split(a:text, "\n", 1)
  if a:end >= a:start
    execute a:start . ',' . a:end . 'delete_'
  endif
  call append(a:start - 1, new_lines)
endfunction

function! s:ReplaceWholeBuffer(text) abort
  let new_lines = split(a:text, "\n", 1)
  call setline(1, new_lines)
  if line('$') > len(new_lines)
    execute (len(new_lines) + 1) . ',$delete_'
  endif
endfunction

" Follow-up edit while already in agent-new: replace in place, no nested review.
function! s:AgentEditInPlace(use_visual, range_start, range_end) abort
  let is_sel = a:use_visual
  if is_sel
    if a:range_start > 0 && a:range_end >= a:range_start
      let start = a:range_start
      let end = a:range_end
      let context = s:TextForLineRange(start, end)
    else
      let context = s:GetVisualText()
      let [start, end] = s:GetVisualLineRange()
    endif
    if context ==# '' || start <= 0
      call s:Warn('no visual selection captured; aborting')
      return
    endif
    call s:Echo('agent-new in-place edit: lines ' . start . '-' . end)
  else
    let context = s:WholeBufferText()
    let start = 1
    let end = line('$')
    call s:Echo('agent-new in-place edit: entire proposal')
  endif

  let instruction = input('agent edit> ')
  echo "\n"
  if instruction =~# '^\s*$'
    call s:Echo('cancelled')
    return
  endif

  let prompt = s:BuildEditPrompt(context, instruction, is_sel)
  let result = s:RunAgent('edit', prompt)
  if result ==# ''
    return
  endif
  let result = s:StripFences(result)

  if is_sel
    call s:ReplaceLineRange(start, end, result)
  else
    call s:ReplaceWholeBuffer(result)
  endif
  call s:Echo('agent-new updated in place (copy or <leader>ay to apply)')
endfunction

function! s:AgentEdit(use_visual, ...) abort
  let range_start = a:0 >= 1 ? a:1 : 0
  let range_end = a:0 >= 2 ? a:2 : 0

  " Nested review from agent-new would CloseReview-wipe this buffer (E86).
  if s:IsAgentNewBuf()
    call s:AgentEditInPlace(a:use_visual, range_start, range_end)
    return
  endif

  let orig_bufnr = bufnr('%')
  let is_sel = a:use_visual
  if is_sel
    if range_start > 0 && range_end >= range_start
      let start = range_start
      let end = range_end
      let context = s:TextForLineRange(start, end)
    else
      let context = s:GetVisualText()
      let [start, end] = s:GetVisualLineRange()
    endif
    if context ==# '' || start <= 0
      call s:Warn('no visual selection captured; aborting')
      return
    endif
    let mode = 'range'
    call s:Echo('edit context: selected lines ' . start . '-' . end)
  else
    let context = s:WholeBufferText()
    let start = 1
    let end = line('$')
    let mode = 'buffer'
    call s:Echo('edit context: entire buffer')
  endif

  let instruction = input('agent edit> ')
  echo "\n"
  if instruction =~# '^\s*$'
    call s:Echo('cancelled')
    return
  endif

  let prompt = s:BuildEditPrompt(context, instruction, is_sel)
  let result = s:RunAgent('edit', prompt)
  if result ==# ''
    return
  endif
  let result = s:StripFences(result)
  call s:OpenReview(orig_bufnr, result, mode, start, end)
endfunction

" ---------- Maps ----------
" xnoremap: visual mode only (not select mode). Pass '<,'> line range at map time
" so selection survives leaving visual mode (gv-based yank is unreliable here).

nnoremap <silent> <leader>aa :call <SID>AgentAsk(0)<CR>
xnoremap <silent> <leader>aa :<C-u>call <SID>AgentAsk(1, line("'<"), line("'>"))<CR>
nnoremap <silent> <leader>ae :call <SID>AgentEdit(0)<CR>
xnoremap <silent> <leader>ae :<C-u>call <SID>AgentEdit(1, line("'<"), line("'>"))<CR>
