require("tokyonight").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  style = "night",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  light_style = "day",    -- The theme is used when the background is set to light
  transparent = true,     -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "transparent",       -- style for sidebars, see below
    floats = "dark",                -- style for floating windows
  },
  sidebars = { "qf", "help" },      -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3,             -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false,             -- dims inactive windows
  lualine_bold = false,             -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors)
    highlights.CursorLineNr               = { bg = "none", fg = colors.fg, bold = true }
    highlights.LineNr                     = { bg = "none", fg = colors.dark3, }
    highlights.TreesitterContext          = { bg = "none" }
    highlights.TreesitterContextSeparator = { bg = "none", fg = colors.dark5 }
    highlights.OctoEditable               = { bg = colors.black }
    highlights.DiagnosticVirtualTextError = {
      bg = 'none', fg = colors.error,
    }
    highlights.DiagnosticVirtualTextHint  = {
      bg = 'none', fg = colors.hint,
    }
    highlights.DiagnosticVirtualTextInfo  = {
      bg = 'none', fg = colors.info,
    }
    highlights.DiagnosticVirtualTextWarn  = {
      bg = 'none', fg = colors.warning,
    }
    highlights.SagaTitle                  = { bg = colors.black, fg = colors.info }
    highlights.SagaCount                  = { fg = colors.info, bg = colors.black }
    highlights.RenameNormal               = { bg = colors.black, fg = colors.magenta }
    highlights.ActionPreviewTitle         = { bg = colors.black, fg = colors.info }
    highlights.FloatBorder                = { bg = colors.black, fg = colors.border_highlight }
    --[[ highlights.WinbarNC                   = { bg = "none" }
    highlights.Winbar                     = { bg = "none" } ]]
    highlights.StatusLine                 = { bg = "none" }
  end,
})
