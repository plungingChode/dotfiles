local leap = require('leap')
local c = require("nord.colors").palette

leap.opts.highlight_unlabeled_phase_one_targets = true

vim.keymap.set("n" , "s", "<Plug>(leap-forward-to)")
vim.keymap.set("n", "S", "<Plug>(leap-backward-to)")

local colors = {
  LeapMatch = {
    fg = c.snow_storm.brighter,
    bold = true
  },
  LeapLabelPrimary = {
    bg =  "#1E2127",
    fg = c.aurora.yellow,
    bold = true
  },
  LeapBackdrop = {
    link = "Comment"
  },
  LeapLabelSecondary = {
    fg = c.aurora.green,
    bg =  "#1E2127",
    bold = true
  },
}
for k, v in pairs(colors) do
  vim.api.nvim_set_hl(0, k, v)
end
