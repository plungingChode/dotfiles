local treesitter = require("nvim-treesitter.configs")
-- local ts_commentstring = require("ts_context_commentstring")

vim.g.skip_ts_context_commentstring_module = true

---@diagnostic disable-next-line: missing-fields
treesitter.setup({
  ensure_installed = {
    "astro",
    "bash",
    "c",
    "css",
    "css",
    "fish",
    "go",
    "html",
    "javascript",
    "jsdoc",
    "kotlin",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "php",
    "python",
    "regex",
    "rust",
    "sql",
    "svelte",
    "tsx",
    "twig",
    "typescript",
    "vim",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  keymaps = {
    init_selection = false,
    node_incremental = false,
    scope_incremental = false,
    node_decremental = false,
  },
  indent = {
    enable = true,
    disable = {
      "python",
      "yaml",
      "typescript",
      "javascript",
      "tsx",
      "jsx",
    },
  },
  -- required for JoosepAlviste/nvim-ts-context-commentstring
  -- context_commentstring = {
  --   enable = true,
  --   enable_autocmd = false,
  -- },
})

-- required for JoosepAlviste/nvim-ts-context-commentstring
require('ts_context_commentstring').setup({
  enable_autocmd = false,
})
require("Comment").setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
