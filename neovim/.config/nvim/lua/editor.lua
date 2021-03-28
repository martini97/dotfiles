local utils = require('utils')

-- helper function until https://github.com/neovim/neovim/pull/13479 arrives
local opts_info = vim.api.nvim_get_all_options_info()
local opt = setmetatable({}, {
  __index = vim.o,
  __newindex = function(_, key, value)
    vim.o[key] = value
    local scope = opts_info[key].scope
    if scope == "win" then
      vim.wo[key] = value
    elseif scope == "buf" then
      vim.bo[key] = value
    end
  end,
})

local function options()
  opt.number = true
  opt.cursorline = true
  opt.termguicolors = true
  opt.relativenumber = true
  opt.colorcolumn = "80"
  opt.shiftwidth = 2
  opt.softtabstop = 2
  opt.tabstop = 2
  opt.swapfile = false
  opt.expandtab = true

  vim.o.completeopt = "menu,menuone,noselect"
end

local function providers()
  vim.g.loaded_python_provider = 0
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
end

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

options()
providers()
dependencies()
keymaps()
