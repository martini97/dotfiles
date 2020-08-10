local plug = require("cfg.plug")
local edit_mode = require("cfg.edit_mode")
local keybind = require("cfg.keybind")
local kbc = keybind.bind_command
local vcmd = vim.cmd

local layer = {}

function layer.register_plugins()
  plug.add_plugin("tpope/vim-fugitive")
  plug.add_plugin("tpope/vim-rhubarb")
end

function layer.init_config()
  kbc(edit_mode.NORMAL, "<space>gs", ":Gstatus<CR>", {noremap = true})
  vcmd("command! -range GB echo join(systemlist('git -C ' . shellescape(expand('%:p:h')) . ' blame -L <line1>,<line2> ' . expand('%:t')), '\n')")
end

return layer
