-- Plugin to source project settings
-- Based on: https://github.com/neovim/neovim/issues/12474#issuecomment-643159148

local root_pattern = require("lspconfig").util.root_pattern(".git")
local utils = require("utils")

function _G.source_settings()
  local project_root = root_pattern(vim.fn.expand("%"))
  if project_root == nil then
    project_root = ""
  else
    project_root = project_root .. "/"
  end

  local project_file = project_root .. ".vim/local.vim"

  if vim.fn.filereadable(project_file) == 1 then
    vim.cmd("source " .. project_file)
  end
end

local autocmds = {
  project_settings = {
    {"BufRead", "*", "call v:lua.source_settings()"},
    {"BufNewFile", "*", "call v:lua.source_settings()"},
    {"DirChanged", "*", "call v:lua.source_settings()"},
  },
}

utils.nvim_create_augroups(autocmds)
