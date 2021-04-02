local M = {}

local nvim_lsp = require("lspconfig")
local keymaps = require("martini97.lsp.keymaps")
local efm = {}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local flake8 = {
  lintCommand = "flake8 --max-line-length 160 --stdin-display-name ${INPUT} -",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintFormats = {"%f=%l:%c: %m"}
}

local isort = {
  formatCommand = "isort --stdout --profile black -",
  formatStdin = true
}

local black = {
  formatCommand = "black -",
  formatStdin = true
}

efm.languages = {
  javascript = {eslint},
  javascriptreact = {eslint},
  typescript = {eslint},
  typescriptreact = {eslint},
  python = {black, isort, flake8},
}

local function sumneko_cmd ()
  local system_name = ''
  if vim.fn.has("mac") == 1 then
    system_name = "macOS"
  elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
  elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
  end

  if not system_name then return {} end

  local root = vim.fn.expand('~/Code/lua-language-server')
  local binary = root ..  '/bin/' .. system_name .. '/lua-language-server'
  return {binary, "-E", root .. "/main.lua"}
end

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
  },
  sumneko_lua = {
    cmd = sumneko_cmd(),
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          enable = true,
          globals = {"vim", "describe", "it", "before_each", "after_each"},
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }
}

function M.setup()
  for server, config in pairs(servers) do
    if not config.on_attach then
      config.on_attach = make_on_attach(config)
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities(nvim_lsp[server])
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    config.capabilities = capabilities

    nvim_lsp[server].setup(config)
  end
end

return M
