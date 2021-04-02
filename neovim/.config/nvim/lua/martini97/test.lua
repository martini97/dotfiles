local M = {}

local function leader(key)
	return "<space>t" .. key
end

local function nearest_or_last()
	if vim.fn["test#exists"]() == 1 then
    vim.cmd [[ TestNearest ]]
  else
    vim.cmd [[ TestLast ]]
  end
end

function M.setup()
  vim.keymap.nnoremap {leader't', nearest_or_last}
  vim.keymap.nnoremap {leader'l', ":TestLast<cr>"}
  vim.keymap.nnoremap {leader'f', ":TestFile<cr>"}
  vim.keymap.nnoremap {leader'r', ":TestVisit<cr>"}
end

return M
