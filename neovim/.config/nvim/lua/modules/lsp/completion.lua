local M = {}

local compe = require("compe")

function M.setup()
  compe.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,

    source = {
      path = true,
      buffer = true,
      calc = true,
      nvim_lsp = true,
      nvim_lua = true,
      spell = true,
      snippets_nvim = true,
    },
  }

  vim.api.nvim_set_keymap(
    "i", "<C-Space>", "compe#complete()",
    {expr = true, silent = true, noremap = true}
  )

  vim.api.nvim_set_keymap(
    "i", "<CR>", "compe#confirm('<CR>')",
    {expr = true, silent = true, noremap = true}
  )
end

return M
