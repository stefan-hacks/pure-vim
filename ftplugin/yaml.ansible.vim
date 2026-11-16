" ~/.vim/ftplugin/yaml.ansible.vim — Ansible support for pure-vim
" Requires: ansible-lint (lint), yamlfmt (format)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal indentkeys-=0#
setlocal foldmethod=indent foldlevel=99
setlocal commentstring=#\ %s

" Lint: ansible-lint
if executable('ansible-lint')
  setlocal makeprg=ansible-lint\ -p\ %
  setlocal errorformat=%f:%l:\ %t%*[^:]\ %m
  nnoremap <buffer> <Leader>m :make<CR>:cwindow<CR>
endif

" Format: yamlfmt or prettier
if executable('yamlfmt')
  setlocal formatprg=yamlfmt
  nnoremap <buffer> <Leader>= :%!yamlfmt<CR>
elseif executable('prettier')
  setlocal formatprg=prettier\ --parser\ yaml
  nnoremap <buffer> <Leader>= :%!prettier --parser yaml<CR>
endif

" Run playbook in bottom terminal
nnoremap <buffer> <Leader>r :botright term ansible-playbook %<CR>

setlocal omnifunc=syntaxcomplete#Complete

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< indentkeys< foldmethod< foldlevel< cms< mp< efm< fp< ofu<'
else
  let b:undo_ftplugin = 'setlocal ts< sw< sts< et< indentkeys< foldmethod< foldlevel< cms< mp< efm< fp< ofu<'
endif
