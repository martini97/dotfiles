local M = {}

local compe = require("compe")
local autopairs = require('nvim-autopairs')

function _G.martini97.completion_confirm ()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      vim.fn["compe#confirm"]()
      return autopairs.esc("<c-y>")
    else
      vim.defer_fn(function()
        vim.fn["compe#confirm"]("<cr>")
      end, 20)
      return autopairs.esc("<c-n>")
    end
  else
    return autopairs.check_break_line_char()
  end
end

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

  autopairs.setup()

  vim.keymap.inoremap {"<c-space>", vim.fn["compe#complete"], silent = true}
  vim.keymap.inoremap {
    "<cr>",
    "v:lua.martini97.completion_confirm()",
    silent = false,
    expr = true,
  }
end

return M
