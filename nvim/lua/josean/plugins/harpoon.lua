local harpoon = require('harpoon')
local Job = require "plenary.job"

harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

local function git_branch()
  local pipe = io.popen("git branch --show-current")
  if pipe then
    local c = pipe:read("*l"):match("^%s*(.-)%s*$")
    pipe:close()
    return c
  end
  return "default list"
end

local function open_harpoon()
  toggle_telescope(harpoon:list(git_branch()))
end

vim.keymap.set("n", "<F6><S-p>", open_harpoon, { desc = "Open harpoon window" })
vim.keymap.set("i", "<F6><S-p>", open_harpoon, { desc = "Open harpoon window" })
vim.keymap.set("c", "<F6><S-p>", open_harpoon, { desc = "Open harpoon window" })
vim.keymap.set("v", "<F6><S-p>", open_harpoon, { desc = "Open harpoon window" })

return {
  git_branch = git_branch,
}
