" ~/.vim/ftplugin/javascript.vim — JavaScript support for pure-vim
" Requires: eslint or jshint (lint), prettier (format)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal foldmethod=syntax foldlevel=99
setlocal commentstring=//\ %s

" Include-search
setlocal include=^\s*import\s\+.*\s\+from\s\+['"]\zs[^'"]*\ze
setlocal includeexpr=substitute(v:fname,'^\.\.\?/',getcwd().'/','')
setlocal define=^\s*\(const\\|let\\|var\\|function\\|class\\|async\s\+function\)\s\+

" Lint: eslint (preferred) > jshint
if executable('eslint')
  setlocal makeprg=eslint\ --format\ compact\ %
  setlocal errorformat=%f:\ line\ %l\,\ col\ %c\,\ %t%*[^-]-\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
elseif executable('jshint')
  setlocal makeprg=jshint\ %
  setlocal errorformat=%f:\ line\ %l\,\ col\ %c\,\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Format: prettier
if executable('prettier')
  setlocal formatprg=prettier\ --parser\ babel
  nnoremap <buffer> <Leader>= :%!prettier --parser babel<CR>
endif

" Run current file with node
nnoremap <buffer> <Leader>r :botright term node %<CR>

setlocal omnifunc=javascriptcomplete#CompleteJS

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< foldmethod< foldlevel< cms< include< includeexpr< define< mp< efm< fp< ofu<'
