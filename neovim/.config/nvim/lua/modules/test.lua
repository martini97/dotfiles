local M = {}

local function keymaps()
  local mappings = {
    {"n", "<space>tt", ":TestNearest<CR>", { noremap = true }},
    {"n", "<space>tl", ":TestLast<CR>", { noremap = true }},
    {"n", "<space>tf", ":TestFile<CR>", { noremap = true }},
    {"n", "<space>tr", ":TestVisit<CR>", { noremap = true }},
  }

  for _, map in pairs(mappings) do
    vim.api.nvim_set_keymap(unpack(map))
  end
end

function M.setup()
  vim.g["test#strategy"] = "vtr"

  keymaps()
end

return M
