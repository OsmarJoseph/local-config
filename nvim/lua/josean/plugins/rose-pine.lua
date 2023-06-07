local setup, rose_pine = pcall(require, "rose-pine")
if not setup then
  return
end

rose_pine.setup({
  disable_background = true,
  disable_float_background = true,
})
