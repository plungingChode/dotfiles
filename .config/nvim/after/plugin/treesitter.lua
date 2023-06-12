local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  ensure_installed = {
    "c",
    "lua",
    "python",
    "rust",
    "astro",
    "typescript",
    "javascript",
    "help",
    "vim",
    "svelte",
    "html",
    "css",
    "tsx",
    "php",
    "jsdoc",
    "sql",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { "python", "yaml" }
  },
  -- required for JoosepAlviste/nvim-ts-context-commentstring
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
})

-- required for JoosepAlviste/nvim-ts-context-commentstring
require("Comment").setup {
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
}
