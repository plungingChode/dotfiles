require("lualine").setup {
  options = {
    icons_enabled = false,
    theme = "nord",
    component_separators = "│",
    section_separators = "",
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = {},
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
}
