-- based on https://gist.github.com/phelipetls/0aeb9f4aca9af25d9f45ee56e0c5a340
local M = {}

local utils = require('utils')

local severity_map = { "E", "W", "I", "H" }

local function parse_diagnostics (diagnostics, bufnr)
  if not diagnostics then return end

  local items = {}

  for _, diagnostic in ipairs(diagnostics) do
    local position = diagnostic.range.start
    local severity = diagnostic.severity
    table.insert(items, {
      filename = vim.api.nvim_buf_get_name(bufnr),
      type = severity_map[severity],
      lnum = position.line + 1,
      col = position.character + 1,
      text = diagnostic.message:gsub("\r", ""):gsub("\n", " ")
    })
  end

  return items
end

function _G.update_diagnostics_loclist()
  local bufnr = vim.fn.bufnr()
  local diagnostics = vim.lsp.diagnostic.get(0)
  local items = parse_diagnostics(diagnostics, bufnr)
  vim.lsp.util.set_loclist(items)

  vim.cmd [[doautocmd QuickFixCmdPost]]
end

function M.setup()
  local autocmds = {
    lsp_loclist = {
      {"User", "LspDiagnosticsChanged", [[call v:lua.update_diagnostics_loclist()]]}
    }
  }

  utils.nvim_create_augroups(autocmds)
end

return M
