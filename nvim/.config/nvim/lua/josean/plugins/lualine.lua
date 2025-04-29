-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
  return
end

local kanagawa_paper = require("lualine.themes.kanagawa-paper-ink")

lualine.setup({
  sections = {
    lualine_a = { "mode" },
    lualine_x = { "filetype" },
  },
  extensions = { "fugitive", "nvim-tree" },
  options = {
    theme = kanagawa_paper,
  },
})
