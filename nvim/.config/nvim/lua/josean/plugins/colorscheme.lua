require("rose-pine").setup({
  variant = "main",      -- Pinned to the base variant, so neither `moon` nor `dawn` is ever picked
  dim_inactive_windows = false,

  enable = {
    terminal = true, -- Configure the colors used when opening a `:terminal` in Neovim
  },

  styles = {
    bold = true,
    italic = true,       -- Rosé Pine only italicises comments; keywords are handled below
    transparency = true, -- Enable this to disable setting the background color
  },

  --- Override specific highlights. Colors accept Rosé Pine palette names
  --- (e.g. "muted") or hex values, and `none` maps to "NONE".
  --- Groups are merged with the built-ins unless `inherit = false`.
  ---
  --- NOTE: `transparency` already clears the background on StatusLine and
  --- TreesitterContext, and CursorLineNr already defaults to bold `text` with
  --- no background -- only the gaps Rosé Pine leaves are listed here.
  highlight_groups = {
    Keyword                    = { italic = true }, -- `@keyword` links here, so it follows
    TreesitterContextSeparator = { bg = "none", fg = "muted" },
  },
})
