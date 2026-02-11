require("mini.ai").setup()
require("mini.surround").setup(
  {
    mappings = {
      add = 'S',
      delete = 'ds',
      replace = 'cs',
    },
  }
)

require("mini.operators").setup(
  {
    replace = {
      prefix = 'rp',
      reindent_linewise = true
    },
  }
)

require("mini.move").setup({
  mappings = {
    -- Move visual selection in Visual mode. Option/Alt + hjkl
    left = "",
    right = "",
    down = "<A-Down>",
    up = "<A-Up>",

    -- Move current line in Normal mode
    line_left = "",
    line_right = "",
    line_down = "<A-Down>",
    line_up = "<A-Up>",
  },
  -- Options which control moving behavior
  options = {
    -- Automatically reindent selection during linewise vertical move
    reindent_linewise = true,
  },
})

require("mini.cursorword").setup()

require("mini.cmdline").setup({
  autocomplete = {
    enable = true,

    -- Delay (in ms) after which to trigger completion
    -- Neovim>=0.12 is recommended for positive values
    delay = 500,

    -- Custom rule of when to trigger completion
    predicate = nil,

    -- Whether to map arrow keys for more consistent wildmenu behavior
    map_arrows = true,
  },
})


vim.opt.wildmenu = true
vim.keymap.set("c", "<Down>", "<C-n>")
vim.keymap.set("c", "<Up>", "<C-p>")
