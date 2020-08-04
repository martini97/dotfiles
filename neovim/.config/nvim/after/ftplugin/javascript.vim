let $PATH = "node_modules/.bin:" . $PATH

function! LoadMainNodeModule(fname)
    let nodeModules = "./node_modules/"
    let packageJsonPath = nodeModules . a:fname . "/package.json"

    if filereadable(packageJsonPath)
        return nodeModules . a:fname . "/" . json_decode(join(readfile(packageJsonPath))).main
    else
        return nodeModules . a:fname
    endif
endfunction

if executable('prettier')
    setlocal formatprg=prettier
endif
if executable('eslint')
    setlocal makeprg=eslint\ --fix\ -f\ compact\ %
endif

" Vim polyglot sets this to a messed up value
augroup unset_formatexpr
  autocmd!
  autocmd BufEnter *.tsx,*.ts,*.jsx,*.js setlocal formatexpr=
augroup END

setlocal includeexpr=LoadMainNodeModule(v:fname)
setlocal path=.,src
setlocal suffixesadd=.js,.jsx
setlocal omnifunc=v:lua.vim.lsp.omnifunc
