local M = {}

local saga = require 'lspsaga'
local completion = require("martini97.lsp.completion")
local servers = require("martini97.lsp.servers")
local fix_tab = require("martini97.lsp.fix_tab")
local handlers = require("martini97.lsp.handlers")

function M.setup()
  handlers.setup()
  completion.setup()
  servers.setup()
  fix_tab.setup()

  saga.init_lsp_saga({
    code_action_prompt = {
      enable = false,
      virtual_text = false,
    },
    finder_action_keys = {
      open = '<cr>',
      vsplit = 's',
      split = 'i',
      quit = {'q', '<esc>'},
      scroll_down = '<C-f>',
      scroll_up = '<C-b>',
    },
  })

  vim.cmd [[
    command! -nargs=0 Format lua vim.lsp.buf.formatting()
  ]]
end

return M
