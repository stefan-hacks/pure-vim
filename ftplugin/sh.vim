" ~/.vim/ftplugin/sh.vim — Bash/Shell support for pure-vim
" Requires: shellcheck (lint), shfmt (format)
setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
setlocal fileformat=unix

" Include-search for sourced files
setlocal include=^\.\s*source\s\+\|
setlocal define=\<function\s\+

" Lint: shellcheck
if executable('shellcheck')
  setlocal makeprg=shellcheck\ -f\ gcc\ --\ %
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]:\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Format: shfmt
if executable('shfmt')
  setlocal formatprg=shfmt\ -i\ 4\ -ci
  nnoremap <buffer> <Leader>= :%!shfmt -i 4 -ci<CR>
endif

" Keywords for completion from syntax
setlocal omnifunc=syntaxcomplete#Complete

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< ff< include< define< mp< efm< fp< ofu<'
