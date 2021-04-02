local M = {}

local telescope = require('telescope')
local actions = require('telescope.actions')
local t_builtin = require 'telescope.builtin'

local function leader(key)
  return "<space>f" .. key
end

local function grep()
	t_builtin.live_grep()
end

local function files()
	t_builtin.find_files()
end

local function vimrc()
	t_builtin.find_files {cwd = "~/.config/nvim"}
end

local function buffers()
	t_builtin.buffers()
end

local function dotfiles()
	t_builtin.git_files { cwd = "~/Code/dotfiles" }
end


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

  vim.keymap.nnoremap {leader"g", grep}
  vim.keymap.nnoremap {leader"f", files}
  vim.keymap.nnoremap {leader"c", vimrc}
  vim.keymap.nnoremap {leader"b", buffers}
  vim.keymap.nnoremap {leader".", dotfiles}
end

return M
