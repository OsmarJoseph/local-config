local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

  "nvim-lua/plenary.nvim", -- lua functions that many plugins

  "rose-pine/neovim",      -- preferred colorscheme

  "szw/vim-maximizer",     -- maximizes and restores current window

  -- essential plugins
  "tpope/vim-surround",               -- add, delete, change surroundings (it's awesome)
  "inkarkat/vim-ReplaceWithRegister", -- replace with register contents using motion (gr + motion)

  -- commenting with gc
  "numToStr/Comment.nvim",

  -- file explorer
  "nvim-tree/nvim-tree.lua",

  -- primagen
  "theprimeagen/harpoon",

  -- vs-code like icons
  "nvim-tree/nvim-web-devicons",

  -- statusline
  "nvim-lualine/lualine.nvim",

  -- fuzzy finding w/ telescope
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance
  "nvim-telescope/telescope-live-grep-args.nvim",
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
  }, -- fuzzy finder

  -- autocompletion
  "hrsh7th/nvim-cmp",   -- completion plugin
  "hrsh7th/cmp-buffer", -- source for text in buffer
  "hrsh7th/cmp-path",   -- source for file system paths

  -- snippets
  "L3MON4D3/LuaSnip",             -- snippet engine
  "saadparwaiz1/cmp_luasnip",     -- for autocompletion
  "rafamadriz/friendly-snippets", -- useful snippets

  -- managing & installing lsp servers, linters & formatters
  "williamboman/mason.nvim",           -- in charge of managing lsp servers, linters & formatters
  "williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig

  -- configuring lsp servers
  "neovim/nvim-lspconfig", -- easily configure language servers
  "hrsh7th/cmp-nvim-lsp",  -- for autocompletion
  {
    "glepnir/lspsaga.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },                                    -- enhanced lsp uis
  "jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)
  "onsails/lspkind.nvim",               -- vs-code like icons for autocompletion
  "folke/neodev.nvim",

  { "nvim-treesitter/nvim-treesitter",          build = ":TSUpdate" },

  -- auto closing
  "windwp/nvim-ts-autotag", -- autoclose tags

  -- git integration
  "lewis6991/gitsigns.nvim", -- show line modifications on left hand side
  "tpope/vim-fugitive",      -- git control
  "tpope/vim-rhubarb",       -- github integration

  -- undotree
  "mbbill/undotree",

  -- copilot
  "github/copilot.vim",

  -- pr review
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },

  "norcalli/nvim-colorizer.lua",           -- normal color highlight
  "themaxmarchuk/tailwindcss-colors.nvim", -- tailwind color highlight

  "mg979/vim-visual-multi",                -- multiple cursors
  "tpope/vim-abolish",                     -- search & replace

  "rest-nvim/rest.nvim",                   -- rest client

  { "jackMort/ChatGPT.nvim", dependencies = { "MunifTanjim/nui.nvim" } },

  -- debugger
  { "rcarriga/nvim-dap-ui",  dependencies = { "mfussenegger/nvim-dap" } },
  "theHamsta/nvim-dap-virtual-text",
  "mxsdev/nvim-dap-vscode-js",
  "simrat39/rust-tools.nvim",

  {
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
}

local opts = {}

require("lazy").setup(plugins, opts)
