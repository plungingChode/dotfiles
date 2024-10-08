vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set highlight on search
vim.o.hlsearch = false
vim.opt.incsearch = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Split windows to the right instead
vim.o.splitright = true

-- Make line numbers default
vim.wo.number = true

-- Limit nvim-cmp suggestion count
vim.o.pumheight = 8

-- Set relative line numbers
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

vim.o.clipboard = vim.o.clipboard .. "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Disable wrapping by default
vim.wo.wrap = false

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- > and >> should always shift to a multiple of the shift width
vim.o.shiftround = true

-- Show 8 lines when scrolling
vim.o.scrolloff = 8

-- Highlight cursor line
vim.o.cursorline = true

vim.o.foldmethod = "marker"

-- Enable project-local configuration extension
vim.o.exrc = true

-- Disable SQL omni completion
vim.g.omni_sql_no_default_maps = 1
