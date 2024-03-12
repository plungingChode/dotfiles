require("packages")
require("opts")
require("remap")

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local cmdline_group = vim.api.nvim_create_augroup("NoiceCursorline", { clear = true });
vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = cmdline_group,
  callback = function ()
    vim.o.cursorline = false
  end
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = cmdline_group,
  callback = function ()
    vim.o.cursorline = true
  end
})
