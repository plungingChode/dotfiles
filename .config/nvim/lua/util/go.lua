local M = {}

function M.create_debug_test_command()
	vim.api.nvim_create_user_command("DebugTest", function()
		require("dap-go").debug_test()
	end, {})
end

---
---@param keymap string|nil
function M.create_debug_last_test_command(keymap)
	vim.api.nvim_create_user_command("DebugLastTest", function()
		require("dap-go").debug_test()
	end, {})
	if keymap then
		vim.keymap.set("n", keymap, "<cmd>DebugLastTest<cr>", { desc = "Run last Go test in debug mode" })
	end
end

return M
