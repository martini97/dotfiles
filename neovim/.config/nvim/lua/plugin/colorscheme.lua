-- based on https://rrethy.github.io/book/colorscheme.html

local action_state = require('telescope.actions.state')
local telescope_actions= require('telescope.actions')
local telescope_action_set = require('telescope.actions.set')
local colorscheme_utils = require('martini97.colorscheme')

local function leader(key)
  return "<space>c"..key
end

local function color_picker()
  local colors = vim.fn.getcompletion('base16', 'color')
  local theme = require('telescope.themes').get_dropdown()
  require('telescope.pickers').new(theme, {
    prompt = 'Change Base16 Colorscheme',
    finder = require('telescope.finders').new_table {
      results = colors
    },
    sorter = require('telescope.config').values.generic_sorter(theme),
    attach_mappings = function(bufnr)
      telescope_actions.select_default:replace(function()
        colorscheme_utils.set_colorscheme(action_state.get_selected_entry().value)
        telescope_actions.close(bufnr)
      end)
      telescope_action_set.shift_selection:enhance({
        post = function()
          colorscheme_utils.set_colorscheme(action_state.get_selected_entry().value)
        end
      })
      return true
    end
  }):find()
end

vim.keymap.nnoremap {leader"c", color_picker}

local colorscheme = colorscheme_utils.get_colorscheme("file")
if colorscheme ~= colorscheme_utils.get_colorscheme("vim") then
  colorscheme_utils.set_colorscheme(colorscheme)
end
