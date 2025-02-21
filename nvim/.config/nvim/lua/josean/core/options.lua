local opt = vim.opt -- for conciseness

opt.guicursor = ""

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true         -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2        -- 2 spaces for tabs (prettier default)
opt.softtabstop = 2    -- 2 spaces for indent width
opt.shiftwidth = 2     -- 2 spaces for indent width
opt.expandtab = true   -- expand tab to spaces
opt.autoindent = true  -- copy indent from current line when starting new one
opt.smartindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- swap and backup
opt.swapfile = false                               -- disable swap file
opt.backup = false                                 -- disable backup
opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- set undodir
opt.undofile = true                                -- enable undo file

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.scrolloff = 8     -- keep 8 lines above and below cursor when scrolling

opt.updatetime = 50

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Hightlight selection on yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 250 })
  end,
})

-- fold
opt.foldmethod = "indent"
opt.foldenable = false

-- spell
opt.spelllang = "en_us,pt"
opt.spellfile = os.getenv("HOME") ..
    "/.config/nvim/spell/en.utf-8.add," .. os.getenv("HOME") .. "/.config/nvim/spell/pt.utf-8.add"

-- obsidian
opt.conceallevel = 2

vim.cmd([[
  augroup spellcheck
  autocmd FileType typescript,typescriptreact,markdown,octo setlocal spell
  augroup END
]])

-- Enable wildmenu
opt.wildmenu = true

-- Customize wildmode to complete until the next capital letter
opt.wildmode = 'longest:full,longest:full'

opt.autochdir = false
