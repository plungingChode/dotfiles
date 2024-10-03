return {
	-- Autocomplete
	{
		"hrsh7th/nvim-cmp",
		version = false, -- load latest commit
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		-- TODO
		-- config = function(_, opts)
		-- 	local cmp = require("cmp")
		--
		-- 	cmp.setup.cmdline({ "/", "?" },  {
		-- 		mapping = cmp.mapping.preset.cmdline(),
		-- 		sources = {
		-- 			{ name = "buffer" }
		-- 		}
		-- 	})
		-- end
	},
	-- NVim Lua type definitions
	{
		"folke/lazydev.nvim",
		ft = "lua",
	},
	-- Git
	{ "tpope/vim-fugitive" },
	{ "lewis6991/gitsigns.nvim" },
	-- Split / join function arguments
	{
		"echasnovski/mini.splitjoin",
		version = "*",
		opts = {
			mappings = {
				toggle = "gJ",
			},
		},
	},
	-- Detect tabstop and shiftwidth automatically
	{ "tpope/vim-sleuth" },
	-- Add indentation guides even on blank lines
	{ "lukas-reineke/indent-blankline.nvim" },
	-- Code snippets
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
		},
		config = function(_, opts)
			require("luasnip").setup(opts)
			require("luasnip.loaders.from_lua").load({
				paths = vim.fn.stdpath("config") .. "/snippets",
			})
		end,
	},
	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		opts = {
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		},
	},
	-- Comment strings for JSX/TSX files
	-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = {
			enable_autocommand = false, -- required when used with Comment.nvim
		},
	},
	-- Surround selections
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = function()
			local config = require("nvim-surround.config")

			return {
				surrounds = {
					-- (S)trong, bold
					["S"] = {
						add = { "**", "**" },
						find = function()
							return config.get_selection({
								pattern = "%*%*.-%*%*",
							})
						end,
						delete = "^(..)().-(..)()$",
					},
					-- (I)talic
					["I"] = {
						add = { "_", "_" },
						find = function()
							return config.get_selection({
								char = "_",
							})
						end,
						delete = "^(.)().-(.)()$",
					},
					-- (L)ine through
					["L"] = {
						add = { "~~", "~~" },
						find = function()
							return config.get_selection({
								pattern = "~~.-~~",
							})
						end,
						delete = "^(..)().-(..)()$",
					},
					-- Link, (a)nchor
					["A"] = {
						add = { "[", "]()" },
						find = function()
							local sel = config.get_selection({
								pattern = "%[.-%]%(.-%)",
							})
							-- print(vim.inspect(sel))
							return sel
						end,
						delete = "^(.)().-(.%(.-%))()$",
					},
				},
				-- TODO obisidian backlink
			}
		end,
	},
	-- Project-specific configurations (.nvim.lua)
	{ "klen/nvim-config-local" },
}

-- vim: ts=2 sw=2
