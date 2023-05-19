local leap = require('leap')

leap.opts.highlight_unlabeled_phase_one_targets = true

vim.keymap.set("n" , "s", "<Plug>(leap-forward-to)")
vim.keymap.set("n", "S", "<Plug>(leap-backward-to)")
vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
