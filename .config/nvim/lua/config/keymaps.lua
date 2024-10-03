-- Move selected lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Replace selection with yanked text
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Replace selection with text on clipboard" })

-- Keep cursor position when using J
vim.keymap.set("n", "J", "mzJ`z", { desc = "J" })

-- Fix Ctrl+C for visual block mode
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Initiate replacing next word/selected text
-- stylua: ignore
vim.keymap.set("n", "<leader>v", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace all occurrences of the current word" })
-- stylua: ignore
vim.keymap.set( "v", "<leader>v", [[y:%s/<C-r><C-0>/<C-r><C-0>/gI<Left><Left><Left>]], { desc = "Replace all occurrences of the selected text" })

-- Easier indent/dedent
vim.keymap.set("n", ">", ">>", { silent = true, desc = "Increase indent" })
vim.keymap.set("n", "<", "<<", { silent = true, desc = "Increase indent" })
vim.keymap.set("v", ">", ">gv", { silent = true, desc = "Decrease indent" })
vim.keymap.set("v", "<", "<gv", { silent = true, desc = "Decrease indent" })

-- Move up/down wrapped lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "k" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "j" })

-- Navigate quickfix list, location list, diagnostics
vim.keymap.set("n", "]q", [[:cnext<CR>zz]], { desc = "Go to next quickfix list item" })
vim.keymap.set("n", "[q", [[:cprev<CR>zz]], { desc = "Go to previous quickfix list item" })

vim.keymap.set("n", "]l", [[:lnext<CR>zz]], { desc = "Go to next location list item" })
vim.keymap.set("n", "[l", [[:lprev<CR>zz]], { desc = "Go to next location list item" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic under cursor" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set diagnostics as the location list" })
