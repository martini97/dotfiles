local colorbuddy = require('colorbuddy')
local Path = require('plenary.path')

local M = {}

local theme_file = Path:new(vim.env.XDG_CONFIG_HOME..'/.base16_theme')

local function set_vim_colorscheme(colorscheme)
  vim.cmd('colorscheme '..colorscheme)
  local handle
  handle = vim.loop.spawn(
    'nvr',
    { args = { "-c", "colorscheme "..colorscheme } },
    function ()
      handle:close()
    end
  )
end

local function set_kitty_colorscheme(colorscheme)
  vim.loop.spawn('kitty', {
    args = {
      '@',
      '--to',
      'unix:/tmp/mykitty',
      'set-colors',
      '-c',
      '-a',
      string.format(vim.env.HOME..'/.config/kitty/base16-kitty/colors/%s.conf', colorscheme)
    }
  }, nil)
end

local function fix_eof_colors()
  local Group = colorbuddy.Group
  local colors = colorbuddy.colors
  Group.new('EndOfBuffer', colors.foreground, colors.background)
end

function M.set_colorscheme(name)
  theme_file:write(name, 'w')
  set_vim_colorscheme(name)
  set_kitty_colorscheme(name)
  fix_eof_colors()
end

function M.get_colorscheme(from)
  if from == "vim" then
    return vim.g.colors_name
  elseif from == "file" then
    return theme_file:read()
  end
end

return M
