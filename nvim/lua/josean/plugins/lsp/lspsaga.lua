-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
  return
end

saga.setup({
  -- keybinds for navigation in lspsaga window
  scroll_preview = { scroll_down = "<C-Space>j", scroll_up = "<C-Space>k" },
  -- use enter to open file with definition preview
  definition = {
    edit = "<CR>",
    quit = "<ESC>",
  },
  finder = {
    keys = {
      expand_or_jump = "<CR>", -- open definition or jump to it
    },
  },
  code_action = {
    keys = {
      quit = "<ESC>",
    },
  },
  diagnostic = {
    keys = {
      quit = "<ESC>",
      quit_in_show = { "q", "<ESC>" },
    },
  },
  outline = {
    keys = {
      expand_or_jump = "<CR>",
    },
  },
  rename = {
    quit = "<ESC>",
    in_select = false,
  },
  lightbulb = {
    enabled = false,
    enable_in_insert = false,
    sign = false,
    virtual_text = false,
  },
  ui = {
    colors = {
      normal_bg = "#022746",
    },
  },
})
