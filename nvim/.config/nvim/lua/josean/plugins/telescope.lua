-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
  return
end

-- import live_grep_args actions safely
local lga_actions_setup, lga_actions = pcall(require, "telescope-live-grep-args.actions")
if not lga_actions_setup then
  return
end

local actions = require("telescope.actions")

-- configure telescope
telescope.setup({
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      }
    },
    hidden = true,
    file_ignore_patterns = { ".git/", "node_modules/" },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden", -- thats the new thing
    },
    cache_picker = {
      num_pickers = 10,
    }
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      mappings = {
        i = {
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
