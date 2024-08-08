local cmp = require("cmp")

local icons = {
  Array = "[]",
  Boolean = "",
  Calendar = "",
  Class = "󰠱",
  Codeium = "",
  Color = "󰏘",
  Constant = "󰏿",
  Constructor = "",
  Copilot = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰜢",
  File = "󰈚",
  Folder = "󰉋",
  Function = "󰆧",
  Interface = "",
  Keyword = "󰌋",
  Method = "󰆧",
  Module = "",
  Namespace = "󰌗",
  Null = "󰟢",
  Number = "",
  Object = "󰅩",
  Operator = "󰆕",
  Package = "",
  Property = "󰜢",
  Reference = "󰈇",
  Snippet = "",
  String = "󰉿",
  Struct = "󰙅",
  TabNine = "",
  Table = "",
  Tag = "",
  Text = "󰉿",
  TypeParameter = "󰊄",
  Unit = "󰑭",
  Value = "󰎠",
  Variable = "󰀫",
  Watch = "󰥔",
}

local options = {
  completion = {
    completeopt = "menu,menuone",
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = {
    -- default fields order i.e completion word + item.kind + item.kind icons
    fields = { "abbr", "kind", "menu" },

    format = function(_, item)
      local icon = icons[item.kind] or ""

      icon = (" " .. icon .. " ") or icon
      item.kind = string.format("%s %s", icon, item.kind or "")

      return item
    end,
  },

  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<Tab>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "nvim_lsp_signature_help" },
  },
}

return options
