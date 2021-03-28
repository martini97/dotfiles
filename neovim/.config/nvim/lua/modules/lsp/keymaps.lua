local M = {}

function M.set_keymaps(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  buf_set_keymap('n', 'K', [[<cmd>lua require('lspsaga.hover').render_hover_doc()]], opts)
  buf_set_keymap('n', 'gD', [[<Cmd>lua require('lspsaga.provider').preview_definition()<CR>]], opts)
  buf_set_keymap('n', 'gd', [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts)
  buf_set_keymap('n', 'gr', [[<cmd>lua require('lspsaga.rename').rename()<CR>]], opts)
  buf_set_keymap('n', 'gh', [[<cmd>lua require('lspsaga.provider').lsp_finder()<CR>]], opts)
  buf_set_keymap('n', '[d', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], opts)
  buf_set_keymap('n', ']d', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], opts)
  buf_set_keymap('n', '<C-k>', [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]], opts)
  buf_set_keymap('n', '<space>e', [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]], opts)
  buf_set_keymap('n', '<space>q', [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]], opts)
  buf_set_keymap('n', '<space>ca', [[<Cmd>lua require('lspsaga.codeaction').code_action()<CR>]], opts)
  buf_set_keymap('v', '<space>ca', [[:<C-U>lua require('lspsaga.codeaction').code_action()<CR>]], opts)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end
end

return M
