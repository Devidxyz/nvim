-- dofile(vim.g.base46_cache .. "lsp")

local M = {}
local utils = require("core.utils")

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })

  -- TODO
  -- if client.server_capabilities.signatureHelpProvider then
  --   require("nvchad.signature").setup(client)
  -- end
end

-- disable semantic tokens
M.on_init = function(client, _)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

local servers = {
  "tsserver",
  "eslint",
  "pylsp",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = M.on_attach,
    capabilities = M.capabilities,
  })
end

lspconfig.lua_ls.setup({
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
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          [vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

lspconfig.elixirls.setup({
  cmd = { "elixir-ls" },
  on_attach = M.on_attach,
  capabilities = M.capabilities,
})

lspconfig.tsserver.setup({
  cmd = { "typescript-language-server", "--stdio" },
  on_attach = M.on_attach,
  capabilities = M.capabilities,
})

lspconfig.gopls.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = false,
      analyses = {
        unusedparams = true,
        unusedresult = true,
      },
      gofumpt = false,
      -- staticcheck = true,
    },
  },
})

lspconfig.eslint.setup({})

lspconfig.pylsp.setup({
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

-- rounded corners
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.diagnostic.config({ float = { border = "rounded" } })

return M
