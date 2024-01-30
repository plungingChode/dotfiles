vim.g.mapleader = " "
vim.g.maplocalleader = " "

return require("lazy").setup({
  -- Package manager
  { "folke/lazy.nvim" },

  -- LSP Support
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      { "neovim/nvim-lspconfig" }, -- Required
      {
        -- Optional
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
      },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },     -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" },     -- Required
      { "j-hui/fidget.nvim" },    -- Optional, show loading
      { "folke/neodev.nvim" },    -- Optional, nvim_* API docs
    }
  },

  -- Highlight, edit, and navigate code
  {
    "nvim-treesitter/nvim-treesitter",
    -- Typescript indentation is broken after this one, see
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4842
    commit = "aa44e5fc5f301eb934698b04c71e65b44c21c4fe",
    build = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
      local fn = vim.fn
      fn.system({
        'cp',
        fn.stdpath('config') .. '/treesitter-indent-works.lua',
        fn.stdpath('config') .. '/site/pack/packer/start/nvim-treesitter/lua/nvim-treesitter/indent.lua'
      })
    end,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    }
  },

  -- Git related plugins
  { "tpope/vim-fugitive" },
  -- { "tpope/vim-rhubarb" }
  { "lewis6991/gitsigns.nvim" },

  { "gbprod/nord.nvim" },
  { "nvim-lualine/lualine.nvim" },           -- Fancier statusline
  { "lukas-reineke/indent-blankline.nvim" }, -- Add indentation guides even on blank lines
  { "numToStr/Comment.nvim" },               -- "gc" to comment visual regions/lines
  { "tpope/vim-sleuth" },                    -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- Surround selections
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end
  },

  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
  },

  {
    "mbbill/undotree",
    event = "VeryLazy"
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "ggandor/leap.nvim" },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" }
  },
  { "ThePrimeagen/harpoon" },
  -- { "nvim-treesitter/playground" },
  { "leoluz/nvim-dap-go" },

  {
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup()
    end
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    requires = { "mfussenegger/nvim-dap" }
  },

  -- ("akinsho/flutter-tools.nvim")
})
