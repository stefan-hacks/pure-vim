" ~/.vim/ftplugin/json.vim — JSON support for pure-vim
" Requires: jq (format), jsonlint or python -m json.tool (validate)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal foldmethod=syntax foldlevel=99

" Validate: jq
if executable('jq')
  setlocal makeprg=jq\ .\ %
  setlocal errorformat=parse\ error:\ %m\ at\ line\ %l\,\ column\ %c
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Format: jq (preferred) > python json.tool
if executable('jq')
  setlocal formatprg=jq\ .
  nnoremap <buffer> <Leader>= :%!jq .<CR>
elseif executable('python3')
  setlocal formatprg=python3\ -m\ json.tool
  nnoremap <buffer> <Leader>= :%!python3 -m json.tool<CR>
endif

setlocal omnifunc=syntaxcomplete#Complete

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< foldmethod< foldlevel< mp< efm< fp< ofu<'
else
  let b:undo_ftplugin = 'setlocal ts< sw< sts< et< foldmethod< foldlevel< mp< efm< fp< ofu<'
endif
