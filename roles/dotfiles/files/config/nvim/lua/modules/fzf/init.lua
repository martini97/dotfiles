local plug = require("cfg.plug")
local edit_mode = require("cfg.edit_mode")
local keybind = require("cfg.keybind")
local kbc = keybind.bind_command

local layer = {}

function layer.register_plugins()
  plug.add_plugin("junegunn/fzf", {["do"] = "fzf#install()"})
  plug.add_plugin("junegunn/fzf.vim")
end

function layer.init_config()
  vim.g.fzf_history_dir = vim.fn.stdpath('cache') .. '/fzf-history'
  vim.g.fzf_layout = {window = {width = 0.6, height = 0.6}}
  vim.g.fzf_action = {
    ['ctrl-t'] = 'tab split',
    ['ctrl-s'] = 'split',
    ['ctrl-v'] = 'vsplit',
  }
  vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob '!.git/*'"
  vim.env.FZF_DEFAULT_OPTS = '--reverse'

  kbc(edit_mode.NORMAL, "<c-f>", ":Files<CR>", {noremap = true})
  kbc(edit_mode.NORMAL, "<c-b>", ":Buffers<CR>", {noremap = true})
end

return layer
