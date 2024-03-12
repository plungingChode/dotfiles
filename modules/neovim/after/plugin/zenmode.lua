local zenmode = require("zen-mode")

vim.keymap.set("n", "<leader>zz", function()
  zenmode.setup({
    window = {
      width = 120,
      options = {
        number = true,
        relativenumber = true,
        cursorline = true,
      }
    }
  })
  zenmode.toggle()
  vim.wo.wrap = false
  vim.wo.number = true
  vim.wo.relativenumber = true
end)
