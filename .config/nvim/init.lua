require('packer').startup(function(use)
  -- Package manager
  use('wbthomason/packer.nvim')

  use({
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  })

  use({
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
  })

  use({
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  })

  -- use({
  --   -- Additional text objects via treesitter
  --   'nvim-treesitter/nvim-treesitter-textobjects',
  --   after = 'nvim-treesitter',
  -- })

  -- Git related plugins
  use({
    'tpope/vim-fugitive',
    after = 'nvim-treesitter'
  })
  use('tpope/vim-rhubarb')
  use('lewis6991/gitsigns.nvim')

  -- TODO one of the new commits breaks it altogether, check which one
  use({ 'Mofiqul/vscode.nvim', commit = 'db9ee33' }) -- VS Code dark theme
  use('aktersnurra/no-clown-fiesta.nvim')            -- normal color scheme
  use('gbprod/nord.nvim')
  use('lewpoly/sherbet.nvim')
  use('nvim-lualine/lualine.nvim')           -- Fancier statusline
  use('lukas-reineke/indent-blankline.nvim') -- Add indentation guides even on blank lines
  use('numToStr/Comment.nvim')               -- "gc" to comment visual regions/lines
  use('tpope/vim-sleuth')                    -- Detect tabstop and shiftwidth automatically

  use({
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      'nvim-lua/plenary.nvim',
    }
  })

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available
  use({
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable 'make' == 1
  })

  use({
    -- Surround selections
    "kylechui/nvim-surround",
    tag = "*",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  })

  -- Enhanced motion
  -- use({
  --     'aznhe21/hop.nvim',
  --     branch = 'fix-some-bugs',
  -- })

  use({
    'ggandor/leap.nvim',
    requires = {
      'tpope/vim-repeat'
    }
  })

  -- Reduce input lag for 'jj'
  use('nvim-zh/better-escape.vim')

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end
end)

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})


-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Split windows to the right instead
vim.o.splitright = true

-- Make line numbers default
vim.wo.number = true

-- Limit nvim-cmp suggestion count
vim.o.pumheight = 7

-- Set relative line numbers
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Disable wrapping by default
vim.wo.wrap = false

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
-- require('vscode').setup({})
require('nord').setup({
  transparent = true,
  diff = { mode = "fg" },
  errors = { mode = "fg" },
  styles = {
    comments = { italic = false },
  },
  on_highlights = function(highlights, colors)
    highlights["Normal"].bg = "#1E2127" 
    highlights["CursorLine"] = {
      bg = colors.polar_night.origin
    }
    highlights["IncSearch"] = {
      fg = colors.frost.artic_water,
      bg = colors.none,
      reverse = true
    }
    highlights["Search"] = {
      fg = colors.frost.polar_water,
      bg = colors.none,
      reverse = true
    }
    highlights["TelescopeBorder"] = {
      fg = colors.polar_night.light,
      bg = colors.none
    }
    highlights["LeapBackdrop"] = {
      link = "Comment"
    }
    highlights["LeapMatch"] = {
      fg = colors.snow_storm.brighter,
      bold = true
    }
    highlights["LeapLabelPrimary"] = {
      fg = colors.aurora.yellow,
      bold = true
    }
    highlights["LeapLabelSecondary"] = {
      fg = colors.aurora.green,
      bold = true
    }
    highlights["DiffAdd"] = {
      fg = colors.none,
      bg = "#424D38", 
    }
    highlights["DiffDelete"] = {
      fg = colors.none,
      bg = "#592D32",
    }
    highlights["DiffChange"] = {
      fg = colors.none,
      bg = "#4D422D",
    }
    highlights["DiffText"] = {
      fg = colors.none,
      bg = "#5E5237",
    }
  end,
})
vim.cmd [[colorscheme nord]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- > and >> should always shift to a multiple of the shift width
vim.o.shiftround = true

-- Show 5 lines when scrolling
vim.o.scrolloff = 5

-- Highlight cursor line
vim.o.cursorline = true

-- Neovide options
vim.g.neovide_cursor_animation_length = 0

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Easier indent/dedent
vim.keymap.set('n', '>', '>>', { silent = true });
vim.keymap.set('n', '<', '<<', { silent = true });
vim.keymap.set('v', '>', '>gv', { silent = true });
vim.keymap.set('v', '<', '<gv', { silent = true });

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "k" })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "j" })

