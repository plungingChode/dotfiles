local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
end

local harpoon = require("harpoon")
local function harpoon_file()
  local list = harpoon:list()
  local len = list:length()
  if len == 0 then
    return ""
  end

  local active = -1
  local current_buf = vim.fn.expand("%")
  for i = 1, len do
    local harpooned = list:get(i)
    if harpooned.value == current_buf then
      active = i
      break
    end
  end
  if active == -1 then
    return "⇁  ./" .. len
  else
    return "⇁ " .. active .. "/" .. len
  end
end


require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = "nord",
    component_separators = "│",
    section_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics", { "harpoon", fmt = harpoon_file } },
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = { "progress" },
    lualine_z = { "location" }
  }
})
