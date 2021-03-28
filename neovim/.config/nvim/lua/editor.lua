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
  opt.termguicolors = true
  opt.number = true
  opt.relativenumber = true
  opt.colorcolumn = "80"

  vim.o.completeopt = "menu,menuone,noselect"
end

local function providers()
  vim.g.python_host_prog = ""
  vim.g.loaded_python_provider = 0
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

options()
providers()
dependencies()
