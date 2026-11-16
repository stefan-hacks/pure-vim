" ~/.vim/ftplugin/cpp.vim — C++ support for pure-vim
" Requires: clang-format (format), g++/clang++ (lint + compile)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal foldmethod=syntax foldlevel=99
setlocal commentstring=//\ %s

" Include-search
setlocal include=^\s*#\s*include\s\+["\u003c]\zs[^"\u003e]\+
setlocal includeexpr=substitute(v:fname,'\.','/','g')
setlocal define=^\s*#\s*define\s\+\zs\S\+\ze

" Format: clang-format
if executable('clang-format')
  setlocal formatprg=clang-format
  nnoremap <buffer> <Leader>= :%!clang-format<CR>
endif

" Compile & lint: clang++ preferred > g++
if executable('clang++')
  setlocal makeprg=clang++\ -Wall\ -Wextra\ -g\ -std=c++20\ %\ -o\ %:r
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
elseif executable('g++')
  setlocal makeprg=g++\ -Wall\ -Wextra\ -g\ -std=c++20\ %\ -o\ %:r
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Debug: native Termdebug
nnoremap <buffer> <Leader>db :packadd termdebug<CR>:Termdebug %:r<CR>

" Run compiled binary
nnoremap <buffer> <Leader>r :botright term ./%:r<CR>

setlocal omnifunc=ccomplete#Complete

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< foldmethod< foldlevel< cms< include< includeexpr< define< mp< efm< fp< ofu<'
