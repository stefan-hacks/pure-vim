" ~/.vim/ftplugin/nix.vim — Nix support for pure-vim
" Requires: nixfmt (format), statix (lint)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal commentstring=#\ %s
setlocal iskeyword=@,48-57,_,192-255,-

" Include-search for imports and paths
setlocal include=\(import\s\+\|\\$\=\)\zs[^;\ ]\+

" Lint: statix check or nix-instantiate --parse
if executable('statix')
  setlocal makeprg=statix\ check\ %
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]:\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
elseif executable('nix-instantiate')
  setlocal makeprg=nix-instantiate\ --parse\ %
  setlocal errorformat=error:\ %m\ at\ %f:%l:%c
endif

" Format: nixfmt or alejandra or nixpkgs-fmt
if executable('alejandra')
  setlocal formatprg=alejandra
  nnoremap <buffer> <Leader>= :%!alejandra<CR>
elseif executable('nixfmt')
  setlocal formatprg=nixfmt
  nnoremap <buffer> <Leader>= :%!nixfmt<CR>
elseif executable('nixpkgs-fmt')
  setlocal formatprg=nixpkgs-fmt
  nnoremap <buffer> <Leader>= :%!nixpkgs-fmt<CR>
endif

setlocal omnifunc=syntaxcomplete#Complete

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< cms< isk< include< mp< efm< fp< ofu<'
