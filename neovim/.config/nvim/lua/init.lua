local reload = require("cfg.reload")
reload.unload_user_modules()

local log = require("cfg.log")
local layer = require("cfg.layer")
local autocmd = require("cfg.autocmd")
local plug = require("cfg.plug")

autocmd.init()
log.init()
plug.install()

local modules = {
  "editor";
  "style";
  "lsp";
  "git";
  "go";
  "python";
  "lua";
  "html";
  "js";
  "yaml";
  "fzf";
  "test";
  "bash";
  "vim";
  "json";
}
layer.load_modules(modules)