-- Exit insert mode with `jj`
vim.g.better_escape_shortcut = 'jj'
vim.g.better_escape_interval = 200
-- vim.keymap.set('i', 'jj', '<Esc>', { silent = true })
--
-- Insert newline in normal mode with `K`
vim.keymap.set('n', 'K', 'i<Return><Esc>', { silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Toggle centered layout
local function vim_width()
  local width = vim.api.nvim_exec("set columns", true)
  return tonumber(width:sub(11))
end

local function center_around(window)
  -- Close windows besides the focused one
  vim.api.nvim_set_current_win(window)
  vim.cmd [[only]]

  config = {
    around = window,
    left_pad = nil,
    right_pad = nil,
  }

  local width = vim_width() / 6

  vim.cmd [[leftabove vnew]]
  vim.cmd [[set nocursorline]]
  left_win = vim.api.nvim_get_current_win()
  config.left_pad = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_hl_ns(left_win, 1)
  vim.api.nvim_win_set_width(left_win, width)
  vim.api.nvim_set_current_win(window)

  vim.cmd [[rightbelow vnew]]
  vim.cmd [[set nocursorline]]
  right_win = vim.api.nvim_get_current_win()
  config.right_pad = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_hl_ns(right_win, 1)
  vim.api.nvim_win_set_width(right_win, width)
  vim.api.nvim_set_current_win(window)

  vim.api.nvim_set_hl(1, "EndOfBuffer", { fg = "#1E2127"  })
  vim.api.nvim_win_set_option(left_win, "number", false)
  vim.api.nvim_win_set_option(left_win, "relativenumber", false)

  vim.api.nvim_win_set_option(right_win, "number", false)
  vim.api.nvim_win_set_option(right_win, "relativenumber", false)

  vim.g.centered = config
end

local function center_end()
  local config = vim.g.centered
  if not config then
    return
  end

  vim.cmd('bw ' .. config.left_pad)
  vim.cmd('bw ' .. config.right_pad)

  vim.g.centered = nil
end


vim.api.nvim_create_user_command(
  'Center',
  function() center_around(vim.api.nvim_get_current_win()) end,
  { desc = 'Center the currently active buffer' }
)

vim.api.nvim_create_user_command(
  'CenterEnd',
  center_end,
  { desc = 'Turn off centered layout for the active buffer' }
)

vim.cmd [[cab C Center]]
vim.cmd [[cab CE CenterEnd]]

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    -- theme = 'vscode',
    theme = 'nord',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup({
  char = '│',
  show_trailing_blankline_indent = false,
  -- char_highlight_list = { 'IndentBlanklineIndent1' },
})
-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#555555 gui=nocombine]]

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
            ['<C-u>'] = false,
            ['<C-d>'] = require('telescope.actions').delete_buffer,
            ['<esc>'] = require('telescope.actions').close,
      },
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = 'Find existing [b]uffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'c',
    'lua',
    'python',
    'rust',
    'astro',
    'typescript',
    'help',
    'vim',
    'svelte',
    'html',
    'css',
    'typescript',
    'tsx',
    'prisma',
    'graphql',
    'php',
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true,
    disable = { 'python' }
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>', -- yep
    },
  },
  -- textobjects = {
  --   select = {
  --     enable = true,
  --     lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
  --     keymaps = {
  --       -- You can use the capture groups defined in textobjects.scm
  --       ['aa'] = '@parameter.outer',
  --       ['ia'] = '@parameter.inner',
  --       ['af'] = '@function.outer',
  --       ['if'] = '@function.inner',
  --       ['ac'] = '@class.outer',
  --       ['ic'] = '@class.inner',
  --     },
  --   },
  --   move = {
  --     enable = true,
  --     set_jumps = true, -- whether to set jumps in the jumplist
  --     goto_next_start = {
  --       [']m'] = '@function.outer',
  --       [']]'] = '@class.outer',
  --     },
  --     goto_next_end = {
  --       [']M'] = '@function.outer',
  --       [']['] = '@class.outer',
  --     },
  --     goto_previous_start = {
  --       ['[m'] = '@function.outer',
  --       ['[['] = '@class.outer',
  --     },
  --     goto_previous_end = {
  --       ['[M'] = '@function.outer',
  --       ['[]'] = '@class.outer',
  --     },
  --   },
  --   swap = {
  --     enable = true,
  --     swap_next = {
  --       ['<leader>a'] = '@parameter.inner',
  --     },
  --     swap_previous = {
  --       ['<leader>A'] = '@parameter.inner',
  --     },
  --   },
  -- },
})
-- Separate setup for D2
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.d2 = {
  install_info = {
    url = 'https://github.com/pleshevskiy/tree-sitter-d2',
    revision = 'main',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
  filetype = 'd2',
};

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open diagnostic under cursor" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Set diagnostics as the location list" })

