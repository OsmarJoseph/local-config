-- keymapleader key to spacekeymap
vim.g.mapleader = " "
local obsidianConfig = require("josean.plugins.obsidian")

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

keymap.set("n", "<leader><CR>", ":source ~/.config/nvim/init.lua<CR>")

-- keep cursor centered when scrolling
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- navigate on quickfix list
keymap.set("n", "<leader>q", ":copen<CR>")
keymap.set("n", "[q", ":cprev<CR>zz")
keymap.set("n", "]q", ":cnext<CR>zz")

-- navigate on location list
keymap.set("n", "<leader>l", ":lopen<CR>")
keymap.set("n", "[l", ":lprev<CR>zz")
keymap.set("n", "]l", ":lnext<CR>zz")

-- create new line on insert mode
keymap.set("i", "<S-Space>", "<C-m>")

-- delete without yanking
keymap.set("v", "<leader>d", '"_d')
keymap.set("n", "<leader>d", '"_d')
keymap.set("v", "<leader>D", '"_D')
keymap.set("n", "<leader>D", '"_D')

keymap.del("n", "gri")
keymap.del("n", "grr")
keymap.del("n", "grt")
keymap.del("n", "gra")
keymap.del("x", "gra")
keymap.del("n", "grn")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<Plug>SpeedDatingUp")   -- increment
keymap.set("n", "<leader>-", "<Plug>SpeedDatingDown") -- decrement

-- window management
keymap.set("n", "<F6>\\", "<C-w>v")     -- split window vertically
keymap.set("n", "<F6>-", "<C-w>s")      -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<F6>w", ":close<CR>")  -- close current split window
keymap.set("c", "<F6>w", ":close<CR>")  -- close current split window
keymap.set("n", "<F6><S-w>", ":on<CR>") -- close all split windows except current
keymap.set("c", "<F6><S-w>", ":on<CR>") -- close all split windows except current
keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>")
keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>")
keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>")
keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>")

-- tabs
keymap.set("n", "<leader>tn", ":tabnew<CR>")   -- open new tab
keymap.set("n", "<leader>tw", ":tabclose<CR>") -- close current tab
keymap.set("n", "<F6>]", ":tabn<CR>")          --  go to next tab
keymap.set("n", "<F6>[", ":tabp<CR>")          --  go to previous tab

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
local nvim_tree = require("nvim-tree.api")

keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer
keymap.set("n", "<F6>e", ":NvimTreeToggle<CR>")     -- toggle file explorer
keymap.set("n", "<F6>b", ":NvimTreeToggle<CR>")     -- toggle file explorer
keymap.set("n", "<F6><S-m>", nvim_tree.marks.navigate.select)


local function getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

local tb = require("telescope.builtin")
local live_grep_args = require("telescope").extensions.live_grep_args.live_grep_args

local opts = { noremap = true, silent = true }

keymap.set("n", "<F6><S-f>", live_grep_args)
keymap.set("i", "<F6><S-f>", live_grep_args)
keymap.set("c", "<F6><S-f>", live_grep_args)

keymap.set("v", "<F6><S-f>", function()
  local text = getVisualSelection()
  live_grep_args({ default_text = text })
end, opts)

-- buffers
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>")    -- list open buffers
keymap.set("v", "<leader>b", "<cmd>Telescope buffers<cr>")    -- list open buffers
keymap.set("n", "<leader>fb", function() tb.live_grep({ grep_open_files = true }) end, { desc = "Grep Open Buffers" })

-- command history
keymap.set("n", "<leader>:", tb.command_history, { desc = "Command History" })

