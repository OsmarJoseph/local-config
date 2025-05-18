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

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = true,
        },
        char = {
          jump_labels = true
        }
      },
    },
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "ST",    mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  "szw/vim-maximizer", -- maximizes and restores current window

  -- essential plugins
  "tpope/vim-surround",               -- add, delete, change surroundings (it's awesome)
  "tpope/vim-speeddating",            -- fix increment on dates
  "inkarkat/vim-ReplaceWithRegister", -- replace with register contents using motion (gr + motion)

  -- commenting with gc
  "numToStr/Comment.nvim",

  -- file explorer
  "nvim-tree/nvim-tree.lua",

  -- primagen
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- vs-code like icons
  "nvim-tree/nvim-web-devicons",

  "christoomey/vim-tmux-navigator", -- navigate between vim & tmux panes

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
  {
    "hrsh7th/nvim-cmp", -- completion plugin
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",           -- source for text in buffer
      "hrsh7th/cmp-path",             -- source for file system paths
      "hrsh7th/cmp-nvim-lsp",         -- for autocompletion
      "L3MON4D3/LuaSnip",             -- snippet engine
      "saadparwaiz1/cmp_luasnip",     -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim",         -- vs-code like icons for autocompletion
    }
  },

  -- managing & installing lsp servers, linters & formatters
  "williamboman/mason.nvim",           -- in charge of managing lsp servers, linters & formatters
  "williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig

  -- configuring lsp servers
  "neovim/nvim-lspconfig", -- easily configure language servers
  {
    "glepnir/lspsaga.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  }, -- enhanced lsp uis
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  },

  { "nvim-treesitter/nvim-treesitter",          build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-context",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl",                              opts = {} },
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

  "tpope/vim-abolish",                     -- search & replace

  -- debugger
  { "rcarriga/nvim-dap-ui",                dependencies = { "mfussenegger/nvim-dap" } },
  "theHamsta/nvim-dap-virtual-text",
  "mxsdev/nvim-dap-vscode-js",
  { "nvim-neotest/nvim-nio" },
  "simrat39/rust-tools.nvim",

  {
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },

  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    ft = "markdown",
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
    -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
    event = { "BufReadPre " .. vim.fn.expand "~" .. "/Library/Mobile Documents/com~apple~CloudDocs/notes/**.md" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "OsmarJoseph/Export.nvim",
    lazy = true,
    event = "BufEnter *.ts",
    config = function()
      require('export').setup()
    end,
  },
  { 'echasnovski/mini.pairs', version = false },
  {
    "kwkarlwang/bufjump.nvim",
    lazy = true,
    event = "BufEnter",
    config = function()
      require('bufjump').setup({
        forward_key = "<F6>i",
        backward_key = "<F6>o",
        on_success = nil
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "github/copilot.vim" },    -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken",       -- Only on MacOS or Linux
  },
}

local opts = {}

require("lazy").setup(plugins, opts)
