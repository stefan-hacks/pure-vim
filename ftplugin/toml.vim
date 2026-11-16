" ~/.vim/ftplugin/toml.vim — TOML support for pure-vim
" Requires: taplo (lint + format)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal commentstring=#\ %s

" Lint: taplo lint
if executable('taplo')
  setlocal makeprg=taplo\ lint\ %
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Format: taplo fmt
if executable('taplo')
  setlocal formatprg=taplo\ fmt\ -
  nnoremap <buffer> <Leader>= :%!taplo fmt -<CR>
endif

setlocal omnifunc=syntaxcomplete#Complete

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< cms< mp< efm< fp< ofu<'
