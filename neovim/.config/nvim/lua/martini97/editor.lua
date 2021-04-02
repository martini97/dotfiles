local utils = require('martini97.utils')
local Path = require 'plenary.path'

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.swapfile = false
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.wildignore = { '__pycache__', '*.o' , '*~', '*.pyc', '*pycache*' }
vim.opt.formatoptions = vim.opt.formatoptions
                    - 'a'     -- Auto formatting is BAD.
                    - 't'     -- Don't auto format my code. I got linters for that.
                    + 'c'     -- In general, I like it when comments respect textwidth
                    + 'q'     -- Allow formatting comments w/ gq
                    - 'o'     -- O and o, don't continue comments
                    + 'r'     -- But do continue when pressing enter.
                    + 'n'     -- Indent past the formatlistpat, not underneath it.
                    + 'j'     -- Auto-remove comments if possible.
                    - '2'     -- I'm not in gradeschool anymore
vim.opt.fillchars = { eob = "~" }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.inccommand = 'nosplit'

vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep --no-column --smart-case --color=never"
end

vim.keymap.cnoremap {"<c-k>", "<up>"}
vim.keymap.cnoremap {"<c-j>", "<down>"}
vim.keymap.cnoremap {"<c-a>", "<home>"}
vim.keymap.cnoremap {"<c-e>", "<end>"}
vim.keymap.nnoremap {"<a-d>", [[:Lspsaga open_floaterm<CR>]]}
vim.keymap.tnoremap {"<a-d>", [[<C-\><C-n>:Lspsaga close_floaterm<CR>]]}

vim.cmd [[
  cnoreabbrev W! w!
  cnoreabbrev Q! q!
  cnoreabbrev Qall! qall!
  cnoreabbrev Wq wq
  cnoreabbrev Wa wa
  cnoreabbrev wQ wq
  cnoreabbrev WQ wq
  cnoreabbrev W w
  cnoreabbrev Q q
  cnoreabbrev Qall qall
]]

local autocmds = {
  highlight_yank = {
    {"TextYankPost", "*", [[lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}]]}
  }
}

local dependencies_dir = vim.fn.stdpath('config') .. '/dependencies'
local node_deps = dependencies_dir .. '/node/node_modules/.bin'
local py_deps = dependencies_dir .. '/python/venv/bin'
local deps = { node_deps, py_deps }

for _, dep in ipairs(deps) do
  if Path:new(node_deps):is_dir() then
    vim.env.PATH = dep .. ':' .. vim.env.PATH
  end
end

utils.nvim_create_augroups(autocmds)
