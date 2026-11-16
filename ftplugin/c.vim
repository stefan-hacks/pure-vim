" ~/.vim/ftplugin/c.vim — C support for pure-vim
" Requires: clang-format (format), gcc/clang (lint + compile)
setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
setlocal foldmethod=syntax foldlevel=99
setlocal commentstring=/*\ %s\ */

" Include-search
setlocal include=^\s*#\s*include\s\+["\u003c]\zs[^"\u003e]\+
setlocal includeexpr=substitute(v:fname,'\.','/','g')
setlocal define=^\s*#\s*define\s\+\zs\S\+\ze

" Format: clang-format
if executable('clang-format')
  setlocal formatprg=clang-format
  nnoremap <buffer> <Leader>= :%!clang-format<CR>
endif

" Compile & lint: clang preferred > gcc
if executable('clang')
  setlocal makeprg=clang\ -Wall\ -Wextra\ -g\ -std=c17\ %\ -o\ %:r
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
elseif executable('gcc')
  setlocal makeprg=gcc\ -Wall\ -Wextra\ -g\ -std=c17\ %\ -o\ %:r
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Debug: native Termdebug
nnoremap <buffer> <Leader>db :packadd termdebug<CR>:Termdebug %:r<CR>

" Run compiled binary
nnoremap <buffer> <Leader>r :botright term ./%:r<CR>

setlocal omnifunc=ccomplete#Complete

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< foldmethod< foldlevel< cms< include< includeexpr< define< mp< efm< fp< ofu<'
else
  let b:undo_ftplugin = 'setlocal ts< sw< sts< et< foldmethod< foldlevel< cms< include< includeexpr< define< mp< efm< fp< ofu<'
endif
