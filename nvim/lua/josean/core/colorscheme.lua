local status, _ = pcall(vim.cmd, "colorscheme rose-pine") -- set colorscheme

if not status then
  print("Colorscheme not found!") -- print error if colorscheme not installed
  return
end

local theme = require("rose-pine.palette")

-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "LineNr", { bg = "none", fg = theme.muted })
-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
-- vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "none", fg = theme.foam })
-- vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "none", fg = theme.rose })
-- vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "none", fg = theme.love })
-- vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = "none", fg = theme.iris })
-- vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "none", fg = theme.gold })
-- vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none", fg = theme.love })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", fg = theme.love })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none", fg = theme.text, bold = true })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = theme.base })
