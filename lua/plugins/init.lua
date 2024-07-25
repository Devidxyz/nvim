local plugins = {
  -- "All the lua functions I don't want to write twice"
  "nvim-lua/plenary.nvim",

  {
    "NvChad/base46",
    branch = "v2.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = "User FilePost",
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults
        "vim",
        "vimdoc",
        "lua",

        -- web dev
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",

        -- other languages
        "elixir",
        "go",
        "python",
      },
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      indent = { enable = true },
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require("plugins.cmp")
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          require("cmp").setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" },
            },
          })
        end,
      })
    end,
  },

  -- mason
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "typescript-language-server",
        "elixir-ls",
        "prettier",
        "sonarlint-language-server",
        "stylua",
        "eslint-lsp",
        "js-debug-adapter",
        "gopls",
        "golines",
        "goimports",
        "pg_format",
      },
      PATH = "skip",

      ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = " 󰚌",
        },

        keymaps = {
          toggle_server_expand = "<CR>",
          install_server = "i",
          update_server = "u",
          check_server_version = "c",
          update_all_servers = "U",
          check_outdated_servers = "C",
          uninstall_server = "X",
          cancel_installation = "<C-c>",
        },
      },

      max_concurrent_installers = 10,
    },
    config = function(_, opts)
      --dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",

    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("plugins.null-ls")
      end,
    },

    config = function()
      require("plugins.lspconfig")
    end,
  },

  -- elixir
  -- {
  --   "elixir-tools/elixir-tools.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   config = function()
  --     local elixir = require "elixir"
  --     local elixirls = require "elixir.elixirls"
  --
  --     elixir.setup {
  --       credo = {},
  --       elixirls = {
  --         enabled = true,
  --         settings = elixirls.settings {
  --           dialyzerEnabled = false,
  --           enableTestLenses = false,
  --         },
  --         on_attach = function(client, bufnr)
  --           vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
  --           vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
  --           vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
  --         end,
  --       },
  --     }
  --   end,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  -- },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  { "ellisonleao/glow.nvim",          config = true, cmd = "Glow" },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings("nvimtree")
    end,
    opts = function()
      return require("plugins.nvimtree")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings("telescope")
    end,
    opts = function()
      return require("plugins.telescope")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require("telescope")
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- don't know if this is working
  -- {
  --   "tiagovla/scope.nvim",
  --   lazy = false,
  --   config = function(_, opts)
  --     require("scope").setup(opts)
  --   end,
  -- },

  -- tabs
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "*",
    opts = {
      options = {
        numbers = "ordinal",
        always_show_bufferline = true,
        -- separator_style = "slant",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
    dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
  },

  -- tmux navigation
  { "christoomey/vim-tmux-navigator", lazy = false },

  -- debugger
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    init = function()
      -- require("core.utils").load_mappings "dap"
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      -- require("core.utils").load_mappings "dap_go"
    end,
  },
  { "nvim-neotest/nvim-nio" },
  {
    "folke/neodev.nvim",
    opts = {},
    config = function(_, opts)
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },

  -- minimap
  {
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap",
    -- lazy = false,
    cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
    init = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 0")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },

  -- vim in browser
  {
    "glacambre/firenvim",
    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    config = function()
      vim.g.firenvim_config.globalSettings = { takeover = "never" }
    end,
  },

  -- terminals
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    config = function()
      require("plugins.toggleterm")
    end,
  },

  -- context for functions, nested logic
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- god
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({
        "telescope",
        keymap = {
          fzf = {
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
          },
        },
      })
    end,
  },

  -- multi cursor support
  -- disabled because it messes up my mappings
  -- {
  --   "mg979/vim-visual-multi",
  --   event = { "BufReadPost", "BufNewFile" },
  -- },

  -- open in github
  {
    "almo7aya/openingh.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- go snippets
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd([[silent! GoInstallDeps]])
    end,
  },

  -- comment
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n",          desc = "Comment toggle current line" },
      { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n",          desc = "Comment toggle current block" },
      { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      require("core.utils").load_mappings("comment")
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
      })
    end,
  },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = function()
      return require("plugins.others").gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        theme = "palenight",
      })
    end,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1

      require("core.utils").load_mappings("dbui")
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion",
  },

  {
    "tpope/vim-dotenv",
  },
}

return plugins
