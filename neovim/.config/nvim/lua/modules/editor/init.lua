local plug = require("cfg.plug")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local autocmd = require("cfg.autocmd")
local kbc = keybind.bind_command
local vcmd = vim.cmd

local layer = {}

function layer.register_plugins()
  plug.add_plugin("sheerun/vim-polyglot")
  plug.add_plugin("skywind3000/asyncrun.vim")
  plug.add_plugin('machakann/vim-sandwich')
  plug.add_plugin('romainl/vim-qf')
  plug.add_plugin('romainl/vim-cool')
  plug.add_plugin('ludovicchabant/vim-gutentags')
end

function layer.python3_provider()
  local neovim_python = (os.getenv("WORKON_HOME") or "") .. "/neovim/bin/python"
  if vim.fn.executable(neovim_python) then
    return neovim_python
  end
  return "python3"
end

function layer.set_globals()
  vim.g.loaded_python_provider = 0
  vim.g.loaded_perl_provider = 0

  vim.g.python3_host_prog = layer.python3_provider()
  vim.g.node_host_prog = vim.fn.exepath("neovim-node-host")
  vim.g.ruby_host_prog = vim.fn.exepath("neovim-ruby-host")

  -- Vim-QA
  vim.g.qf_shorten_path = 0
  vim.g.qf_auto_resize = 1
  vim.g.qf_mapping_ack_style = 1
end

function layer.set_options()
  vim.api.nvim_buf_set_option(0, "softtabstop", 2)
  vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
  vim.api.nvim_buf_set_option(0, "expandtab", true)
  vim.api.nvim_buf_set_option(0, "autoindent", true)
  vim.api.nvim_buf_set_option(0, "autoread", true)
  vim.api.nvim_buf_set_option(0, "smartindent", true)
  vim.api.nvim_buf_set_option(0, "swapfile", false)
  vim.api.nvim_buf_set_option(0, "textwidth", 0)
  vim.api.nvim_buf_set_option(0, "tabstop", 2)
  vim.api.nvim_buf_set_option(0, "undofile", true)

  vim.o.expandtab = true
  vim.o.undodir = vim.fn.stdpath("data") .. "/undo"
  vim.o.hidden = true
  vim.o.updatetime = 50
  vim.o.foldmethod = "marker"
  vim.o.exrc = true
  vim.o.secure = true
  vim.o.wildmode = "longest,list,full"
  vim.o.inccommand = "split"
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.shortmess = vim.o.shortmess .. "c"
  vim.o.wildignore = vim.o.wildignore .. "*/node_modules/*,*/__pycache__/*"
  vim.o.wildmenu = true

  if vim.fn.executable("rg") == 1 then
    vim.o.grepprg = "rg --vimgrep --no-column --smart-case --color=never"
  end
end

--- Configures vim and plugins for this layer
function layer.init_config()
  layer.set_globals()
  layer.set_options()

  -- Edit files in current dir
  kbc(edit_mode.NORMAL, "<space>er", ":r <c-r>=expand('%:.:h') . '/'<cr>", {noremap = true})
  kbc(edit_mode.NORMAL, "<space>ew", ":e <c-r>=expand('%:.:h') . '/'<cr>", {noremap = true})
  kbc(edit_mode.NORMAL, "<space>es", ":sp <c-r>=expand('%:.:h') . '/'<cr>", {noremap = true})
  kbc(edit_mode.NORMAL, "<space>ev", ":vs <c-r>=expand('%:.:h') . '/'<cr>", {noremap = true})

  -- Emacs like binding on cmd line
  kbc(edit_mode.COMMAND, "<c-a>", "<home>", {noremap = true})
  kbc(edit_mode.COMMAND, "<c-e>", "<end>", {noremap = true})
  kbc(edit_mode.COMMAND, "<c-k>", "<up>", {noremap = true})
  kbc(edit_mode.COMMAND, "<c-j>", "<down>", {noremap = true})

  -- Vmap for maintain Visual Mode after shifting > and <
  kbc(edit_mode.VISUAL, "<", "<gv")
  kbc(edit_mode.VISUAL, ">", ">gv")
  kbc(edit_mode.VISUAL, "J", ":m '>+1<CR>gv=gv")
  kbc(edit_mode.VISUAL, "K", ":m '<-2<CR>gv=gv")

  -- Close current buffer
  kbc(edit_mode.NORMAL, "<space>x", ":bn<cr>:bd#<cr>", {noremap = true})

  -- Remeber last cursor position
  autocmd.bind("BufReadPost *", function()
    local line_nr_quote = vim.api.nvim_call_function('line', {"'\""})
    local line_nr_last = vim.api.nvim_call_function('line', {"$"})
    local filetype = vim.bo[0].filetype
    local nonofiletypes = {
      ['commit'] = true,
      ['gitcommit'] = true,
      ['fugitive'] = true,
    }
    if line_nr_quote >= 1 and line_nr_quote <= line_nr_last and not nonofiletypes[filetype] then
      vcmd("normal! g`\"")
    end
  end)

  -- Highlight yanks
  autocmd.bind("TextYankPost *", function()
    require('vim.highlight').on_yank()
  end)

  -- A shortcut command for :lua print(vim.inspect(...)) (:Li for Lua Inspect)
  vcmd("command! -nargs=+ Li :lua print(vim.inspect(<args>))")
  vcmd("command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>")

  -- Return asyncrun status
  vim.api.nvim_exec([[
    function! AsyncrunStatus() abort
      let status = get(g:, 'asyncrun_status', '')
      if status == 'running'
        return ' running'
      elseif status == 'failure'
        return ' error'
      endif
      return ''
    endfunction
    ]], false)
end

return layer
