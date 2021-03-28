local M = {}

local function keymaps()
  local mappings = {
    {"n", "<space>gs", ":Gstatus<Cr>", { noremap = true }},
    {"n", "<space>gp", ":Gpull<Cr>", { noremap = true }},
    {"n", "<space>gP", ":Gpush<Cr>", { noremap = true }},
  }

  for _, map in pairs(mappings) do
    vim.api.nvim_set_keymap(unpack(map))
  end
end

function M.setup()
  keymaps()
end

return M
