local M = {}

local nvim_lsp = require("lspconfig")
local saga = require("lspsaga")
local keymaps = require("modules.lsp.keymaps")


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
  tsserver = {},
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
