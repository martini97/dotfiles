--- Python layer
local autocmd = require("cfg.autocmd")
local file = require("cfg.file")
local layer = {}

local function on_filetype_python()
  vim.g["test#python#runner"] = "pytest"

  vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
  vim.api.nvim_buf_set_option(0, "tabstop", 4)
  vim.api.nvim_buf_set_option(0, "softtabstop", 4)
  vim.api.nvim_buf_set_option(0, "errorformat", "%f:%l:%c: %t%n %m")
  vim.api.nvim_buf_set_option(0, "makeprg", "flake8 %:S")
  vim.api.nvim_buf_set_option(0, "formatprg", "black --quiet -")
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local workon_bin = (os.getenv("WORKON_HOME") or "") .. "/neovim/bin"
  if file.is_dir(workon_bin) then
    vim.env.PATH = workon_bin .. ":" .. vim.env.PATH
  end

  vim.env.PATH = ".venv/bin:" .. vim.env.PATH
end

function layer.register_plugins()
end

function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")
  local lsp_status = require("lsp-status")
  local config = {
    callbacks = lsp_status.extensions.pyls_ms.setup();
    settings = {
      python = {
        analysis = {
          disabled = {};
    }}};
    init_options = {
      interpreter = {
        properties = {
          InterpreterPath = vim.g.python3_host_prog;
          Version = "3.6";
  }}}}

  -- XXX: testing pyls_ms for a bit
  lsp.register_server(nvim_lsp.pyls_ms, config)
  autocmd.bind_filetype("python", on_filetype_python)
end

return layer
