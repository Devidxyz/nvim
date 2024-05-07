local Terminal = require("toggleterm.terminal").Terminal
local M = {}

local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

function M.lazygit_toggle()
  lazygit:toggle()
end

local loggo = Terminal:new({ cmd = "loggo stream --file .log", direction = "float", hidden = true })

function M.loggo_toggle()
  loggo:toggle()
end

return M
