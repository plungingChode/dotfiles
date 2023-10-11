local ibl = require("ibl")

local highlight = {
  "Whitespace"
}

ibl.setup({
  indent = {
    highlight = highlight,
    char = "│"
  },
  scope = { enabled = false },
  whitespace = {
    highlight = highlight,
    remove_blankline_trail = false,
  }
})


-- Refresh indents afer the window was scrolled horizontally
vim.api.nvim_create_augroup('IndentBlankLineFix', {})
vim.api.nvim_create_autocmd('WinScrolled', {
  group = 'IndentBlankLineFix',
  callback = function()
    if vim.v.event.all.leftcol ~= 0 then
      vim.cmd('silent! IndentBlanklineRefresh')
    end
  end,
})
