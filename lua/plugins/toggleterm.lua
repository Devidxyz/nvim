local toggleterm = require "toggleterm"

local opts = {
  float_opts = {
    border = "curved",
    winblend = 15,
  },
  winbar = {
    enabled = true,
  },
}

toggleterm.setup(opts)
