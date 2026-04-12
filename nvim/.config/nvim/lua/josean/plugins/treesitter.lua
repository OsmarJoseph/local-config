-- import nvim-treesitter plugin safely
local status, ts = pcall(require, "nvim-treesitter")
if not status then
  return
end

-- install parsers (async, no-op for already installed)
ts.install({
  "json",
  "http",
  "javascript",
  "typescript",
  "tsx",
  "yaml",
  "html",
  "css",
  "markdown",
  "markdown_inline",
  "graphql",
  "bash",
  "lua",
  "vim",
  "dockerfile",
  "gitignore",
})

-- enable treesitter highlighting and indentation for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then
      return
    end
    if not vim.treesitter.language.add(lang) then
      return
    end
    vim.treesitter.start(args.buf)
    if vim.treesitter.query.get(lang, "indents") then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
    -- re-enable regex highlighting for markdown alongside treesitter
    if args.match == "markdown" then
      vim.bo[args.buf].syntax = "on"
    end
  end,
})

-- treesitter-context
require("treesitter-context").setup({
  enable = true,
  max_lines = 0,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = "outer",
  mode = "cursor",
  separator = "-",
  zindex = 20,
  on_attach = nil,
})
