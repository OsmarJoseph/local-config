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
  { 'nvim-mini/mini.nvim',                      version = false },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'stevearc/oil.nvim',
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    lazy = true,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy     = false,
    ---@type snacks.Config
    opts     = {
      image        = { enabled = true },
      bigfile      = { enabled = true },
      indent       = {
        enabled = true,
        char = "▏",
        scope = {
          underline = true,
        },
      },
      input        = {
        enabled = true,
      },
      styles       = {
        input = {
          position = "float",
          relative = "cursor",
          row = -3,
          col = 0,
        }
      },
      bufdelete    = { enabled = true },
      rename       = { enabled = true },
      quickfile    = { enabled = true },
      scope        = { enabled = true },
      scroll       = { enabled = true },
      statuscolumn = { enabled = true },
    },
  },
  {
    "sudo-tee/opencode.nvim",
  },
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "InsertEnter", -- Load when entering insert mode
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      jump = {
        autojump = true,
      },
      modes = {
        search = {
          enabled = true,
        },
        char = {
          jump_labels = true,
          multi_line = false,
          jump = {
            autojump = true,
          },
        }
      },
    },
  },

  "szw/vim-maximizer", -- maximizes and restores current window

  -- essential plugins
  "tpope/vim-speeddating", -- fix increment on dates

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
      "hrsh7th/cmp-buffer",     -- source for text in buffer
      "hrsh7th/cmp-path",       -- source for file system paths
      {
        "hrsh7th/cmp-nvim-lsp", -- for autocompletion
        event = { "BufReadPre", "BufNewFile" },
      },
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
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-context",
  -- auto closing
  "windwp/nvim-ts-autotag", -- autoclose tags

  -- git integration
  "lewis6991/gitsigns.nvim", -- show line modifications on left hand side
  "tpope/vim-fugitive",      -- git control
  "tpope/vim-rhubarb",       -- github integration

  -- undotree
  "mbbill/undotree",

  -- pr review
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },

  "themaxmarchuk/tailwindcss-colors.nvim", -- tailwind color highlight

  "tpope/vim-abolish",                     -- search & replace

  -- debugger
  { "rcarriga/nvim-dap-ui",            dependencies = { "mfussenegger/nvim-dap" } },
  "theHamsta/nvim-dap-virtual-text",
  "mxsdev/nvim-dap-vscode-js",
  { "nvim-neotest/nvim-nio" },
  "mrcjkb/rustaceanvim",

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
}

local opts = {}

require("lazy").setup(plugins, opts)
