local M = {}

---
---@param repository string Remote repository name
function M.create_bitbucket_browser_command(repository)
	vim.api.nvim_create_user_command("BitbucketBrowse", function()
		local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
		local filename = string.gsub(vim.api.nvim_buf_get_name(0), vim.loop.cwd(), "")
		local commit = vim.fn.system("git rev-parse HEAD"):gsub("%s+$", "")
		local url = "https://bitbucket.org/" .. repository .. "/src/" .. commit .. filename .. "#lines-" .. line
		os.execute("xdg-open " .. url)
	end, {})
end

return M
