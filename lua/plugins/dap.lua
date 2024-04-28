-- local dap = require "dap"
--
-- dap.adapters["pwa-node"] = {
--   type = "server",
--   host = "localhost",
--   port = 8123,
--   executable = {
--     command = "js-debug-adapter",
--   },
-- }
--
-- for _, language in ipairs { "typescript", "javascript" } do
--   dap.configurations[language] = {
--     {
--       type = "pwa-node",
--       request = "launch",
--       name = "Launch file",
--       program = "${file}",
--       cwd = "${workspaceFolder}",
--       runtimeExecutable = "node",
--     },
--   }
-- end

-- code from
-- https://github.com/anasrar/.dotfiles/blob/671c32cbf44d828e5b5128ada4f4637b58a0b792/neovim/.config/nvim/lua/rin/DAP/languages/typescript.lua

local dap = require "dap"
local dap_utils = require "dap.utils"
local dap_vscode_js = require "dap-vscode-js"

dap_vscode_js.setup {
  node_path = "node",
  -- debugger_path = os.getenv "HOME" .. ".local/share/nvim/mason/bin/js-debug-adapter",
  debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
}

local exts = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
}

for i, ext in ipairs(exts) do
  dap.configurations[ext] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node)",
      cwd = vim.fn.getcwd(),
      args = { "${file}" },
      sourceMaps = true,
      protocol = "inspector",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node with ts-node)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "--loader", "ts-node/esm" },
      runtimeExecutable = "node",
      args = { "${file}" },
      sourceMaps = true,
      protocol = "inspector",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node with deno)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "run", "--inspect-brk", "--allow-all", "${file}" },
      runtimeExecutable = "deno",
      attachSimplePort = 9229,
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with jest)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
      runtimeExecutable = "node",
      args = { "${file}", "--coverage", "false" },
      rootPath = "${workspaceFolder}",
      sourceMaps = true,
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with vitest)",
      cwd = vim.fn.getcwd(),
      program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
      args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
      autoAttachChildProcesses = true,
      smartStep = true,
      console = "integratedTerminal",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with deno)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
      runtimeExecutable = "deno",
      attachSimplePort = 9229,
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "Attach Program (pwa-chrome, select port)",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      port = function()
        return vim.fn.input("Select port: ", 9222)
      end,
      webRoot = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach Program (pwa-node, select pid)",
      cwd = vim.fn.getcwd(),
      processId = 3218475, -- dap_utils.pick_process,
      skipFiles = { "<node_internals>/**" },
    },
  }
end
