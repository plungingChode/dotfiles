local dap = require("dap")
local dapui = require("dapui")

-- PHP
dap.adapters.php = {
  type = "executable",
  command = "node",
  args = { os.getenv('HOME') .. "/source/vscode-php-debug/out/phpDebug.js" },
}

-- Javascript/Firefox
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
  }
}
dap.configurations.typescriptreact = dap.configurations.javascript
dap.configurations.typescript = dap.configurations.javascript

-- Godot
dap.adapters.godot = {
  type = "server",
  host = "127.0.0.1",
  port = 6006,
}

dap.configurations.gdscript = {
  {
    type = "godot",
    request = "launch",
    name = "Launch scene",
    project = "${workspaceFolder}",
    launch_scene = true,
  }
}

-- Go
require('dap-go').setup()

vim.keymap.set("n", "<F5>", dap.continue);
vim.keymap.set("n", "<S-F5>", function()
  dap.terminate()
  vim.cmd [[set cmdheight=1]]
  vim.cmd [[set laststatus=2]]
  dapui.close()
end);
vim.keymap.set("n", "<C-b>", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dlp", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message > "))
end)
vim.keymap.set("n", "<leader>dcp", function()
  dap.set_breakpoint(vim.fn.input("Condition > "), nil, nil)
end)
vim.keymap.set("n", "<F10>", dap.step_into);
vim.keymap.set("n", "<F11>", dap.step_over);
vim.keymap.set("n", "<F12>", dap.step_out);
vim.api.nvim_create_user_command("DapBreakOnExceptions", function(args)
  dap.set_exception_breakpoints()
end, {})

dap.listeners.after.event_initialized["dapui_config"] = function()
  vim.cmd [[set laststatus=3]]
  dapui.open()
end

vim.fn.sign_define('DapBreakpoint', {
  text = '●',
  texthl = 'DapBreakpoint',
  linehl = 'DapBreakpointLine',
  numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapBreakpointCondition', {
  text = '◆',
  texthl = 'DapLogPoint',
  linehl = 'DapLogPointLine',
  numhl = 'DapLogPoint',
})
vim.fn.sign_define('DapBreakpointRejected', {
  text = '',
  texthl = 'DapBreakpoint',
  linehl = 'DapBreakpointLine',
  numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapLogPoint', {
  text = '',
  texthl = 'DapLogPoint',
  linehl = 'DapLogPointLine',
  numhl = 'DapLogPoint',
})
vim.fn.sign_define('DapStopped', {
  text = '',
  texthl = 'DapStopped',
  linehl = 'DapStoppedLine',
  numhl = 'DapStopped'
})

dapui.setup({
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
    }
  }
})
