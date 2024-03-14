-- Open Netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move selected lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Replace selection with yanked text
vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set({ "n", "i" }, "<C-v>", "<C-S-v>")

-- Keep cursor position when using J
vim.keymap.set("n", "J", "mzJ`z")

-- Yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Fix Ctrl+C for visual block mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Search selection/next word in current buffer

-- Initiate replacing next word/selected text
vim.keymap.set("n", "<leader>v", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>v", [[y:%s/<C-r><C-0>/<C-r><C-0>/gI<Left><Left><Left>]])

-- Easier indent/dedent
vim.keymap.set("n", ">", ">>", { silent = true });
vim.keymap.set("n", "<", "<<", { silent = true });
vim.keymap.set("v", ">", ">gv", { silent = true });
vim.keymap.set("v", "<", "<gv", { silent = true });

-- Move up/down wrapped lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "k" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "j" })

-- Navigate quickfix list, location list, diagnostics
vim.keymap.set("n", "]q", [[:cnext<CR>zz]])
vim.keymap.set("n", "[q", [[:cprev<CR>zz]])

vim.keymap.set("n", "]l", [[:lnext<CR>zz]])
vim.keymap.set("n", "[l", [[:lprev<CR>zz]])

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic under cursor" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set diagnostics as the location list" })
