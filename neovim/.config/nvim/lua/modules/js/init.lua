local autocmd = require("cfg.autocmd")

--- Javascript layer
local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
end

local function on_filetype_js()
  vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
  vim.api.nvim_buf_set_option(0, "tabstop", 2)
  vim.api.nvim_buf_set_option(0, "softtabstop", 2)
  vim.api.nvim_buf_set_option(0, "formatprg", "prettier --parser typescript")
  vim.api.nvim_buf_set_option(0, "makeprg", "eslint -f compact %")
  vim.api.nvim_buf_set_option(0, "formatexpr", "")
  vim.api.nvim_buf_set_option(0, "suffixesadd", ".js,.jsx,.ts,.tsx")
  vim.api.nvim_buf_set_option(0, "path", ".,src")
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")

  vim.env.PATH = "node_modules/.bin:" .. vim.env.PATH
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.tsserver)

  autocmd.bind_filetype("javascript", on_filetype_js)
  autocmd.bind_filetype("javascriptreact", on_filetype_js)
  autocmd.bind_filetype("typescript", on_filetype_js)
  autocmd.bind_filetype("typescriptreact", on_filetype_js)
end

return layer
