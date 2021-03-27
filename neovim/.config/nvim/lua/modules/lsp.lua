local nvim_lsp = require("lspconfig")
local saga = require("lspsaga")

require("compe").setup {
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
    vim_dadbod = true,
  },
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.api.nvim_set_keymap(
  "i", "<C-Space>", "compe#complete()",
  {expr = true, silent = true, noremap = true}
)

vim.api.nvim_set_keymap(
  "i", "<CR>", "compe#confirm('<CR>')",
  {expr = true, silent = true, noremap = true}
)

local servers = {
  "pyright",
  "tsserver"
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup{}
end
