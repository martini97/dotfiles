local M = {}

local nvim_lsp = require("lspconfig")
local saga = require("lspsaga")
local keymaps = require("modules.lsp.keymaps")
local efm = require("modules.lsp.efm")


local function make_on_attach(config)
  return function (client, bufnr)
    if config.before then config.before(config, client, bufnr) end

    keymaps.set_keymaps(client, bufnr)

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

    if config.after then config.after(config, client, bufnr) end
  end
end

local servers = {
  pyright = {},
  tsserver = {
    before = function (_, client, _)
      if client.config.flags then
        client.config.flags.allow_incremental_sync = true
      end
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end,
  },
  efm = {
    before = function (_, client, _)
      client.resolved_capabilities.document_range_formatting = true
      client.resolved_capabilities.document_formatting = true
      client.resolved_capabilities.goto_definition = false
    end,
    root_dir = nvim_lsp.util.root_pattern("yarn.lock", "lerna.json", ".git"),
    init_options = {documentFormatting = true, codeAction = true},
    settings = {
      rootMarkers = {".git/"},
      log_level = 1,
      log_file = '~/efm.log',
      languages = efm.languages,
    },
    filetypes = vim.tbl_keys(efm.languages),
  }
}

function M.setup()
  for server, config in pairs(servers) do
    if not config.on_attach then
      config.on_attach = make_on_attach(config)
    end
    nvim_lsp[server].setup(config)
  end
end

return M
