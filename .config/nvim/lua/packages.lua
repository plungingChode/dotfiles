return require("packer").startup(function(use)
  -- Package manager
  use("wbthomason/packer.nvim")

  -- LSP Support
  use({
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    requires = {
      { "neovim/nvim-lspconfig" }, -- Required
      {
        -- Optional
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },     -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" },     -- Required
      { "j-hui/fidget.nvim" },    -- Optional, show loading
      { "folke/neodev.nvim" },    -- Optional, nvim_* API docs
    }
  })

  -- Highlight, edit, and navigate code
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
    requires = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    }
  })

  -- Git related plugins
  use({
    "tpope/vim-fugitive",
    after = "nvim-treesitter"
  })
  use("tpope/vim-rhubarb")
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
  use("mfussenegger/nvim-dap")
  use({
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" }
  })
  use("ThePrimeagen/harpoon")
  use("nvim-treesitter/playground")
end)
