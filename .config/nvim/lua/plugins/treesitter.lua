return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				sync_install = false,
				ensure_installed = {
					-- "c",
					-- "lua",
					-- "python",
					-- "rust",
					-- "astro",
					-- "typescript",
					-- "javascript",
					-- "vim",
					-- "svelte",
					-- "html",
					-- -- "css",
					-- "tsx",
					-- "php",
					-- "phpdoc",
					-- "jsdoc",
					-- "sql",
					-- "go",
					-- "css",
					-- "kotlin",
					-- "twig",
					-- "markdown",
					-- "markdown_inline",
					-- "bash",
					-- "fish",
					-- "regex",
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
			})
		end,
	},
}
