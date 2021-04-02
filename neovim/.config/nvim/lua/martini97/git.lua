local M = {}
local t_builtin = require 'telescope.builtin'

local function git_branches()
  t_builtin.git_branches()
end

function M.setup()
  vim.keymap.nnoremap {"<space>gs", ":Gstatus<cr>"}
  vim.keymap.nnoremap {"<space>gp", ":Gpull<cr>"}
  vim.keymap.nnoremap {"<space>gP", ":Gpush<cr>"}
  vim.keymap.nnoremap {"<space>gb", git_branches}
end

return M
