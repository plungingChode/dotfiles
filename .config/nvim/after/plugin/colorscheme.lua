local c = require("nord.colors").palette
local nord = require("nord")

local overrides = {
  Normal = {
    fg = c.snow_storm.origin,
    bg = "#1E2127",
    -- bg = "#171717"
  },
  CursorLine = {
    bg = c.polar_night.origin
  },
  IncSearch = {
    fg = c.frost.artic_water,
    bg = c.none,
    reverse = true
  },
  Search = {
    fg = c.frost.polar_water,
    bg = c.none,
    reverse = true
  },
  -- tab pages line, not active tab page label
  TabLine = {
    fg = c.frost.ice,
    bg = c.polar_night.bright
  },
  -- tab pages line, where there are no labels
  TabLineFill = {
    fg = c.snow_storm.origin,
    bg = c.polar_night.bright
  },
  -- tab pages line, active tab page label
  TabLineSel = {
    fg = c.snow_storm.origin,
    bg = c.fg_gutter,
    bold = true,
  },
  -- Match Telescope borders to the background
  TelescopeBorder = {
    fg = c.polar_night.light,
    bg = c.none
  },
  -- Leap colors
  LeapBackdrop = {
    link = "Comment"
  },
  LeapMatch = {
    fg = c.snow_storm.brighter,
    bold = true
  },
  LeapLabelPrimary = {
    fg = c.aurora.yellow,
    bold = true
  },
  LeapLabelSecondary = {
    fg = c.aurora.green,
    bold = true
  },
  -- Diff view settings
  DiffAdd = {
    fg = c.none,
    bg = "#424D38",
  },
  DiffDelete = {
    fg = c.none,
    bg = "#592D32",
  },
  DiffChange = {
    fg = c.none,
    bg = "#4D422D",
  },
  DiffText = {
    fg = c.none,
    bg = "#5E5237",
  },
  -- Debug adapter breakpoints
  DapBreakpoint = {
    fg = c.aurora.red,
  },
  DapBreakpointLine = {
    bg = "#49272C",
  },
  DapLogPoint = {
    fg = c.aurora.purple,
  },
  DapLogPointLine = {
    bg = "#473845",
  },
  DapStopped = {
    fg = c.aurora.yellow,
  },
  DapStoppedLine = {
    bg = "#453C29",
  },
  -- Debug adapter UI
  DapUINormal = {
    fg = c.snow_storm.origin,
    bg = c.none,
  },
  DapUIScope = {
    link = "Keyword",
  },
  DapUILineNumber = {
    link = "Keyword",
  },
  DapUIValue = {
    link = "DapUINormal",
  },
  DapUIModifiedValue = {
    fg = c.frost.artic_water,
    bold = true
  },
  DapUISource = {
    link = "Keyword",
  },
  DapUIType = {
    link = "@type",
  },
  DapUIWatchesEmpty = {
    fg = c.aurora.yellow
  },
  DapUIWatchesValue = {
    link = "@type",
  },
  DapUIWatchesError = {
    fg = c.aurora.red
  },
  DapUIBreakpointsPath = {
    link = "Keyword",
  },
  DapUIBreakpointsInfo = {
    link = "@type",
  },
  DapUIBreakpointsCurrentLine = {
    fg = c.aurora.yellow,
    bold = true
  },
  DapUIBreakpointsDisabledLine = {
    link = "Comment",
  },
  DapUIThread = {
    link = "@type",
  },
  DapUIStoppedThread = {
    link = "Keyword",
  },
  DapUIDecoration = {
    link = "@type",
  },
  -- LSP overrides
  ["@lsp.type.type"] = {
    link = "@type",
  },
  ["@lsp.type.parameter"] = {
    fg = c.snow_storm.origin,
  },
}

nord.setup({
  transparent = true,
  diff = { mode = "fg" },
  errors = { mode = "fg" },
  styles = {
    comments = { italic = false },
  },
  on_highlights = function(hl)
    for k, v in pairs(overrides) do
      hl[k] = v
    end
  end,
})

vim.cmd [[colorscheme nord]]
