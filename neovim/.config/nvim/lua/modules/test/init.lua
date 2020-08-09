local plug = require("cfg.plug")
local edit_mode = require("cfg.edit_mode")
local keybind = require("cfg.keybind")
local kbc = keybind.bind_command

local layer = {}

function layer.register_plugins()
  plug.add_plugin("vim-test/vim-test")
end

function layer.init_config()
  vim.g["test#strategy"] = "neovim"
  kbc(edit_mode.NORMAL, ",tt", ":TestNearest<CR>", {noremap = true})
  kbc(edit_mode.NORMAL, ",tl", ":TestLast<CR>", {noremap = true})
end

return layer
