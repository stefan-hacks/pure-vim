" ~/.vim/ftplugin/rust.vim — Rust support for pure-vim
" Requires: rustfmt (format), rustc/clippy (lint)
setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
setlocal foldmethod=syntax foldlevel=99
setlocal commentstring=//\ %s

" Include-search for mod/use statements
setlocal include=^\s*\(use\\|mod\)\s\+\zs\S\+\ze
setlocal includeexpr=substitute(v:fname,'::','/','g')
setlocal define=^\s*\(fn\\|struct\\|enum\\|impl\\|trait\\|type\\|macro_rules\)\s\+

" Format: rustfmt
if executable('rustfmt')
  setlocal formatprg=rustfmt
  nnoremap <buffer> <Leader>= :%!rustfmt<CR>
endif

" Lint: cargo clippy (preferred) > rustc
if executable('cargo')
  setlocal makeprg=cargo\ clippy\ --message-format=short
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
elseif executable('rustc')
  setlocal makeprg=rustc\ --error-format=short\ %
  setlocal errorformat=%f:%l:%c:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Run current file or project
nnoremap <buffer> <Leader>r :botright term cargo run<CR>
nnoremap <buffer> <Leader>t :botright term cargo test<CR>

setlocal omnifunc=syntaxcomplete#Complete

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< foldmethod< foldlevel< cms< include< includeexpr< define< mp< efm< fp< ofu<'
