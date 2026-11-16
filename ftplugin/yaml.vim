" ~/.vim/ftplugin/yaml.vim — YAML support for pure-vim
" Requires: yamllint (lint), yamlfmt (format)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal indentkeys-=0#
setlocal foldmethod=indent foldlevel=99

" Lint: yamllint
if executable('yamllint')
  setlocal makeprg=yamllint\ -f\ parsable\ %
  setlocal errorformat=%f:%l:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Format: yamlfmt or prettier
if executable('yamlfmt')
  setlocal formatprg=yamlfmt
  nnoremap <buffer> <Leader>= :%!yamlfmt<CR>
elseif executable('prettier')
  setlocal formatprg=prettier\ --parser\ yaml
  nnoremap <buffer> <Leader>= :%!prettier --parser yaml<CR>
endif

setlocal omnifunc=syntaxcomplete#Complete

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< indentkeys< foldmethod< foldlevel< mp< efm< fp< ofu<'
