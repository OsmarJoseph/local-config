local rt = require("rust-tools")
local obsidianConfig = require("josean.plugins.obsidian")

-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

local keymap = vim.keymap -- for conciseness

local function format_with_(formatter, range)
  local current_bufnr = vim.api.nvim_get_current_buf()

  local start_line, end_line
  if range then
    start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")
  else
    start_line = 1
    end_line = vim.fn.line('$') -- Last line of the buffer
  end

  local command = {
    formatter,
  }

  if (formatter == "biome") then
    table.insert(command, 'format')
    table.insert(command, '--stdin-file-path')
  end

  if (formatter == "prettier") then
    table.insert(command, '--stdin-filepath')
  end

  table.insert(command, vim.fn.expand('%:p'))


  local formatted_content = vim.fn.systemlist(command, table.concat(vim.fn.getline(start_line, end_line), '\n'))

  if formatted_content and #formatted_content > 0 then
    -- Set the buffer lines to the formatted content
    vim.api.nvim_buf_set_lines(current_bufnr, start_line - 1, end_line, false, formatted_content)
  end
end

local function format_with_biome(range)
  format_with_("biome", range)
end

local function format_with_prettier(range)
  format_with_("prettier", range)
end

local function format_rust()
  vim.cmd("w")
  vim.cmd("lua vim.lsp.buf.format()")
end


-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

  -- set keybinds
  keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts) -- show definition, references

  if (client.name ~= "marksman") then
    keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)               -- got to declaration
  end
  keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", opts)                 -- see definition and make edits in window
  keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)        -- go to implementation
  keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)            -- go to implementation
  keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)                -- go to implementation
  keymap.set("n", "<F6>.", "<cmd>Lspsaga code_action<CR>", opts)                  -- see available code actions
  keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)                  -- smart rename
  keymap.set("n", "<leader>Di", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)   -- show  diagnostics for line
  keymap.set("n", "<leader>di", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)            -- jump to previous diagnostic in buffer
  keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)            -- jump to next diagnostic in buffer
  keymap.set("n", "gh", "<cmd>Lspsaga hover_doc<CR>", opts)                       -- show documentation for what is under cursor
  keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)                  -- see outline on right hand side
  opts.desc = "Restart LSP"
  keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)                          -- mapping to restart lsp if necessary

  -- typescript specific keymaps (e.g. rename file and update imports)
  if client.name == "typescript-tools" then
    keymap.set("n", "<leader>rf", ":TSToolsRenameFile<CR>")   -- rename file and update imports
    keymap.set("n", "<leader>ru", ":TSToolsRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
    keymap.set("n", "<leader>ami", ":TSToolsAddMissingImports<CR>")
  end

  if client.name == "typescript-tools" and filetype ~= "javascript" then
    client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
  end

  if client.name == "eslint" then
    client.server_capabilities.documentFormattingProvider = true -- 0.8 and later
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end
  if client.name == "tailwindcss" then
    require("tailwindcss-colors").buf_attach(bufnr)
  end
  local isInNotesPath = vim.fn.expand("%:p:h"):find(obsidianConfig.notesPath) ~= nil

  if (client.name == "marksman" and isInNotesPath) then
    client.server_capabilities.documentFormattingProvider = true
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "FormatWithPrettierAndWrite",
    })
    -- format on command + s
    keymap.set("n", "<F6>s", format_with_prettier)
    keymap.set("i", "<F6>s", "<Esc><cmd>FormatWithPrettier<CR>i")

    vim.api.nvim_create_user_command("ZK", obsidianConfig.create_zettelkasten_note, {})
  else
    keymap.set("n", "<F6>s", "<cmd>lua vim.lsp.buf.format()<CR>")
    keymap.set("i", "<F6>s", "<Esc><cmd>lua vim.lsp.buf.format()<CR>i")
    keymap.set("v", "<F6>s", "<cmd>lua vim.lsp.buf.format()<CR>i")
  end

  if (client.name == "rust_analyzer") then
    vim.keymap.set("n", "<leader>run", ":RustRunnables<CR>")
    keymap.set("n", "<F6>s", format_rust)
  end

  if (client.name == "gopls") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
        vim.lsp.buf.format({ async = false })
      end
    })
  end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure deno server
lspconfig["denols"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  filetypes = { "typescript" },
})

-- configure deno server
lspconfig["gopls"].setup({
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lspconfig.util.root_pattern("go.mod", "go.work"),
  settings = {
    completeUnimported = true,
    usePlaceholders = true,
    analyses = {
      unusedparams = true,
    },
  }
})

-- configure eslint server
lspconfig["eslint"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure json server
lspconfig["jsonls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("typescript-tools").setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = false
})

-- configure css server
lspconfig["cssls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure markdown server
lspconfig["marksman"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "markdown" },
})


-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "typescriptreact", "javascriptreact" },
})

-- configure graphql server
lspconfig["graphql"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "graphql", "typescriptreact", "javascriptreact", "javascript", "typescript" },
  root_dir = lspconfig.util.root_pattern(".graphqlconfig"),
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    -- custom settings for lua
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim" },
      },
      completion = {
        callSnippet = "Replace",
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

local mason_registry = require("mason-registry")

local codelldb = mason_registry.get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

rt.setup({
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
  },
  server = {
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
    capabilities = capabilities,
    on_attach = on_attach,
  },
})

vim.api.nvim_create_user_command("FormatWithBiome", function(opts)
  format_with_biome(opts.range ~= 0)
end, { range = true })

vim.api.nvim_create_user_command("FormatWithPrettier", function(opts)
  format_with_prettier(opts.range ~= 0)
end, { range = true })

vim.api.nvim_create_user_command("FormatWithPrettierAndWrite", function()
  format_with_prettier()
  vim.api.nvim_command("write")
end, {})

vim.cmd([[
  augroup strdr4605
  autocmd FileType typescript,typescriptreact compiler tsc | setlocal makeprg=NODE_OPTIONS=\"--max_old_space_size=4096\"\ yarn\ tsc
  augroup END
]])

local function import_sort_run()
  local current_bufnr = vim.api.nvim_get_current_buf()
  local start_line = 1
  local end_line = vim.fn.line('$') -- Last line of the buffer
  local import_sort_executable = vim.fn.expand("~/.config/nvim/sort.js")

  -- Get the current file path
  local current_file_path = vim.fn.expand("%:p")

  -- Get the content of the buffer
  local content = table.concat(vim.fn.getline(start_line, end_line), '\n')

  -- Prepare the command
  local command = {
    "node",
    import_sort_executable,
    current_file_path,
    content
  }

  -- Execute the command
  local formatted_content = vim.fn.systemlist(command)

  if formatted_content and #formatted_content > 0 then
    -- Set the buffer lines to the formatted content
    vim.api.nvim_buf_set_lines(current_bufnr, start_line - 1, end_line, false, formatted_content)
  else
    print("No formatted content returned.")
  end
end

vim.api.nvim_create_user_command("Sort", function()
  import_sort_run()
end, {})
