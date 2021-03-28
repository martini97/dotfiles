local M = {}

local completion = require("modules.lsp.completion")
local servers = require("modules.lsp.servers")

function M.setup()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {underline = true, virtual_text = false}
  )
  completion.setup()
  servers.setup()
end

return M
