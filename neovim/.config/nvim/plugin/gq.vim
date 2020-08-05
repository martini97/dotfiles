if exists("g:loaded_gq")
  finish
endif
let g:loaded_gq = 1

if has('nvim') && exists('*luaeval')
  lua require 'init'
endif
function! Format(type, ...)
  normal! '[v']gq
  if v:shell_error > 0
    silent undo
    redraw
    echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
  endif
  call winrestview(w:gqview)
  unlet w:gqview
endfunction

nmap <silent> GQ :let w:gqview = winsaveview()<CR>:set opfunc=Format<CR>g@
