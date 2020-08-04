if exists("g:loaded_lua_plugin")
  finish
endif
let g:loaded_lua_plugin = 1

if has('nvim') && exists('*luaeval')
  lua require 'init'
endif
