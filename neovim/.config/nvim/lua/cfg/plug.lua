local file = require("cfg.file")
local plug = {}
local plugins_dir = vim.fn.stdpath("data") .. "/plugged"
local plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"

-- install vim plug if not installed
function plug.install()
  local autocmd = require("cfg.autocmd")
  local url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

  if file.exists(plug_path) then
    return
  end

  vim.api.nvim_exec("!curl -fLo " .. plug_path .. " --create-dirs " .. url, false)
  autocmd.bind_vim_enter(function()
    vim.cmd("PlugInstall --sync | source $MYVIMRC")
  end)
end

--- Start loading all registered plugins
function plug.finish_plugin_registration()
  vim.fn["plug#begin"](plugins_dir)

  for _, v in pairs(plug.plugins) do
    if type(v) == "string" then
      vim.fn["plug#"](v)
    elseif type(v) == "table" then
      local pkg = v[1]
      assert(pkg ~= nil, "Must specify package as first index")
      v[1] = nil
      vim.fn["plug#"](pkg, v)
    end
  end

  vim.fn["plug#end"]()

  plug.finished_plugin_init = true
end

plug.finished_plugin_init = false
plug.plugins = {}

--- Register a plugin
function plug.add_plugin(plugin, options)
  assert(not plug.finished_plugin_init,
         "Tried to add a plugin after plugin registration was over")
  if options == nil then
    table.insert(plug.plugins, plugin)
  else
    options[1] = plugin
    table.insert(plug.plugins, options)
  end
end

--- Check if a plugin has been registered
function plug.has_plugin(plugin)
  plugin = "/" .. plugin

  for _, v in pairs(plug.plugins) do
    if type(v) == "string" then
      if vim.endswith(v, plugin) then
        return true
      end
      if vim.endswith(v, plugin .. ".git") then
        return true
      end
    elseif type(v) == "table" then
      if vim.endswith(v[1], plugin) then
        return true
      end
      if vim.endswith(v[1], plugin .. ".git") then
        return true
      end
    end
  end

  return false
end

return plug
