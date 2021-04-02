require('astronauta.keymap')

P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

RLSP = function()
  vim.schedule_wrap(function()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.api.nvim_command("edit")
  end)
end

_G.martini97 = {}

require('martini97.globals.opt')
