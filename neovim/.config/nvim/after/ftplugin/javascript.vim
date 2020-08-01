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
    setlocal errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m
    setlocal errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m
endif

setlocal includeexpr=LoadMainNodeModule(v:fname)
setlocal path=.,src
setlocal suffixesadd=.js,.jsx
