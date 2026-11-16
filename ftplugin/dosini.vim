" ~/.vim/ftplugin/dosini.vim — INI / Config file support for pure-vim
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal commentstring=#\ %s
setlocal foldmethod=syntax foldlevel=99

setlocal omnifunc=syntaxcomplete#Complete

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< cms< foldmethod< foldlevel< ofu<'
