" ~/.vim/ftplugin/go.vim — Go support for pure-vim
" Requires: go (gofmt, goimports, golint, staticcheck)
setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
setlocal foldmethod=syntax foldlevel=99

" Include-search
setlocal include=^\s*import\s\+\(\zs\"\S\+\"\\|\\)\s\+\zs\"\S\+\"\)
setlocal includeexpr=substitute(v:fname,'"','','g')

" Format: gofmt is the canonical Go formatter
if executable('gofmt')
  setlocal formatprg=gofmt
  nnoremap <buffer> <Leader>= :%!gofmt<CR>
endif

" Import: goimports (preferred) > gofmt
if executable('goimports')
  nnoremap <buffer> <Leader>i :%!goimports<CR>
endif

" Lint: staticcheck (preferred) > golint
if executable('staticcheck')
  setlocal makeprg=staticcheck\ %:p:h
  setlocal errorformat=%f:%l:%c:\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
elseif executable('golint')
  setlocal makeprg=golint\ %
  setlocal errorformat=%f:%l:%c:\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Run current file
nnoremap <buffer> <Leader>r :botright term go run %<CR>

" Test current file
nnoremap <buffer> <Leader>t :botright term go test %:p:h<CR>

setlocal omnifunc=syntaxcomplete#Complete

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< foldmethod< foldlevel< include< includeexpr< mp< efm< fp< ofu<'
else
  let b:undo_ftplugin = 'setlocal ts< sw< sts< et< foldmethod< foldlevel< include< includeexpr< mp< efm< fp< ofu<'
endif
