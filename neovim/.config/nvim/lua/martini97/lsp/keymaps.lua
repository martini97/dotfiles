local M = {}

local codeaction = require 'lspsaga.codeaction'
local hover = require 'lspsaga.hover'
local utils = require 'martini97.utils'

local function has_lsp_capability(capability)
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.resolved_capabilities[capability] == true then
      return true
    end
  end
  return false
end

local function code_action()
  if has_lsp_capability('code_action') then
    codeaction.code_action()
  end
end

local function format()
  if has_lsp_capability('document_formatting') then
    vim.lsp.buf.formatting()
  elseif has_lsp_capability('document_range_formatting') then
    vim.lsp.buf.range_formatting()
  else
    utils.asyncformat()
  end
end

local function go_to_definition()
  if has_lsp_capability('goto_definition') then
    vim.lsp.buf.definition()
  end
end

local function show_docs()
  if has_lsp_capability('hover') then
    hover.render_hover_doc()
  end
end

local function find_references()
  if has_lsp_capability('find_references') then
    vim.lsp.buf.references()
  else
    utils.asyncgrep(nil, { full_word = true })
  end
end


function M.set_keymaps(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  if client.resolved_capabilities.completion then
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  end

  vim.keymap.nnoremap {"<space>ca", code_action, silent = false, buffer = true}
  vim.keymap.vnoremap {"<space>ca", code_action, silent = true, buffer = true}
  vim.keymap.nnoremap {"<space>=", format, silent = true, buffer = true}
  vim.keymap.vnoremap {"<space>=", format, silent = true, buffer = true}
  vim.keymap.nnoremap {"gd", go_to_definition, silent = false, buffer = true}
  vim.keymap.nnoremap {"K", show_docs, silent = true, buffer = true}
  vim.keymap.nnoremap {"gh", find_references, silent = false, buffer = true}

  if client.resolved_capabilities.rename then
    buf_set_keymap('n', 'gr', [[<cmd>lua require('lspsaga.rename').rename()<CR>]], opts)
  end

  buf_set_keymap('n', '[d', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], opts)
  buf_set_keymap('n', ']d', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], opts)
  buf_set_keymap('n', '<C-k>', [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]], opts)
  buf_set_keymap('n', '<space>e', [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]], opts)
  buf_set_keymap('n', '<space>q', [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]], opts)
end

return M
