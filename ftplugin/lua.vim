" ~/.vim/ftplugin/lua.vim — Lua support for pure-vim
" Requires: luac (lint), stylua (format)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal foldmethod=syntax foldlevel=99
setlocal commentstring=--\ %s

" Include-search
setlocal include=^\s*require\s*(['"]
setlocal includeexpr=substitute(v:fname,'\.','/','g')
setlocal define=^\s*\(local\s\+\\|function\\|local\s\+function\)\s\+

" Lint: luac -p
if executable('luac')
  setlocal makeprg=luac\ -p\ %
  setlocal errorformat=luac:\ %f:%l:\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Format: stylua (preferred)
if executable('stylua')
  setlocal formatprg=stylua\ -
  nnoremap <buffer> <Leader>= :%!stylua -<CR>
endif

" Run current file
if executable('lua')
  nnoremap <buffer> <Leader>r :botright term lua %<CR>
elseif executable('luajit')
  nnoremap <buffer> <Leader>r :botright term luajit %<CR>
endif

setlocal omnifunc=syntaxcomplete#Complete

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< foldmethod< foldlevel< cms< include< includeexpr< define< mp< efm< fp< ofu<'
