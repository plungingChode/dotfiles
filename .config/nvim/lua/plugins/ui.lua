local function lualine_harpoon_file()
	local harpoon = require("harpoon")
	local list = harpoon:list()
	local len = list:length()

	-- Deleting the only entry manually causes there to be a single `nil` entry
	-- in the list. This should not be displayed.
	if len == 0 or (len == 1 and list:get(1) == nil) then
		return ""
	end

	local active = -1
	local current_buf = vim.fn.expand("%")
	for i = 1, len do
		local harpooned = list:get(i)
		if current_buf:sub(-#harpooned.value) == harpooned.value then
			active = i
			break
		end
	end
	if active == -1 then
		return "⇁  ./" .. len
	else
		return "⇁ " .. active .. "/" .. len
	end
end

return {
	-- File explorer
	{
		"stevearc/oil.nvim",
		lazy = false,
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			default_file_explorer = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
			},
		},
		keys = {
			{ "<leader>pv", "<cmd>Oil<cr>", desc = "Open file explorer" },
		},
		dependencies = {
			{ "echasnovski/mini.icons", opts = {} },
		},
	},
	-- Replace netrw's `gx`
	{
		"chrishrb/gx.nvim",
		keys = {
			{ "gx", "<cmd>Browse<cr>", desc = "Open link" },
			{ "gx", "<cmd>Browse<cr>", mode = "x", desc = "Open link" },
		},
	},
	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = actions.delete_buffer,
						},
					},
				},
			})
			pcall(telescope.load_extension, "fzf")
		end,
		keys = function()
			local builtin = require("telescope.builtin")

			local find_in_buffer = function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end

			local find_current_word = function()
				builtin.grep_string({ search = vim.fn.expand("<cword>") })
			end

			-- stylua: ignore
			return {
				{ "<leader>b", builtin.buffers, desc = "[telescope] Find existing [b]uffers" },
				{ "<leader>/", find_in_buffer, desc = "[telescope] Find string in buffer" },
				{ "<leader>gw", find_current_word, desc = "[telescope] Find current word in buffer" },
				{ "<leader>gf", [["9y:vimgrep <C-r><C-9> % | copen<CR>]], desc = "[telescope] Search selection in current buffer", mode = "v", },
				{ "<leader>gf", [["9yw:vimgrep <C-r><C-9> % | copen<CR>]], desc = "[telescope] Search selection in current buffer", },
				{ "<leader>sf", builtin.find_files, desc = "[telescope] [S]earch [F]iles" },
				{ "<leader>sh", builtin.help_tags, desc = "[telescope] [S]earch [H]elp" },
				{ "<leader>sw", builtin.grep_string, desc = "[telescope] [S]earch current [W]ord" },
				{ "<leader>sg", builtin.live_grep, desc = "[telescope] [S]earch by [G]rep" },
				{ "<leader>sd", builtin.diagnostics, desc = "[telescope] [S]earch [D]iagnostics" },
				{ "<leader>zf", builtin.current_buffer_fuzzy_find, desc = "[telescope] Fuz[z]y [f]ind" },
				{ "<leader>rl", builtin.resume, desc = "[telescope] [R]esume [l]ast dialog" },
			}
		end,
	},
	-- Fuzzy finder implementation
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	-- Zen mode
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				width = 120,
				options = {
					number = true,
					relativenumber = true,
					cursorline = true,
				},
			},
		},
		config = function(_, opts)
			local zenmode = require("zen-mode")
			zenmode.setup(opts)

			local toggle_zenmode = function()
				zenmode.toggle()
				vim.wo.wrap = false
				vim.wo.number = true
				vim.wo.relativenumber = true
			end

			vim.keymap.set("n", "<leader>zz", toggle_zenmode, { desc = "Toggle zen mode" })
		end,
		keys = { "<leader>zz" },
	},
	-- Leap
	{
		"ggandor/leap.nvim",
		lazy = false,
		config = function()
			local leap = require("leap")
			leap.opts.highlight_unlabeled_phase_one_targets = true
			leap.create_default_mappings()
		end,
		-- keys = {
		-- 	{ "s", "<Plug>(leap-forward-to)" },
		-- 	{ "S", "<Plug>(leap-backward-to)" },
		-- },
	},
	-- Harpoon
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("harpoon"):setup()
		end,
		-- stylua: ignore
		keys = {
			{ "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon file", },
			{ "<leader>ho", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Toggle Harpoon quick menu", },

			{ "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Select Harpoon file 1", },
			{ "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Select Harpoon file 2", },
			{ "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Select Harpoon file 3", },
			{ "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Select Harpoon file 4", },
			{ "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Select Harpoon file 5", },
		},
	},
	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = false,
				-- theme = "nord",
				component_separators = "│",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics", { "harpoon", fmt = lualine_harpoon_file } },
				lualine_c = { "filename" },
				lualine_x = {},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},
	-- Undo tree
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
		},
		cmd = {
			"UndotreeToggle",
		},
	},
}

-- vim: sw=2 ts=2
