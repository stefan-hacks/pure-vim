" ~/.vim/ftplugin/python.vim — Python support for pure-vim
" Requires: ruff or flake8 (lint), black (format)
setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
setlocal textwidth=88
setlocal foldmethod=indent foldlevel=99

" Include-search for Python imports
setlocal include=^\s*\(from\|import\)\s\+\zs\S\+\ze
setlocal includeexpr=substitute(v:fname,'\.','/','g')
setlocal define=^\s*\(def\\|class\\|async\s\+def\)\s\+

" Native completion
setlocal omnifunc=python3complete#Complete

" Lint: ruff (preferred) > flake8
if executable('ruff')
  setlocal makeprg=ruff\ check\ --output-format=concise\ %
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
elseif executable('flake8')
  setlocal makeprg=flake8\ --format=default\ %
  setlocal errorformat=%f:%l:%c:\ %t%n\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Format: black (preferred) > autopep8
if executable('black')
  setlocal formatprg=black\ -q\ -
  nnoremap <buffer> <Leader>= :%!black -q -<CR>
elseif executable('autopep8')
  setlocal formatprg=autopep8\ -
  nnoremap <buffer> <Leader>= :%!autopep8 -<CR>
endif

" Run current file in bottom terminal
nnoremap <buffer> <Leader>r :botright term python3 %<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< tw< foldmethod< foldlevel< include< includeexpr< define< mp< efm< fp< ofu<'
else
  let b:undo_ftplugin = 'setlocal ts< sw< sts< et< tw< foldmethod< foldlevel< include< includeexpr< define< mp< efm< fp< ofu<'
endif
