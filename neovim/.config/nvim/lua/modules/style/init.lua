local plug = require("cfg.plug")
local autocmd = require("cfg.autocmd")
local vcmd = vim.cmd
local layer = {}

function layer.register_plugins()
  plug.add_plugin("itchyny/lightline.vim")
  plug.add_plugin("ryanoasis/vim-devicons")
  plug.add_plugin("patstockwell/vim-monokai-tasty")
end

local function set_globals()
  vim.wo.number = true
  vim.wo.relativenumber = true
  vim.wo.list = true
  vim.wo.listchars = "tab:│ ,eol: ,trail:·"
  vim.wo.cursorline = true
  vim.o.timeoutlen = 200
  vim.wo.signcolumn = "auto"

  -- lightline config
  vim.g.lightline = {
    active = {
      left = {
        {"mode"; "paste"};
        {"gitbranch"; "readonly"; "filename"; "modified"; "lineinfo"};
      };
      right = {{"lsp"}; {"gutentags"}};
    };
    tabline = {left = {{"buffers"}}; right = {{"close"}}};
    component_function = {
      gitbranch = "FugitiveStatusline";
      lsp = "LspStatus";
      gutentags = "gutentags#statusline";
    };
    colorscheme = "monokai_tasty";
  }
end

local function set_options()
  vim.o.termguicolors = true
  vim.o.showtabline = 1
  vim.o.splitright = true
  vim.o.scrolloff = 12
  vim.o.sidescrolloff = 12
  vim.o.showcmd = true
  vim.o.mouse = ""
  vim.o.pumblend = 10
  vim.o.winblend = 10
  vim.wo.colorcolumn = "100"
  vim.o.background = "dark"
  vim.g.vim_monokai_tasty_italic = 1
end

function layer.init_config()
  set_globals()
  set_options()

  autocmd.bind_colorscheme(function()
    vcmd(
      "highlight LspDiagnosticsError ctermfg=167 ctermbg=none guifg=#EB4917 guibg=none")
    vcmd(
      "highlight LspDiagnosticsWarning ctermfg=167 ctermbg=none guifg=#EBA217 guibg=none")
    vcmd(
      "highlight LspDiagnosticsInformation ctermfg=167 ctermbg=none guifg=#17D6EB guibg=none")
    vcmd(
      "highlight LspDiagnosticsHint ctermfg=167 ctermbg=none guifg=#17EB7A guibg=none")

    end)
    vcmd("colorscheme vim-monokai-tasty")
end

return layer
