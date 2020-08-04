local has_lsp, nvim_lsp = pcall(require, 'nvim_lsp')
local has_completion, completion = pcall(require, 'completion')
local has_diagnostic, diagnostic = pcall(require, 'diagnostic')

if not has_lsp then
  return
end

-- highlights
vim.fn.sign_define('LspDiagnosticsErrorSign', {text='✖ ' or 'E', texthl='LspDiagnosticsError', linehl='', numhl=''})
vim.fn.sign_define('LspDiagnosticsWarningSign', {text='⚠' or 'W', texthl='LspDiagnosticsWarning', linehl='', numhl=''})
vim.fn.sign_define('LspDiagnosticsInformationSign', {text='ℹ' or 'I', texthl='LspDiagnosticsInformation', linehl='', numhl=''})
vim.fn.sign_define('LspDiagnosticsHintSign', {text='➤' or 'H', texthl='LspDiagnosticsHint', linehl='', numhl=''})

vim.api.nvim_command('highlight! link LspDiagnosticsError DiffDelete')
vim.api.nvim_command('highlight! link LspDiagnosticsWarning DiffChange')
vim.api.nvim_command('highlight! link LspDiagnosticsHint NonText')

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local resolved_capabilities = client.resolved_capabilities

  if has_diagnostic then
    diagnostic.on_attach()
  end

  if has_completion then
    completion.on_attach()
  end

  -- Mappings.
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  if resolved_capabilities.document_highlight then
    vim.api.nvim_command[[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.api.nvim_command[[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.api.nvim_command[[autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()]]
  end
end

local servers = {
  {name = 'vimls'},
  {
    name = 'pyls',
    config = {
      cmd = {vim.g.python3_host_prog, "-m", "pyls"},
    },
  },
  {
    name = 'tsserver',
    config = {
      root_dir = nvim_lsp.util.root_pattern("tsconfig.json", ".git"),
    }
  },
  {
    name = 'jsonls',
    config = {
      settings = {
        json = {
          schemas = {
            {
              description = 'TypeScript compiler configuration file',
              fileMatch = {'tsconfig.json', 'tsconfig.*.json'},
              url = 'http://json.schemastore.org/tsconfig'
            },
            {
              description = 'Babel configuration',
              fileMatch = {'.babelrc.json', '.babelrc', 'babel.config.json'},
              url = 'http://json.schemastore.org/lerna'
            },
            {
              description = 'ESLint config',
              fileMatch = {'.eslintrc.json', '.eslintrc'},
              url = 'http://json.schemastore.org/eslintrc'
            },
            {
              description = 'Prettier config',
              fileMatch = {'.prettierrc', '.prettierrc.json', 'prettier.config.json'},
              url = 'http://json.schemastore.org/prettierrc'
            },
          }
        },
      },
    }
  },
  {
    name = 'yamlls',
    config = {
      settings = {
        yaml = {
          schemas = {
            ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*.{yml,yaml}',
            ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
            ['http://json.schemastore.org/ansible-stable-2.9'] = 'roles/tasks/*.{yml,yaml}',
            ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
            ['http://json.schemastore.org/stylelintrc'] = '.stylelintrc.{yml,yaml}',
            ['http://json.schemastore.org/circleciconfig'] = '.circleci/**/*.{yml,yaml}'
          }
        }
      },
    }
  },
}

for _, lsp in ipairs(servers) do
  if lsp.config then
    lsp.config.on_attach = on_attach
  else
    lsp.config = {
      on_attach = on_attach
    }
  end

  nvim_lsp[lsp.name].setup(lsp.config)
end

-- Send diagnostics to quickfix
do
  local method = "textDocument/publishDiagnostics"
  local default_callback = vim.lsp.callbacks[method]
  vim.lsp.callbacks[method] = function(err, method, result, client_id)
    default_callback(err, method, result, client_id)
    if result and result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.bufnr = client_id
        v.lnum = v.range.start.line + 1
        v.col = v.range.start.character + 1
        v.text = v.message
      end
      vim.lsp.util.set_qflist(result.diagnostics)
    end
  end
end
