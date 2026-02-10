local setup, oil = pcall(require, "oil")
if not setup then
  return
end

oil.setup({
  default_file_explorer = false,
  delete_to_trash = true,
  use_default_keymaps = false,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  }
})
