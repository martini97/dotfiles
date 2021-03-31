local utils = require('martini97.utils')

local function dependencies()
  local dependencies_dir = vim.fn.stdpath('config') .. '/dependencies'
  local node_deps = dependencies_dir .. '/node/node_modules/.bin'
  local py_deps = dependencies_dir .. '/python/venv/bin'
  local deps = { node_deps, py_deps }

  for _, dep in ipairs(deps) do
    if utils.isdir(node_deps) then
      vim.env.PATH = dep .. ':' .. vim.env.PATH
    end
  end
end

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

vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

local function keymaps()
  local mappings = {
    {"c", "<C-k>", "<Up>", { noremap = true }},
    {"c", "<C-j>", "<Down>", { noremap = true }},
    {"c", "<C-a>", "<Home>", { noremap = true }},
    {"c", "<C-e>", "<End>", { noremap = true }},
  }

  for _, map in pairs(mappings) do
    vim.api.nvim_set_keymap(unpack(map))
  end

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
end

local autocmds = {
  highlight_yank = {
    {"TextYankPost", "*", [[lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}]]}
  }
}


dependencies()
keymaps()

utils.nvim_create_augroups(autocmds)
