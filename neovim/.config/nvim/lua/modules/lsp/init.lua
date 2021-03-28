local M = {}

local completion = require("modules.lsp.completion")
local servers = require("modules.lsp.servers")

function M.setup()
  completion.setup()
  servers.setup()

  vim.cmd [[
    command! -nargs=0 Format lua vim.lsp.buf.formatting()
  ]]
end

return M
