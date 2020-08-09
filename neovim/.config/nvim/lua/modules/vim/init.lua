local autocmd = require("cfg.autocmd")
local layer = {}

function layer.register_plugins()
end

local function on_filetype_vim()
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.vimls)
  autocmd.bind_filetype("vim", on_filetype_vim)
end

return layer
