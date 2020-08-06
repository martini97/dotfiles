if exists("g:loaded_redir")
  finish
endif
let g:loaded_redir = 1

function! s:redir(cmd) abort
    let output = execute(a:cmd)
    tabnew
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    call setline(1, split(output, "\n"))
endfunction
command! -nargs=1 Redir silent call s:redir(<f-args>)
