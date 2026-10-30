local M = {}
local utils = require("core.utils")
local util = require("lspconfig.util")

-- on_attach
M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })
end

-- disable semantic tokens
M.on_init = function(client)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()

--------------------------------------------------
-- LUA
--------------------------------------------------

vim.lsp.config("lua_ls", {
  on_init = M.on_init,
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath("config"),
        },
      },
    },
  },
})

--------------------------------------------------
-- GO
--------------------------------------------------

vim.lsp.config("gopls", {
  on_init = M.on_init,
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  cmd = { "gopls" },

  filetypes = { "go", "gomod", "gowork", "gotmpl" },

  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = false,
      analyses = {
        unusedparams = true,
        unusedresult = true,
      },
      -- gofumpt = true,
    },
  },
})

--------------------------------------------------
-- ELIXIR
--------------------------------------------------

vim.lsp.config("elixirls", {
  cmd = { "elixir-ls" },
  on_attach = M.on_attach,
  capabilities = M.capabilities,
})

--------------------------------------------------
-- TYPESCRIPT
--------------------------------------------------

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = '/home/david/.local/share/nvim/mason/bin/vue-language-server',
  languages = { 'vue' },
  configNamespace = 'typescript',
}

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript", "vue" },
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  init_options = {
    plugins = {
      vue_plugin,
    }
  }
})

vim.lsp.config('vue_ls', {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  on_attach = M.on_attach,
  capabilities = M.capabilities
})

--------------------------------------------------
-- PYTHON
--------------------------------------------------

vim.lsp.config("pylsp", {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "python", "tiltfile" },

  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 80,
        },
      },
    },
  },
})

--------------------------------------------------
-- ESLINT
--------------------------------------------------

vim.lsp.config("eslint", {})

--------------------------------------------------
-- ENABLE SERVERS
--------------------------------------------------

vim.lsp.enable({
  "lua_ls",
  "gopls",
  "elixirls",
  "pylsp",
  "ts_ls",
  "vue_ls",
  "eslint",
  "ccls",
})

--------------------------------------------------
-- UI
--------------------------------------------------

local function with_rounded_border(handler)
  return function(err, result, ctx, config)
    config = config or {}
    config.border = "rounded"
    return handler(err, result, ctx, config)
  end
end

vim.lsp.handlers["textDocument/hover"] =
  with_rounded_border(vim.lsp.handlers.hover)

vim.lsp.handlers["textDocument/signatureHelp"] =
  with_rounded_border(vim.lsp.handlers.signature_help)

vim.diagnostic.config({
  float = { border = "rounded" },
})

return M
