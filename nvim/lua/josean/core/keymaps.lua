-- keymapleader key to spacekeymap
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

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

-- delete without yanking
keymap.set("v", "<leader>d", '"_d')
keymap.set("n", "<leader>d", '"_d')
keymap.set("v", "<leader>D", '"_D')
keymap.set("n", "<leader>D", '"_D')

-- change ReplaceWithRegister command
keymap.set("n", "rp", "<Plug>ReplaceWithRegisterOperator")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<F6>\\", "<C-w>v") -- split window vertically
keymap.set("n", "<F6>-", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<F6>w", ":close<CR>") -- close current split window
keymap.set("c", "<F6>w", ":close<CR>") -- close current split window
keymap.set("n", "<F6><S-w>", ":on<CR>") -- close all split windows except current
keymap.set("c", "<F6><S-w>", ":on<CR>") -- close all split windows except current
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

keymap.set("n", "<leader>tne", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tw", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
keymap.set("n", "<F6><S-e>", ":NvimTreeToggle<CR>") -- toggle file explorer
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer
keymap.set("n", "<F6>b", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
keymap.set("n", "<F6><S-b>", "<cmd>Telescope buffers<cr>") -- list open buffers
keymap.set("i", "<F6><S-b>", "<cmd>Telescope buffers<cr>") -- list open buffers
keymap.set("c", "<F6><S-b>", "<cmd>Telescope buffers<cr>") -- list open buffers
keymap.set("v", "<F6><S-b>", "<cmd>Telescope buffers<cr>") -- list open buffers

function vim.getVisualSelection()
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

keymap.set("n", "<space>fc", ":Telescope current_buffer_fuzzy_find<cr>", opts)
keymap.set("v", "<space>fc", function()
  local text = vim.getVisualSelection()
  tb.current_buffer_fuzzy_find({ default_text = text })
end, opts)

keymap.set("n", "<F6><S-f>", live_grep_args)
keymap.set("i", "<F6><S-f>", live_grep_args)
keymap.set("c", "<F6><S-f>", live_grep_args)

keymap.set("v", "<F6><S-f>", function()
  local text = vim.getVisualSelection()
  live_grep_args({ default_text = text })
end, opts)

keymap.set("n", "<F6>p", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("i", "<F6>p", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("c", "<F6>p", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("v", "<F6>p", function()
  local text = vim.getVisualSelection()
  tb.find_files({ default_text = text })
end, opts) -- find files within current working directory, respects .gitignore

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]
keymap.set("n", "<leader>gt", "<cmd>Git<cr>") -- open vim fugitive
keymap.set("n", "<F6>g", "<cmd>Git<cr>") -- open vim fugitive
keymap.set("n", "dv", "<cmd>Gvdiffsplit<cr>") -- open vim fugitive diff

-- format on command + s
keymap.set("n", "<F6>s", "<cmd>lua vim.lsp.buf.format()<CR>")
keymap.set("i", "<F6>s", "<Esc><cmd>lua vim.lsp.buf.format()<CR>i")
keymap.set("v", "<F6>s", "<cmd>lua vim.lsp.buf.format()<CR>i")

-- search on command + f
keymap.set("n", "<F6>f", "/")

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

keymap.set("n", "<leader>p", mark.add_file)
keymap.set("n", "<C-p>", ui.toggle_quick_menu)
keymap.set("n", "<F6><S-p>", "<cmd>Telescope harpoon marks<cr>") -- list open harpoon in current neovim instance
keymap.set("i", "<F6><S-p>", "<cmd>Telescope harpoon marks<cr>") -- list open harpoon in current neovim instance
keymap.set("c", "<F6><S-p>", "<cmd>Telescope harpoon marks<cr>") -- list open harpoon in current neovim instance
keymap.set("v", "<F6><S-p>", "<cmd>Telescope harpoon marks<cr>") -- list open harpoon in current neovim instance

keymap.set("n", "<F6>1", function()
  ui.nav_file(1)
end)
keymap.set("n", "<F6>2", function()
  ui.nav_file(2)
end)
keymap.set("n", "<F6>3", function()
  ui.nav_file(3)
end)
keymap.set("n", "<F6>4", function()
  ui.nav_file(4)
end)

-- undotree
keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>")

-- comments
keymap.set("n", "<F6>/", "<Plug>(comment_toggle_linewise_current)")
keymap.set("i", "<F6>/", "<ESC><Plug>(comment_toggle_linewise_current)i")
keymap.set("v", "<F6>/", "<Plug>(comment_toggle_blockwise_visual)")

-- map arrows to move on nvim command mode
keymap.set("c", "<Down>", "<C-n>")
keymap.set("c", "<Up>", "<C-p>")
keymap.set("c", "<Enter>", 'pumvisible() ? "<C-y>" : "<CR>"', { expr = true, noremap = true })

-- keymap to move lines
keymap.set("n", "<A-Down>", ":lua vim.api.nvim_command('move +1')<CR>==")
keymap.set("n", "<A-Up>", ":lua vim.api.nvim_command('move -2')<CR>==")
keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")
keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")

-- keymap to move words
keymap.set("n", "<A-Left>", "b")
keymap.set("i", "<A-Left>", "<S-Left>")
keymap.set("c", "<A-Left>", "<S-Left>")
keymap.set("n", "<A-Right>", "e")
keymap.set("i", "<A-Right>", "<S-Right>")
keymap.set("c", "<A-Right>", "<S-Right>")

-- delete line
keymap.set("n", "<A-0>", "d0")
keymap.set("i", "<A-0>", "<C-u>")
keymap.set("c", "<A-0>", "<C-u>")
-- delete word
keymap.set("n", "<A-5>", "db")
keymap.set("i", "<A-5>", "<C-w>")
keymap.set("c", "<A-5>", "<C-w>")
-- keymapto move to start/end of line with command
keymap.set("n", "<A-6>", "0")
keymap.set("i", "<A-6>", "<Home>")
keymap.set("c", "<A-6>", "<Home>")
keymap.set("n", "<A-7>", "$")
keymap.set("i", "<A-7>", "<End>")
keymap.set("c", "<A-7>", "<End>")
-- select to start/end of line with command
keymap.set("n", "<A-8>", "v0")
keymap.set("i", "<A-8>", "<Esc>v0")
keymap.set("v", "<A-8>", "k")
keymap.set("n", "<A-9>", "v$")
keymap.set("i", "<A-9>", "<Esc>v$")
keymap.set("v", "<A-9>", "j")
-- select words with option + shift
keymap.set("n", "<A-1>", "vb")
keymap.set("i", "<A-1>", "<Esc>vb")
keymap.set("v", "<A-1>", "b")
keymap.set("n", "<A-2>", "ve")
keymap.set("i", "<A-2>", "<Esc>ve")
keymap.set("v", "<A-2>", "e")
-- select file
keymap.set("n", "<A-4>", "ggVG")

-- multicursor
keymap.set("n", "<F6>d", "<Plug>(VM-Find-Under)")
keymap.set("v", "<F6>d", "<Plug>(VM-Find-Subword-Under)")
keymap.set("n", "<F6>l", "<Plug>(VM-Select-All)")
keymap.set("v", "<F6>l", "<Plug>(VM-Select-All)")

-- rest
keymap.set("n", "<leader>run", "<Plug>RestNvim")
