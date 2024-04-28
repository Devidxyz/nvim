local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
  formatting.prettier,
  formatting.stylua,
  formatting.mix,
  formatting.gofumpt,
  formatting.goimports_reviser,
  formatting.golines,
  formatting.nixpkgs_fmt,

  lint.shellcheck,
}

-- format on save - https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup {
  debug = true,
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
          vim.lsp.buf.format { async = false }
        end,
      })
    end
  end,
}
