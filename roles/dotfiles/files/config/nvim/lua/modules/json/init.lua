local autocmd = require("cfg.autocmd")
local layer = {}

function layer.register_plugins()
end

local function on_filetype_json()
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")
  local config = {
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

  lsp.register_server(nvim_lsp.jsonls, config)

  autocmd.bind_filetype("json", on_filetype_json)
end

return layer
