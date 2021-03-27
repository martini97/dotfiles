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

  use {"tpope/vim-fugitive", "tpope/vim-rhubarb"}

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
      require('modules.telescope')
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("modules.treesitter")
    end,
  }

  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("modules.lsp")
    end,
    requires = {"glepnir/lspsaga.nvim", "hrsh7th/nvim-compe"},
  }
end)