-- Telescope resume
keymap.set("n", "<leader>re", "<cmd>Telescope resume<cr>")
keymap.set("n", "<leader>pi", "<cmd>Telescope pickers<cr>")
keymap.set("n", "<F6>p", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("i", "<F6>p", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("c", "<F6>p", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("v", "<F6>p", function()
  local text = getVisualSelection()
  tb.find_files({ default_text = text })
end, opts) -- find files within current working directory, respects .gitignore

-- telescope git commands (not on youtube nvim video)

keymap.set("n", "<leader>gf", ":Gclog -n 10 %<CR>", { desc = "Git Log File" })

keymap.set("n", "<leader>gc", ":Gclog -n 10<CR>")  -- list all git commits 
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")   -- list current changes per file with diff preview ["gs" for git status]
keymap.set("n", "<F6>g", "<cmd>Git<cr>")                         -- open vim fugitive
keymap.set("n", "dv", "<cmd>Gvdiffsplit<cr>")                    -- open vim fugitive diff

-- search on command + f
keymap.set("n", "<F6>f", "/")

keymap.set("n", "<leader>ru", ":TSToolsRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
keymap.set("n", "<leader>ami", ":TSToolsAddMissingImports<CR>")
keymap.set("n", "<leader>ri", ":TSToolsRemoveUnusedImports<CR>")

-- harpoon

local harpoon = require("harpoon")

local function git_branch()
  local pipe = io.popen("git branch --show-current")
  if pipe then
    local c = pipe:read("*l"):match("^%s*(.-)%s*$")
    pipe:close()
    return c
  end
  return "default list"
end

keymap.set("n", "<leader>p", function() harpoon:list(git_branch()):add() end)
keymap.set("n", "<C-p>", function() harpoon.ui:toggle_quick_menu(harpoon:list(git_branch())) end)

local isInNotesPath = vim.fn.expand("%:p:h"):find(obsidianConfig.notesPath) ~= nil

if (isInNotesPath) then
  keymap.set("n", "<F6>2", ":ObsidianToday<CR>")
  keymap.set("i", "<F6>2", ":ObsidianToday<CR>")
  keymap.set("n", "<F6>3", ":ObsidianToday +1<CR>")
  keymap.set("i", "<F6>3", ":ObsidianToday +1<CR>")
else
  keymap.set("n", "<F6>2", function() harpoon:list(git_branch()):select(2) end)
  keymap.set("i", "<F6>2", function() harpoon:list(git_branch()):select(2) end)
  keymap.set("n", "<F6>3", function() harpoon:list(git_branch()):select(3) end)
  keymap.set("i", "<F6>3", function() harpoon:list(git_branch()):select(3) end)
end


keymap.set("n", "<F6>1", function() harpoon:list(git_branch()):select(1) end)
keymap.set("n", "<F6>4", function() harpoon:list(git_branch()):select(4) end)
keymap.set("n", "<F6>5", function() harpoon:list(git_branch()):select(5) end)

keymap.set("i", "<F6>1", function() harpoon:list(git_branch()):select(1) end)
keymap.set("i", "<F6>4", function() harpoon:list(git_branch()):select(4) end)
keymap.set("i", "<F6>5", function() harpoon:list(git_branch()):select(5) end)

-- undotree
keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>")

-- comments
keymap.set("n", "<F6>/", "<Plug>(comment_toggle_linewise_current)")
keymap.set("i", "<F6>/", "<ESC><Plug>(comment_toggle_linewise_current)i")
keymap.set("v", "<F6>/", "<Plug>(comment_toggle_blockwise_visual)")


-- keymap to move words
keymap.set("n", "<M-b>", "b")
keymap.set("i", "<M-b>", "<S-Left>")
keymap.set("c", "<M-b>", "<C-f>")

-- alt + right on tmux
keymap.set("n", "<M-f>", "e")
keymap.set("i", "<M-f>", "<S-Right>")
keymap.set("c", "<M-f>", "<S-Right>")

-- keymapto move to start/end of line with command
keymap.set("n", "<C-a>", "0")
keymap.set("i", "<C-a>", "<Home>")
keymap.set("c", "<C-a>", "<Home>")

keymap.set("n", "<C-e>", "$")
keymap.set("i", "<C-e>", "<End>")
keymap.set("c", "<C-e>", "<End>")
-- select to start/end of line with command
-- alt + 8
keymap.set("n", "•", "v0")
keymap.set("i", "•", "<Esc>v0")
keymap.set("v", "•", "k")
-- alt + 9
keymap.set("n", "ª", "v$")
keymap.set("i", "ª", "<Esc>v$")
keymap.set("v", "ª", "j")
-- select words with option + shift
keymap.set("n", "¡", "vb")
keymap.set("i", "¡", "<Esc>vb")
keymap.set("v", "¡", "b")
keymap.set("n", "™", "ve")
keymap.set("i", "™", "<Esc>ve")
keymap.set("v", "™", "e")

local function wrap_with_console_log()
  -- Get the current visual selection
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  -- Get lines from visual selection
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  -- Handle multi-line and single-line selections
  if #lines == 1 then
    -- Single line: Wrap the selected text in the same line
    local line = lines[1]
    local start_col = start_pos[3]
    local end_col = end_pos[3]

    local selected_text = string.sub(line, start_col, end_col)
    local wrapped_text = "console.log(" .. selected_text .. ")"

    -- Replace the selected text
    local new_line = string.sub(line, 1, start_col - 1) .. wrapped_text .. string.sub(line, end_col + 1)
    vim.fn.setline(start_pos[2], new_line)
    vim.fn.cursor(start_pos[2], start_pos[3] + #wrapped_text)
  else
    -- Multi-line selection (wrap entire lines)
    for i = 1, #lines do
      lines[i] = "console.log(" .. lines[i] .. ")"
    end
    vim.fn.setline(start_pos[2], lines)
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

-- insert console.log
keymap.set("n", "<F6>l", "oconsole.log()<Esc>i<Esc>")
keymap.set("i", "<F6>l", "<Esc>oconsole.log()<Esc>i")
keymap.set("v", "<F6>l", wrap_with_console_log)

-- macros
keymap.set("n", "Q", "@q")
keymap.set("v", "Q", ":norm @q<CR>")

keymap.set("c", "<Left>", "<Space><BS><Left>", { noremap = true })
keymap.set("c", "<Right>", "<Space><BS><Right>", { noremap = true })

-- do tab completion on command + space
keymap.set("c", "<C-Space>", "<C-z>", { noremap = true })

-- user commands
keymap.set("n", "<leader>tc", ":TSContext toggle<CR>") -- toggle treesitter context
keymap.set("n", "<leader>fm", ":FormatWithPrettier<CR>")
keymap.set("n", "<leader>st", ":Sort<CR>")
keymap.set("n", "<leader>xp", ":Export<CR>")

keymap.set("n", "<leader>db", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
keymap.set("n", "<leader>rf", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
keymap.set("n", "<leader>oil", ":Oil<CR>")

local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
  pattern = "NvimTreeSetup",
  callback = function()
    local events = require("nvim-tree.api").events
    events.subscribe(events.Event.NodeRenamed, function(data)
      if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
        data = data
        Snacks.rename.on_rename_file(data.old_name, data.new_name)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions[1].type == "move" then
      Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})
