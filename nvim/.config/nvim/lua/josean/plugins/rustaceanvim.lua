vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        checkOnSave = true,
        check = { command = "clippy" },
        diagnostics = { enable = true },
      },
    },
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function(args)
    vim.keymap.set({ "n", "i", "v" }, "<F6>s", "<Esc><cmd>w<CR>", { buffer = args.buf })
  end,
})
