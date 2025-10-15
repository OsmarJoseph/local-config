-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
  return
end

lualine.setup({
  sections = {
    lualine_a = { "mode" },
    lualine_b = { 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { "filetype" },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  extensions = { "fugitive", "nvim-tree" },
})
