local M = {}

function M.setup()
  vim.keymap.nnoremap {"<space>gs", ":Gstatus<cr>"}
  vim.keymap.nnoremap {"<space>gp", ":Gpull<cr>"}
  vim.keymap.nnoremap {"<space>gP", ":Gpush<cr>"}
end

return M