-- Virtual text is disabled by default (see mason_lspconfig.setup)
vim.g.virtual_text_disabled = true;
local function toggle_virtual_text()
  local new_state = not vim.g.virtual_text_disabled;
  vim.g.virtual_text_disabled = new_state;
  vim.diagnostic.config({ virtual_text = not new_state })
end

vim.keymap.set('n', '<leader>td', toggle_virtual_text, { desc = "[T]oggle [d]iagnostics virtual text" })

-- LSP settings.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  -- nmap('K', vim.lsp.buf.hover, 'Hover documentation')
  nmap('<leader>k', vim.lsp.buf.hover, 'Hover documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  local function array_contains(table, value)
    for _, v in pairs(table) do
      if v == value then
        return true
      end
    end
    return false
  end

  -- Create a command `:Format` local to the LSP buffer
  local use_prettierd = (
      array_contains(client.config.filetypes, 'typescript') or
      array_contains(client.config.filetypes, 'typescript.tsx') or
      array_contains(client.config.filetypes, 'typescriptreact') or
      array_contains(client.config.filetypes, 'javascript') or
      array_contains(client.config.filetypes, 'javascript.jsx') or
      array_contains(client.config.filetypes, 'javascriptreact')
      )

  if use_prettierd then
    vim.api.nvim_buf_create_user_command(
      bufnr, 'Format', '%!prettierd %',
      { desc = 'Format current buffer with prettierd' }
    )
  else
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end
end



-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  rust_analyzer = {},
  svelte = {},
  tsserver = {},
  texlab = {},
  pyright = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            -- Disable virtual_text
            virtual_text = false
          }
        ),
      }
    })
  end,
})

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

local cmp_kinds = {
  Text = ' ',
  Method = ' ',
  Function = ' ',
  Constructor = ' ',
  Field = ' ',
  Variable = ' ',
  Class = ' ',
  Interface = ' ',
  Module = ' ',
  Property = ' ',
  Unit = ' ',
  Value = ' ',
  Enum = ' ',
  Keyword = ' ',
  Snippet = ' ',
  Color = ' ',
  File = ' ',
  Reference = ' ',
  Folder = ' ',
  EnumMember = ' ',
  Constant = ' ',
  Struct = ' ',
  Event = ' ',
  Operator = ' ',
  TypeParameter = ' ',
}

cmp.setup({
  completion = {
    autocomplete = true
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete({ reason = cmp.ContextReason.auto }),
        ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
        ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
      return vim_item
    end,
  },
})

local leap = require('leap')
leap.add_default_mappings()
leap.opts.highlight_unlabeled_phase_one_targets = true

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
