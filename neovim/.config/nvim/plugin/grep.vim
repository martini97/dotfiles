" Based on https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3

if exists("g:loaded_grep")
  finish
endif
let g:loaded_grep = 1

function! s:grep(...)
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr s:grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr s:grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'
