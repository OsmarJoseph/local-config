-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
  return
end

lualine.setup({
  sections = {
    lualine_a = { "mode" },
    lualine_x = { "filetype" },
  },
  extensions = { "fugitive", "nvim-tree" },
})
