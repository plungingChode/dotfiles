local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = actions.delete_buffer,
      }
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(telescope.load_extension, "fzf")

vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Find existing [b]uffers" })
vim.keymap.set("n", "<leader>/", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>gw", function()
  builtin.grep_string({ search = vim.fn.expand("<cword>") })
end)
vim.keymap.set("v", "<leader>gf", [["9y:vimgrep <C-r><C-9> % | copen<CR>]])
vim.keymap.set("n", "<leader>gf", [["9yw:vimgrep <C-r><C-9> % | copen<CR>]])

vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>zf", builtin.current_buffer_fuzzy_find, { desc = "Fuz[z]y [f]ind" })
