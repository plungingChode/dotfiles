vim.bo.textwidth = 80

local config = require("nvim-surround.config")

require("nvim-surround").setup({
  surrounds = {
    -- (S)trong, bold
    ["S"] = {
      add = { "**", "**" },
      find = function()
        return config.get_selection({
          pattern = "%*%*.-%*%*"
        })
      end,
      delete = "^(..)().-(..)()$",
    },
    -- (I)talic
    ["I"] = {
      add = { "_", "_" },
      find = function()
        return config.get_selection({
          char = "_"
        })
      end,
      delete = "^(.)().-(.)()$",
    },
    -- (L)ine through
    ["L"] = {
      add = { "~~", "~~" },
      find = function()
        return config.get_selection({
          pattern = "~~.-~~"
        })
      end,
      delete = "^(..)().-(..)()$",
    },
    -- Link, (a)nchor
    ["A"] = {
      add = { "[", "]()" },
      find = function()
        local sel = config.get_selection({
          pattern = "%[.-%]%(.-%)"
        });
        print(vim.inspect(sel))
        return sel
      end,
      delete = "^(.)().-(.%(.-%))()$",
    }
  },
  -- TODO obisidian backlink
})
