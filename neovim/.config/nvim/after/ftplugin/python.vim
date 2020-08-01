let $PATH = ".venv/bin:" . $PATH

setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
setlocal errorformat=%f:%l:%c:\ %t%n\ %m

if executable('black')
    setlocal formatprg=black\ --quiet\ -
endif
if executable('flake8')
    setlocal makeprg=flake8\ %:S
endif

python3 << EOF
import os
import sys
import vim
for p in sys.path:
    # Add each directory in sys.path, if it exists.
    if os.path.isdir(p):
        # Command 'set' needs backslash before each space.
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF
