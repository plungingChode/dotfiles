local u = require("util")
local cmp = require("cmp")
local lsp = require("lsp-zero")
local lsp_util = require("lspconfig").util
local telescope = require("telescope.builtin")

local cmp_action = lsp.cmp_action()

-- require("mason-lspconfig").setup({
--   ensure_installed = {
--     "lua_ls"
--   }
-- });

lsp = lsp.preset({
  float_border = "none",
  manage_nvim_cmp = {
    set_format = false
  }
})

-- nvim API types
require("neodev").setup()

lsp.configure("lua_ls", {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        globals = { "vim" }
      }
    }
  }
})

-- lsp.configure("phpactor", {
--   root_dir = lsp_util.root_pattern(".phpactor.json", "composer.json", ".git")
-- })

-- lsp.configure("tailwindcss", {
--   settings = {
--     tailwindCSS = {
--       colorDecorators = false,
--       codeActions = false,
--       suggestions = false,
--       validate = false,
--       files = {
--         exclude = {
--           "**/.git/**",
--           "**/node_modules/**",
--           "**/.hg/**",
--           "**/.svn/**",
--           "*.php",
--         }
--       },
--       experimental = {
--         classRegex = {
--           'tailwind\\("(.*)"\\)',
--           'tw\\("(.*)"\\)'
--         }
--       }
--     }
--   }
-- });

local on_attach = function(client, bufnr)
  local map = function(mode, keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
  end

  map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  map("n", "gr", telescope.lsp_references, "[G]oto [R]eferences")
  map("n", "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  map("n", "<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
  map("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  map("n", "K", vim.lsp.buf.hover, "Hover documentation")
  map({ "n", "i" }, "<C-h>", vim.lsp.buf.signature_help, "Signature documentation")

  -- Format languages that prettier supports with prettier
  local use_prettierd = u.table_contains(
    client.config.filetypes,
    {
      "typescript",
      "typescript.tsx",
      "typescriptreact",
      "javascript",
      "javascript.jsx",
      "javascriptreact",
    }
  )

  local keymaps = vim.api.nvim_get_keymap("n")

  for _, mapping in pairs(keymaps) do
    if mapping['lhs'] == ' f' then
      return
    end
  end

  if use_prettierd then
    vim.api.nvim_buf_create_user_command(
      bufnr, "Format", function()
        vim.cmd [[set lz]]
        vim.cmd [[%!prettierd %]]
        vim.cmd [[set nolz]]
      end,
      { desc = "Format current buffer with prettier" }
    )
    map("n", "<leader>f", "mz:Format<CR>`z", "[F]ormat current buffer")
  else
    vim.api.nvim_buf_create_user_command(
      bufnr, "Format", function(_)
        vim.lsp.buf.format()
      end, { desc = "Format current buffer with LSP" }
    )
    map("n", "<leader>f", ":Format<CR>", "[F]ormat current buffer")
  end
end

lsp.on_attach(on_attach)

local cmp_kinds = {
  Text = " ",
  Method = " ",
  Function = " ",
  Constructor = " ",
  Field = " ",
  Variable = " ",
  Class = " ",
  Interface = " ",
  Module = " ",
  Property = " ",
  Unit = " ",
  Value = " ",
  Enum = " ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = " ",
  Folder = " ",
  EnumMember = " ",
  Constant = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
}

cmp.setup({
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({ reason = cmp.ContextReason.auto }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ["<Tab>"] = cmp_action.tab_complete(),
    -- ["<C-n>"] = cmp_action.luasnip_jump_forward(),
    -- ["<C-p>"] = cmp_action.luasnip_jump_backward(),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer",  keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
  },
  formatting = {
    format = function(_, vim_item)
      print(vim.inspect(vim_item))
      vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
      return vim_item
    end,
  },
})

require("lspconfig").gdscript.setup({
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150
  }
})

lsp.setup()

vim.diagnostic.config({
  virtual_text = false
})

-- Set max width of hover documentation
-- https://neovim.discourse.group/t/3276
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
  opts = opts or {}
  opts.max_width = opts.max_width or 80
  return orig_open_floating_preview(contents, syntax, opts, ...)
end
