local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  -- Package manager
  use("wbthomason/packer.nvim")

  -- LSP Support
  use({
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    requires = {
      { "neovim/nvim-lspconfig" }, -- Required
      -- {
      --   -- Optional
      --   "williamboman/mason.nvim",
      --   build = function()
      --     pcall(vim.cmd, "MasonUpdate")
      --   end,
      -- },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },     -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" },     -- Required
      { 'saadparwaiz1/cmp_luasnip' },
      { "j-hui/fidget.nvim", },   -- Optional, show loading
      { "folke/neodev.nvim" },    -- Optional, nvim_* API docs
    }
  })

  -- Highlight, edit, and navigate code
  use({
    "nvim-treesitter/nvim-treesitter",
    -- Typescript indentation is broken after this one, see
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4842
    -- commit = "aa44e5fc5f301eb934698b04c71e65b44c21c4fe",
    run = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
      local fn = vim.fn
      fn.system({
        'cp',
        fn.stdpath('config') .. '/treesitter-indent-works.lua',
        fn.stdpath('config') .. '/site/pack/packer/start/nvim-treesitter/lua/nvim-treesitter/indent.lua'
      })
    end,
    requires = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    }
  })

  -- Git related plugins
  use("tpope/vim-fugitive")
  -- use("tpope/vim-rhubarb")
  use("lewis6991/gitsigns.nvim")

  use("gbprod/nord.nvim")
  use("nvim-lualine/lualine.nvim")           -- Fancier statusline
  use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
  use("numToStr/Comment.nvim")               -- "gc" to comment visual regions/lines
  use("tpope/vim-sleuth")                    -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = { "nvim-lua/plenary.nvim" }
  })

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    cond = vim.fn.executable "make" == 1
  })

  -- Surround selections
  use({
    "kylechui/nvim-surround",
    tag = "*",
    config = function()
      require("nvim-surround").setup({})
    end
  })

  use({
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({})
    end
  })

  use("mbbill/undotree")
  use("nvim-treesitter/nvim-treesitter-context")
  use("ggandor/leap.nvim")
  use({
    "mfussenegger/nvim-dap",
    requires = {
      "nvim-neotest/nvim-nio"
    }
  })
  use({
    "rcarriga/nvim-dap-ui",
    requires = {
      "mfussenegger/nvim-dap"
    }
  })
  use({
    "ThePrimeagen/harpoon",
    branch = "harpoon2"
  })
  -- use("nvim-treesitter/playground")
  use("leoluz/nvim-dap-go")

  use({
    "klen/nvim-config-local",
    config = function()
      require('config-local').setup()
    end
  })
  use({
    "mxsdev/nvim-dap-vscode-js",
    requires = { "mfussenegger/nvim-dap" }
  })

  -- use("akinsho/flutter-tools.nvim")
  use({
    "stevearc/oil.nvim",
    requires = {
      "nvim-tree/nvim-web-devicons",
      "chrishrb/gx.nvim"
    },
  });

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
