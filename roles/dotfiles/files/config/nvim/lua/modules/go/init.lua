local plug = require("cfg.plug")
local autocmd = require("cfg.autocmd")
local layer = {}

local function on_filetype_go()
  vim.g.go_fmt_command = "goimports"
  vim.g.go_autodetect_gopath = true
  vim.g.go_list_type = "quickfix"
  vim.g.go_addtags_transform = "camelcase"
  vim.g.go_highlight_types = true
  vim.g.go_highlight_fields = true
  vim.g.go_highlight_buf_opttions = true
  vim.g.go_highlight_buf_opttion_calls = true
  vim.g.go_highlight_build_constraints = true
  vim.g.go_highlight_generate_tags = true
  vim.g.go_highlight_extra_types = true
  vim.g.go_highlight_generate_tags = true
  vim.g.go_metalinter_autosave = true
  vim.g["test#go#executable"] = "go test -v"
  vim.g.go_metalinter_autosave_enabled = {"govet"; "golint"; "gosimple"}

  vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
  vim.api.nvim_buf_set_option(0, "tabstop", 4)
  vim.api.nvim_buf_set_option(0, "softtabstop", 4)
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

function layer.register_plugins()
  plug.add_plugin("fatih/vim-go", {["do"] = ":GoUpdateBinaries"; ["for"] = "go"})
end

function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")
  lsp.register_server(nvim_lsp.gopls)
  autocmd.bind_filetype("go", on_filetype_go)
end

return layer
