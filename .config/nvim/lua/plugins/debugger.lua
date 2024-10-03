local dap = require("dap")
local dap_ui = require("dapui")

local function config()
	-- Open DAP ui after debugging has started
	dap.listeners.after.event_initialized["dapui_config"] = function()
		vim.cmd([[set laststatus=3]])
		dap_ui.open()
	end

	vim.api.nvim_create_user_command("DapBreakOnExceptions", function()
		dap.set_exception_breakpoints()
	end, {})

	-- Define breakpoint highlights
	vim.fn.sign_define("DapBreakpoint", {
		text = "●",
		texthl = "DapBreakpoint",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpoint",
	})
	vim.fn.sign_define("DapBreakpointCondition", {
		text = "◆",
		texthl = "DapLogPoint",
		linehl = "DapLogPointLine",
		numhl = "DapLogPoint",
	})
	vim.fn.sign_define("DapBreakpointRejected", {
		text = "",
		texthl = "DapBreakpoint",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpoint",
	})
	vim.fn.sign_define("DapLogPoint", {
		text = "",
		texthl = "DapLogPoint",
		linehl = "DapLogPointLine",
		numhl = "DapLogPoint",
	})
	vim.fn.sign_define("DapStopped", {
		text = "",
		texthl = "DapStopped",
		linehl = "DapStoppedLine",
		numhl = "DapStopped",
	})

	dap_ui.setup({
		controls = {
			element = "repl",
			enabled = false,
		},
		icons = {
			collapsed = "›",
			current_frame = "›",
			expanded = "⌄",
		},
		layouts = {
			{
				elements = {
					{
						id = "breakpoints",
						size = 0.33,
					},
					{
						id = "stacks",
						size = 0.33,
					},
					{
						id = "scopes",
						size = 0.33,
					},
				},
				position = "left",
				size = 60,
			},
			{
				elements = {
					{
						id = "watches",
						size = 1.0,
					},
				},
				position = "bottom",
				size = 10,
			},
		},
	})

	-- PHP
	dap.adapters.php = {
		type = "executable",
		command = "node",
		args = { os.getenv("HOME") .. "/source/vscode-php-debug/out/phpDebug.js" },
	}

	-- Javascript/Typescript (Firefox)
	dap.adapters.firefox = {
		type = "executable",
		command = "node",
		args = { os.getenv("HOME") .. "/source/vscode-firefox-debug/dist/adapter.bundle.js" },
	}
	dap.configurations.javascript = {
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:19006",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = "/usr/bin/firefox-developer-edition",
			profileDir = "/home/pszigeti/.mozilla/firefox/1ojzzxh1.dev-edition-default",
		},
	}
	dap.configurations.typescriptreact = dap.configurations.javascript
	dap.configurations.typescript = dap.configurations.javascript

	require("dap-vscode-js").setup({
		-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
		debugger_path = os.getenv("HOME") .. "/source/vscode-js-debug", -- Path to vscode-js-debug installation.
		-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
		adapters = {
			"node",
			"chrome",
			"pwa-node",
			"pwa-chrome",
			"pwa-msedge",
			"node-terminal",
			"pwa-extensionHost",
		}, -- which adapters to register in nvim-dap
		-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
		-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
		-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
	})

	for _, language in ipairs({ "typescript", "javascript" }) do
		dap.configurations[language] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			-- {
			--   type = "pwa-node",
			--   request = "attach",
			--   name = "Attach",
			--   processId = require 'dap.utils'.pick_process,
			--   cwd = "${workspaceFolder}",
			-- }
		}
	end

	-- Go
	require("dap-go").setup()
end

local function terminate_debugger()
	dap.terminate()
	vim.cmd([[set cmdheight=1]])
	vim.cmd([[set laststatus=2]])
	dap_ui.close()
end

local function toggle_logpoint()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message > "))
end

local function toggle_conditional_breakpoint()
	dap.set_breakpoint(vim.fn.input("Condition > "), nil, nil)
end

return {
	-- Debug adapter UI
	{
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		config = config,
		-- stylua: ignore
		keys = {
			{ "<F5>", dap.continue, desc = "[dap] Continue debugger execution" },
			{ "<S-F5>", terminate_debugger, desc = "[dap] Terminate debugger" },
			{ "<C-b>", dap.toggle_breakpoint, desc = "[dap] Toggle line breakpoint" },
			{ "<leader>dlp", toggle_logpoint, desc = "[dap] Toggle log point" },
			{ "<leader>dcp", toggle_conditional_breakpoint, desc = "[dap] Toggle conditional breakpoint" },
			{ "<F10>", dap.step_into, desc = "[dap] Step into" },
			{ "<F11>", dap.step_over, desc = "[dap] Step over" },
			{ "<F12>", dap.step_out, desc = "[dap] Step out" },
		},
		cmd = {
			"DapBreakOnExceptions",
			"DapNew",
		},
	},
	-- Debug adapter
	{
		"mfussenegger/nvim-dap",
		lazy = true,
	},
	-- JS debug adapter
	{
		"mxsdev/nvim-dap-vscode-js",
		lazy = true,
		dependencies = { "mfussenegger/nvim-dap" },
	},
	-- Golang debug adapter
	{
		"leoluz/nvim-dap-go",
		lazy = true,
		dependencies = { "nvim-neotest/nvim-nio" },
	},
}
