local M = {}

M.general = {
  n = {
    ["<Esc>"] = { "<cmd> noh <CR>", "Clear highlights" },
    ["<C-d>"] = { "<C-d>zz", "Scroll windows downwards and center cursor" },
    ["<C-u>"] = { "<C-u>zz", "Scroll windows upwards and center cursor" },
    ["n"] = { "nzzzv", "Jump to next result and center cursor" },
    ["N"] = { "Nzzzv", "Jump to previous result and center cursor" },
    ["Q"] = { "<cmd> qa <CR>", "Quit all (qa)" },
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },

    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      "LSP formatting",
    },
  },

  i = {
    ["<C-s>"] = { "<cmd> w <CR>", "Scroll windows upwards and center cursor" },
  },

  t = {
    ["<C-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
  },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["<"] = { "<gv", "Indent line" },
    [">"] = { ">gv", "Indent line" },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
    ["<C-/>"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}

M.navigation = {
  n = {
    -- navigation
    -- [Alt + direction] instead of [Ctrl + direction]
    ["<A-h>"] = { "<cmd> TmuxNavigateLeft <CR>", "Window left" },
    ["<A-l>"] = { "<cmd> TmuxNavigateRight <CR>", "Window right" },
    ["<A-j>"] = { "<cmd> TmuxNavigateDown <CR>", "Window down" },
    ["<A-k>"] = { "<cmd> TmuxNavigateUp <CR>", "Window up" },

    -- move window
    ["<A-H>"] = { "<C-w>H", "Move window left" },
    ["<A-L>"] = { "<C-w>L", "Move window right" },
    ["<A-J>"] = { "<C-w>J", "Move window down" },
    ["<A-K>"] = { "<C-w>K", "Move window up" },

    -- close window
    ["<C-w>"] = { ":q<CR>", "Close window" },
    ["<A-w>"] = { ":q<CR>", "Close window" },

    -- split
    ["<A-v>"] = { ":vs<CR>", "Vertical split" },
    ["<A-V>"] = { ":sp<CR>", "Horizontal split" },
    ["<leader>v"] = { ":vs<CR>", "Vertical split" },
    ["<leader>V"] = { ":sp<CR>", "Horizontal split" },

    -- new buffer
    ["<C-n>"] = { "<cmd> enew <CR>", "New buffer" },
  },
  i = {
    -- same in insert mode
    ["<A-h>"] = { "<C-w>h", "Window left" },
    ["<A-l>"] = { "<C-w>l", "Window right" },
    ["<A-j>"] = { "<C-w>j", "Window down" },
    ["<A-k>"] = { "<C-w>k", "Window up" },
  },
}

M.nvimtree = {
  plugin = true,
  n = {
    ["<A-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
    -- ["<leader>n"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
    ["<A-e>"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
  },
}

M.minimap = {
  n = {
    ["<A-m>"] = { "<cmd> MinimapToggle <CR>", "Toggle minimap" },
    ["<leader>mr"] = { "<cmd> MinimapRefresh <CR>", "Refresh minimap" },
    ["<leader>mc"] = { "<cmd> MinimapClose <CR>", "Close minimap" },
    ["<leader>mh"] = { "<cmd> MinimapUpdateHighlight <CR>", "Update minimap highlight" },
  },
}

-- [Ctrl + j] to toggle terminal
M.toggleterm = {
  t = {
    ["<C-j>"] = {
      "<cmd> ToggleTerm direction=horizontal <CR>",
      "Toggle horizontal term",
    },
    ["<A-i>"] = {
      "<cmd> ToggleTerm direction=float <CR>",
      "Toggle horizontal term",
    },
    ["<A-f>"] = {
      function()
        require("uilts.lazygit_toggle").lazygit_toggle()
      end,
      "Toggle lazygit",
    },
    ["<A-o>"] = {
      function()
        require("utils.lazygit_toggle").loggo_toggle()
      end,
      "Toggle loggo",
    },
  },
  n = {
    ["<C-j>"] = {
      "<cmd>ToggleTerm direction=horizontal <CR>",
      "Toggle horizontal term",
    },
    ["<A-i>"] = {
      "<cmd> ToggleTerm direction=float <CR>",
      "Toggle horizontal term",
    },
    ["<A-f>"] = {
      function()
        require("utils.lazygit_toggle").lazygit_toggle()
      end,
      "Toggle lazygit",
    },
    ["<A-o>"] = {
      function()
        require("utils.lazygit_toggle").loggo_toggle()
      end,
      "Toggle loggo",
    },
  },
}

M.bufferline = {
  n = {
    ["<tab>"] = { "<cmd>BufferLineCycleNext<CR>", "Goto next buffer" },

    ["<S-tab>"] = {
      "<cmd>BufferLineCyclePrev<CR>",
      "Goto prev buffer",
    },

    ["<C-p>"] = {
      "<cmd>BufferLinePick<CR>",
      "Goto specific buffer",
    },

    ["<A-1>"] = {
      "<cmd>BufferLineGoToBuffer 1<CR>",
      "Goto 1. buffer",
    },
    ["<A-2>"] = {
      "<cmd>BufferLineGoToBuffer 2<CR>",
      "Goto 2. buffer",
    },
    ["<A-3>"] = {
      "<cmd>BufferLineGoToBuffer 3<CR>",
      "Goto 3. buffer",
    },
    ["<A-4>"] = {
      "<cmd>BufferLineGoToBuffer 4<CR>",
      "Goto 4. buffer",
    },
    ["<A-5>"] = {
      "<cmd>BufferLineGoToBuffer 5<CR>",
      "Goto 5. buffer",
    },
    ["<A-6>"] = {
      "<cmd>BufferLineGoToBuffer 6<CR>",
      "Goto 6. buffer",
    },
    ["<A-7>"] = {
      "<cmd>BufferLineGoToBuffer 7<CR>",
      "Goto 7. buffer",
    },
    ["<A-8>"] = {
      "<cmd>BufferLineGoToBuffer 8<CR>",
      "Goto 8. buffer",
    },

    ["<leader>x"] = {
      function()
        require("bufdelete").bufdelete(0)
      end,
      "Close buffer",
    },
    ["<A-x>"] = {
      function()
        require("bufdelete").bufdelete(0)
      end,
      "Close buffer",
    },
  },
}

--
M.telescope = {
  plugin = true,

  n = {
    -- find
    --    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    --    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
    --    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    --    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    --    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
    --    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
    --    ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },

    -- git
    --    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
    --    ["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "Git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

    ["<leader>ma"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
  },
}

-- lsp custom shortcuts
M.lspconfig = {
  n = {
    ["gd"] = {
      function()
        require("fzf-lua").lsp_definitions()
      end,
      "LSP definition",
    },
    ["J"] = {
      function()
        require("fzf-lua").lsp_definitions()
      end,
      "LSP definitions fzf",
    },
    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "LSP hover",
    },
    ["L"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "Open floating diagnostics",
    },
    ["gr"] = {
      function()
        require("fzf-lua").lsp_references()
      end,
      "LSP references fzf",
    },
    ["H"] = {
      function()
        require("fzf-lua").lsp_references()
      end,
      "LSP references fzf",
    },
    ["<leader>p"] = {
      function()
        vim.diagnostic.goto_prev({ float = { border = "rounded" } })
      end,
      "Goto prev diagnostic",
    },
    ["<leader>n"] = {
      function()
        vim.diagnostic.goto_next({ float = { border = "rounded" } })
      end,
      "Goto next diagnostic",
    },
    [";"] = {
      function()
        require("fzf-lua").lsp_code_actions()
      end,
      "LSP code action fzf",
    },
    ["gD"] = {
      function()
        require("fzf-lua").lsp_declarations()
      end,
      "LSP declaration fzf",
    },
    ["gi"] = {
      function()
        require("fzf-lua").lsp_implementations()
      end,
      "LSP implementations fzf",
    },
    ["ga"] = {
      function()
        require("fzf-lua").lsp_finder()
      end,
      "LSP all",
    },
    ["<leader>ff"] = {
      function()
        require("fzf-lua").files()
      end,
      "Find files",
    },
    ["<leader>fa"] = { -- legacy, because habit
      function()
        require("fzf-lua").files()
      end,
      "Find files",
    },
    ["<leader>ft"] = {
      function()
        require("fzf-lua").buffers()
      end,
      "Find tabs",
    },
    ["<leader>fs"] = {
      function()
        require("fzf-lua").lsp_document_symbols()
      end,
      "Find symbols in document",
    },
    ["<leader>fS"] = {
      function()
        require("fzf-lua").lsp_workspace_symbols()
      end,
      "Find symbols in workspace",
    },
    ["<leader>le"] = {
      function()
        require("fzf-lua").diagnostics_document()
      end,
      "Document diagnostics",
    },
    ["<leader>lE"] = {
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      "workspace diagnostics",
    },
  },
}

M.grep = {
  n = {
    ["<leader>gg"] = {
      function()
        require("fzf-lua").lgrep_curbuf()
      end,
      "Live grep current buffer",
    },
    ["<leader>ga"] = {
      function()
        require("fzf-lua").live_grep()
      end,
      "Live grep current project",
    },
    ["<leader>gr"] = {
      function()
        require("fzf-lua").live_grep_resume()
      end,
      "Grep resume",
    },
    ["<leader>gw"] = {
      function()
        require("fzf-lua").grep_cword()
      end,
      "Grep curren word",
    },
    ["<leader>gh"] = {
      function()
        require("fzf-lua").builtin()
      end,
      "Grep curren word",
    },
  },
  v = {
    ["<leader>gv"] = {
      function()
        require("fzf-lua").grep_visual()
      end,
      "Grep visual",
    },
  },
}

M.tmux = {
  n = {
    ["<C-Space>"] = { "", "prefix" },
    ["<C-Left>"] = { "", "next window" },
    ["<C-Right>"] = { "", "previous windows" },
    ["<C-t>"] = { "", "new windows" },
    ["<A-s>"] = { "", "vertical split" },
    ["<A-d>"] = { "", "horizontal split" },
    ["<A-S-w>"] = { "", "kill pane" },
  },
}

M.dab = {
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Run or continue the debugger",
    },
    ["<leader>du"] = {
      function()
        require("dapui").toggle()
      end,
      "Open debugging sidebar",
    },
    ["<leader>dt"] = {
      function()
        require("dap-go").debug_test()
      end,
      "Debug go test",
    },
    ["<leader>dl"] = {
      function()
        require("dap-go").debug_last()
      end,
      "Debug last go test",
    },
    ["<leader>dd"] = {
      function()
        require("fzf-lua").dap_breakpoints()
      end,
      "List, delete breakpoints",
    },
    ["<leader>dc"] = {
      function()
        require("fzf-lua").dap_breakpoints()
      end,
      "Dap commands",
    },
  },
}

M.dictionary = {
  v = {
    ["<leader>ch"] = {
      function()
        -- call mdbg
        require("custom.configs.mdbg").mdbg()
        -- call esc
        local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
        vim.api.nvim_feedkeys(esc, "x", false)
      end,
      "translate word (chinese)",
    },
    -- vim.api.nvim_set_keymap("x", "<leader>vv", "<Cmd>lua mdgb()<Cr><esc>", { noremap = true, silent = true })
  },
}

M.whichkey = {
  plugin = true,

  n = {
    ["<leader>wK"] = {
      function()
        vim.cmd("WhichKey")
      end,
      "Which-key all keymaps",
    },
    ["<leader>wk"] = {
      function()
        local input = vim.fn.input("WhichKey: ")
        vim.cmd("WhichKey " .. input)
      end,
      "Which-key query lookup",
    },
  },
}

M.blankline = {
  plugin = true,

  n = {
    ["<leader>cc"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd([[normal! _]])
        end
      end,

      "Jump to current context",
    },
  },
}

-- TODO gitsigns

return M
