require('treesitter-context').setup({
  multiline_threshold = 3,
  min_window_height = 30,
  max_lines = 5,
})

local c = require("nord.colors").palette

vim.cmd([[hi TreeSitterContext guibg=Normal]])
vim.cmd([[hi TreesitterContextBottom gui=underline guisp=]] .. c.polar_night.bright)
vim.cmd([[hi TreesitterContextLineNumberBottom gui=underline guisp=]] .. c.polar_night.bright)
