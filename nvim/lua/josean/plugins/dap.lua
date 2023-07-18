local dap = require("dap")
local dapui = require("dapui")
local dap_widgets = require("dap.ui.widgets")

require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "Attach to Chrome",
      port = 9222,
      webRoot = "${workspaceFolder}",
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = 'Start Chrome with "localhost"',
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
      userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
    },
  }
end

dapui.setup()
require("nvim-dap-virtual-text").setup({})

vim.cmd(
  [[
  augroup DapFloatMapping
    autocmd!
    autocmd FileType dap-float nnoremap <buffer><silent> <F6>w <cmd>close!<CR>
    autocmd FileType dap-float nnoremap <buffer><silent> <Esc> <cmd>close!<CR>
  augroup END
]]
)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set("n", "<leader>ui", dapui.toggle)

vim.keymap.set("n", "<leader>dpc", dap.continue)
vim.keymap.set("n", "<leader>dpv", dap.step_over)
vim.keymap.set("n", "<leader>dpi", dap.step_into)
vim.keymap.set("n", "<leader>dpo", dap.step_out)
vim.keymap.set("n", "<leader>dpb", dap.toggle_breakpoint)

vim.keymap.set("n", "<leader>dph", dap_widgets.hover)
vim.keymap.set("n", "<leader>dpp", dap_widgets.preview)

vim.keymap.set("n", "<leader>dpw", function()
  dap_widgets.centered_float(dap_widgets.scopes)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>dpcb", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>dplb", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { noremap = true, silent = true })
