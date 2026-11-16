" ~/.vim/ftplugin/markdown.vim — Markdown support for pure-vim
" Requires: prettier or mdformat (format)
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal wrap linebreak textwidth=0 wrapmargin=0
setlocal foldmethod=expr foldlevel=99
setlocal commentstring=\u003c!--\ %s\ --\u003e

" Don't trim trailing whitespace — markdown uses it for line breaks
setlocal formatoptions-=t

" Format: prettier (preferred) > mdformat
if executable('prettier')
  setlocal formatprg=prettier\ --parser\ markdown
  nnoremap <buffer> <Leader>= :%!prettier --parser markdown<CR>
elseif executable('mdformat')
  setlocal formatprg=mdformat\ -
  nnoremap <buffer> <Leader>= :%!mdformat -<CR>
endif

" Preview in browser (requires xdg-open or open)
if executable('xdg-open')
  nnoremap <buffer> <Leader>p :!xdg-open %<CR>
elseif executable('open')
  nnoremap <buffer> <Leader>p :!open %<CR>
endif

setlocal omnifunc=syntaxcomplete#Complete

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '|setlocal ts< sw< sts< et< wrap< linebreak< tw< wm< foldmethod< foldlevel< cms< fo< fp< ofu<'
