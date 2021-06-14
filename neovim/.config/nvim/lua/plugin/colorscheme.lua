-- based on https://rrethy.github.io/book/colorscheme.html

local action_state = require('telescope.actions.state')
local telescope_actions= require('telescope.actions')
local telescope_action_set = require('telescope.actions.set')
local Path = require('plenary.path')
local colorbuddy = require('colorbuddy')

local function leader(key)
  return "<space>c"..key
end

-- this is our single source of truth created above
-- local base16_theme_fname = vim.fn.expand(vim.env.XDG_CONFIG_HOME..'/.base16_theme')
local base16_theme_file = Path:new(vim.env.XDG_CONFIG_HOME..'/.base16_theme')
-- this function is the only way we should be setting our colorscheme
local function set_colorscheme(name)
  -- write our colorscheme back to our single source of truth
  base16_theme_file:write(name, 'w')
  -- vim.fn.writefile({name}, base16_theme_fname)
  -- set Neovim's colorscheme
  vim.cmd('colorscheme '..name)
  -- execute `kitty @ set-colors -c <color>` to change terminal window's
  -- colors and newly created terminal windows colors
  vim.loop.spawn('kitty', {
    args = {
      '@',
      '--to',
      'unix:/tmp/mykitty',
      'set-colors',
      '-c',
      '-a',
      string.format(vim.env.HOME..'/.config/kitty/base16-kitty/colors/%s.conf', name)
    }
  }, nil)
end

local function color_picker()
  -- get our base16 colorschemes
  local colors = vim.fn.getcompletion('base16', 'color')
  -- we're trying to mimic VSCode so we'll use dropdown theme
  local theme = require('telescope.themes').get_dropdown()
  -- create our picker
  require('telescope.pickers').new(theme, {
    prompt = 'Change Base16 Colorscheme',
    finder = require('telescope.finders').new_table {
      results = colors
    },
    sorter = require('telescope.config').values.generic_sorter(theme),
    attach_mappings = function(bufnr)
      -- change the colors upon selection
      telescope_actions.select_default:replace(function()
        set_colorscheme(action_state.get_selected_entry().value)
        telescope_actions.close(bufnr)
      end)
      telescope_action_set.shift_selection:enhance({
        -- change the colors upon scrolling
        post = function()
          set_colorscheme(action_state.get_selected_entry().value)
        end
      })
      return true
    end
  }):find()
end

vim.keymap.nnoremap {leader"c", color_picker}

if base16_theme_file:exists() then
  local colorscheme = base16_theme_file:read()
  if colorscheme ~= vim.g.colors_name then
    vim.cmd('colorscheme '..colorscheme)
    -- fix eof weird colors
    --   -- highlight EndOfBuffer ctermfg=fg guifg=fg ctermbg=bg guibg=bg
    local Group = colorbuddy.Group
    local colors = colorbuddy.colors
    Group.new('EndOfBuffer', colors.foreground, colors.background)
  end
end
