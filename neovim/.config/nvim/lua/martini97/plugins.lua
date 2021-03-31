local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

vim.cmd [[autocmd BufWritePost plugins.lua PackerCompile ]]
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
  use {"wbthomason/packer.nvim", opt = true}

  use {"tjdevries/astronauta.nvim", config = function ()
    require('astronauta.keymap')
  end}

  use {"tpope/vim-unimpaired"}

  use {
    "tpope/vim-fugitive",
    requires = {"tpope/vim-rhubarb"},
    config = function ()
      require('martini97.modules.git').setup()
    end,
  }

  use {
    "sainnhe/sonokai",
    config = function ()
      vim.g.sonokai_style = 'andromeda'
      vim.g.sonokai_enable_italic = true
      vim.cmd [[colorscheme sonokai]]
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzy-native.nvim'},
    },
    config = function ()
      require('martini97.modules.telescope').setup()
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("martini97.modules.treesitter").setup()
    end,
  }

  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("martini97.modules.snippets")
      require("martini97.modules.lsp").setup()
    end,
    requires = {
      "glepnir/lspsaga.nvim",      -- better ui for lsp
      "hrsh7th/nvim-compe",        -- autocompletion
      "norcalli/snippets.nvim",    -- snippets handler
      "windwp/nvim-autopairs",     -- autopairing
    },
  }

  use {"editorconfig/editorconfig-vim"}

  use {
    'hoob3rt/lualine.nvim',
    config = function()
      require('martini97.modules.statusline').setup()
    end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  use {
    "szw/vim-maximizer",
    config = function()
      vim.g.maximizer_set_default_mapping = 0
      vim.api.nvim_set_keymap("n", "<C-w><Space>", ":MaximizerToggle<Cr>", { noremap = true })
    end,
  }

  use {
    "vim-test/vim-test",
    requires = {"christoomey/vim-tmux-runner"},
    config = function()
      require("martini97.modules.test").setup()
    end,
  }

  use {"romainl/vim-cool"}

  use {
    "~/Code/project-config.nvim",
    requires = {"nvim-lua/plenary.nvim"},
  }

  use {"kyazdani42/nvim-tree.lua"}
end)
