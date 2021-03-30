local M = {}

local completion = require("modules.lsp.completion")
local servers = require("modules.lsp.servers")
-- local loclist = require("modules.lsp.loclist")
local fix_tab = require("modules.lsp.fix_tab")

function M.setup()
  completion.setup()
  servers.setup()
  -- loclist.setup()
  fix_tab.setup()

  vim.cmd [[
    command! -nargs=0 Format lua vim.lsp.buf.formatting()
  ]]
end

return M
