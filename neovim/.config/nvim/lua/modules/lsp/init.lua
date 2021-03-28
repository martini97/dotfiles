local M = {}

local completion = require("modules.lsp.completion")
local servers = require("modules.lsp.servers")

function M.setup()
  completion.setup()
  servers.setup()
end

return M
