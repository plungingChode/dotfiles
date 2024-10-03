local ensure_installed = {
	"lua_ls",
	"astro-language-server",
	"typescript-language-server",
}

local cmp_kinds = {
	Text = " ",
	Method = " ",
	Function = " ",
	Constructor = " ",
	Field = " ",
	Variable = " ",
	Class = " ",
	Interface = " ",
	Module = " ",
	Property = " ",
	Unit = " ",
	Value = " ",
	Enum = " ",
	Keyword = " ",
	Snippet = " ",
	Color = " ",
	File = " ",
	Reference = " ",
	Folder = " ",
	EnumMember = " ",
	Constant = " ",
	Struct = " ",
	Event = " ",
	Operator = " ",
	TypeParameter = " ",
}

local function on_attach(_, bufnr)
	local telescope = require("telescope.builtin")
	local map = function(mode, keys, func, desc)
		if desc then
			desc = "[lsp] " .. desc
		end

		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
	end

	map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [a]ction")

	map("n", "gd", vim.lsp.buf.definition, "[G]oto [d]efinition")
	map("n", "gr", telescope.lsp_references, "[G]oto [r]eferences")
	map("n", "<leader>d", vim.lsp.buf.type_definition, "Type [d]efinition")
	map("n", "<leader>ds", telescope.lsp_document_symbols, "[D]ocument [s]ymbols")
	map("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [s]ymbols")

	map("n", "K", vim.lsp.buf.hover, "Hover documentation")
	map({ "n", "i" }, "<C-h>", vim.lsp.buf.signature_help, "Signature help")
end

local function config()
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	local mason = require("mason")
	local mason_lspconfig = require("mason-lspconfig")

	mason.setup({})
	mason_lspconfig.setup({ ensure_installed })

	vim.diagnostic.config({
		virtual_text = false,
	})

	-- Lua
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
				},
				diagnostics = {
					globals = { "vim" },
				},
				telemetry = {
					enable = false,
				},
				codeLens = {
					enable = false,
				},
				completion = {
					callSnippet = "Replace",
				},
				doc = {
					privateName = { "^_" },
				},
				hint = {
					enable = true,
					setType = false,
					paramType = true,
					paramName = "Disable",
					semicolon = "Disable",
					arrayIndex = "Disable",
				},
			},
		},
	})

	-- PHP
	lspconfig.phpactor.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- Typescript, Javascript
	lspconfig.ts_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- Tailwind CSS
	lspconfig.tailwindcss.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- Svelte
	lspconfig.svelte.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- Astro
	lspconfig.svelte.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- CSS
	lspconfig.cssls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- HTML
	lspconfig.html.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- JSON
	lspconfig.jsonls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- Go
	lspconfig.gopls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- SQL
	lspconfig.sqlls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- Python
	lspconfig.pyright.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- OpenAPI (JSON/yaml)
	lspconfig.spectral.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	local cmp = require("cmp")
	local luasnip = require("luasnip")
	cmp.setup({
		mapping = cmp.mapping.preset.insert({
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete({ reason = cmp.ContextReason.auto }),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.locally_jumpable(1) then
					luasnip.jump(1)
				else
					fallback()
				end
			end, { "i", "s" }),

			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
			-- ["<C-n>"] = cmp_action.luasnip_jump_forward(),
			-- ["<C-p>"] = cmp_action.luasnip_jump_backward(),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "buffer", keyword_length = 3 },
			{ name = "luasnip", keyword_length = 2 },
			-- { name = "lazydev", group_index = 0 },
		}),
		formatting = {
			format = function(_, vim_item)
				vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
				return vim_item
			end,
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
	})

	-- Set max width of hover documentation
	-- https://neovim.discourse.group/t/3276
	local orig_open_floating_preview = vim.lsp.util.open_floating_preview
	vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
		opts = opts or {}
		opts.max_width = opts.max_width or 120
		return orig_open_floating_preview(contents, syntax, opts, ...)
	end
end

return {
	-- LSP config
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
			{ "williamboman/mason-lspconfig.nvim", config = function() end },
		},
		config = config,
	},
	-- Command line tools and LSP servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)

			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
}

-- vim: sw=2 ts=2
