local M = {}
local treesitter = require("nvim-treesitter.configs")

function M.setup()
  treesitter.setup({
    highlight = {enable = true},
    indent = {enable = true},
    ensure_installed = {
      "python",
      "lua",
      "yaml",
      "json",
      "javascript",
      "typescript",
      "tsx",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      }
    }
  })

  vim.cmd [[
     set foldmethod=expr
     set foldexpr=nvim_treesitter#foldexpr()
  ]]
end

return M
