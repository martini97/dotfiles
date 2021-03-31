local M = {}

local telescope = require('telescope')
local actions = require('telescope.actions')

local opts = {noremap = true}
local mappings = {
  {
    "n",
    "<space>fg",
    [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]],
    opts,
  },
  {
    "n",
    "<space>ff",
    [[<Cmd>lua require("telescope.builtin").find_files()<CR>]],
    opts
  },
  {
    "n",
    "<space>fc",
    [[<Cmd>lua require("telescope.builtin").find_files{cwd = "~/.config/nvim"}<CR>]],
    opts,
  },
  {
    "n",
    "<space>fb",
    [[<Cmd>lua require("telescope.builtin").buffers()<CR>]],
    opts
  },
  {
    "n",
    "<space>f.",
    [[<Cmd>lua require'telescope.builtin'.git_files({ cwd = "~/Code/dotfiles" })<CR>]],
    opts
  },
}

function M.setup()
  telescope.setup({
    defaults = {
      shorten_path = false,
      mappings = {
        i = {
          ["<Esc>"] = actions.close,
          ["<C-q>"] = actions.smart_send_to_qflist,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next,
        },
      },
    },
  })
  telescope.load_extension("fzy_native")

  for _, map in pairs(mappings) do
    vim.api.nvim_set_keymap(unpack(map))
  end
end

return M
