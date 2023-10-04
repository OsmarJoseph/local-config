-- import nvim-tree plugin safely
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end

local api = require("nvim-tree.api")

-- recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd(':command! -nargs=1 Browse silent execute "!open" shellescape(<q-args>,1)') -- enables :Browse command for GBrowse

local function opts(desc, bufnr)
  return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
end

local function collapse_all_and_keep_buffers()
  api.tree.collapse_all(true)
end

local function my_on_attach(bufnr)
  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', 'W', collapse_all_and_keep_buffers, opts('collapse all and keep buffers', bufnr))
  vim.keymap.set('n', '<leader>W', api.tree.collapse_all, opts('collapse all', bufnr))
  vim.keymap.set("n", "[m", api.marks.navigate.prev)
  vim.keymap.set("n", "]m", api.marks.navigate.next)
end

-- configure nvim-tree
nvimtree.setup({
  -- change folder arrow icons
  view = {
    side = "right",
    width = 50,
    centralize_selection = true,
  },
  update_focused_file = {
    enable = true,
    update_root = true,
    ignore_list = {},
  },

  renderer = {
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "", -- arrow when folder is closed
          arrow_open = "",   -- arrow when folder is open
        },
      },
    },
  },
  -- disable window_picker for
  -- explorer to work well with
  -- window splits
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false,
      },
    },
  },

  live_filter = {
    always_show_folders = false,
  },
  on_attach = my_on_attach,
})

-- open nvim-tree on setup

local function open_nvim_tree(data)
  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not no_name and not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
