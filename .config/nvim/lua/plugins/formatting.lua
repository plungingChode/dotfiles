local function config()
	local conform = require("conform")

	conform.setup({
		formatters_by_ft = {
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			json = { "prettierd" },
			fish = { "fish_indent" },
			lua = { "stylua" },
			sh = { "shfmt" },
			-- yaml = { "yamlfmt" },
		},

		format_on_save = {
			lsp_format = "fallback",
			async = false,
			timeout_ms = 500,
		},
	})
end

local function format()
	local conform = require("conform")
	if not conform.format({ bufnr = 0 }) then
		vim.lsp.buf.format()
	end
end

return {
	{
		"stevearc/conform.nvim",
		config = config,
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{ "<leader>f", format, desc = "Format current buffer" },
		},
	},
}
