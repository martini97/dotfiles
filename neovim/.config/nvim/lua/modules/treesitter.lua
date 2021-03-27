require("nvim-treesitter.configs").setup({
  highlight = {enable = true},
  indent = {enable = true},
  ensure_installed = {
    "python",
    "lua",
    "yaml",
    "json",
    "javascript",
    "typescript",
  },
})
