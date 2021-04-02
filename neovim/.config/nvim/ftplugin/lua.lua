vim.bo.formatprg = 'lua-format'
vim.bo.makeprg = 'luacheck --globals vim --std luajit --no-color %'
vim.bo.errorformat = '%f:%l:%c: %m,%-G%.%#'
