local M = {}

---Execute the [phpstan_exe] and send the results to the quickfix list.
---
---@param phpstan_exe string|nil path to the PHPStan executable
function M.phpstan_analyse_to_quickfix(phpstan_exe)
	phpstan_exe = phpstan_exe or "./vendor/bin/phpstan"

  -- stylua: ignore
  local output = vim.fn.system({
    phpstan_exe, "analyse",
    "--configuration", "phpstan.neon",
    "--error-format", "raw",
    "--no-progress",
  })

	local qf_items = {}
	for output_line in output:gmatch("([^\n]*)\n") do
		local file_end = output_line:find(":", 1)
		local line_end = output_line:find(":", file_end + 1)
		local message_end = #output_line

		local filename = output_line:sub(1, file_end - 1)
		local line = output_line:sub(file_end + 1, line_end - 1)
		local message = output_line:sub(line_end + 1, message_end)

		table.insert(qf_items, {
			filename = filename,
			lnum = line,
			type = "E",
			text = message,
		})
	end

	vim.fn.setqflist(qf_items, "r")
	vim.cmd("cope")
end

---
---@param phpstan_exe string|nil path to the PHPStan executable
function M.create_phpstan_analyse_command(phpstan_exe)
	vim.api.nvim_create_user_command("PhpstanAnalyse", function()
		M.phpstan_analyse_to_quickfix(phpstan_exe)
	end, {})
end

---Initializes the default debug adapter configuration (Docker container,
---with sources mounted to `/var/www/html`)
function M.create_xdebug_configuration()
	require("dap").configurations.php = {
		{
			type = "php",
			request = "launch",
			name = "Listen for Xdebug",
			port = 9003,
			pathMappings = {
				["/var/www/html"] = vim.fn.getcwd(),
			},
		},
	}
end

return M

-- vim: sw=2 ts=2
