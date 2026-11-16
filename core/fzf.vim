" ============================================================
"  core/fzf.vim — Floating popup fzf + bat, pure Vimscript
" ============================================================
" Requires: fzf binary on $PATH, bat binary on $PATH (for previews)
" Fallback: if fzf/bat are missing, commands degrade gracefully
" Dependencies: Vim 8.1+ with popup_create() and term_start()
" ============================================================

" Guard: skip if popup_create or term_start are unavailable
if !exists('*popup_create') || !exists('*term_start')
  finish
endif

let s:has_fzf = executable('fzf')
let s:has_bat = executable('bat')
let s:has_rg  = executable('rg')

" ---------- Core popup wrapper ----------
" Runs {cmd} inside a hidden terminal, shows it in a centered popup,
" and calls {sink}(first_line_of_temp_file) when fzf exits.
function! s:FzfPopup(cmd, sink) abort
  let l:temp = tempname()
  let l:full_cmd = a:cmd . ' > ' . shellescape(l:temp) . '; exit 0'

  let l:width  = max([40, float2nr(&columns * 0.8)])
  let l:height = max([10, float2nr(&lines * 0.75)])

  let l:opts = #{
        \ minwidth:  l:width,
        \ maxwidth:  l:width,
        \ minheight: l:height,
        \ maxheight: l:height,
        \ border:    [],
        \ title:     ' fzf ',
        \ wrap:      0,
        \ }

  " Start hidden terminal buffer, then create popup with it
  let l:bufnr = term_start(['/bin/sh', '-c', l:full_cmd], #{
        \ hidden: 1,
        \ exit_cb: function('s:OnFzfExit', [l:temp, a:sink])
        \ })

  " Store winid on buffer so the callback can close the popup
  call setbufvar(l:bufnr, 'purevim_fzf_winid',
        \ popup_create(l:bufnr, l:opts))
endfunction

function! s:OnFzfExit(temp, sink, job, status) abort
  " Locate the popup window via the buffer that owns it
  let l:bufnr = job_info(a:job).bufnr
  let l:winid = getbufvar(l:bufnr, 'purevim_fzf_winid', -1)

  " Close popup if still open
  if l:winid != -1 && popup_getpos(l:winid) != {}
    call popup_close(l:winid)
  endif

  " Wipe out the now-dead terminal buffer
  if bufexists(l:bufnr)
    silent! execute 'bwipeout! ' . l:bufnr
  endif

  " Pass result to sink (empty / cancelled selections are ignored)
  if filereadable(a:temp)
    let l:lines = readfile(a:temp)
    call delete(a:temp)
    if !empty(l:lines) && l:lines[0] !=# ''
      call call(a:sink, [l:lines[0]])
    endif
  endif
endfunction

" ---------- Fuzzy file finder ----------
function! s:FzfFiles() abort
  if !s:has_fzf
    echo '[pure-vim] fzf not found in $PATH'
    return
  endif
  let l:preview = s:has_bat
        \ ? 'bat --style=numbers --color=always --line-range :300 {}'
        \ : 'cat {}'
  let l:cmd = 'fzf --preview ' . shellescape(l:preview)
  call s:FzfPopup(l:cmd, {file -> execute('edit ' . fnameescape(file))})
endfunction

nnoremap <silent> <Leader>F :call <SID>FzfFiles()<CR>

" ---------- Live ripgrep + fzf ----------
function! s:OpenRgResult(line) abort
  let l:parts = split(a:line, ':')
  if len(l:parts) >= 2
    execute 'edit +' . l:parts[1] . ' ' . fnameescape(l:parts[0])
  endif
endfunction

function! s:FzfRipgrep(query) abort
  if !s:has_fzf
    echo '[pure-vim] fzf not found in $PATH'
    return
  endif
  if !s:has_rg
    echo '[pure-vim] ripgrep (rg) not found in $PATH'
    return
  endif
  let l:rg = 'rg --line-number --no-heading --color=always --smart-case'
  if a:query !=# ''
    let l:rg .= ' ' . shellescape(a:query)
  endif
  let l:preview = s:has_bat
        \ ? 'bat --style=numbers --color=always --highlight-line {2} {1}'
        \ : 'cat {1}'
  let l:cmd = l:rg
        \ . ' | fzf --ansi --delimiter : --preview '
        \ . shellescape(l:preview)
        \ . ' --preview-window +{2}-/2'
  call s:FzfPopup(l:cmd, function('s:OpenRgResult'))
endfunction

command! -nargs=? -complete=file Rg call <SID>FzfRipgrep(<q-args>)
nnoremap <silent> <Leader>s :call <SID>FzfRipgrep('')<CR>
nnoremap <silent> <Leader>S :call <SID>FzfRipgrep(expand('<cword>'))<CR>

" ---------- Buffer switcher ----------
function! s:FzfBuffers() abort
  if !s:has_fzf
    echo '[pure-vim] fzf not found in $PATH'
    return
  endif
  let l:bufs = filter(range(1, bufnr('$')),
        \ 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# ""')
  let l:names = map(l:bufs, 'v:val . "\t" . bufname(v:val)')
  let l:temp = tempname()
  call writefile(l:names, l:temp)
  let l:cmd = 'cat ' . shellescape(l:temp) . ' | fzf --with-nth=2..'
  call s:FzfPopup(l:cmd,
        \ {line -> execute('buffer ' . fnameescape(split(line, "\t")[0]))})
endfunction

nnoremap <silent> <Leader>b :call <SID>FzfBuffers()<CR>

" ---------- Command palette ----------
function! s:FzfCommands() abort
  if !s:has_fzf
    echo '[pure-vim] fzf not found in $PATH'
    return
  endif
  let l:cmds = []
  redir => l:cmdout
  silent command
  redir END
  for l:line in split(l:cmdout, "\n")[1:]
    let l:word = matchstr(l:line, '^\S\+')
    if l:word !=# '' | call add(l:cmds, ':' . l:word) | endif
  endfor
  let l:temp = tempname()
  call writefile(l:cmds, l:temp)
  let l:cmd = 'cat ' . shellescape(l:temp) . ' | fzf'
  call s:FzfPopup(l:cmd, {line -> execute(line[1:])})
endfunction

nnoremap <silent> <Leader>c :call <SID>FzfCommands()<CR>

" ---------- Help tags finder ----------
function! s:FzfHelptags() abort
  if !s:has_fzf
    echo '[pure-vim] fzf not found in $PATH'
    return
  endif
  let l:tags = []
  for l:tagfile in findfile('tags', &runtimepath, -1)
    for l:line in readfile(l:tagfile)
      if l:line =~# '^\S\+'
        call add(l:tags, matchstr(l:line, '^\S\+'))
      endif
    endfor
  endfor
  if empty(l:tags)
    echo '[pure-vim] No help tags found'
    return
  endif
  let l:temp = tempname()
  call writefile(uniq(sort(l:tags)), l:temp)
  let l:cmd = 'cat ' . shellescape(l:temp) . ' | fzf'
  call s:FzfPopup(l:cmd, {line -> execute('help ' . fnameescape(line))})
endfunction

nnoremap <silent> <Leader>H :call <SID>FzfHelptags()<CR>
