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

  vim.g.lexima_no_default_rules = true
  vim.fn["lexima#set_default_rules"]()

  vim.keymap.inoremap {"<c-space>", [[compe#complete()]], silent = true, expr = true}
  vim.keymap.inoremap {
    "<cr>", [[compe#confirm(lexima#expand('<LT>CR>', 'i'))]],
    silent = true, expr = true,
  }
  vim.keymap.inoremap {"<c-e>", [[compe#close('<c-e>')]], silent = true, expr = true}
end

return M
