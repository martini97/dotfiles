local M = {}

local nvim_lsp = require("lspconfig")
local saga = require("lspsaga")
local compe = require("compe")

local servers = {
  "pyright",
  "tsserver"
}

local function completion_setup()
  compe.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,

    source = {
      path = true,
      buffer = true,
      calc = true,
      nvim_lsp = true,
      nvim_lua = true,
      spell = true,
      snippets_nvim = true,
    },
  }

  vim.api.nvim_set_keymap(
    "i", "<C-Space>", "compe#complete()",
    {expr = true, silent = true, noremap = true}
  )

  vim.api.nvim_set_keymap(
    "i", "<CR>", "compe#confirm('<CR>')",
    {expr = true, silent = true, noremap = true}
  )
end

local function on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', [[<Cmd>lua require('lspsaga.provider').preview_definition()<CR>]], opts)
  buf_set_keymap('n', 'gd', [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts)
  buf_set_keymap('n', 'gr', [[<cmd>lua require('lspsaga.rename').rename()<CR>]], opts)
  buf_set_keymap('n', 'gR', [[<cmd>lua vim.lsp.buf.references()<CR>]], opts)
  buf_set_keymap('n', 'K', [[<Cmd>lua vim.lsp.buf.hover()<CR>]], opts)
  buf_set_keymap('n', '<C-k>', [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]], opts)
  buf_set_keymap('n', '<space>e', [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]], opts)
  buf_set_keymap('n', '[d', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], opts)
  buf_set_keymap('n', ']d', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], opts)
  buf_set_keymap('n', '<space>q', [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]], opts)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

function M.setup()
 completion_setup()

  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup{  on_attach = on_attach }
  end
end

return M
