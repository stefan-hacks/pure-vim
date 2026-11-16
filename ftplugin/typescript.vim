" ~/.vim/ftplugin/typescript.vim — TypeScript support for pure-vim
" Requires: tsc (lint), prettier (format)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal foldmethod=syntax foldlevel=99
setlocal commentstring=//\ %s

" Include-search
setlocal include=^\s*import\s\+.*\s\+from\s\+['"]\zs[^'"]*\ze
setlocal includeexpr=substitute(v:fname,'^\.\.\?/',getcwd().'/','')
setlocal define=^\s*\(const\\|let\\|var\\|function\\|class\\|interface\\|type\\|enum\)\s\+

" Lint: tsc --noEmit
if executable('tsc')
  setlocal makeprg=tsc\ --noEmit\ --pretty\ false\ %
  setlocal errorformat=%f(%l\,%c):\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Format: prettier
if executable('prettier')
  setlocal formatprg=prettier\ --parser\ typescript
  nnoremap <buffer> <Leader>= :%!prettier --parser typescript<CR>
endif

" Run current file with ts-node
if executable('ts-node')
  nnoremap <buffer> <Leader>r :botright term ts-node %<CR>
endif

setlocal omnifunc=javascriptcomplete#CompleteJS

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< foldmethod< foldlevel< cms< include< includeexpr< define< mp< efm< fp< ofu<'
